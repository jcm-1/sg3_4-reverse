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

    # check formatting of start, end and destination pages
        StartPageValue = self.StartPage.get("1.0", "end-1c")
        EndPageValue = self.EndPage.get("1.0", "end-1c")
        DestPageValue = self.DestPage.get("1.0", "end-1c")

    # are page numbers blank?
        if len(StartPageValue) < 1:
            WriteText(self.text_box,"ERROR: Start Page must contain an integer between 0 and 9999, inclusive.\n")
            return

        if len(EndPageValue) < 1:
            WriteText(self.text_box,"ERROR: End Page must contain an integer between the Start Page value and 9999, inclusive.\n")
            return
        
        if len(DestPageValue) < 1:
            WriteText(self.text_box,"ERROR: Destination Page must contain an integer between the 0 and 9999, inclusive.\n")
            return

    # do the page numbers contain any non numbers?
        if not StartPageValue.isdigit():
            WriteText(self.text_box,"ERROR: Start Page contains a non-digit.\n")
            return
       
        if not EndPageValue.isdigit():
            WriteText(self.text_box,"ERROR: End Page contains a non-digit.\n")
            return
        
        if not DestPageValue.isdigit():
            WriteText(self.text_box,"ERROR: Destination Page contains a non-digit.\n")
            return
        
    # convert page values into numbers values
        StartPageInt = int(StartPageValue)
        EndPageInt = int(EndPageValue)
        DestPageInt = int(DestPageValue)

    # set upper bound to 9999
        if StartPageInt > 9999:
            StartPageInt = 9999

        if EndPageInt > 9999:
            EndPageInt = 9999

        if DestPageInt > 9999:
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

    # check to see if the File Name is blank
        FolderName = FileLabelText.get()
        if FolderName == "":
            WriteText(self.text_box,"ERROR: You must select a file.\n\n")
            return

    # Get Page numbers from form to check sanity
        RequestedStartPage = int(self.StartPage.get("1.0", "end-1c"))
        RequestedEndPage = int(self.EndPage.get("1.0", "end-1c"))
        RequestedDestPage = int(self.DestPage.get("1.0", "end-1c"))
        TotalPagesInFile = int((len(G_content_array)/379))
 
    # check start page isn't greater than the end page
        if RequestedStartPage > RequestedEndPage:
            WriteText(self.text_box,f"ERROR: You requested a start page greater than the number of pages in the file.\n")
            return

    # get the real end page
        RealEndPageOffset = ((TotalPagesInFile-1)*379)+6
        RealEndPage = int.from_bytes(G_content_array[RealEndPageOffset:RealEndPageOffset+2],'little')

    # check that requested end page isn't greater than real end page
        if RequestedEndPage > RealEndPage:
            WriteText(self.text_box,f"ERROR: You requested an end page greater than the real end page in the file.\n")
            return

    # check destination, can't be greater than 9999 minus the total number of pages
        if RequestedDestPage > 9999-(TotalPagesInFile+1):
            WriteText(self.text_box,f"ERROR: You requested a destination page that would eventually put pages beyond 9999.\n")
            return

    # format the bytearray properly for sending
        # First, create a subarray that begins and ends at the start and end page the user requested.

        # Create Page Indexes
        PageIndexStart = RequestedStartPage - GetStartPage(G_content_array)     # Index into the bytearray of the page we start working from.
        PageIndexEnd = RequestedEndPage                                         # Index into the bytearray of the last page we work from.

        # determine which byte number to start on
        StartByte = (PageIndexStart * 379)

        # determine which byte to end on
        EndByte = ((PageIndexEnd)+1)*379

        # create new array that is range stated above
        ArrayToSend = G_content_array[StartByte:EndByte]
        PagesToHack = int((len(ArrayToSend))/379)

        # Now, we transform each page to have the correct System Name, destination page number, and Checksum
        for i in range(PagesToHack):
            Offset = i*379
            # set system name on each page
            system_name = bytearray(SystemName, "utf-8")
            ArrayToSend[Offset+2] = system_name[0]
            ArrayToSend[Offset+3] = system_name[1]
            
            # Re-Number all the pages starting, with the first page being DestPage, second page being DestPage+1, etc.
            page_number = (RequestedDestPage + i).to_bytes(2, byteorder='little')
            ArrayToSend[Offset+6] = page_number[0]
            ArrayToSend[Offset+7] = page_number[1]

            # Checksum each page
            CheckSum0 = Offset+8
            ArrayToSend[CheckSum0] = CalculateChecksum(page_number,184)   # XOR = B8

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

    # Send each page
        for i in range(PagesToHack):
            Offset = i*379
            PageData = ArrayToSend[Offset:Offset+379]           # get 379 bytes starting at Offset
            WriteText(self.text_box,f"Sending Page {i+1} of {PagesToHack}\n")

            ser.write(PageData)                                 # send bytes
            CheckACK = ser.read(9)                              # receive the ACK

            WriteText(self.text_box,f"Got ACK, checking... ")   # Check the ACK
            if CheckACK[5] != 71:                               # The command in ACK must be "P"
                WriteText(self.text_box,f"Invalid ACK, got {CheckACK[5]} aborting.\n")
                return
            WriteText(self.text_box,f"ACK Good!\n")

    # when last page was fetched, send End Of Comms ACK
        WriteText(self.text_box,f"Sending 'End Of Comms' Message...\n")
        end_of_comms_ack((((EndPageInt+1)-StartPageInt)),SystemName,ser)

        if ser.in_waiting > 1:
            WriteText(self.text_box,f"There are bytes left to receive for some reason...\n")

    # we're done!
        abort(ser,self.text_box)
        return  # fallthrough failsafe


    def open_file_dialog(self):     # Opens a file dialog for user to select a folder path
        file_path = filedialog.askopenfilename(
            title="Select a File",
            initialdir=os.getcwd(),                                         # Sets the current OS directory as where we start
            filetypes=(("Binary Files", "*.BIN"), ("All files", "*.*"))     # Sets default open option to .BIN files
        )
        if file_path:  # Check if a file was actually selected
            SetFileLabel(self.FileLabel,FileLabelText,os.path.basename(file_path))
        else:
            pass

        # now, open the file and do sanity checks on it.
        global G_content_array                          # declaring as a global makes working with this easier. *shrug*
        G_content_array = bytearray(b"")                # null the array each time we open a file, so we're not appending to the file, just in case.
        try:    
            with open(file_path, "rb") as file:         # Try to open the file
                content = file.read()                   # Read the entire content into a bytes object
                G_content_array = bytearray(content)    # Convert the bytes object to a bytearray
        except FileNotFoundError:
            WriteText(self.text_box,"File Not Found!\n\n")
            SetFileLabel(self.FileLabel,FileLabelText,b"")
            return
        except Exception as e:
            WriteText(self.text_box,f"An error occurred: {e}")
            SetFileLabel(self.FileLabel,FileLabelText,b"")
            return
        
        # check the length of the file
        if (len(G_content_array) % 379 != 0):
            WriteText(self.text_box,"ERROR: File is the wrong size, can't be a data file.")
            SetFileLabel(self.FileLabel,FileLabelText,b"")
            return

        # check that first byte is 55
        if G_content_array[0] != 85:
            WriteText(self.text_box,"ERROR: File is missing 55 at beginning, can't be a data file.")
            SetFileLabel(self.FileLabel,FileLabelText,b"")
            return

        # File seems valid. Lets set up the text fields.

        # get the start page number
        StartPage = GetStartPage(G_content_array)   # Set the value of the StartPage text box to the first page in the data file.
        self.StartPage.delete("1.0", tk.END)        # Enable the StartPage text box.
        self.StartPage.insert('1.0', StartPage)
        self.StartPage.grid()

        # get the end page number
        NumOfPages = int((len(G_content_array)/379)-1)
        EndPage = StartPage + NumOfPages            # Set the value of the EndPage text box to a value calculated from length of file.
        self.EndPage.delete("1.0", tk.END)
        self.EndPage.insert('1.0', EndPage)         # Enable the EndPage text box.
        self.EndPage.grid()

        # assume the destination number to be the start page
        DestPage = StartPage                        # Set the DestPage text box to be the same as the StartPage (i.e. the insert point on the destination machine
                                                    #   is the same as the first page of the fetched file.)

        self.DestPage.delete("1.0", tk.END)         # Enable the Destination Page text box.
        self.DestPage.insert('1.0', DestPage)
        self.DestPage.grid()

    def InitUI(self):
        # Create a Text widget to display the output
        self.text_box = tk.Text(self.parent, wrap='word', height = 19, width=70)
        self.text_box.grid(row=0, column=0, padx=5, pady=5, columnspan=10)

        # Row 1 ########################################
        # Serial Port Label
        PortLabel = tk.Label(root, text="Serial Port")
        PortLabel.grid(row=1, column=0, padx=5, pady=5,sticky="E")

        # Serial Port Combobox
        serial_port_options = get_serial_ports()
        PortCombobox = ttk.Combobox(root, textvariable=COMPort,  values=(serial_port_options), width=10)
        PortCombobox.current(0)
        PortCombobox.grid(row=1, column=1, padx=5, pady=5,sticky="W")

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

        # Row 2 #########################################
        # Starting Page Label
        self.StartPageLabel = tk.Label(root, text="Start Page:")
        self.StartPageLabel.grid(row=2, column=0, padx=5, pady=5,sticky="E")

        # Staring Page Text Box
        self.StartPage = tk.Text(self.parent, wrap='word', height = 1, width=4)
        self.StartPage.grid(row=2, column=1, padx=5, pady=5, sticky="W")
        self.StartPage.grid_remove()

        # Destination Page Label
        self.DestPageLabel = tk.Label(root, text="Destination Page:")
        self.DestPageLabel.grid(row=2, column=2, padx=5, pady=5,sticky="E")

        # Destination Page Text Box
        self.DestPage = tk.Text(self.parent, wrap='word', height = 1, width=4)
        self.DestPage.grid(row=2, column=3, padx=5, pady=5, sticky="W")
        self.DestPage.grid_remove()

        # Row 3 ##########################################
        # End Page Label
        self.EndPageLabel = tk.Label(root, text="End Page:")
        self.EndPageLabel.grid(row=3, column=0, padx=5, pady=5,sticky="E")

        # End Page Text Box
        self.EndPage = tk.Text(self.parent, wrap='word', height = 1, width=4)
        self.EndPage.grid(row=3, column=1, padx=5, pady=5, sticky="W")
        self.EndPage.grid_remove()

        # Row 4 ##########################################
        # Set up the get folder path button
        GetFileNameButton = tk.Button(root, text="Choose File...", command=self.open_file_dialog)
        GetFileNameButton.grid(row=4, column=0, padx=5, pady=5,sticky="E")

        # Create a Text widget to display the selected folder
        FileLabelText.set(b"")
        self.FileLabel = tk.Label(root, textvariable=FileLabelText)
        self.FileLabel.grid(row=4, column=1, padx=5, pady=5, columnspan=5,sticky="W")

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
    HandshakeChecksum = CalculateChecksum(system_name,218)  # XOR = DA
    
    # Send Handshake
    ser.write(b'\x55'+b'\xAA')                                  # [55 AA]	Signature - 2 Bytes
    ser.write(system_name)                                      # [XX XX]   "SYSTEM NAME" - 2 Bytes.
    ser.write(b'\x42')                                          # [42]		Command - 1 byte. ASCII value, in this case 0x42, or "B" probably meaning "BATCH"
    ser.write(b'\x47')                                          # [47]		Command Subtype: 1 Byte. ASCII value, in this case 0x50 or "P", probably meaning "PAGE"
    ser.write(b'\x00')                                          # [00]      Unknown A: 1 Byte. Value always seems to be [00]
    ser.write(b'\x00')                                          # [00]		Unknown B: 1 Byte. Value always seems to be [00]
    ser.write(HandshakeChecksum.to_bytes(1,byteorder='big'))    # [XX]      System Name Checksum

def end_of_comms_ack(pagenum,system,ser):
    system_name = bytearray(system, "utf-8")
    EndOfCommsACK = CalculateChecksum(pagenum.to_bytes(2, byteorder='little'),255)

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

def GetStartPage(array):
    # get the start page number
    StartPage = int.from_bytes(array[6:8], byteorder='little')
    return StartPage

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
root.title("SpectraGen Batch Send")
root.geometry("600x480")
root.resizable(False, False)
COMPort = tk.StringVar()
FileLabelText = tk.StringVar()
gui = CoreGUI(root)
root.mainloop()