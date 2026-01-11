# Send NOAA Page data to a SpectraGen 3/4 from an NOAA Query
# Requires: pip install requests

# Pass the script the requested parameters, and it will grab the closest NOAA data, format it, and send it to the unit.
# Running the script without paramters will fetch and send based on defaults.

# things you need to know
#   The 4 character "OPEN CODE" that the SpectraGen is expecting to receive
#       Default: "AAAA"
#   The SpectraGen's 2 character CHANNEL name
#       Default: " D"
#   The Lat and Lon of the area you wish to fetch
#       Default Lat: ""
#       Default Lon: ""
#   The COM port to send it over
#       Default: "COM1"
#   The Baud Rate
#       Default: "2400"
#       (Serial settings for NOAA are always 8,N,1 for the SpectraGen)
#   First Forecast Period
#       This is the first period you would like to fetch.
#       Default: 0 (i.e. the most current available period)
#       Minimum: 0
#       Maximim: 13
#   Forecast Loop?
#       Useful for getting multiple days of forecast.
#       A value of 0 means don't run a loop, just fetch the First Forecast Period
#       1 means run a loop
#       Default: 0 (don't loop)
#       Minimum: 0
#       Maximum: 1
#   Last Forecast Period
#       The Forecast Period to end on, if doing a loop.
#       Default: 13 (i.e. the last possible period)
#       Minimum: 1
#       Maximum: 13
#   Forecast Loop Skip
#       A number of forecast periods to skip, if pulling a loop
#       Valid values are 0 and 1.
#           0 = don't skip.
#           1 = get every other one. Useful for getting only days or nights.
#       Default: 0 (don't skip)

import argparse
import json
import requests
import serial
import sys
import time

# ########################################################################
# External data passed to the script, replacing with defaults if values aren't passed.

# Define the parser
parser = argparse.ArgumentParser(description='Send NOAA Page data to a SpectraGen 3/4 from an NOAA Query')

# Declare arguments (--name), store the value in 'dest' field, and use a default if the argument isn't given
parser.add_argument('--o', action="store", dest='OpenCode', default="AAAA", help="SpectraGen's OPEN CODE. (default 'AAAA')")
parser.add_argument('--c', action="store", dest='ChannelName', default=" D", help="SpectraGen's CHANNEL NAME. (default ' D')")
parser.add_argument('--s', action="store", dest='SerialPort', default="COM1", help="Serial Port to send data through. (default 'COM1')")
parser.add_argument('--b', action="store", dest='BaudRate', default=2400, help="Baud Rate (default: 2400)")
parser.add_argument('--lat', action="store", dest='Lat', default=40.38, help="Latitude for requested forecast, in decimal format (default: 40.38)")
parser.add_argument('--lon', action="store", dest='Lon', default=-82.48, help="Longituded for requested forecast, in decimal format (default: -82.48)")
parser.add_argument('--fp', action="store", dest='FirstPeriod', default=0, help="First Forecast Period (default: 0, most current to NOW)")
parser.add_argument('--lo', action="store", dest='Loop', default=0, help="Get Multiple Periods? 0 for no. 1 for yes. (default: 0, don't get more than First Forecast Period)")
parser.add_argument('--lp', action="store", dest='LastPeriod', default=13, help="Last Period in Loop, maximum 13. (default: 13, as many as possible)")
parser.add_argument('--sk', action="store", dest='Skip', default=0, help="Skip every other forecast periods. 0=no skip, 1=skip. (default: 0, no skipping)")

# Parse the command line arguments and store the values in the `args` variable
args = parser.parse_args()

# recast relevant args from str to number
BaudRate = int(args.BaudRate)
Lat = float(args.Lat)
Lon = float(args.Lon)
FirstPeriod = int(args.FirstPeriod)
Loop = int(args.Loop)
LastPeriod = int(args.LastPeriod)
Skip = int(args.Skip)

#sys.exit()

# ########################################################################
# Define a required User-Agent
HEADERS = {
    'User-Agent': 'JCM-NOAA-Python, monitoring@jcm-1.com' 
}

# Set a Default MessageText so even if it fails, something is sent to the SG
MessageText = "No data received."

# Get the forecast office and grid data URL
points_url = f"https://api.weather.gov/points/{Lat},{Lon}"
points_response = requests.get(points_url, headers=HEADERS)

if points_response.status_code == 200:
    points_data = points_response.json()

    # Extract the forecast URL from the response
    forecast_url = points_data['properties']['forecast']
    
    # Get the actual forecast
    forecast_response = requests.get(forecast_url, headers=HEADERS)
    if forecast_response.status_code == 200:
        forecast_data = forecast_response.json()    # This is all the data.

        # Stringify the Data! ###################################      
        current_forecast = forecast_data['properties']['periods'][FirstPeriod]
        MessageText = "Forecast for " + points_data['properties']['relativeLocation']['properties']['city'] + ", " + points_data['properties']['relativeLocation']['properties']['state'] + ":  "
        
        if Loop == 1:
            if Skip == 1:
                step = 2
            else:
                step = 1

            for i in range(FirstPeriod, LastPeriod + 1, step):
                current_forecast = forecast_data['properties']['periods'][i]
                MessageText = MessageText + " " + current_forecast['name'] + ": " + current_forecast['detailedForecast']
        else:
            # this works because you already chose FirstPeriod to get the city data.
            MessageText = MessageText + current_forecast['name'] + ": " + current_forecast['detailedForecast']
    else:
        MessageText = (f"Failed to fetch forecast: Status code {forecast_response.status_code}")
else:
    MessageText = (f"Failed to fetch location: Status code {points_response.status_code}")

# Format data correctly.
space = b"\x20"
eop = bytearray("$$",'utf-8')

MessageText = MessageText.replace("$$", "$!")     #sanity check the transcript to ensure it doesn't contain the closer string
MessageTextArray = bytearray(MessageText, 'utf-8')
OpenCodeArray = bytearray(args.OpenCode,'utf-8')

message = bytearray()
message = message + OpenCodeArray + space + space
message = message + MessageTextArray
message = message + eop

# LETS GO!
ser = serial.Serial(args.SerialPort, args.BaudRate, timeout=1)  # open serial port

#print("Waiting for serial port to settle...\n")
time.sleep(1)

#print("Flushing Hardware Serial Buffer...\n")
flush = "a"
while len(flush) > 0:
    flush = ser.read(1)

#print("Sending Test Data...\n")
ser.write(message)

#if ser.in_waiting > 1:
    #print("There are bytes left to receive for some reason...\n")