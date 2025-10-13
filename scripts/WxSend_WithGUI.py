import serial
import serial.tools.list_ports
import time
from tkinter import messagebox
import math

import tkinter as tk
from tkinter import ttk

class CoreGUI(object):
    def __init__(self,parent):
        self.parent = parent
        self.InitUI()

    def main(self):
        self.StatusBar.config(text="")        # Clear the status bar when we begin, to clear out any previous messages.
        try:
            port = COMPort.get()
            ser = serial.Serial(port, 150, timeout=1)  # open serial port
        except serial.SerialException as e:
            messagebox.showerror("Exception", f"Error opening serial port {port}:\n\n{e}")
            return
        except Exception as e:
            messagebox.showerror("Exception", f"An unexpected error occurred:\n\n{e}")
            return
                        
    # Convert Temperature
        temperature = self.TempText.get()
        try:
            temperature = int(temperature)
        except ValueError:
            self.StatusBar.config(text="Invalid Temperature Value")
            return
    
        if self.StandardCombobox.get() == "US":
            if temperature < -67 or temperature > 390:  # check for bounds
                self.StatusBar.config(text="Temperature must be between -67 and 390")
                return
            else:                                       # convert value
                temperature = math.ceil(((temperature*10)+670)/18) 
        else:
            if temperature < -55 or temperature > 199:  # check for bounds
                self.StatusBar.config(text="Temperature must be between -55 and 199")
                return
            else:                                       # convert value
                temperature = math.ceil(((temperature*10)+550)/10) 

    # Convert Wind Speed
        windspeed = self.WindSpeedText.get()
        try:
            windspeed = int(windspeed)
        except ValueError:
            self.StatusBar.config(text="Invalid Wind Speed Value")
            return
        if self.StandardCombobox.get() == "US":
            if windspeed < 0 or windspeed > 99:  # check for bounds
                self.StatusBar.config(text="Wind Speed must be between 0 and 99")
                return
            else:                                       # convert value
                windspeed = windspeed*2 
        else:
            if windspeed < 0 or windspeed > 99:  # check for bounds
                self.StatusBar.config(text="Wind Speed must be between 0 and 99")
                return
            else:                                       # convert value
                windspeed = int(windspeed/0.813)
        
    # Convert Wind Direction
        winddir = 0
        match self.WindDirCombobox.get():
            case "Calm":
                winddir = 24
            case "N":   
                winddir = 23
            case "NE":   
                winddir = 21
            case "E":    
                winddir = 29
            case "SE":   
                winddir = 25
            case "S":    
                winddir = 27
            case "SW":   
                winddir = 26
            case "W":    
                winddir = 30
            case "NW":   
                winddir = 22
            case _:
                winddir = 24
        
    # Convert Humidity
        humidity = self.HumidText.get()
        try:
            humidity = int(humidity)
        except ValueError:
            self.StatusBar.config(text="Invalid Humidity Value")
            return

        if humidity < 0 or humidity > 99:
            self.StatusBar.config(text="Invalid Humidity Value")
            return

    # Convert Barometer
        barohigh = self.BaroHighNumber.get()
        barolow = self.BaroLowNumber.get()
        try:
            barohigh = int(barohigh)
            barolow = int(barolow)
        except ValueError:
            self.StatusBar.config(text="Invalid Barometer Value")
            return
        
        if self.StandardCombobox.get() == "US":
            if (barohigh < 29 or barohigh > 31) or (barolow < 0 or barolow > 99):
                self.StatusBar.config(text="Invalid Barometer Value")
                return
            barohigh = ((barohigh-29)*100)
            barometer = barohigh+barolow
        else:
            if (barohigh < 98 or barohigh > 106) or (barolow < 0 or barolow > 9):
                self.StatusBar.config(text="Invalid Barometer Value")
                return
            #barohigh = barohigh
            barolow = barolow/10
            barometer = (((barohigh + barolow)*10)-983)*2.953488372093023

        if barometer > 254:
            barometer = 254
        if barometer < 0:
            barometer = 0
        barometer = int(barometer)
            
    # Convert Rain
        # NOP

    # compile the data into a string
        header = bytearray(b"\xFF\xFA\xF5")
        rain = bytearray(b"\x02")
        end = bytearray(b"\x00")

        temperature = temperature.to_bytes(length=1, byteorder='big')
        winddir = winddir.to_bytes(length=1, byteorder='big')
        humidity = humidity.to_bytes(length=1, byteorder='big')
        windspeed = windspeed.to_bytes(length=1, byteorder='big')
        barometer = barometer.to_bytes(length=1, byteorder='big')

        message = bytearray()
        message = header + temperature + winddir + humidity + windspeed + barometer + rain + end + end + end + end

        # LETS GO!
        self.StatusBar.config(text="Waiting for serial port to settle...")
        self.StatusBar.update()
        time.sleep(1)
        self.StatusBar.config(text="Flushing Hardware Serial Buffer...")
        self.StatusBar.update()

        flush = "a"
        while len(flush) > 0:
            flush = ser.read(1)
            self.StatusBar["text"] += "."
    
    # Send the data.
        self.StatusBar.config(text="Sending...")
        ser.write(message)
        ser.write(message)

    # we're done!
        self.StatusBar.config(text="Sent!")
        abort(ser,self)
        return  # fallthrough failsafe

    def InitUI(self):
        # Left and Right Frames
        LeftFrame = tk.Frame(root, borderwidth=0, relief="flat")
        LeftFrame.grid(row=0, column=0, padx=(0,40), pady=0, sticky="NW")

        RightFrame = tk.Frame(root, borderwidth=0, relief="flat")
        RightFrame.grid(row=0, column=1, padx=(0,0), pady=0, sticky="NW")

        # Temp Standard
        StandardLabel = tk.Label(LeftFrame, text="Standard")
        StandardLabel.grid(row=0, column=0, padx=3, pady=3,sticky="E")
    
        self.StandardCombobox = ttk.Combobox(LeftFrame, values=("US","Metric"), width=10)
        self.StandardCombobox.grid(row=0, column=1, padx=3, pady=3,sticky="W")
        self.StandardCombobox.current(0)

        # Temperature
        TempLabel = tk.Label(LeftFrame, text="Temperature")
        TempLabel.grid(row=1, column=0, padx=3, pady=3,sticky="E")
    
        self.TempText = tk.Entry(LeftFrame, width=3, validate='key', validatecommand=(ValidateNumber, '%P'))
        self.TempText.grid(row=1, column=1, padx=3, pady=3, sticky="W")

        # Wind Speed
        WindSpeedLabel = tk.Label(LeftFrame, text="Wind Speed")
        WindSpeedLabel.grid(row=2, column=0, padx=3, pady=3,sticky="E")
    
        self.WindSpeedText = tk.Entry(LeftFrame, width=3, validate='key', validatecommand=(ValidateNumber, '%P'))
        self.WindSpeedText.grid(row=2, column=1, padx=3, pady=3, sticky="W")

        # Wind Direction
        WindDirLabel = tk.Label(LeftFrame, text="Wind Direction")
        WindDirLabel.grid(row=3, column=0, padx=3, pady=3,sticky="E")
    
        self.WindDirCombobox = ttk.Combobox(LeftFrame, values=("Calm","N","NE","E","SE","S","SW","W","NW"), width=10)
        self.WindDirCombobox.grid(row=3, column=1, padx=3, pady=3,sticky="W")
        self.WindDirCombobox.current(0)

        # Humidity
        HumidLabel = tk.Label(LeftFrame, text="Humidity")
        HumidLabel.grid(row=4, column=0, padx=3, pady=3,sticky="E")
    
        self.HumidText = tk.Entry(LeftFrame, width=3, validate='key', validatecommand=(ValidateNumber, '%P'))
        self.HumidText.grid(row=4, column=1, padx=3, pady=3, sticky="W")

        # Barometer
        BarometerLabel = tk.Label(LeftFrame, text="Barometer")
        BarometerLabel.grid(row=5, column=0, padx=3, pady=3,sticky="E")
    
        BaroFrame = tk.Frame(LeftFrame, borderwidth=0, relief="flat")
        BaroFrame.grid(row=5, column=1, padx=(0,0), pady=0, sticky="W")

        self.BaroHighNumber = tk.Entry(BaroFrame, width=3, validate='key', validatecommand=(ValidateNumber, '%P'))
        self.BaroHighNumber.grid(row=0, column=0, padx=(3,0), pady=3, sticky="W")

        BaroDot = tk.Label(BaroFrame, text=".")
        BaroDot.grid(row=0, column=1, padx=0, pady=0,sticky="E")

        self.BaroLowNumber = tk.Entry(BaroFrame, width=3, validate='key', validatecommand=(ValidateNumber, '%P'))
        self.BaroLowNumber.grid(row=0, column=2, padx=(0,3), pady=3, sticky="W")
        # End Left Frame ############################

        # Begin Right Frame #########################
        # Serial Port Combobox
        PortLabel = tk.Label(RightFrame, text="Serial Port", justify="left")
        PortLabel.grid(row=0, column=0, padx=3, pady=3,sticky="NW")

        PortCombobox = ttk.Combobox(RightFrame, textvariable=COMPort,  values=(get_serial_ports()), width=10)
        PortCombobox.current(0)
        PortCombobox.grid(row=1, column=0, padx=3, pady=3,sticky="NW")

        PortNotice = tk.Label(RightFrame, text="SG Unit is hard coded\nto 150,8,N,1. Not all ports\nsupport this speed.", justify="left")
        PortNotice.grid(row=2, column=0, padx=3, pady=3,sticky="NW")

        # End Right Frame ###########################

        # Send Button
        RunButton = tk.Button(root, text="Send It!", command=self.main)
        RunButton.grid(row=1, column=0, padx=5, pady=5,sticky="E")

        # Status bar (sunken frame)
        StatusBarFrame = tk.Frame(root, borderwidth=1, relief="sunken")
        StatusBarFrame.grid(row=2, column=0, padx=5, pady=5, sticky="EW", columnspan=10)

        self.StatusBar = tk.Label(StatusBarFrame, text="Ready.")
        self.StatusBar.grid(row=0, column=0, padx=1, pady=1,sticky="E")

        # COM Port notice
        # COM Port Selection

        return

def validate_number_entry(p):
    if p == "":         # Allow empty string (for clearing the entry)
        return True
    if p == "-":        # Allow minus sign at beginning
        return True
    try:
        int(p)          # Attempt to convert to int
        return True
    except ValueError:
        return False
        
def abort(ser,self):
    ser.close()
    return

def get_serial_ports():
    ports = serial.tools.list_ports.comports()
    port_names = [port.device for port in ports]
    return port_names

# Initialze the GUI
root = tk.Tk()
ValidateNumber = root.register(validate_number_entry)
root.title("SpectraGen Weather Station")
root.geometry("366x240")
root.resizable(False, False)
COMPort = tk.StringVar()
FileLabelText = tk.StringVar()
gui = CoreGUI(root)
root.mainloop()