import serial
import serial.tools.list_ports
import time
import os
import sys
from datetime import datetime
from tkinter import filedialog

import tkinter as tk
from tkinter import ttk

def WriteText(text_box,data):
    text_box.insert(tk.END, data)
    text_box.see(tk.END)
    text_box.update_idletasks()

def SetFileLabel(LabelObject,VariableObject,data):
    VariableObject.set(data)
    LabelObject.update_idletasks()

class CoreGUI(object):
    def __init__(self,parent):
        self.parent = parent
        self.InitUI()
        WriteText(self.text_box,"NOTE: files have checksums. Please do not edit them with improper editors. \n\n")

    def main(self):
        port = COMPort.get()
        ser = serial.Serial(port, 9600, timeout=1)  # open serial port

    # check to see if system name is blank.     
        SystemName = self.systemname_box.get("1.0", "end-1c")

        match len(SystemName):
            case 0:
                WriteText(self.text_box,"ERROR: System Name cannot be empty.\n\n")
                return 
            case 1:
                SystemName = " "+SystemName
            case 2:
                pass
            case _:
                SystemName = SystemName[:2]
          
        WriteText(self.text_box,f"Sending Handshake...\n")
        StartHandshake(SystemName,ser)
        system_name = bytearray(SystemName, "utf-8")

    # Wait for the ACK
        buffer = ser.read(5)
        if buffer:
            WriteText(self.text_box,f"Got an ACK. Checking... ")
        else:
            WriteText(self.text_box,f"\nACK not received within the 1 second timeout.\n  - Did you provide the correct System Name?\n  - Are your cables connected properly?\n  - Have you chosen the correct serial port?\n\n")
            return
            
        for index, byte in enumerate(buffer):   # Check all bytes to ensure they are 0xAA
            if byte != 170:
                WriteText(self.text_box,f"ERROR: Invalid ACK value at position {index}. Expected 170, received {byte} \n")
                return
        buffer = b""

        WriteText(self.text_box,f"Received good ACK!\n")

    # Send the data!

        # Default Data Field Values
        #   1	DAYOFWEEK	    \x00
        #   2	MONTH		    \x01
        #   3	DAYNUMBER	    \x01
        #   4	YEAR		    \x58
        #   5	HOUR            \x0C
        #   6	MINUTE          \x00
        #   7	SECOND		    \x00
        #   8   AM or PM        \x00
        #   9:10   STARTPAGE    \x02\x00
        #   11:12  ENDPAGE      \x02\x00

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
        
        startpage = int(self.StartPage.get("1.0", "end-1c")).to_bytes(2, byteorder='little')
        endpage = int(self.EndPage.get("1.0", "end-1c")).to_bytes(2, byteorder='little')

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

        MessageChecksum = ChecksumHeader(system_name,"S","T",[0,0])
        ByteFieldChecksum = ChecksumPayload(bytefield,0,len(bytefield))

        WriteText(self.text_box,f"Sending the time...\n")

        ser.write(b'\x55'+b'\xAA')                                  # [55 AA]	Signature - 2 Bytes
        ser.write(system_name)                                      # [XX XX]   "SYSTEM NAME" - 2 Bytes.
        ser.write(bytes("S", 'utf-8'))
        ser.write(bytes("T", 'utf-8'))
        ser.write(b'\x00')                                          # [00]      page number low
        ser.write(b'\x00')                                          # [00]		page number high
        ser.write(MessageChecksum.to_bytes(1,byteorder='big'))      # [XX]      System Name Checksum
        ser.write(bytefield)
        ser.write(ByteFieldChecksum.to_bytes(1,byteorder='big'))
        
        CheckACK = ser.read(9)                              # receive the ACK

        WriteText(self.text_box,f"Got message ACK, checking... ")   # Check the ACK
        if CheckACK[5] != 71:                               # The command in ACK must be "G"
            WriteText(self.text_box,f"Invalid ACK, got {CheckACK[5]} aborting.\n")
            return
        WriteText(self.text_box,f"ACK Good!\n")

    # Message sent. Send End Of Comms ACK
        WriteText(self.text_box,f"Sending 'End Of Comms' Message...\n")
        end_of_comms_ack([0,0],system_name,ser)

        if ser.in_waiting > 1:
            WriteText(self.text_box,f"There are bytes left to receive for some reason...\n")

    # we're done!
        abort(ser,self.text_box)
        return  # fallthrough failsafe

    def InitUI(self):
        # Create a Text widget to display the output
        self.text_box = tk.Text(self.parent, wrap='word', height = 8, width=50)
        self.text_box.grid(row=0, column=0, padx=5, pady=5, columnspan=10)

        # Serial Port Label
        PortLabel = tk.Label(root, text="Serial Port")
        PortLabel.grid(row=1, column=0, padx=5, pady=5,sticky="E")

        # Serial Port Combobox
        serial_port_options = get_serial_ports()
        PortCombobox = ttk.Combobox(root, textvariable=COMPort,  values=(serial_port_options), width=10)
        PortCombobox.current(0)
        PortCombobox.grid(row=1, column=1, padx=5, pady=5,sticky="W")

        SystemHelpLabel = tk.Label(root, font=("", 8), justify="left", text="The serial port is hard coded in\nthis app to 9600 baud.\nPlease set your unit appropriately.")
        SystemHelpLabel.grid(row=2, column=0, padx=10, pady=0,sticky="E", columnspan=2)

        # system name label
        SystemLabel = tk.Label(root, text="System Name")
        SystemLabel.grid(row=1, column=2, padx=5, pady=5,sticky="E")
        
        # System Name Text box
        self.systemname_box = tk.Text(self.parent, wrap='word', height = 1, width=4)
        self.systemname_box.grid(row=1, column=3, padx=5, pady=5, sticky="W")
        self.systemname_box.insert('1.0', "D")

        # Set up the run button
        RunButton = tk.Button(root, text="Send It!", command=self.main)
        RunButton.grid(row=1, column=5, padx=5, pady=5,sticky="E")

        # Starting Page Label
        self.StartPageLabel = tk.Label(root, text="Start Page:")
        self.StartPageLabel.grid(row=4, column=0, padx=5, pady=5,sticky="E")

        # Staring Page Text Box
        self.StartPage = tk.Text(self.parent, wrap='word', height = 1, width=4)
        self.StartPage.insert(tk.END, "2")
        self.StartPage.grid(row=4, column=1, padx=5, pady=5, sticky="W")

        # End Page Label
        self.EndPageLabel = tk.Label(root, text="End Page:")
        self.EndPageLabel.grid(row=5, column=0, padx=5, pady=5,sticky="E")

        # End Page Text Box
        self.EndPage = tk.Text(self.parent, wrap='word', height = 1, width=4)
        self.EndPage.insert(tk.END, "2")
        self.EndPage.grid(row=5, column=1, padx=5, pady=5, sticky="W")

def abort(ser,text_box):
    text_box.insert(tk.END, "Closing serial port\n")
    text_box.see(tk.END)
    ser.close()
    text_box.insert(tk.END, "Done!\n")
    text_box.see(tk.END)
    # sys.exit()
    return

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

def end_of_comms_ack(pagenum,system,ser):
    EndOfCommsACK = ChecksumHeader(system,"C","G",pagenum)
    ser.write(b'\x55'+b'\xAA')                              # [55 AA]	Signature - 2 Bytes
    ser.write(system)                                       # [XX XX]   "SYSTEM NAME" - 2 Bytes.
    ser.write(b'\x43')                                      # [43]		Command: 1 byte. ASCII value, "C"
    ser.write(b'\x47')                                      # [47]		Command Subtype: 1 Byte. ASCII value, "G"
    ser.write(b'\x00')                                      # [00]      Unknown A: 1 Byte. Value always seems to be [00]
    ser.write(b'\x00')                                      # [00]		Unknown B: 1 Byte. Value always seems to be [00]
    ser.write(EndOfCommsACK.to_bytes(1,byteorder='big'))    # [XX]		Checksum: 1 Byte.

def get_serial_ports():
    ports = serial.tools.list_ports.comports()
    port_names = [port.device for port in ports]
    return port_names

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

# Initialze the GUI
root = tk.Tk()
root.title("SpectraGen Time Sync")
root.geometry("410x310")
root.resizable(False, False)
COMPort = tk.StringVar()
FileLabelText = tk.StringVar()
gui = CoreGUI(root)
root.mainloop()