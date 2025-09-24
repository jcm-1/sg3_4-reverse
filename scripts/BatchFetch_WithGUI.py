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

def SetFolderLabel(LabelObject,VariableObject,data):
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

    # check formatting of start and end pages
        StartPageValue = self.StartPage.get("1.0", "end-1c")
        EndPageValue = self.EndPage.get("1.0", "end-1c")

    # are page numbers blank?
        if len(StartPageValue) < 1:
            WriteText(self.text_box,"ERROR: Start Page must contain an integer between 0 and 9999, inclusive.\n")
            return

        if len(EndPageValue) < 1:
            WriteText(self.text_box,"ERROR: End Page must contain an integer between the Start Page value and 9999, inclusive.\n")
            return

    # do the page numbers contain any non numbers?
        if not StartPageValue.isdigit():
            WriteText(self.text_box,"ERROR: Start Page contains a non-digit.\n")
            return
        
        if not EndPageValue.isdigit():
            WriteText(self.text_box,"ERROR: End Page contains a non-digit.\n")
            return
        
    # convert page values into numbers values
        StartPageInt = int(StartPageValue)
        EndPageInt = int(EndPageValue)

    # set upper bound to 9999
        if StartPageInt > 9999:
            StartPageInt = 9999

        if EndPageInt > 9999:
            EndPageInt = 9999

    # is end page smaller than start page?
        if EndPageInt < StartPageInt:
            WriteText(self.text_box,"ERROR: End Page must be equal to or larger than the Start Page.\n")
            return
                
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

    # check to see if the Folder Name is blank
        FolderName = FolderLabelText.get()
        if FolderName == "":
            WriteText(self.text_box,"ERROR: You must select a folder name.\n\n")
            return

    # LETS GO!
        WriteText(self.text_box,"Waiting for serial port to settle...\n")
        time.sleep(1)

        WriteText(self.text_box,"Flushing Hardware Serial Buffer...\n")
        flush = "a"
        while len(flush) > 0:
            flush = ser.read(1)

    # Send the handshake
        WriteText(self.text_box,f"Sending Handshake...\n")
        StartHandshake(SystemName,ser)

    # Wait for the ACK
        # Ensure ACK is 0xAA five times
        buffer = ser.read(5)
        if buffer:
            WriteText(self.text_box,f"Got an ACK. Checking... ")
        else:
            WriteText(self.text_box,f"\nACK not received within the 1 second timeout.\n  - Did you provide the correct System Name?\n  - Are your cables connected properly?\n  - Have you chosen the correct serial port?")
            return
            
        for index, byte in enumerate(buffer):
            if byte != 170:
                WriteText(self.text_box,f"ERROR: Invalid ACK value at position {index}. Expected 170, received {byte} \n")
                return
        buffer = b""

        WriteText(self.text_box,f"Received good ACK!\n")

    # send request for each page
        for index in range(StartPageInt, EndPageInt+1):
            WriteText(self.text_box,f"Requesting Page {index} ... ")
            SendFetchRequest(index,SystemName,ser)
            # check for error from responder
            tempbuffer = ser.read(9)   # get 9 bytes - i.e. the length of an error
       
            if tempbuffer[5] == 73:   # check xth byte
                WriteText(self.text_box,f"\n\nERROR: Response 'I' from remote unit: probably requested a page number greater than it's maximum\n")
                return

            # if valid, add tempbuffer to buffer, then get x more bytes
            buffer = buffer+tempbuffer
            buffer = buffer+ser.read(370)
            WriteText(self.text_box,f"Received page {index}\n")

    # when last page was fetched, send closer
        WriteText(self.text_box,f"Sending 'End Of Comms' Message...\n")
        end_of_comms_ack((((EndPageInt+1)-StartPageInt)),SystemName,ser)    # send the end of page ack

        if ser.in_waiting > 1:
            WriteText(self.text_box,f"There are bytes left to receive for some reason...\n")

    # Create file name from date/time
        now = datetime.now()
        nowStr = now.strftime("%Y-%m-%d %H.%M.%S")
        FriendlyName = self.FriendlyName_box.get("1.0", "end-1c")

        file_name="SG_Backup [" +FriendlyName+ "]["+SystemName+"][S"+StartPageValue+"][E"+EndPageValue+"] "+nowStr+".bin"

        # Open the file in binary write mode ('wb') and write the bytearray
        try:
            with open(file_name, 'wb') as f:
                f.write(buffer)
            WriteText(self.text_box,"\nData successfully written to:\n      " + file_name + "\n\n")
        except IOError as e:
            WriteText(self.text_box,"Error saving the file!\n\n")
            WriteText(self.text_box,e)
            WriteText(self.text_box,"\n\n")

    # we're done!
        abort(ser,self.text_box)

        return  # fallthrough failsafe

    def open_file_dialog(self):
        # Opens a file dialog for user to select a folder path
        file_path = filedialog.askdirectory(
            title="Select a Directory",
            initialdir=os.getcwd(),  # Sets the initial directory
        )
        if file_path:  # Check if a file was actually selected
            SetFolderLabel(self.FolderLabel,FolderLabelText,file_path)
            os.chdir(file_path)
        else:
            pass
        
    def InitUI(self):
        # Create a Text widget to display the output
        self.text_box = tk.Text(self.parent, wrap='word', height = 15, width=70)
        self.text_box.grid(row=0, column=0, padx=5, pady=5, columnspan=10)


        # Row 1 ########################################
        # Serial Port Label
        PortLabel = tk.Label(root, text="Serial Port")
        PortLabel.grid(row=1, column=0, padx=5, pady=5,sticky="E")

        # Serial Port Combobox
        serial_port_options = get_serial_ports()
        PortCombobox = ttk.Combobox(root, textvariable=COMPort,  values=(serial_port_options))
        PortCombobox.current(0)
        PortCombobox.grid(row=1, column=1, padx=5, pady=5,sticky="W")

        # system name label
        SystemLabel = tk.Label(root, text="System Name")
        SystemLabel.grid(row=1, column=2, padx=5, pady=5,sticky="W")
        
        # System Name Text box
        self.systemname_box = tk.Text(self.parent, wrap='word', height = 1, width=4)
        self.systemname_box.grid(row=1, column=3, padx=5, pady=5, sticky="W")
        self.systemname_box.insert('1.0', "D")

        # Set up the run button
        RunButton = tk.Button(root, text="Fetch It!", command=self.main)
        RunButton.grid(row=1, column=5, padx=5, pady=5,sticky="E")

        # Row 2 #########################################
        # Starting Page Label
        self.StartPageLabel = tk.Label(root, text="Start Page:")
        self.StartPageLabel.grid(row=2, column=0, padx=5, pady=5,sticky="E")

        # Staring Page Text Box
        self.StartPage = tk.Text(self.parent, wrap='word', height = 1, width=4)
        self.StartPage.grid(row=2, column=1, padx=5, pady=5, sticky="W")

        # Row 3 ##########################################
        # End Page Label
        self.EndPageLabel = tk.Label(root, text="End Page:")
        self.EndPageLabel.grid(row=3, column=0, padx=5, pady=5,sticky="E")

        # End Page Text Box
        self.EndPage = tk.Text(self.parent, wrap='word', height = 1, width=4)
        self.EndPage.grid(row=3, column=1, padx=5, pady=5, sticky="W")

        # Row 4 ##########################################
        # Set up the get folder path button
        RunButton = tk.Button(root, text="Choose Folder...", command=self.open_file_dialog)
        RunButton.grid(row=4, column=0, padx=5, pady=5,sticky="E")

        # Create a Text widget to display the selected folder
        FolderLabelText.set(os.getcwd())
        self.FolderLabel = tk.Label(root, textvariable=FolderLabelText)
        self.FolderLabel.grid(row=4, column=1, padx=5, pady=5, columnspan=5,sticky="W")

        # Row 5 ##########################################
        # Set up the "default file name" part
        self.FriendlyNameLabel = tk.Label(root, text="Friendly Name")
        self.FriendlyNameLabel.grid(row=5, column=0, padx=5, pady=5, columnspan=5,sticky="W")

        self.FriendlyName_box = tk.Text(self.parent, wrap='word', height = 1, width=31)
        self.FriendlyName_box.grid(row=5, column=1, padx=5, pady=5, sticky="E")
        self.FriendlyName_box.insert('1.0', "SYSTEM")

        # Row 6 ##########################################
        # Set up the "default file name" part
        self.FNExplainLabel = tk.Label(root, text="The friendly name is a nickname you use to identify your system,\n so you can always match fetched batches to real units.", font=("", 10),justify=tk.LEFT)
        self.FNExplainLabel.grid(row=6, column=0, padx=5, pady=5, columnspan=5,sticky="W")


def abort(ser,text_box):
    text_box.insert(tk.END, "Closing serial port\n")
    text_box.see(tk.END)
    ser.close()
    text_box.insert(tk.END, "Exiting")
    text_box.see(tk.END)
    # sys.exit()
    return

def StartHandshake(system,ser):
    system_name = bytearray(system, "utf-8")
    HandshakeChecksum = CalculateChecksum(system_name,218)

    # Send Handshake
    ser.write(b'\x55'+b'\xAA')                                  # [55 AA]	Signature - 2 Bytes
    ser.write(system_name)                                      # [XX XX]   "SYSTEM NAME" - 2 Bytes.
    ser.write(b'\x42')                                          # [42]		Command - 1 byte. ASCII value, in this case 0x42, or "B" probably meaning "BATCH"
    ser.write(b'\x47')                                          # [47]		Command Subtype: 1 Byte. ASCII value, in this case 0x50 or "P", probably meaning "PAGE"
    ser.write(b'\x00')                                          # [00]      Unknown A: 1 Byte. Value always seems to be [00]
    ser.write(b'\x00')                                          # [00]		Unknown B: 1 Byte. Value always seems to be [00]
    ser.write(HandshakeChecksum.to_bytes(1,byteorder='big'))    # [XX]      System Name Checksum

def SendFetchRequest(pagenum,system,ser):
    system_name = bytearray(system, "utf-8")

    # Generate Page Number Checksum
    PageNumBytes = pagenum.to_bytes(2, byteorder='little')
    FetchChecksum = CalculateChecksum(PageNumBytes,173)         # XOR = 0xAD

    # Send Request
    ser.write(b'\x55'+b'\xAA')                                  # [55 AA]	Signature - 2 Bytes
    ser.write(system_name)                                      # [XX XX]   "SYSTEM NAME" - 2 Bytes.
    ser.write(b'\x46')                                          # [42]		Command: 1 byte. ASCII value, in this case 0x46, or "F" meaning "FETCH"
    ser.write(b'\x50')                                          # [47]		Command Subtype: 1 Byte. ASCII value, in this case 0x50 or "P", possibly meaning "PAGE"
    ser.write(PageNumBytes)
    ser.write(FetchChecksum.to_bytes(1,byteorder='big'))        # [XX]      System Name Checksum

def end_of_comms_ack(pagenum,system,ser):
    system_name = bytearray(system, "utf-8")
    
    # Generate Page Number Checksum
    PageNumBytes = pagenum.to_bytes(2, byteorder='little')
    EndOfCommsACK = CalculateChecksum(PageNumBytes,255)
    
    # Send ACK
    ser.write(b'\x55'+b'\xAA')                              # [55 AA]	Signature - 2 Bytes
    ser.write(system_name)                                  # [XX XX]   "SYSTEM NAME" - 2 Bytes.
    ser.write(b'\x43')                                      # [43]		Command: 1 byte. ASCII value, in this case 0x43, or "C"
    ser.write(b'\x47')                                      # [47]		Command Subtype: 1 Byte. ASCII value, in this case 0x50 or "P"
    ser.write(b'\x00')                                      # [00]      Unknown A: 1 Byte. Value always seems to be [00]
    ser.write(b'\x00')                                      # [00]		Unknown B: 1 Byte. Value always seems to be [00]
    ser.write(EndOfCommsACK.to_bytes(1,byteorder='big'))    # [XX]		Checksum: 1 Byte.

def get_serial_ports():
    ports = serial.tools.list_ports.comports()
    port_names = [port.device for port in ports]
    return port_names

def CalculateChecksum(data,xor):
    # data must be a two byte object of a little endian number
    # XOR is a value between 0 and 255

    # Table of Known XORs
    # Fetch a Page              173 / 0xAD
    # Send a page               184 / 0xB8
    # Start Handshake           218 / 0xDA
    # End of Communicattions    255 / 0xFF

    step1 = data[0] ^ data[1]   # xor first byte with 2nd byte
    step2 = step1 ^ 32                          # then, you xor result with 0x20
    CheckSum = step2 ^ xor                 # then, you xor result with 255
    return CheckSum

# Initialze the GUI
root = tk.Tk()
root.title("SpectraGen Batch Fetch")
root.geometry("600x480")
root.resizable(False, False)
COMPort = tk.StringVar()
FolderLabelText = tk.StringVar()
gui = CoreGUI(root)
root.mainloop()