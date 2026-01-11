# Send current date and time to a SpectraGen 3/4

# Pass the script the requested parameters, and it will send date/time to the unit
# Running the script without paramters will send based on defaults.

# things you need to know
#   The SpectraGen's set date/time page
#       Default: "2"
#   The SpectraGen's 2 character CHANNEL name
#       Default: " D"
#   The COM port to send it over
#       Default: "COM1"
#   The Baud Rate
#       Default: "2400"
#       (Serial settings for NOAA are always 8,N,1 for the SpectraGen)

import argparse
import serial
from datetime import datetime
import sys

### defined procedures
def is_leap_year(year):
    # A year is a leap year if it is divisible by 4, unless it is divisible by 100 but not by 400.
    if year % 4 == 0:
        if year % 100 == 0 and year % 400 != 0:
            return False
        if year % 100 == 0 and year % 400 == 0:
            return True
        return True
    return False

def get_january_first_weekday(year):
    january_first = datetime(year, 1, 1)
    days_of_week = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    return days_of_week[january_first.weekday()]

def find_previous_identical_calendar_year(current_year):
    current_year_is_leap = is_leap_year(current_year)
    current_year_start_day = get_january_first_weekday(current_year)

    previous_year = current_year - 1
    while True:
        previous_year_is_leap = is_leap_year(previous_year)
        previous_year_start_day = get_january_first_weekday(previous_year)

        if (previous_year_is_leap == current_year_is_leap and
            previous_year_start_day == current_year_start_day):
            return previous_year
        previous_year -= 1
    return

def ChecksumHeader(sysname,messagetype,submessagetype,page):
    value = 0
    value = value ^ 85          # \x55
    value = value ^ 170         # \xAA
    value = value ^ sysname[0]
    value = value ^ sysname[1] 
    value = value ^ ord(messagetype)
    value = value ^ ord(submessagetype)
    value = value ^ page[0]
    value = value ^ page[1]
    return value

def ChecksumPayload(array,start,end):
    checksum=0
    for i in range(start,end):
        checksum = checksum ^ array[i]
    return checksum

def end_of_comms_ack(pagenum,system,ser):
    EndOfCommsACK = ChecksumHeader(system,"C","G",pagenum)
    ser.write(b'\x55'+b'\xAA')                              # [55 AA]	Signature - 2 Bytes
    ser.write(system)                                       # [XX XX]   "SYSTEM NAME" - 2 Bytes.
    ser.write(b'\x43')                                      # [43]		Command: 1 byte. ASCII value, "C"
    ser.write(b'\x47')                                      # [47]		Command Subtype: 1 Byte. ASCII value, "G"
    ser.write(b'\x00')                                      # [00]      Unknown A: 1 Byte. Value always seems to be [00]
    ser.write(b'\x00')                                      # [00]		Unknown B: 1 Byte. Value always seems to be [00]
    ser.write(EndOfCommsACK.to_bytes(1,byteorder='big'))    # [XX]		Checksum: 1 Byte.

def StartHandshake(system,ser):
    system_name = bytearray(system, "utf-8")
    HandshakeChecksum = ChecksumHeader(system_name,"B","G",[0,0])  # XOR = DA
    
    # Send Handshake
    ser.write(b'\x55'+b'\xAA')                                  # [55 AA]	Signature - 2 Bytes
    ser.write(system_name)                                      # [XX XX]   "SYSTEM NAME" - 2 Bytes.                                         
    ser.write(bytes("B", 'utf-8'))                              # [..]		Command - 1 byte.                               
    ser.write(bytes("G", 'utf-8'))                              # [..]		Command Subtype: 1 Byte.
    ser.write(b'\x00')                                          # [00]      Unknown A: 1 Byte. Value always seems to be [00]
    ser.write(b'\x00')                                          # [00]		Unknown B: 1 Byte. Value always seems to be [00]
    ser.write(HandshakeChecksum.to_bytes(1,byteorder='big'))    # [XX]      System Name Checksum

# ########################################################################
# External data passed to the script, replacing with defaults if values aren't passed.

# Define the parser
parser = argparse.ArgumentParser(description='Send current date and time to a SpectraGen 3/4.')

# Declare arguments (--name), store the value in 'dest' field, and use a default if the argument isn't given
parser.add_argument('--c', action="store", dest='ChannelName', default=" D", help="SpectraGen's CHANNEL NAME. (default ' D')")
parser.add_argument('--p', action="store", dest='Page', default="2", help="Page your date/time are stored on. (default: '2')")
parser.add_argument('--s', action="store", dest='SerialPort', default="COM1", help="Serial Port to send data through. (default 'COM1')")
parser.add_argument('--b', action="store", dest='BaudRate', default=9600, help="Baud Rate (default: 9600)")

# Parse the command line arguments and store the values in the `args` variable
args = parser.parse_args()

# recast relevant args from str to number
BaudRate = int(args.BaudRate)

# LETS GO!
ser = serial.Serial(args.SerialPort, args.BaudRate, timeout=1)  # open serial port

# Calculate Date and Time
now = datetime.now()
dayofweek = (int(now.strftime('%w'))).to_bytes(1, byteorder='big')
month = (now.month-1).to_bytes(1, byteorder='big')
daynumber = (now.day-1).to_bytes(1, byteorder='big')

year = now.year
year_is_in_range = 0

while year_is_in_range == 0:
    year = find_previous_identical_calendar_year(year)
    if year <= 1999:
        year_is_in_range = 1

year = (year - 1900).to_bytes(1, byteorder='big')

hour = now.hour
ampm = 0
if hour > 12:
    hour = hour - 12
    ampm = 1

hour = hour.to_bytes(1, byteorder='big')    
ampm = ampm.to_bytes(1, byteorder='big')

minute = now.minute.to_bytes(1, byteorder='big')
second = now.second.to_bytes(1, byteorder='big')

startpage = int(args.Page).to_bytes(2, byteorder='little')
endpage = startpage

bytefield = bytearray()
bytefield += dayofweek
bytefield += month
bytefield += daynumber
bytefield += year
bytefield += hour
bytefield += minute
bytefield += second
bytefield += ampm
bytefield += startpage
bytefield += endpage

system_name = bytearray(args.ChannelName, "utf-8")
MessageChecksum = ChecksumHeader(system_name,"S","T",[0,0])
ByteFieldChecksum = ChecksumPayload(bytefield,0,len(bytefield))

# send the handshake
StartHandshake(args.ChannelName,ser)

# read in the ack
buffer = ser.read(5)

# send the time
ser.write(b'\x55'+b'\xAA')                                  # [55 AA]	Signature - 2 Bytes
ser.write(system_name)                                      # [XX XX]   "SYSTEM NAME" - 2 Bytes.
ser.write(bytes("S", 'utf-8'))
ser.write(bytes("T", 'utf-8'))
ser.write(b'\x00')                                          # [00]      page number low
ser.write(b'\x00')                                          # [00]		page number high
ser.write(MessageChecksum.to_bytes(1,byteorder='big'))      # [XX]      System Name Checksum
ser.write(bytefield)
ser.write(ByteFieldChecksum.to_bytes(1,byteorder='big'))

# receive the ACK
CheckACK = ser.read(9)                              

# Check the ACK
if CheckACK[5] != 71:                               # The command in ACK must be "G"
    print(f"Invalid ACK, got {CheckACK[5]} aborting.\n")
    sys.exit()

# Message sent. Send End Of Comms ACK
end_of_comms_ack([0,0],system_name,ser)

if ser.in_waiting > 1:
    print(f"There are bytes left to receive for some reason...\n")
    print(ser.in_waiting)

ser.close()

# we're done!


