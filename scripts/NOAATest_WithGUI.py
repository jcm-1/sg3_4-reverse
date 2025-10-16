import serial
import serial.tools.list_ports
import time
import os
import sys
from datetime import datetime
from tkinter import filedialog
from tkinter import messagebox

import tkinter as tk
from tkinter import ttk

def WriteText(text_box,data):
    text_box.insert(tk.END, data)
    text_box.see(tk.END)
    text_box.update_idletasks()

class CoreGUI(object):
    def __init__(self,parent):
        self.parent = parent
        self.InitUI()
        WriteText(self.StatusBox,"Ready! \n\n")

    def main(self):
        port = COMPort.get()
        ser = serial.Serial(port, 2400, timeout=1)  # open serial port

        # Message sequence number nnn  - A queue number for the message, assigned at the time the message was readied for transmission by the switching system.
        # SequenceNumberS = "001"
        # SequenceNumber = SequenceNumberS.encode('ascii')

        # T1T2     DATA TYPE and/or FORM DESIGNATORS
        # TDesignatorS = "AA"

        # A1A2     GEOGRAPHICAL and/or DATA TYPE and/or TIME DESIGNATORS
        # ADesignatorS = "XX"
        # TADesignatorsS = TDesignatorS+ADesignatorS
        # TADesignators = TADesignatorsS.encode('ascii')

        # ii      Used to differentiate two or more bulletins which contain data in the same code, originate from the same geographical area.
        # iiS =  "01"
        # ii = iiS.encode('ascii')

        # CCCC    International four-letter location indicator of the station originating or compiling the bulletin """
        LocationS = self.LocationText.get("1.0",'end-1c')
        if len(LocationS) != 4:
            messagebox.showerror("Bad Location Length", "Location must be exactly 4 characters.")
            return
        
        Location = LocationS.encode('ascii')

        # YYGGgg     International date-time group. YY = day of month.  GGgg = Hours and Minutes (HHMM)
        # now = datetime.now()
        # timestampS = now.strftime("%d%H%M")
        # timestamp = timestampS.encode('ascii')

        space = b"\x20"
        eopS = "$$"
        eop = eopS.encode('ascii')

        transcriptS = self.TranscriptText.get("1.0",'end-1c')
        transcriptS = transcriptS.replace("$$", "$!")     #sanity check the transcript to ensure it doesn't contain the closer string
        transcript = transcriptS.encode('utf-8')

        message = bytearray()
        message = message + Location + space + space
        message = message + transcript
        message = message + eop

    # LETS GO!
        WriteText(self.StatusBox,"Waiting for serial port to settle...\n")
        time.sleep(1)

        WriteText(self.StatusBox,"Flushing Hardware Serial Buffer...\n")
        flush = "a"
        while len(flush) > 0:
            flush = ser.read(1)

        WriteText(self.StatusBox,"Sending Test Data...\n")
        ser.write(message)

        if ser.in_waiting > 1:
            WriteText(self.StatusBox,f"There are bytes left to receive for some reason...\n")

    # we're done!
        abort(ser,self.StatusBox)
        return  # fallthrough failsafe
   
    def InitUI(self):
        # Create a Text widget to display the output
        self.StatusBox = tk.Text(self.parent, wrap='word', height = 7, width=70)
        self.StatusBox.grid(row=0, column=0, padx=5, pady=5, columnspan=10)

        # Row 1 ########################################
        # Serial Port Label
        PortLabel = tk.Label(root, text="Serial Port")
        PortLabel.grid(row=1, column=0, padx=5, pady=5,sticky="E")

        # Serial Port Combobox
        serial_port_options = get_serial_ports()
        PortCombobox = ttk.Combobox(root, textvariable=COMPort,  values=(serial_port_options), width=10)
        PortCombobox.current(0)
        PortCombobox.grid(row=1, column=1, padx=5, pady=5,sticky="W")

        SystemHelpLabel = tk.Label(root, font=("", 8), justify="left", text="The serial port is hard coded in\nthis app to 2400 baud.\nPlease set your unit appropriately.")
        SystemHelpLabel.grid(row=2, column=0, padx=0, pady=0,sticky="E", columnspan=2)

        LocationLabel = tk.Label(root, text="Location")
        LocationLabel.grid(row=3, column=0, padx=5, pady=5,sticky="E")
        self.LocationText = tk.Text(root, width=4,height=1)
        self.LocationText.grid(row=3, column=1, padx=3, pady=3, sticky="W")

        TranscriptLabel = tk.Label(root, text="Transcript")
        TranscriptLabel.grid(row=4, column=0, padx=5, pady=5,sticky="E")
        self.TranscriptText = tk.Text(root, width=32,height=8)
        self.TranscriptText.grid(row=4, column=1, padx=3, pady=3, sticky="W", columnspan=10)

        # Set up the run button
        RunButton = tk.Button(root, text="Send It!", command=self.main)
        RunButton.grid(row=2, column=5, padx=5, pady=5,sticky="E")
        return

def abort(ser,text_box):
    text_box.insert(tk.END, "Closing serial port\n")
    text_box.see(tk.END)
    ser.close()
    text_box.insert(tk.END, "Done!\n")
    text_box.see(tk.END)
    # sys.exit()
    return

def get_serial_ports():
    ports = serial.tools.list_ports.comports()
    port_names = [port.device for port in ports]
    return port_names

# Initialze the GUI
root = tk.Tk()
root.title("SpectraGen NOAA Test")
root.geometry("600x480")
root.resizable(False, False)
COMPort = tk.StringVar()
FileLabelText = tk.StringVar()
gui = CoreGUI(root)
root.mainloop()