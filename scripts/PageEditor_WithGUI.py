import serial
import serial.tools.list_ports
import time
import os
import sys
from datetime import datetime
from tkinter import filedialog
from tkinter import font as tkfont
from tkinter import messagebox

import tkinter as tk
from tkinter import ttk

from PIL import Image, ImageTk

pagesarray = bytearray()
LastPageEdited = int()

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

    def main(self):
        #port = COMPort.get()
        #ser = serial.Serial(port, 9600, timeout=1)  # open serial port

    # we're done!
        abort(ser,self.text_box)
        return  # fallthrough failsafe
    
    def save_file_dialog(self):
        SaveGUIToDataArray(self)    # save current page just in case
        global pagesarray
        file_path = filedialog.asksaveasfilename(
            defaultextension=".bin",  # Sets a default file extension
            filetypes=[("BIN files", "*.bin"), ("All files", "*.*")], # Defines file type filters
            title="Save File As" # Sets the dialog window title
        )

        if file_path:  # If a file path is selected (user didn't cancel)
            print(f"Selected file path for saving: {file_path}")
            # You would typically write content to this file_path here
            with open(file_path, 'wb') as file:
                file.write(pagesarray)
        return
    


    def open_file_dialog(self):
        file_path = filedialog.askopenfilename(
            title="Select a File",
            initialdir=os.getcwd(),                                         # Sets the current OS directory as where we start
            filetypes=(("Binary Files", "*.BIN"), ("All files", "*.*"))     # Sets default open option to .BIN files
        )

        # now, open the file and do sanity checks on it.
        try:    
            with open(file_path, "rb") as file:         # Try to open the file
                content = file.read()                   # Read the entire content into a bytes object
                content_array = bytearray(content)    # Convert the bytes object to a bytearray
        except FileNotFoundError:
            #messagebox.showerror("File Not Found", "The file was not found, or you didn't select one.")
            return
        except Exception as e:
            messagebox.showerror("Exception", f"An error occurred: {e}")
            return
        
        # check the length of the file
        if (len(content_array) % 379 != 0):
            messagebox.showerror("Wrong File Type", "File is the wrong size, can't be a data file." )
            return
        
        # check that first byte is 55
        if content_array[0] != 85:
            messagebox.showerror("Wrong File Type", "Magic Bytes incorrect, can't be a data file." )
            return
        
        # File seems valid.

        # return the entire dataset for later manipulation
        global pagesarray
        pagesarray = content_array
        global LastPageEdited
        LastPageEdited = -1

        # reset the GUI with the page data.
        LoadGUIWithPageData(pagesarray,-1,self,0)

        return
        
    def InitUI(self):
    ### Default Page Data when initializing the program
        self.default_page_values = bytearray([
                                         85,170,32,68,83,80,0,0,152,    # [0]       Data Header
                                         0,                             # [9]       Page Skip/Link/Wait   
                                         15,                            # [10]      DISPLAY TIME
                                         16,                            # [11]      DISPLAY SPEED
                                         2,                             # [12]      DISPLAY TYPE
                                         0,0,0,                         # [13]      DISPLAY TIME WINDOW start
                                         0,0,0,                         # [16]      DISPLAY TIME WINDOW end
                                         0,                             # [19]      LINE LEVELS
                                         0,                             # [20]      ... Unknown ...
                                         0,                             # [21]      TAPE ACTIONS and PLAYER NUMBER
                                         0,0,0,                         # [22]      ... Unknown ...
                                         128,1,201,48,                  # [25]      Line 0 Attributes
                                         128,1,201,48,                  # [29]      Line 1 Attributes
                                         128,1,201,48,                  # [33]      Line 2 Attributes
                                         128,1,201,48,                  # [37]      Line 3 Attributes
                                         128,1,201,48,                  # [41]      Line 4 Attributes
                                         128,1,201,48,                  # [45]      Line 5 Attributes
                                         128,1,201,48,                  # [49]      Line 6 Attributes
                                         128,1,201,48,                  # [53]      Line 7 Attributes
                                                                        # [57]      Line Text
                                         32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32, # Line 0 Text
                                         32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32, # Line 1 Text
                                         32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32, # Line 2 Text
                                         32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32, # Line 3 Text
                                         32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32, # Line 4 Text
                                         32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32, # Line 5 Text
                                         32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32, # Line 6 Text
                                         32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32, # Line 7 Text
                                         0,                             # [377]      ... Unknown ...
                                         29                             # [378]     Checksum: running XOR
                                        ])
                                        #48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,
                                        #49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,
                                        #50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,
                                        #51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,
                                        #52,52,52,52,52,52,52,52,52,52,52,52,52,52,52,52,52,52,52,52,52,52,52,52,52,52,52,52,52,52,52,52,52,52,52,52,52,52,52,52,
                                        #53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,
                                        #54,54,54,54,54,54,54,54,54,54,54,54,54,54,54,54,54,54,54,54,54,54,54,54,54,54,54,54,54,54,54,54,54,54,54,54,54,54,54,54,
                                        #55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,
                                        # 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32, # Line 0
                                        # 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32, # Line 1
                                        # 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32, # Line 2
                                        # 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32, # Line 3
                                        # 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32, # Line 4
                                        # 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32, # Line 5
                                        # 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32, # Line 6
                                        # 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32, # Line 7
        global pagesarray
        pagesarray = self.default_page_values
        self.KeyboardWindow = None

    # Check that the font is installed.
        if not "SpectraGen Complete" in list(tkfont.families()):
            messagebox.showerror("Font Missing", "Please insure you have installed the 'Spectragen Complete' font.")
            sys.exit()
            return
        
    # Check that the font image is in the same directory as the script
        if not os.path.isfile("font.png"):
            messagebox.showerror("Glyph File Missing", "Please insure you have placed the 'font.png' file into the same directory as this script.")
            sys.exit()
            return
        
    # line options header frame
        LinesOptionsHeaderFrame = tk.Frame(root, borderwidth=0, relief="groove")
        LinesOptionsHeaderFrame.grid(row=0, column=0, padx=(0,0), pady=0, sticky="W", columnspan=10)

        self.LineOptionsLabel = tk.Label(LinesOptionsHeaderFrame, text="Page Data", font=("", 12), justify="left")
        self.LineOptionsLabel.grid(row=0, column=0, padx=(10), pady=(5,0), sticky="SW")

        LineButtonsFrame = tk.Frame(LinesOptionsHeaderFrame, borderwidth=0, relief="groove")
        LineButtonsFrame.grid(row=0, column=1, padx=(0,0), pady=0, sticky="W", columnspan=10)

        self.EditorPageLabel = tk.Label(LineButtonsFrame, text="Current", justify="left")
        self.EditorPageLabel.grid(row=0, column=1, padx=(0,0), pady=(0,0), sticky="S")

        BackPageButton = tk.Button(LineButtonsFrame, text="<", command=lambda: BackPage(self))
        BackPageButton.grid(row=1, column=0, padx=1, pady=5,sticky="W")

        self.EditorPage = ttk.Combobox(LineButtonsFrame, height = 1, width=4, state="readonly")
        self.EditorPage.grid(row=1, column=1, padx=0, pady=(1,1), sticky="W")
        self.EditorPage.bind("<<ComboboxSelected>>", lambda event: LoadGUIWithPageData(pagesarray,self.EditorPage.current(),self,0))

        NextPageButton = tk.Button(LineButtonsFrame, text=">", command=lambda: NextPage(self))
        NextPageButton.grid(row=1, column=2, padx=1, pady=0,sticky="W")

        AddPageButton = tk.Button(LineButtonsFrame, text="Add Page", command=lambda: AddAPage(self))
        AddPageButton.grid(row=1, column=3, padx=1, pady=5,sticky="W")

        ResetPageButton = tk.Button(LineButtonsFrame, text="Reset Page", command=lambda: ClearThisPage(self))
        ResetPageButton.grid(row=1, column=4, padx=1, pady=0,sticky="W")

        StartOverButton = tk.Button(LineButtonsFrame, text="Start Over", command=lambda: StartOver(self))
        StartOverButton.grid(row=1, column=5, padx=80, pady=0,sticky="W")

        OSKButton = tk.Button(LineButtonsFrame, text="Special Keyboard", command=lambda: OnScreenKeyboard(self))
        OSKButton.grid(row=1, column=6, padx=6, pady=0,sticky="E")

    # Line Options Frame
        LinesFrame = ttk.Frame(root, borderwidth=2, relief="groove", padding=10)
        LinesFrame.grid(row=1, column=0, padx=(10,15), pady=10, sticky="W", columnspan=10)
        
    # Page Options Frame
        self.PageOptionsLabel = tk.Label(root, text="Page Options", font=("", 12), justify="left")
        self.PageOptionsLabel.grid(row=2, column=0, padx=10, pady=(5,0), sticky="SW")

        PageSettingsFrame = ttk.Frame(root, borderwidth=2, relief="groove", padding=10)
        PageSettingsFrame.grid(row=3, column=0, padx=(10,15), pady=10, sticky="W")

    # Data Management Frame
        if 0 == 0:
            DataMgmtLabel = tk.Label(root, text="Data Management", font=("", 12), justify="left")
            DataMgmtLabel.grid(row=2, column=1, padx=(5), pady=(5,0), sticky="SW")

            DataMgmtFrame = ttk.Frame(root, borderwidth=2, relief="groove", padding=10)
            DataMgmtFrame.grid(row=3, column=1, padx=(5,15), pady=10, sticky="NW")

            # Import Button
            ImportButton = tk.Button(DataMgmtFrame, text="Import File", command=self.open_file_dialog)
            ImportButton.grid(row=0, column=0, padx=(5,2), pady=5,sticky="W")

            # Save Button
            SaveButton = tk.Button(DataMgmtFrame, text="Save As", command=self.save_file_dialog)
            SaveButton.grid(row=0, column=1, padx=(2,5), pady=5,sticky="W")

    ### Labels For Line Attribute Columns
        if 0==0:
            self.xVidLabel = tk.Label(LinesFrame, text="Ext.\nVideo", font=("", 8), justify="left")
            self.xVidLabel.grid(row=0, column=1, padx=1, pady=(4,1), sticky="SW")

            self.LineColorLabel = tk.Label(LinesFrame, text="Line Color\nB.Ground:F.Ground", font=("", 8), justify="left")
            self.LineColorLabel.grid(row=0, column=2, padx=1, pady=(4,1), sticky="SW")

            self.SepTypeLabel = tk.Label(LinesFrame, text="Separator\nType", font=("", 8), justify="left")
            self.SepTypeLabel.grid(row=0, column=3, padx=1, pady=(4,1), sticky="SW")

            self.SepColorLabel = tk.Label(LinesFrame, text="Separator\nColor", font=("", 8), justify="left")
            self.SepColorLabel.grid(row=0, column=4, padx=1, pady=(4,1), sticky="SW")

            self.CharHeightLabel = tk.Label(LinesFrame, text="Char\nHeight", font=("", 8), justify="left")
            self.CharHeightLabel.grid(row=0, column=5, padx=1, pady=(4,1), sticky="SW")

            self.CharEdgeLabel = tk.Label(LinesFrame, text="Drop\nShad.", font=("", 8), justify="left")
            self.CharEdgeLabel.grid(row=0, column=6, padx=1, pady=(4,1), sticky="SW")

            self.FontTypeLabel = tk.Label(LinesFrame, text="Font\nType", font=("", 8), justify="left")
            self.FontTypeLabel.grid(row=0, column=7, padx=1, pady=(4,1), sticky="SW")

            self.PropSpaceLabel = tk.Label(LinesFrame, text="Prop.\nSpace", font=("", 8), justify="left")
            self.PropSpaceLabel.grid(row=0, column=8, padx=1, pady=(4,1), sticky="SW")

            self.CharWidthLabel = tk.Label(LinesFrame, text="Chars.\nPer Ln", font=("", 8), justify="left")
            self.CharWidthLabel.grid(row=0, column=9, padx=1, pady=(4,1), sticky="SW")

            self.CharBorderLabel = tk.Label(LinesFrame, text="Char.\nBorder", font=("", 8), justify="left")
            self.CharBorderLabel.grid(row=0, column=10, padx=1, pady=(4,1), sticky="SW")

    ### Load the font
        LineFont = tkfont.Font()
        LineFont.configure(family="SpectraGen Complete",size=22, weight='normal')
    
    ### Line Text Data input fields and field labels
        # this if statement allows me to collapse code segments for easier editing within VS Code. That's all -JSS
        if 0 == 0:
            self.L0_TextLabel = tk.Label(LinesFrame, text="0", font=("", 12, "bold"))
            self.L0_TextLabel.grid(row=2, column=0, padx=5, pady=(3,10), sticky="NE")
            self.Line0 = tk.Text(LinesFrame, wrap='word', height = 1, width=40, font=LineFont,borderwidth=0,padx=0,pady=-7)
            self.Line0.grid(row=2, column=1, padx=(0,5), pady=(1,13), columnspan=10, sticky="W")
            self.Line0.bind("<Key>", lambda event: LineInputEvent(event, self.Line1))
            self.Line0.bind("<B1-Motion>", disable_event)
            self.Line0.bind("<FocusIn>", lambda event: GetFocusedWidget())

            self.L1_TextLabel = tk.Label(LinesFrame, text="1", font=("", 12, "bold"))
            self.L1_TextLabel.grid(row=4, column=0, padx=5, pady=(3,10), sticky="NE")
            self.Line1 = tk.Text(LinesFrame, wrap='word', height = 1, width=40,font=LineFont,borderwidth=0,padx=0,pady=-7)
            self.Line1.grid(row=4, column=1, padx=(0,5), pady=(1,13), columnspan=10, sticky="W")
            self.Line1.bind("<Key>", lambda event: LineInputEvent(event, self.Line2))
            self.Line1.bind("<B1-Motion>", disable_event)
            self.Line1.bind("<FocusIn>", lambda event: GetFocusedWidget())  

            self.L2_TextLabel = tk.Label(LinesFrame, text="2", font=("", 12, "bold"))
            self.L2_TextLabel.grid(row=6, column=0, padx=5, pady=(3,10), sticky="NE")
            self.Line2 = tk.Text(LinesFrame, wrap='word', height = 1, width=40,font=LineFont,borderwidth=0,padx=0,pady=-7)
            self.Line2.grid(row=6, column=1, padx=(0,5), pady=(1,13), columnspan=10, sticky="W")
            self.Line2.bind("<Key>", lambda event: LineInputEvent(event, self.Line3))
            self.Line2.bind("<B1-Motion>", disable_event)
            self.Line2.bind("<FocusIn>", lambda event: GetFocusedWidget())  

            self.L3_TextLabel = tk.Label(LinesFrame, text="3", font=("", 12, "bold"))
            self.L3_TextLabel.grid(row=8, column=0, padx=5, pady=(3,10), sticky="NE")
            self.Line3 = tk.Text(LinesFrame, wrap='word', height = 1, width=40,font=LineFont,borderwidth=0,padx=0,pady=-7)
            self.Line3.grid(row=8, column=1, padx=(0,5), pady=(1,13), columnspan=10, sticky="W")
            self.Line3.bind("<Key>", lambda event: LineInputEvent(event, self.Line4))
            self.Line3.bind("<B1-Motion>", disable_event)
            self.Line3.bind("<FocusIn>", lambda event: GetFocusedWidget())  

            self.L4_TextLabel = tk.Label(LinesFrame, text="4", font=("", 12, "bold"))
            self.L4_TextLabel.grid(row=10, column=0, padx=5, pady=(3,10), sticky="NE")
            self.Line4 = tk.Text(LinesFrame, wrap='word', height = 1, width=40,font=LineFont,borderwidth=0,padx=0,pady=-7)
            self.Line4.grid(row=10, column=1, padx=(0,5), pady=(1,13), columnspan=10, sticky="W")
            self.Line4.bind("<Key>", lambda event: LineInputEvent(event, self.Line5))
            self.Line4.bind("<B1-Motion>", disable_event)
            self.Line4.bind("<FocusIn>", lambda event: GetFocusedWidget())  

            self.L5_TextLabel = tk.Label(LinesFrame, text="5", font=("", 12, "bold"))
            self.L5_TextLabel.grid(row=12, column=0, padx=5, pady=(3,10), sticky="NE")
            self.Line5 = tk.Text(LinesFrame, wrap='word', height = 1, width=40,font=LineFont,borderwidth=0,padx=0,pady=-7)
            self.Line5.grid(row=12, column=1, padx=(0,5), pady=(1,13), columnspan=10, sticky="W")
            self.Line5.bind("<Key>", lambda event: LineInputEvent(event, self.Line6))
            self.Line5.bind("<B1-Motion>", disable_event)
            self.Line5.bind("<FocusIn>", lambda event: GetFocusedWidget())  

            self.L6_TextLabel = tk.Label(LinesFrame, text="6", font=("", 12, "bold"))
            self.L6_TextLabel.grid(row=14, column=0, padx=5, pady=(3,10), sticky="NE")
            self.Line6 = tk.Text(LinesFrame, wrap='word', height = 1, width=40,font=LineFont,borderwidth=0,padx=0,pady=-7)
            self.Line6.grid(row=14, column=1, padx=(0,5), pady=(1,13), columnspan=10, sticky="W")
            self.Line6.bind("<Key>", lambda event: LineInputEvent(event, self.Line7))
            self.Line6.bind("<B1-Motion>", disable_event)
            self.Line6.bind("<FocusIn>", lambda event: GetFocusedWidget())  

            self.L7_TextLabel = tk.Label(LinesFrame, text="7", font=("", 12, "bold"))
            self.L7_TextLabel.grid(row=16, column=0, padx=5, pady=(3,10), sticky="NE")
            self.Line7 = tk.Text(LinesFrame, wrap='word', height = 1, width=40,font=LineFont,borderwidth=0,padx=0,pady=-7)
            self.Line7.grid(row=16, column=1, padx=(0,5), pady=(1,13), columnspan=10, sticky="W")
            self.Line7.bind("<Key>", lambda event: LineInputEvent(event, self.Line0))
            self.Line7.bind("<B1-Motion>", disable_event)
            self.Line7.bind("<FocusIn>", lambda event: GetFocusedWidget()) 

        # Text Structures for Per Line Settings Comboboxes      
        if 0 == 0:  # this if statement allows me to collapse code segments for easier editing within VS Code. That's all -JSS
            xVidOptions = ["Yes","No"]
            LineColorOptions = ["Blue:White",  "Red:White",  "Green:White",       "White:Dark Blue",    "Yellow:Olive",    "Olive:Yellow", "Violet:White", "Black:White 7",
                                "Blue:Yellow", "Red:Yellow", "Dark Green:Yellow", "White:Lt. Blue", "Yellow:Dk. Green", "Brown:Yellow", "Pink:Violet",  "Black:White 15", 
                                "White:Lilac",  "White:Red",  "White:Green",         "Pale Lilac:White", "Dk. Green:Yellow",    "Yellow:Dk. Green", "Pale Pink:Violet", "Black:White 23", 
                                "Yellow:Dk. Lilac", "Pink:Red",   "Lt. Yellow:Green",        "Lt. Blue:White","Green:Yellow",    "Brown:Yellow",  "Violet:Pink",  "Black:White 31"]
            SepTypeOptions = ["None","Underline","Overline","Both"]
            SepColorOptions = ["Blue", "Red", "Green", "Lt. Blue", "Yellow", "Olive", "Violet", "Black"]
            CharHeightOptions = ["0","1","2","3","4","5","6","7"]
            CharEdgeOptions = ["7","6","5","4","3","2","1","0"]
            FontTypeOptions = ["Std","Alt"]
            PropSpaceOptions = ["Yes","No"]
            CharWidthOptions = ["40","32","25","20","16","12","10","8"]
            CharBorderOptions = ["None","Black/FG","FG/BG","FG/Black"]

        # Fill Per Line comboboxes with default data
        # Line 0
        if 0 == 0:  # this if statement allows me to collapse code segments for easier editing within VS Code. That's all -JSS
            self.L0_xVid = ttk.Combobox(LinesFrame, values=xVidOptions, height = 1, width=4, state="readonly")
            self.L0_xVid.grid(row=1, column=1, padx=2, pady=0, sticky="W")

            self.L0_LineColor = ttk.Combobox(LinesFrame, values=LineColorOptions, height = 1, width=16, state="readonly")
            self.L0_LineColor.grid(row=1, column=2, padx=1, pady=0)

            self.L0_SepType = ttk.Combobox(LinesFrame, values=SepTypeOptions, height = 1, width=9, state="readonly")
            self.L0_SepType.grid(row=1, column=3, padx=1, pady=0, sticky="W")

            self.L0_SepColor = ttk.Combobox(LinesFrame, values=SepColorOptions, height = 1, width=7, state="readonly")
            self.L0_SepColor.grid(row=1, column=4, padx=1, pady=0, sticky="W")

            self.L0_CharHeight = ttk.Combobox(LinesFrame, values=CharHeightOptions, height = 1, width=3, state="readonly")
            self.L0_CharHeight.grid(row=1, column=5, padx=1, pady=0, sticky="W")

            self.L0_CharEdge = ttk.Combobox(LinesFrame, values=CharEdgeOptions, height = 1, width=3, state="readonly")
            self.L0_CharEdge.grid(row=1, column=6, padx=1, pady=0, sticky="W")

            self.L0_FontType = ttk.Combobox(LinesFrame, values=FontTypeOptions, height = 1, width=3, state="readonly")
            self.L0_FontType.grid(row=1, column=7, padx=1, pady=0, sticky="W")

            self.L0_PropSpace = ttk.Combobox(LinesFrame, values=PropSpaceOptions, height = 1, width=3, state="readonly")
            self.L0_PropSpace.grid(row=1, column=8, padx=1, pady=0, sticky="W")

            self.L0_CharWidth = ttk.Combobox(LinesFrame, values=CharWidthOptions, height = 1, width=3, state="readonly")
            self.L0_CharWidth.grid(row=1, column=9, padx=1, pady=0, sticky="W")

            self.L0_CharBorder = ttk.Combobox(LinesFrame, values=CharBorderOptions, height = 1, width=8, state="readonly")
            self.L0_CharBorder.grid(row=1, column=10, padx=1, pady=0, sticky="W")

            # Text Line 1
            self.L1_xVid = ttk.Combobox(LinesFrame, values=xVidOptions, height = 1, width=4, state="readonly")
            self.L1_xVid.grid(row=3, column=1, padx=1, pady=(1,1), sticky="W")

            self.L1_LineColor = ttk.Combobox(LinesFrame, values=LineColorOptions, height = 1, width=16, state="readonly")
            self.L1_LineColor.grid(row=3, column=2, padx=1, pady=(1,1))

            self.L1_SepType = ttk.Combobox(LinesFrame, values=SepTypeOptions, height = 1, width=9, state="readonly")
            self.L1_SepType.grid(row=3, column=3, padx=1, pady=(1,1), sticky="W")

            self.L1_SepColor = ttk.Combobox(LinesFrame, values=SepColorOptions, height = 1, width=7, state="readonly")
            self.L1_SepColor.grid(row=3, column=4, padx=1, pady=(1,1), sticky="W")

            self.L1_CharHeight = ttk.Combobox(LinesFrame, values=CharHeightOptions, height = 1, width=3, state="readonly")
            self.L1_CharHeight.grid(row=3, column=5, padx=1, pady=(1,1), sticky="W")

            self.L1_CharEdge = ttk.Combobox(LinesFrame, values=CharEdgeOptions, height = 1, width=3, state="readonly")
            self.L1_CharEdge.grid(row=3, column=6, padx=1, pady=(1,1), sticky="W")

            self.L1_FontType = ttk.Combobox(LinesFrame, values=FontTypeOptions, height = 1, width=3, state="readonly")
            self.L1_FontType.grid(row=3, column=7, padx=1, pady=(1,1), sticky="W")

            self.L1_PropSpace = ttk.Combobox(LinesFrame, values=PropSpaceOptions, height = 1, width=3, state="readonly")
            self.L1_PropSpace.grid(row=3, column=8, padx=1, pady=(1,1), sticky="W")

            self.L1_CharWidth = ttk.Combobox(LinesFrame, values=CharWidthOptions, height = 1, width=3, state="readonly")
            self.L1_CharWidth.grid(row=3, column=9, padx=1, pady=(1,1), sticky="W")

            self.L1_CharBorder = ttk.Combobox(LinesFrame, values=CharBorderOptions, height = 1, width=8, state="readonly")
            self.L1_CharBorder.grid(row=3, column=10, padx=1, pady=(1,1), sticky="W")

            # Text Line 2

            self.L2_xVid = ttk.Combobox(LinesFrame, values=xVidOptions, height = 1, width=4, state="readonly")
            self.L2_xVid.grid(row=5, column=1, padx=1, pady=(1,1), sticky="W")

            self.L2_LineColor = ttk.Combobox(LinesFrame, values=LineColorOptions, height = 1, width=16, state="readonly")
            self.L2_LineColor.grid(row=5, column=2, padx=1, pady=(1,1))

            self.L2_SepType = ttk.Combobox(LinesFrame, values=SepTypeOptions, height = 1, width=9, state="readonly")
            self.L2_SepType.grid(row=5, column=3, padx=1, pady=(1,1), sticky="W")

            self.L2_SepColor = ttk.Combobox(LinesFrame, values=SepColorOptions, height = 1, width=7, state="readonly")
            self.L2_SepColor.grid(row=5, column=4, padx=1, pady=(1,1), sticky="W")

            self.L2_CharHeight = ttk.Combobox(LinesFrame, values=CharHeightOptions, height = 1, width=3, state="readonly")
            self.L2_CharHeight.grid(row=5, column=5, padx=1, pady=(1,1), sticky="W")

            self.L2_CharEdge = ttk.Combobox(LinesFrame, values=CharEdgeOptions, height = 1, width=3, state="readonly")
            self.L2_CharEdge.grid(row=5, column=6, padx=1, pady=(1,1), sticky="W")

            self.L2_FontType = ttk.Combobox(LinesFrame, values=FontTypeOptions, height = 1, width=3, state="readonly")
            self.L2_FontType.grid(row=5, column=7, padx=1, pady=(1,1), sticky="W")

            self.L2_PropSpace = ttk.Combobox(LinesFrame, values=PropSpaceOptions, height = 1, width=3, state="readonly")
            self.L2_PropSpace.grid(row=5, column=8, padx=1, pady=(1,1), sticky="W")

            self.L2_CharWidth = ttk.Combobox(LinesFrame, values=CharWidthOptions, height = 1, width=3, state="readonly")
            self.L2_CharWidth.grid(row=5, column=9, padx=1, pady=(1,1), sticky="W")

            self.L2_CharBorder = ttk.Combobox(LinesFrame, values=CharBorderOptions, height = 1, width=8, state="readonly")
            self.L2_CharBorder.grid(row=5, column=10, padx=1, pady=(1,1), sticky="W")
       
            # Text line 3
            self.L3_xVid = ttk.Combobox(LinesFrame, values=xVidOptions, height = 1, width=4, state="readonly")
            self.L3_xVid.grid(row=7, column=1, padx=1, pady=(1,1), sticky="W")

            self.L3_LineColor = ttk.Combobox(LinesFrame, values=LineColorOptions, height = 1, width=16, state="readonly")
            self.L3_LineColor.grid(row=7, column=2, padx=1, pady=(1,1))

            self.L3_SepType = ttk.Combobox(LinesFrame, values=SepTypeOptions, height = 1, width=9, state="readonly")
            self.L3_SepType.grid(row=7, column=3, padx=1, pady=(1,1), sticky="W")

            self.L3_SepColor = ttk.Combobox(LinesFrame, values=SepColorOptions, height = 1, width=7, state="readonly")
            self.L3_SepColor.grid(row=7, column=4, padx=1, pady=(1,1), sticky="W")

            self.L3_CharHeight = ttk.Combobox(LinesFrame, values=CharHeightOptions, height = 1, width=3, state="readonly")
            self.L3_CharHeight.grid(row=7, column=5, padx=1, pady=(1,1), sticky="W")

            self.L3_CharEdge = ttk.Combobox(LinesFrame, values=CharEdgeOptions, height = 1, width=3, state="readonly")
            self.L3_CharEdge.grid(row=7, column=6, padx=1, pady=(1,1), sticky="W")

            self.L3_FontType = ttk.Combobox(LinesFrame, values=FontTypeOptions, height = 1, width=3, state="readonly")
            self.L3_FontType.grid(row=7, column=7, padx=1, pady=(1,1), sticky="W")

            self.L3_PropSpace = ttk.Combobox(LinesFrame, values=PropSpaceOptions, height = 1, width=3, state="readonly")
            self.L3_PropSpace.grid(row=7, column=8, padx=1, pady=(1,1), sticky="W")

            self.L3_CharWidth = ttk.Combobox(LinesFrame, values=CharWidthOptions, height = 1, width=3, state="readonly")
            self.L3_CharWidth.grid(row=7, column=9, padx=1, pady=(1,1), sticky="W")

            self.L3_CharBorder = ttk.Combobox(LinesFrame, values=CharBorderOptions, height = 1, width=8, state="readonly")
            self.L3_CharBorder.grid(row=7, column=10, padx=1, pady=(1,1), sticky="W")

            # Text Line 4
            self.L4_xVid = ttk.Combobox(LinesFrame, values=xVidOptions, height = 1, width=4, state="readonly")
            self.L4_xVid.grid(row=9, column=1, padx=1, pady=(1,1), sticky="W")

            self.L4_LineColor = ttk.Combobox(LinesFrame, values=LineColorOptions, height = 1, width=16, state="readonly")
            self.L4_LineColor.grid(row=9, column=2, padx=1, pady=(1,1))

            self.L4_SepType = ttk.Combobox(LinesFrame, values=SepTypeOptions, height = 1, width=9, state="readonly")
            self.L4_SepType.grid(row=9, column=3, padx=1, pady=(1,1), sticky="W")

            self.L4_SepColor = ttk.Combobox(LinesFrame, values=SepColorOptions, height = 1, width=7, state="readonly")
            self.L4_SepColor.grid(row=9, column=4, padx=1, pady=(1,1), sticky="W")

            self.L4_CharHeight = ttk.Combobox(LinesFrame, values=CharHeightOptions, height = 1, width=3, state="readonly")
            self.L4_CharHeight.grid(row=9, column=5, padx=1, pady=(1,1), sticky="W")

            self.L4_CharEdge = ttk.Combobox(LinesFrame, values=CharEdgeOptions, height = 1, width=3, state="readonly")
            self.L4_CharEdge.grid(row=9, column=6, padx=1, pady=(1,1), sticky="W")

            self.L4_FontType = ttk.Combobox(LinesFrame, values=FontTypeOptions, height = 1, width=3, state="readonly")
            self.L4_FontType.grid(row=9, column=7, padx=1, pady=(1,1), sticky="W")

            self.L4_PropSpace = ttk.Combobox(LinesFrame, values=PropSpaceOptions, height = 1, width=3, state="readonly")
            self.L4_PropSpace.grid(row=9, column=8, padx=1, pady=(1,1), sticky="W")

            self.L4_CharWidth = ttk.Combobox(LinesFrame, values=CharWidthOptions, height = 1, width=3, state="readonly")
            self.L4_CharWidth.grid(row=9, column=9, padx=1, pady=(1,1), sticky="W")

            self.L4_CharBorder = ttk.Combobox(LinesFrame, values=CharBorderOptions, height = 1, width=8, state="readonly")
            self.L4_CharBorder.grid(row=9, column=10, padx=1, pady=(1,1), sticky="W")          

            # Text Line 5
            self.L5_xVid = ttk.Combobox(LinesFrame, values=xVidOptions, height = 1, width=4, state="readonly")
            self.L5_xVid.grid(row=11, column=1, padx=1, pady=(1,1), sticky="W")

            self.L5_LineColor = ttk.Combobox(LinesFrame, values=LineColorOptions, height = 1, width=16, state="readonly")
            self.L5_LineColor.grid(row=11, column=2, padx=1, pady=(1,1))

            self.L5_SepType = ttk.Combobox(LinesFrame, values=SepTypeOptions, height = 1, width=9, state="readonly")
            self.L5_SepType.grid(row=11, column=3, padx=1, pady=(1,1), sticky="W")

            self.L5_SepColor = ttk.Combobox(LinesFrame, values=SepColorOptions, height = 1, width=7, state="readonly")
            self.L5_SepColor.grid(row=11, column=4, padx=1, pady=(1,1), sticky="W")

            self.L5_CharHeight = ttk.Combobox(LinesFrame, values=CharHeightOptions, height = 1, width=3, state="readonly")
            self.L5_CharHeight.grid(row=11, column=5, padx=1, pady=(1,1), sticky="W")

            self.L5_CharEdge = ttk.Combobox(LinesFrame, values=CharEdgeOptions, height = 1, width=3, state="readonly")
            self.L5_CharEdge.grid(row=11, column=6, padx=1, pady=(1,1), sticky="W")

            self.L5_FontType = ttk.Combobox(LinesFrame, values=FontTypeOptions, height = 1, width=3, state="readonly")
            self.L5_FontType.grid(row=11, column=7, padx=1, pady=(1,1), sticky="W")

            self.L5_PropSpace = ttk.Combobox(LinesFrame, values=PropSpaceOptions, height = 1, width=3, state="readonly")
            self.L5_PropSpace.grid(row=11, column=8, padx=1, pady=(1,1), sticky="W")

            self.L5_CharWidth = ttk.Combobox(LinesFrame, values=CharWidthOptions, height = 1, width=3, state="readonly")
            self.L5_CharWidth.grid(row=11, column=9, padx=1, pady=(1,1), sticky="W")

            self.L5_CharBorder = ttk.Combobox(LinesFrame, values=CharBorderOptions, height = 1, width=8, state="readonly")
            self.L5_CharBorder.grid(row=11, column=10, padx=1, pady=(1,1), sticky="W")

            # Text Line 6
            self.L6_xVid = ttk.Combobox(LinesFrame, values=xVidOptions, height = 1, width=4, state="readonly")
            self.L6_xVid.grid(row=13, column=1, padx=1, pady=(1,1), sticky="W")

            self.L6_LineColor = ttk.Combobox(LinesFrame, values=LineColorOptions, height = 1, width=16, state="readonly")
            self.L6_LineColor.grid(row=13, column=2, padx=1, pady=(1,1))

            self.L6_SepType = ttk.Combobox(LinesFrame, values=SepTypeOptions, height = 1, width=9, state="readonly")
            self.L6_SepType.grid(row=13, column=3, padx=1, pady=(1,1), sticky="W")

            self.L6_SepColor = ttk.Combobox(LinesFrame, values=SepColorOptions, height = 1, width=7, state="readonly")
            self.L6_SepColor.grid(row=13, column=4, padx=1, pady=(1,1), sticky="W")

            self.L6_CharHeight = ttk.Combobox(LinesFrame, values=CharHeightOptions, height = 1, width=3, state="readonly")
            self.L6_CharHeight.grid(row=13, column=5, padx=1, pady=(1,1), sticky="W")

            self.L6_CharEdge = ttk.Combobox(LinesFrame, values=CharEdgeOptions, height = 1, width=3, state="readonly")
            self.L6_CharEdge.grid(row=13, column=6, padx=1, pady=(1,1), sticky="W")

            self.L6_FontType = ttk.Combobox(LinesFrame, values=FontTypeOptions, height = 1, width=3, state="readonly")
            self.L6_FontType.grid(row=13, column=7, padx=1, pady=(1,1), sticky="W")

            self.L6_PropSpace = ttk.Combobox(LinesFrame, values=PropSpaceOptions, height = 1, width=3, state="readonly")
            self.L6_PropSpace.grid(row=13, column=8, padx=1, pady=(1,1), sticky="W")

            self.L6_CharWidth = ttk.Combobox(LinesFrame, values=CharWidthOptions, height = 1, width=3, state="readonly")
            self.L6_CharWidth.grid(row=13, column=9, padx=1, pady=(1,1), sticky="W")

            self.L6_CharBorder = ttk.Combobox(LinesFrame, values=CharBorderOptions, height = 1, width=8, state="readonly")
            self.L6_CharBorder.grid(row=13, column=10, padx=1, pady=(1,1), sticky="W")

            # Text Line 7
            self.L7_xVid = ttk.Combobox(LinesFrame, values=xVidOptions, height = 1, width=4, state="readonly")
            self.L7_xVid.grid(row=15, column=1, padx=1, pady=(1,1), sticky="W")

            self.L7_LineColor = ttk.Combobox(LinesFrame, values=LineColorOptions, height = 1, width=16, state="readonly")
            self.L7_LineColor.grid(row=15, column=2, padx=1, pady=(1,1))

            self.L7_SepType = ttk.Combobox(LinesFrame, values=SepTypeOptions, height = 1, width=9, state="readonly")
            self.L7_SepType.grid(row=15, column=3, padx=1, pady=(1,1), sticky="W")

            self.L7_SepColor = ttk.Combobox(LinesFrame, values=SepColorOptions, height = 1, width=7, state="readonly")
            self.L7_SepColor.grid(row=15, column=4, padx=1, pady=(1,1), sticky="W")

            self.L7_CharHeight = ttk.Combobox(LinesFrame, values=CharHeightOptions, height = 1, width=3, state="readonly")
            self.L7_CharHeight.grid(row=15, column=5, padx=1, pady=(1,1), sticky="W")

            self.L7_CharEdge = ttk.Combobox(LinesFrame, values=CharEdgeOptions, height = 1, width=3, state="readonly")
            self.L7_CharEdge.grid(row=15, column=6, padx=1, pady=(1,1), sticky="W")

            self.L7_FontType = ttk.Combobox(LinesFrame, values=FontTypeOptions, height = 1, width=3, state="readonly")
            self.L7_FontType.grid(row=15, column=7, padx=1, pady=(1,1), sticky="W")

            self.L7_PropSpace = ttk.Combobox(LinesFrame, values=PropSpaceOptions, height = 1, width=3, state="readonly")
            self.L7_PropSpace.grid(row=15, column=8, padx=1, pady=(1,1), sticky="W")

            self.L7_CharWidth = ttk.Combobox(LinesFrame, values=CharWidthOptions, height = 1, width=3, state="readonly")
            self.L7_CharWidth.grid(row=15, column=9, padx=1, pady=(1,1), sticky="W")

            self.L7_CharBorder = ttk.Combobox(LinesFrame, values=CharBorderOptions, height = 1, width=8, state="readonly")
            self.L7_CharBorder.grid(row=15, column=10, padx=1, pady=(1,1), sticky="W")  

    # Whole Page Option Labels
        # this if statement allows me to collapse code segments for easier editing within VS Code. That's all -JSS
        if 0 == 0:
            
            # row 0
            self.PageSkipLabel = tk.Label(PageSettingsFrame, text="Page Skip", font=("", 8), justify="left")
            self.PageSkipLabel.grid(row=0, column=2, padx=5, pady=(4,1), sticky="SW")

            self.PageLinkLabel = tk.Label(PageSettingsFrame, text="Page Link", font=("", 8), justify="left")
            self.PageLinkLabel.grid(row=0, column=3, padx=5, pady=(4,1), sticky="SW")

            self.PageWaitLabel = tk.Label(PageSettingsFrame, text="Page Wait", font=("", 8), justify="left")
            self.PageWaitLabel.grid(row=0, column=4, padx=5, pady=(4,1), sticky="SW")

            self.DisplayTimeLabel = tk.Label(PageSettingsFrame, text="Display\nTime", font=("", 8), justify="left")
            self.DisplayTimeLabel.grid(row=0, column=5, padx=5, pady=(0,1), sticky="SW")

            self.DisplaySpeedLabel = tk.Label(PageSettingsFrame, text="Display Speed", font=("", 8), justify="left")
            self.DisplaySpeedLabel.grid(row=0, column=6, padx=5, pady=(4,1), sticky="SW")

            self.DisplayTypeLabel = tk.Label(PageSettingsFrame, text="Display Type", font=("", 8), justify="left")
            self.DisplayTypeLabel.grid(row=0, column=7, padx=5, pady=(4,1), sticky="SW")


            # row 2
            self.DisplayTimeWinStartDayLabel = tk.Label(PageSettingsFrame, text="Time Win.\nStart Day", font=("", 8), justify="left")
            self.DisplayTimeWinStartDayLabel.grid(row=2, column=2, padx=5, pady=(4,1), sticky="SW")

            self.DisplayTimeWinStartHours = tk.Label(PageSettingsFrame, text="Time Win.\nStart Hr.", font=("", 8), justify="left")
            self.DisplayTimeWinStartHours.grid(row=2, column=3, padx=5, pady=(4,1), sticky="SW")

            self.DisplayTimeWinStartMin = tk.Label(PageSettingsFrame, text="Time Win.\nStart Min.", font=("", 8), justify="left")
            self.DisplayTimeWinStartMin.grid(row=2, column=4, padx=5, pady=(4,1), sticky="SW")

            self.DisplayTimeWinEndDayLabel = tk.Label(PageSettingsFrame, text="Time Win.\nEnd Day", font=("", 8), justify="left")
            self.DisplayTimeWinEndDayLabel.grid(row=2, column=5, padx=5, pady=(4,1), sticky="SW")

            self.DisplayTimeWinEndHoursLabel = tk.Label(PageSettingsFrame, text="Time Win.\nEnd Hr.", font=("", 8), justify="left")
            self.DisplayTimeWinEndHoursLabel.grid(row=2, column=6, padx=5, pady=(4,1), sticky="SW")

            self.DisplayTimeWinEndMinsLabel = tk.Label(PageSettingsFrame, text="Time Win.\nEnd Min.", font=("", 8), justify="left")
            self.DisplayTimeWinEndMinsLabel.grid(row=2, column=7, padx=5, pady=(4,1), sticky="SW")


            # row 4
            self.LineLevel1Label = tk.Label(PageSettingsFrame, text="Line\nLevel 1", font=("", 8), justify="left")
            self.LineLevel1Label.grid(row=4, column=2, padx=5, pady=(4,1), sticky="SW")

            self.LineLevel2Label = tk.Label(PageSettingsFrame, text="Line\nLevel 2", font=("", 8), justify="left")
            self.LineLevel2Label.grid(row=4, column=3, padx=5, pady=(4,1), sticky="SW")

            self.LineLevel3Label = tk.Label(PageSettingsFrame, text="Line\nLevel 3", font=("", 8), justify="left")
            self.LineLevel3Label.grid(row=4, column=4, padx=5, pady=(4,1), sticky="SW")

            self.LineLevel4Label = tk.Label(PageSettingsFrame, text="Line\nLevel 4", font=("", 8), justify="left")
            self.LineLevel4Label.grid(row=4, column=5, padx=5, pady=(4,1), sticky="SW")

            self.TapeActionsLabel = tk.Label(PageSettingsFrame, text="Tape\nActions", font=("", 8), justify="left")
            self.TapeActionsLabel.grid(row=4, column=6, padx=5, pady=(4,1), sticky="SW")

            self.PlayerNumberLabel = tk.Label(PageSettingsFrame, text="Player\nNo.", font=("", 8), justify="left")
            self.PlayerNumberLabel.grid(row=4, column=7, padx=5, pady=(4,1), sticky="SW")


        # Whole Page Option Boxes
            PageSLWOptions = ["N","Y"]
            DisplayTimeOptions = ["0","1","2","3","4","5","6","7","8","9",
                                "10","11","12","13","14","15","16","17","18","19",
                                "20","21","22","23","24","25","26","27","28","29",
                                "30","31","32","33","34","35","36","37","38","39",
                                "40","41","42","43","44","45","46","47","48","49",
                                "50","51","52","53","54","55","56","57","58","59",
                                "60","61","62","63","64","65","66","67","68","69",
                                "70","71","72","73","74","75","76","77","78","79",
                                "80","81","82","83","84","85","86","87","88","89",
                                "90","91","92","93","94","95","96","97","98","99"
                                ]
            DisplaySpeedOptions = ["0 (slowest)","1","2","3","4","5","6","7",
                                "8 - SLOW","9", "10","11","12","13","14","15",
                                "16 - MEDIUM","17","18","19","20","21","22","23",
                                "24","25","26","27","28","29","30","31","32 - FAST"
                                ]
            
            DisplayTypeOptions = ["RESERVED (0)","Bang","Splash","Crawl","Roll","Page Print","RESERVED (6)","RESERVED (7)"]


            DisplayTimeWinStartDayOptions = ["Ignore","Sun","Mon","Tue","Wed","Thu","Fri","Sat","All Days"]

            DisplayTimeWinStartHoursOptions = ["Ignore","1 AM","2 AM","3 AM","4 AM","5 AM","6 AM","7 AM","8 AM","9 AM","10 AM","11 AM","12 AM",
                                            "Ignore", "1 PM","2 PM","3 PM","4 PM","5 PM","6 PM","7 PM","8 PM","9 PM","10 PM","11 PM","12 PM"]
            
            DisplayTimeWinStartMinsOptions = [  "0","1","2","3","4","5","6","7","8","9",
                                                "10","11","12","13","14","15","16","17","18","19",
                                                "20","21","22","23","24","25","26","27","28","29",
                                                "30","31","32","33","34","35","36","37","38","39",
                                                "40","41","42","43","44","45","46","47","48","49",
                                                "50","51","52","53","54","55","56","57","58","59"]
            DisplayTimeWinEndDayOptions = DisplayTimeWinStartDayOptions
            DisplayTimeWinEndHoursOptions = DisplayTimeWinStartHoursOptions
            DisplayTimeWinEndMinsOptions = DisplayTimeWinStartMinsOptions

            LineLevelOptions = ["N","H","L","P"]

            TapeActionsOptions=["None","Play","Stop","Rewind"]
            PlayerNumberOptions=["Video B","VTR 1","VTR 2","VTR 3","VTR 4","VTR 5","VTR 6","VTR 7","VTR 8","VTR 9","VTR 10","VTR 11","VTR 12","VTR 13","VTR 14","Video A"]

            # page wait/link/skip
            # row 1
            self.PageSkip = ttk.Combobox(PageSettingsFrame, values=PageSLWOptions, height = 1, width=10)
            self.PageSkip.grid(row=1, column=2, padx=1, pady=(1,1), sticky="W")

            self.PageLink = ttk.Combobox(PageSettingsFrame, values=PageSLWOptions, height = 1, width=10)
            self.PageLink.grid(row=1, column=3, padx=1, pady=(1,1), sticky="W")
            
            self.PageWait = ttk.Combobox(PageSettingsFrame, values=PageSLWOptions, height = 1, width=10)
            self.PageWait.grid(row=1, column=4, padx=1, pady=(1,1), sticky="W")

            self.DisplayTime = ttk.Combobox(PageSettingsFrame, values=DisplayTimeOptions, height = 1, width=4)
            self.DisplayTime.grid(row=1, column=5, padx=1, pady=(1,1), sticky="W")

            self.DisplaySpeed = ttk.Combobox(PageSettingsFrame, values=DisplaySpeedOptions, height = 1, width=12)
            self.DisplaySpeed.grid(row=1, column=6, padx=1, pady=(1,1), sticky="W")

            self.DisplayType = ttk.Combobox(PageSettingsFrame, values=DisplayTypeOptions, height = 1, width=11)
            self.DisplayType.grid(row=1, column=7, padx=1, pady=(1,1), sticky="W")

            # row 3
            self.DisplayTimeWinStartDay = ttk.Combobox(PageSettingsFrame, values=DisplayTimeWinStartDayOptions, height = 1, width=7)
            self.DisplayTimeWinStartDay.grid(row=3, column=2, padx=1, pady=(1,1), sticky="W")

            self.DisplayTimeWinStartHours = ttk.Combobox(PageSettingsFrame, values=DisplayTimeWinStartHoursOptions, height = 1, width=7)
            self.DisplayTimeWinStartHours.grid(row=3, column=3, padx=1, pady=(1,1), sticky="W")

            self.DisplayTimeWinStartMins = ttk.Combobox(PageSettingsFrame, values=DisplayTimeWinStartMinsOptions, height = 1, width=4)
            self.DisplayTimeWinStartMins.grid(row=3, column=4, padx=1, pady=(1,1), sticky="W")

            self.DisplayTimeWinEndDay = ttk.Combobox(PageSettingsFrame, values=DisplayTimeWinEndDayOptions, height = 1, width=7)
            self.DisplayTimeWinEndDay.grid(row=3, column=5, padx=1, pady=(1,1), sticky="W")

            self.DisplayTimeWinEndHours = ttk.Combobox(PageSettingsFrame, values=DisplayTimeWinEndHoursOptions, height = 1, width=7)
            self.DisplayTimeWinEndHours.grid(row=3, column=6, padx=1, pady=(1,1), sticky="W")

            self.DisplayTimeWinEndMins = ttk.Combobox(PageSettingsFrame, values=DisplayTimeWinEndMinsOptions, height = 1, width=4)
            self.DisplayTimeWinEndMins.grid(row=3, column=7, padx=1, pady=(1,1), sticky="W")

            # row 5
            self.LineLevel1 = ttk.Combobox(PageSettingsFrame, values=LineLevelOptions, height = 1, width=4)
            self.LineLevel1.grid(row=5, column=2, padx=1, pady=(1,1), sticky="W")

            self.LineLevel2 = ttk.Combobox(PageSettingsFrame, values=LineLevelOptions, height = 1, width=4)
            self.LineLevel2.grid(row=5, column=3, padx=1, pady=(1,1), sticky="W")

            self.LineLevel3 = ttk.Combobox(PageSettingsFrame, values=LineLevelOptions, height = 1, width=4)
            self.LineLevel3.grid(row=5, column=4, padx=1, pady=(1,1), sticky="W")

            self.LineLevel4 = ttk.Combobox(PageSettingsFrame, values=LineLevelOptions, height = 1, width=4)
            self.LineLevel4.grid(row=5, column=5, padx=1, pady=(1,1), sticky="W")

            self.TapeActions = ttk.Combobox(PageSettingsFrame, values=TapeActionsOptions, height = 1, width=7)
            self.TapeActions.grid(row=5, column=6, padx=1, pady=(1,1), sticky="W")

            self.PlayerNumber = ttk.Combobox(PageSettingsFrame, values=PlayerNumberOptions, height = 1, width=7)
            self.PlayerNumber.grid(row=5, column=7, padx=1, pady=(1,1), sticky="W")

        global LastPageEdited
        LastPageEdited = -1    
        LoadGUIWithPageData(self.default_page_values,-1,self,0)        # set the startup values
        return

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


    step1 = data[0] ^ data[1]   # xor first byte with 2nd byte
    step2 = step1 ^ 32          # then, you xor result with 0x20
    CheckSum = step2 ^ xor      # then, you xor result with 255
    return CheckSum

def ChecksumPage(array,start,end):
    checksum=0
    for i in range(start,end):
        checksum = checksum ^ array[i]
    return checksum

def ExtractLineAttrData(data):

    # data is a bytearray of the line display attributes.
    # returns the data items below as variables xvid,bfc,lsl,lsc,lst,cet,ft,ps,cw,cb 

# Byte 0
    # Bit 7: External Video
    mask = int("10000000",2)    # Selection Mask
    xvid = data[0] & mask       # Get the bits
    xvid = xvid >> 7            # Shift until the LSB is at bit 0

    # Bits 6-5: unknown/unused/reserved

    # Bits 4-0: Background/Foreground color
    mask = int("00011111",2)    # Selection Mask
    bfc = data[0] & mask        # Get the bits. Alread left aligned; No shift required.   
    
# Byte 1
    # Bits 7-6: Separator Location
    mask = int("11000000",2)    # Selection Mask
    lsl = data[1] & mask        # Get the bits.
    lsl = lsl >> 6              # Shift until the LSB is at bit 0

    # Bits 5-3: Line Separator Color
    mask = int("00111000",2)    # Selection Mask
    lsc = data[1] & mask        # Get the bits.
    lsc = lsc >> 3              # Shift until the LSB is at bit 0

    # Bits 2-0: Line Separator Thickness
    mask = int("00000111",2)    # Selection Mask
    lst = data[1] & mask        # Get the bits. Alread left aligned; No shift required.   
    
# Byte 2
    # Bits 7-5: Character Edge Thickness
    mask = int("11100000",2)    # Selection Mask
    cet = data[2] & mask        # Get the bits
    cet = cet >> 5              # Shift until the LSB is at bit 0

    # Bit 4: Font Type
    mask = int("00010000",2)    # Selection Mask
    ft = data[2] & mask         # Get the bits
    ft = ft >> 4                # Shift until the LSB is at bit 0

    # Bit 3: Proportional Spacing
    mask = int("00001000",2)    # Selection Mask
    ps = data[2] & mask         # Get the bits
    ps = ps >> 3                # Shift until the LSB is at bit 0

    # Bits 2-0: Character Width
    mask = int("00000111",2)    # Selection Mask
    cw = data[2] & mask         # Get the bits. Alread left aligned; No shift required.

# Byte 3
    # Bit 7-6: Character Border (4B only)
    mask = int("11000000",2)    # Selection Mask
    cb = data[3] & mask         # Get the bits
    cb = cb >> 6                # Shift until the LSB is at bit 0

    return xvid,bfc,lsl,lsc,lst,cet,ft,ps,cw,cb

def StoreLineDisplayAttrs(xVid,LineColor,SepType,SepColor,CharHeight,CharEdge,FontType,PropSpace,CharWidth,CharBorder):
    # inputs are the boxes to get data from
    # returns data as a 4-byte bytearray
    DisplayAttrs = bytearray(4)

    # constructing byte zero
    xv = xVid.current()*128     # xvid
    bgfg = LineColor.current()  # Bg/FG Combo Color
    DisplayAttrs[0]=xv+bgfg

    # constructing byte 1
    st = SepType.current()*64   # line sep
    sc = SepColor.current()*8   # sep color
    lh = CharHeight.current()   # character height
    DisplayAttrs[1]=st+sc+lh

    # constructing byte 2
    ce = CharEdge.current()*32
    co = FontType.current()*16
    ps = PropSpace.current()*8
    cw = CharWidth.current()
    DisplayAttrs[2] = ce+co+ps+cw

    # constructing byte 3
    cb = CharBorder.current()*64
    Bits5and4 = 48      # these bits have been observed to always be set to 11
    Bits3through0 = 0   # these bits have been observed to always be set to 0000
    DisplayAttrs[3] = cb+Bits5and4+Bits3through0

    return DisplayAttrs

def SetSingleBitFieldBox(item,data,mask,shift):
    value = data & mask       # Get the bits
    value = value >> shift    # Shift until the LSB is at bit 0
    item.current(value)
    return

def SetTimeWinHoursBox(item,data):
    if data == 0:
        item.current(12)
    elif data > 0 and data < 13:
        item.current(data)
    elif data == 128:
        item.current(12)    #this may be a bug
    elif data > 128:
        item.current(data-128)
    else:
        item.current(12)
    return

def GetTimeWinHoursBox(item):
    if item.current() == 0 or item.current() == 13:     # items 0 or 13 means "ignore", but we return 12
        return 12
    elif item.current() > 0 and item.current() < 13:    # items 1 - 12 = return literal
        return item.current()
    elif item.current() > 13 and item.current() <= 24:  # item 14 - 24 =  128 + (index-13)
        return (item.current()-13) + 128
    return 12 # we don't know what happened, just return a nice safe 12am.
    
def LoadLineDisplayAttrs(items,data):
    for i in range(len(items)): 
        items[i].current(data[i])
    return

def GetLineLevelsBox(item):
    match item.current():
        case 0:
            return 0
        case 1:
            return 1
        case 2:
            return 16
        case 3:
            return 17
    return

def SetLineLevelsBox(index,item,data):
    match index:
        case 0:
            mask = int("00000001",2)    # Selection Mask - bit 0
            lsb = data & mask        # Get the bits
            mask = int("00010000",2)    # Selection Mask - bit 4
            msb = data & mask        # Get the bits
        case 1:
            mask = int("00000010",2)    # Selection Mask - bit 1
            lsb = data & mask        # Get the bits
            mask = int("00100000",2)    # Selection Mask - bit 5
            msb = data & mask        # Get the bits
        case 2:
            mask = int("00000100",2)    # Selection Mask - bit 2
            lsb = data & mask        # Get the bits
            mask = int("01000000",2)    # Selection Mask - bit 6
            msb = data & mask        # Get the bits
        case 3:
            mask = int("00001000",2)    # Selection Mask - bit 3
            lsb = data & mask        # Get the bits
            mask = int("10000000",2)    # Selection Mask - bit 7
            msb = data & mask        # Get the bits
        case _:
            pass
    lsb = lsb >> index
    msb = msb >> index+3
    value = msb+lsb
    item.current(value)
    return

def SetLineDisplayText(inputarray,start,textbox):
    textdata=bytearray(40)
    index=0
    for i in range(start,start+40):
        textdata[index] = inputarray[i]
        index+=1
    ascii=textdata.decode('cp437')
    textbox.delete("1.0", tk.END)
    textbox.insert("1.0", ascii)
    return

def LineInputEvent(event,nextbox):   
    widget = event.widget                           # The widget that called us
    cursor_pos = widget.index(tk.INSERT)            # current cursor position literal
    line, column = map(int, cursor_pos.split('.'))  # current cursor position as an integer
    next_column = column+1                          # next cursor position
    prev_column = column-1                          # previous cursor position

    if next_column > 40:
        next_column = 40
    if prev_column < 0:
        prev_column = 0

    next_pos = "1." + str(next_column)
    prev_pos = "1." + str(prev_column)

    if event.keycode >=112 and event.keycode <=123:  # eat all F keys
        return "break"

    typable_keys = ("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
                    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
                    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
                    "!",  '"', "#", "$", "%", "&", "`", "(", ")", "-", "=", "@", "[", "]", "+", ";", "*", ":", ",", ".", "<", ">", "/", "?", " "
                    )
                    #chars missing:
                    #       up arrow, down arrow, degrees, graphics characters, external video, flash, altcolor, rev video, 3/4 spacing, 1/2 spacing
                    # these will require a special font

    match event.keysym:
        case "BackSpace":
            if column > 1 or column < 40:
                widget.delete(f"{cursor_pos}-1c", cursor_pos)
                widget.insert(tk.INSERT," ")
                widget.mark_set("insert", prev_pos)

        case "Delete":
            widget.delete(cursor_pos)
            widget.mark_set("insert", cursor_pos)
            widget.insert(tk.END," ")

        case "Left":
            widget.mark_set("insert", prev_pos)
            return "break"  # do nothing for now

        case "Right":
            widget.mark_set("insert", next_pos)
            return "break"
        
        case "Tab":
            nextbox.focus_set()
            nextbox.mark_set("insert", "1.0")
            return "break"
        
        case "Home" | "End" | "Prior" | "Next" | "Insert" | "Up" | "Down" | "Return" | "KP_Enter" | "Control_L" | "Control_R" | "Alt_L" | "Alt_R" |"Shift_L" | "Shift_R" | "Caps_Lock" | "Cancel" | "Num_Lock" | "Scroll_Lock" | "Pause" | "Scroll_Lock" | "Escape":
            return "break"  # eat all keys that don't make sense in the input field.
        
        case _: # all other keys
            if event.char in typable_keys:
                if (column >= 0) and (column <= 39):
                    widget.delete(cursor_pos)
                    widget.insert(cursor_pos,event.char)
            return "break"

    return "break"  # catch fall through
    
def disable_event(event):
    return "break" 

def SaveGUIToDataArray(self):
    L0Start=57
    L1Start=L0Start+40
    L2Start=L1Start+40
    L3Start=L2Start+40
    L4Start=L3Start+40
    L5Start=L4Start+40
    L6Start=L5Start+40
    L7Start=L6Start+40

    # determine the current EditorPage
    global LastPageEdited
    selected = LastPageEdited

    if selected != -1:  #i.e. if we're not loading an empty page upon first program initialization
    
    # create a new bytearray object from the "previous page". This helps us preserve the header.
        start = selected * 379  # index of location in array to start blasting data
        end = start + 379
        global pagesarray
        
        tosave = bytearray()
        tosave = bytearray(tosave + pagesarray[start:end])
    # fill it with the values of all the boxes

        # Line Text Data
        tosave[L0Start:L1Start] = bytearray(self.Line0.get('1.0', '1.40'), 'cp437') # line 0
        tosave[L1Start:L2Start] = bytearray(self.Line1.get('1.0', '1.40'), 'cp437') # line 1
        tosave[L2Start:L3Start] = bytearray(self.Line2.get('1.0', '1.40'), 'cp437') # line 2
        tosave[L3Start:L4Start] = bytearray(self.Line3.get('1.0', '1.40'), 'cp437') # line 3
        tosave[L4Start:L5Start] = bytearray(self.Line4.get('1.0', '1.40'), 'cp437') # line 4
        tosave[L5Start:L6Start] = bytearray(self.Line5.get('1.0', '1.40'), 'cp437') # line 5
        tosave[L6Start:L7Start] = bytearray(self.Line6.get('1.0', '1.40'), 'cp437') # line 6
        tosave[L7Start:L7Start+40] = bytearray(self.Line7.get('1.0', '1.40'), 'cp437') # line 7

        # Page Display Attrs
        tosave[9] = (1 * self.PageSkip.current()) + (2 * self.PageLink.current()) + (4 * self.PageWait.current())

        tosave[10] = self.DisplayTime.current()             # fields that use the entire byte to represent a value don't need special handling
        tosave[11] = self.DisplaySpeed.current()            # fields that use the entire byte to represent a value don't need special handling
        tosave[12] = self.DisplayType.current()             # fields that use the entire byte to represent a value don't need special handling

        tosave[13] = self.DisplayTimeWinStartDay.current()  # fields that use the entire byte to represent a value don't need special handling
        tosave[14] = GetTimeWinHoursBox(self.DisplayTimeWinStartHours)
        tosave[15] = self.DisplayTimeWinStartMins.current() # fields that use the entire byte to represent a value don't need special handling
        
        tosave[16] = self.DisplayTimeWinEndDay.current()    # fields that use the entire byte to represent a value don't need special handling
        tosave[17] = GetTimeWinHoursBox(self.DisplayTimeWinEndHours)
        tosave[18] = self.DisplayTimeWinEndMins.current()   # fields that use the entire byte to represent a value don't need special handling

        a = (GetLineLevelsBox(self.LineLevel1))*1
        b = (GetLineLevelsBox(self.LineLevel2))*2
        c = (GetLineLevelsBox(self.LineLevel3))*4
        d = (GetLineLevelsBox(self.LineLevel4))*8
        tosave[19] = a+b+c+d

        # field index [20] currently unknown or unused

        ta = self.PlayerNumber.current()
        pn = (self.PlayerNumber.current())*16
        tosave[21] = ta + pn

        # line 0 attrs
        tosave[25:29] = StoreLineDisplayAttrs(self.L0_xVid,
                                    self.L0_LineColor,
                                    self.L0_SepType,
                                    self.L0_SepColor,
                                    self.L0_CharHeight,
                                    self.L0_CharEdge,
                                    self.L0_FontType,
                                    self.L0_PropSpace,
                                    self.L0_CharWidth,
                                    self.L0_CharBorder)
        
        # line 1 attrs
        tosave[29:33] = StoreLineDisplayAttrs(self.L1_xVid,
                                    self.L1_LineColor,
                                    self.L1_SepType,
                                    self.L1_SepColor,
                                    self.L1_CharHeight,
                                    self.L1_CharEdge,
                                    self.L1_FontType,
                                    self.L1_PropSpace,
                                    self.L1_CharWidth,
                                    self.L1_CharBorder)

        # line 2 attrs
        tosave[33:37] = StoreLineDisplayAttrs(self.L2_xVid,
                                    self.L2_LineColor,
                                    self.L2_SepType,
                                    self.L2_SepColor,
                                    self.L2_CharHeight,
                                    self.L2_CharEdge,
                                    self.L2_FontType,
                                    self.L2_PropSpace,
                                    self.L2_CharWidth,
                                    self.L2_CharBorder)
        
        # line 3 attrs
        tosave[37:41] = StoreLineDisplayAttrs(self.L3_xVid,
                                    self.L3_LineColor,
                                    self.L3_SepType,
                                    self.L3_SepColor,
                                    self.L3_CharHeight,
                                    self.L3_CharEdge,
                                    self.L3_FontType,
                                    self.L3_PropSpace,
                                    self.L3_CharWidth,
                                    self.L3_CharBorder)
        
        # line 4 attrs
        tosave[41:45] = StoreLineDisplayAttrs(self.L4_xVid,
                                    self.L4_LineColor,
                                    self.L4_SepType,
                                    self.L4_SepColor,
                                    self.L4_CharHeight,
                                    self.L4_CharEdge,
                                    self.L4_FontType,
                                    self.L4_PropSpace,
                                    self.L4_CharWidth,
                                    self.L4_CharBorder)
        
        # line 5 attrs
        tosave[45:49] = StoreLineDisplayAttrs(self.L5_xVid,
                                    self.L5_LineColor,
                                    self.L5_SepType,
                                    self.L5_SepColor,
                                    self.L5_CharHeight,
                                    self.L5_CharEdge,
                                    self.L5_FontType,
                                    self.L5_PropSpace,
                                    self.L5_CharWidth,
                                    self.L5_CharBorder)
        
        # line 6 attrs
        tosave[49:53] = StoreLineDisplayAttrs(self.L6_xVid,
                                    self.L6_LineColor,
                                    self.L6_SepType,
                                    self.L6_SepColor,
                                    self.L6_CharHeight,
                                    self.L6_CharEdge,
                                    self.L6_FontType,
                                    self.L6_PropSpace,
                                    self.L6_CharWidth,
                                    self.L6_CharBorder)
        
        # line 7 attrs
        tosave[53:57] = StoreLineDisplayAttrs(self.L7_xVid,
                                    self.L7_LineColor,
                                    self.L7_SepType,
                                    self.L7_SepColor,
                                    self.L7_CharHeight,
                                    self.L7_CharEdge,
                                    self.L7_FontType,
                                    self.L7_PropSpace,
                                    self.L7_CharWidth,
                                    self.L7_CharBorder)

        tosave[378] = ChecksumPage(tosave,9,378)

    # save it over the locations in the pagearray
        pagesarray[start:end] = tosave
    return

def BackPage(self):
    global pagesarray
    if self.EditorPage.current() > 0:
        self.EditorPage.current((self.EditorPage.current())-1)          #get current, minus 1
        LoadGUIWithPageData(pagesarray,self.EditorPage.current(),self,0)  #loadgui with new current
    return

def NextPage(self):
    global pagesarray
    if self.EditorPage.current() < (len(self.EditorPage['values'])-1):
        self.EditorPage.current((self.EditorPage.current())+1)          #get current, plus 1
        LoadGUIWithPageData(pagesarray,self.EditorPage.current(),self,0)  #loadgui with new current
    return

def LoadGUIWithPageData(data,page,self,loadonly):
    # takes a page byte array (data), 
    # selects the page of the array to display from (page) (not the literal page number saved in the array data, just that index into the array)
    # and sets the GUI elements (self.object) to match it.
    # if loadonly =1, don't save the page before loading it

    # before we load a new page, make sure we save the current page.
    if loadonly != 1:
        SaveGUIToDataArray(self)

    # if we're getting here with a -1, that means this is the first time we've run the program, so initalize with blank data.
    if page == -1:
        page = 0

    offset = page*379                                           
    localdata = data[offset:offset+379]                         # convert "data" variable into a page from that variable, as determined by the "page" offset
    StartPage = int.from_bytes(data[6:8], byteorder='little')   # get the start page literal
    NumOfPages = int((len(data)/379))                           # get number of pages. returns a 0 indexed number of pages.

    self.EditorPage['values'] = ()          # Clear all combobox items. Set values to an empty tuple
    self.EditorPage.set("")                 # Clear the currently displayed text

    options = []                            # re-create the combobox options
    for i in range(NumOfPages):
        options.append(str(StartPage+(i)))
    self.EditorPage['values'] = options
    
    self.EditorPage.current(page)           # set the combobox to the new current page

    # set the contents of the current page box to the number indexed
    L0Start=57
    L1Start=L0Start+40
    L2Start=L1Start+40
    L3Start=L2Start+40
    L4Start=L3Start+40
    L5Start=L4Start+40
    L6Start=L5Start+40
    L7Start=L6Start+40

    L0DAStart=25
    L1DAStart=L0DAStart+4
    L2DAStart=L1DAStart+4
    L3DAStart=L2DAStart+4
    L4DAStart=L3DAStart+4
    L5DAStart=L4DAStart+4
    L6DAStart=L5DAStart+4
    L7DAStart=L6DAStart+4

    SetLineDisplayText(localdata,L0Start,self.Line0)
    SetLineDisplayText(localdata,L1Start,self.Line1)
    SetLineDisplayText(localdata,L2Start,self.Line2)
    SetLineDisplayText(localdata,L3Start,self.Line3)
    SetLineDisplayText(localdata,L4Start,self.Line4)
    SetLineDisplayText(localdata,L5Start,self.Line5)
    SetLineDisplayText(localdata,L6Start,self.Line6)
    SetLineDisplayText(localdata,L7Start,self.Line7)

    LoadLineDisplayAttrs([
                self.L0_xVid,self.L0_LineColor,self.L0_SepType,self.L0_SepColor,self.L0_CharHeight,self.L0_CharEdge,self.L0_FontType,self.L0_PropSpace,self.L0_CharWidth,self.L0_CharBorder],
                ExtractLineAttrData(localdata[L0DAStart:L1DAStart])
                )
    
    LoadLineDisplayAttrs([
                self.L1_xVid,self.L1_LineColor,self.L1_SepType,self.L1_SepColor,self.L1_CharHeight,self.L1_CharEdge,self.L1_FontType,self.L1_PropSpace,self.L1_CharWidth,self.L1_CharBorder],
                ExtractLineAttrData(localdata[L1DAStart:L2DAStart])
                )
    
    LoadLineDisplayAttrs([
                self.L2_xVid,self.L2_LineColor,self.L2_SepType,self.L2_SepColor,self.L2_CharHeight,self.L2_CharEdge,self.L2_FontType,self.L2_PropSpace,self.L2_CharWidth,self.L2_CharBorder],
                ExtractLineAttrData(localdata[L2DAStart:L3DAStart])
                )
         
    LoadLineDisplayAttrs([
                self.L3_xVid,self.L3_LineColor,self.L3_SepType,self.L3_SepColor,self.L3_CharHeight,self.L3_CharEdge,self.L3_FontType,self.L3_PropSpace,self.L3_CharWidth,self.L3_CharBorder],
                ExtractLineAttrData(localdata[L3DAStart:L4DAStart])
                )
    
    LoadLineDisplayAttrs([
                self.L4_xVid,self.L4_LineColor,self.L4_SepType,self.L4_SepColor,self.L4_CharHeight,self.L4_CharEdge,self.L4_FontType,self.L4_PropSpace,self.L4_CharWidth,self.L4_CharBorder],
                ExtractLineAttrData(localdata[L4DAStart:L5DAStart])
                )
    
    LoadLineDisplayAttrs([
                self.L5_xVid,self.L5_LineColor,self.L5_SepType,self.L5_SepColor,self.L5_CharHeight,self.L5_CharEdge,self.L5_FontType,self.L5_PropSpace,self.L5_CharWidth,self.L5_CharBorder],
                ExtractLineAttrData(localdata[L5DAStart:L6DAStart])
                )
    
    LoadLineDisplayAttrs([
                self.L6_xVid,self.L6_LineColor,self.L6_SepType,self.L6_SepColor,self.L6_CharHeight,self.L6_CharEdge,self.L6_FontType,self.L6_PropSpace,self.L6_CharWidth,self.L6_CharBorder],
                ExtractLineAttrData(localdata[L6DAStart:L7DAStart])
                )

    LoadLineDisplayAttrs([
                self.L7_xVid,self.L7_LineColor,self.L7_SepType,self.L7_SepColor,self.L7_CharHeight,self.L7_CharEdge,self.L7_FontType,self.L7_PropSpace,self.L7_CharWidth,self.L7_CharBorder],
                ExtractLineAttrData(localdata[L7DAStart:L7DAStart+4])
                )

    SetSingleBitFieldBox(self.PageSkip,localdata[9],(int("00000001",2)),0) # target box, the value to get the bit from, the bit mask to fetch, the steps to shift
    SetSingleBitFieldBox(self.PageLink,localdata[9],(int("00000010",2)),1)
    SetSingleBitFieldBox(self.PageWait,localdata[9],(int("00000100",2)),2)
    self.DisplayTime.current(localdata[10])   # fields that use the entire byte to represent a value don't need special handling
    self.DisplaySpeed.current(localdata[11])   # fields that use the entire byte to represent a value don't need special handling
    self.DisplayType.current(localdata[12])   # fields that use the entire byte to represent a value don't need special handling
    self.DisplayTimeWinStartDay.current(localdata[13])   # fields that use the entire byte to represent a value don't need special handling
    SetTimeWinHoursBox(self.DisplayTimeWinStartHours,localdata[14])
    self.DisplayTimeWinStartMins.current(localdata[15])   # fields that use the entire byte to represent a value don't need special handling
    self.DisplayTimeWinEndDay.current(localdata[16])   # fields that use the entire byte to represent a value don't need special handling
    SetTimeWinHoursBox(self.DisplayTimeWinEndHours,localdata[17])
    self.DisplayTimeWinEndMins.current(localdata[18])   # fields that use the entire byte to represent a value don't need special handling
    SetLineLevelsBox(0,self.LineLevel1,localdata[19])
    SetLineLevelsBox(1,self.LineLevel2,localdata[19])
    SetLineLevelsBox(2,self.LineLevel3,localdata[19])
    SetLineLevelsBox(3,self.LineLevel4,localdata[19])
    SetSingleBitFieldBox(self.TapeActions,localdata[21],(int("00110000",2)),4)
    SetSingleBitFieldBox(self.PlayerNumber,localdata[21],(int("00001111",2)),0)
    global LastPageEdited
    LastPageEdited = self.EditorPage.current()
    return

def AddAPage(self):
    current = list(self.EditorPage['values'])                       # get the entire list from the combobox
    total = len(current)                                            # get the total number of entries into an int
    last = int(self.EditorPage.cget("values")[-1])                  # get last page entry from combobox
    last += 1                                                       # add one to it
    current.append(last)                                            # add it to the list
    self.EditorPage['values'] = current                             # insert it into the combobox
    self.EditorPage.current(total)                                  # select the last entry
    
    blankpage = self.default_page_values[:] # the colon slice ensures a new instance is made, not a reference
    blankpage[6:8] = (last).to_bytes(2, byteorder='little')
    global pagesarray
    pagesarray = bytearray(pagesarray + blankpage)   # add defaults array to end of pagesarray
    LoadGUIWithPageData(pagesarray,self.EditorPage.current(),self,0)  # change the page to that entry
    return

def ClearThisPage(self):
    #get the current page
    global LastPageEdited
    global pagesarray

    #overwrite the data with defaults
    index = LastPageEdited*379
    pagesarray[index:index+379] = self.default_page_values

    #save the page load the gui without saving!
    LoadGUIWithPageData(pagesarray,self.EditorPage.current(),self,1)    # loadonly = 1!

    return

def StartOver(self):
    if messagebox.askyesno("Confirm Action", "Are you sure you want to\nclear all data and start over?"):
        global pagesarray
        global LastPageEdited
        pagesarray = []
        pagesarray = self.default_page_values[:]
        LastPageEdited = 0
        LoadGUIWithPageData(pagesarray,LastPageEdited,self,1)    # loadonly = 1!
        return
    else:
        return
    return

def InsertSpecialChar(self,char,widget):
    char=char.decode("cp437")       # convert char to real char
    index = widget.index(tk.INSERT)    # get the cursor position of the text widget
    line, column = map(int, index.split('.'))  # convert current cursor position to mathable integer

    if (column >= 0) and (column <= 39):    # delete char at current position and replace with typed char
        widget.delete(index)
        widget.insert(index,char)

    return

def OnScreenKeyboard(self):  
    # get current the last selected text box so we know where to insert chars
    global focused_widget

    # if called with no box set, force it to first line, first char
    if not isinstance(focused_widget, tk.Text):
        focused_widget = self.Line0
        focused_widget.mark_set("insert", "1.0")

    # Get geometry of the main window
    main_x = root.winfo_x()
    main_y = root.winfo_y()
    main_width = root.winfo_width()

    # Calculate new window position (to the right of the main window)
    new_x = main_x + main_width
    new_y = main_y

    # ensure the user can't launch it again
    if self.KeyboardWindow is not None and self.KeyboardWindow.winfo_exists():
        return
    else:
        pass

    # Create the new window
    self.KeyboardWindow = tk.Toplevel(root)
    self.KeyboardWindow.title("Special Character Keyboard")
    self.KeyboardWindow.geometry(f"380x130+{new_x}+{new_y}")

    # get the characters from the raw image into a usable object
    image = Image.open("font.png")

    # ######################################################################## #
    at_img = ImageTk.PhotoImage(image.crop((1, 199, 17, 230)))
    a_img = ImageTk.PhotoImage(image.crop((18, 199, 34, 230)))
    b_img = ImageTk.PhotoImage(image.crop((35, 199, 51, 230)))
    c_img = ImageTk.PhotoImage(image.crop((52, 199, 68, 230)))
    d_img = ImageTk.PhotoImage(image.crop((69, 199, 85, 230)))
    e_img = ImageTk.PhotoImage(image.crop((86, 199, 102, 230)))
    f_img = ImageTk.PhotoImage(image.crop((103, 199, 119, 230)))
    g_img = ImageTk.PhotoImage(image.crop((120, 199, 136, 230)))
    h_img = ImageTk.PhotoImage(image.crop((137, 199, 153, 230)))
    i_img = ImageTk.PhotoImage(image.crop((154, 199, 170, 230)))
    j_img = ImageTk.PhotoImage(image.crop((171, 199, 187, 230)))
    k_img = ImageTk.PhotoImage(image.crop((188, 199, 204, 230)))
    l_img = ImageTk.PhotoImage(image.crop((205, 199, 221, 230)))
    m_img = ImageTk.PhotoImage(image.crop((222, 199, 238, 230)))
    n_img = ImageTk.PhotoImage(image.crop((239, 199, 255, 230)))
    o_img = ImageTk.PhotoImage(image.crop((256, 199, 272, 230)))

    chars1 = tk.Frame(self.KeyboardWindow, borderwidth=1, relief="groove")
    chars1.pack()

    at = tk.Button(chars1, image=at_img, command=lambda: InsertSpecialChar(self,b'\x80',focused_widget))
    at.image = at_img
    at.grid(row=0, column=0)

    a = tk.Button(chars1, image=a_img, command=lambda: InsertSpecialChar(self,b'\x81',focused_widget))
    a.image = a_img
    a.grid(row=0, column=1)

    b = tk.Button(chars1, image=b_img, command=lambda: InsertSpecialChar(self,b'\x82',focused_widget))
    b.image = b_img
    b.grid(row=0, column=2)

    c = tk.Button(chars1, image=c_img, command=lambda: InsertSpecialChar(self,b'\x83',focused_widget))
    c.image = c_img
    c.grid(row=0, column=3)

    d = tk.Button(chars1, image=d_img, command=lambda: InsertSpecialChar(self,b'\x84',focused_widget))
    d.image = d_img
    d.grid(row=0, column=4)

    e = tk.Button(chars1, image=e_img, command=lambda: InsertSpecialChar(self,b'\x85',focused_widget))
    e.image = e_img
    e.grid(row=0, column=5)

    f = tk.Button(chars1, image=f_img, command=lambda: InsertSpecialChar(self,b'\x86',focused_widget))
    f.image = f_img
    f.grid(row=0, column=6)

    g = tk.Button(chars1, image=g_img, command=lambda: InsertSpecialChar(self,b'\x87',focused_widget))
    g.image = g_img
    g.grid(row=0, column=7)

    h = tk.Button(chars1, image=h_img, command=lambda: InsertSpecialChar(self,b'\x88',focused_widget))
    h.image = h_img
    h.grid(row=0, column=8)

    i = tk.Button(chars1, image=i_img, command=lambda: InsertSpecialChar(self,b'\x89',focused_widget))
    i.image = i_img
    i.grid(row=0, column=9)

    j = tk.Button(chars1, image=j_img, command=lambda: InsertSpecialChar(self,b'\x8A',focused_widget))
    j.image = j_img
    j.grid(row=0, column=10)

    k = tk.Button(chars1, image=k_img,  command=lambda: InsertSpecialChar(self,b'\x8B',focused_widget))
    k.image = k_img
    k.grid(row=0, column=11)

    l = tk.Button(chars1, image=l_img, command=lambda: InsertSpecialChar(self,b'\x8C',focused_widget))
    l.image = l_img
    l.grid(row=0, column=12)

    m = tk.Button(chars1, image=m_img, command=lambda: InsertSpecialChar(self,b'\x8D',focused_widget))
    m.image = m_img
    m.grid(row=0, column=13)

    n = tk.Button(chars1, image=n_img, command=lambda: InsertSpecialChar(self,b'\x8E',focused_widget))
    n.image = n_img
    n.grid(row=0, column=14)

    o = tk.Button(chars1, image=o_img, command=lambda: InsertSpecialChar(self,b'\x8F',focused_widget))
    o.image = o_img
    o.grid(row=0, column=15)
    

    # ######################################################################## #
 
    p_img = ImageTk.PhotoImage(image.crop((1, 232, 17, 263)))
    q_img = ImageTk.PhotoImage(image.crop((18, 232, 34, 263)))
    r_img = ImageTk.PhotoImage(image.crop((35, 232, 51, 263)))
    s_img = ImageTk.PhotoImage(image.crop((52, 232, 68, 263)))
    t_img = ImageTk.PhotoImage(image.crop((69, 232, 85, 263)))
    u_img = ImageTk.PhotoImage(image.crop((86, 232, 102, 263)))
    v_img = ImageTk.PhotoImage(image.crop((103, 232, 119, 263)))
    w_img = ImageTk.PhotoImage(image.crop((120, 232, 136, 263)))
    x_img = ImageTk.PhotoImage(image.crop((137, 232, 153, 263)))
    y_img = ImageTk.PhotoImage(image.crop((154, 232, 170, 263)))
    z_img = ImageTk.PhotoImage(image.crop((171, 232, 187, 263)))
    circle_img = ImageTk.PhotoImage(image.crop((188, 232, 204, 263)))
    truck_img = ImageTk.PhotoImage(image.crop((205, 232, 221, 263)))
    flag_img = ImageTk.PhotoImage(image.crop((222, 232, 238, 263)))
    ltee_img = ImageTk.PhotoImage(image.crop((239, 232, 255, 263)))
    rtee_img = ImageTk.PhotoImage(image.crop((256, 232, 272, 263)))

    chars2 = tk.Frame(self.KeyboardWindow, borderwidth=1, relief="groove")
    chars2.pack()

    p = tk.Button(chars2, image=p_img, command=lambda: InsertSpecialChar(self,b'\x90',focused_widget))
    p.image = p_img
    p.grid(row=0, column=0)

    q = tk.Button(chars2, image=q_img, command=lambda: InsertSpecialChar(self,b'\x91',focused_widget))
    q.image = q_img
    q.grid(row=0, column=1)

    r = tk.Button(chars2, image=r_img, command=lambda: InsertSpecialChar(self,b'\x92',focused_widget))
    r.image = r_img
    r.grid(row=0, column=2)

    s = tk.Button(chars2, image=s_img, command=lambda: InsertSpecialChar(self,b'\x93',focused_widget))
    s.image = s_img
    s.grid(row=0, column=3)

    t = tk.Button(chars2, image=t_img, command=lambda: InsertSpecialChar(self,b'\x94',focused_widget))
    t.image = t_img
    t.grid(row=0, column=4)

    u = tk.Button(chars2, image=u_img, command=lambda: InsertSpecialChar(self,b'\x95',focused_widget))
    u.image = u_img
    u.grid(row=0, column=5)

    v = tk.Button(chars2, image=v_img, command=lambda: InsertSpecialChar(self,b'\x96',focused_widget))
    v.image = v_img
    v.grid(row=0, column=6)

    w = tk.Button(chars2, image=w_img, command=lambda: InsertSpecialChar(self,b'\x97',focused_widget))
    w.image = w_img
    w.grid(row=0, column=7)

    x = tk.Button(chars2, image=x_img, command=lambda: InsertSpecialChar(self,b'\x98',focused_widget))
    x.image = x_img
    x.grid(row=0, column=8)

    y = tk.Button(chars2, image=y_img, command=lambda: InsertSpecialChar(self,b'\x99',focused_widget))
    y.image = y_img
    y.grid(row=0, column=9)

    z = tk.Button(chars2, image=z_img, command=lambda: InsertSpecialChar(self,b'\x9A',focused_widget))
    z.image = z_img
    z.grid(row=0, column=10)

    circle = tk.Button(chars2, image=circle_img, command=lambda: InsertSpecialChar(self,b'\x9B',focused_widget))
    circle.image = circle_img
    circle.grid(row=0, column=11)

    truck = tk.Button(chars2, image=truck_img, command=lambda: InsertSpecialChar(self,b'\x9C',focused_widget))
    truck.image = truck_img
    truck.grid(row=0, column=12)

    flag = tk.Button(chars2, image=flag_img, command=lambda: InsertSpecialChar(self,b'\x9D',focused_widget))
    flag.image = flag_img
    flag.grid(row=0, column=13)

    ltee = tk.Button(chars2, image=ltee_img, command=lambda: InsertSpecialChar(self,b'\x9E',focused_widget))
    ltee.image = ltee_img
    ltee.grid(row=0, column=14)

    rtee = tk.Button(chars2, image=rtee_img, command=lambda: InsertSpecialChar(self,b'\x9F',focused_widget))
    rtee.image = rtee_img
    rtee.grid(row=0, column=15)
    
    # ################################################### #
    sp34_img = ImageTk.PhotoImage(image.crop((1, 265, 17, 297)))
    sp12_img = ImageTk.PhotoImage(image.crop((18, 265, 34, 297)))
    evsel_img = ImageTk.PhotoImage(image.crop((35, 265, 51, 297)))
    altfnt_img = ImageTk.PhotoImage(image.crop((52, 265, 68, 297)))
    altcol_img = ImageTk.PhotoImage(image.crop((69, 265, 85, 297)))
    revvid_img = ImageTk.PhotoImage(image.crop((86, 265, 102, 297)))
    flash_img = ImageTk.PhotoImage(image.crop((103, 265, 119, 297)))
    chars3 = tk.Frame(self.KeyboardWindow, borderwidth=1, relief="groove")
    chars3.pack()

    sp34_button = tk.Button(chars3, image=sp34_img,  command=lambda: InsertSpecialChar(self,b'\xF0',focused_widget))
    sp34_button.image = sp34_img
    sp34_button.grid(row=0, column=0)

    sp12_button = tk.Button(chars3, image=sp12_img,  command=lambda: InsertSpecialChar(self,b'\xF1',focused_widget))
    sp12_button.image = sp12_img
    sp12_button.grid(row=0, column=1)

    evsel_button = tk.Button(chars3, image=evsel_img,  command=lambda: InsertSpecialChar(self,b'\xFA',focused_widget))
    evsel_button.image = evsel_img
    evsel_button.grid(row=0, column=2)

    altfnt_button = tk.Button(chars3, image=altfnt_img,  command=lambda: InsertSpecialChar(self,b'\xFB',focused_widget))
    altfnt_button.image = altfnt_img
    altfnt_button.grid(row=0, column=3)

    altcol_button = tk.Button(chars3, image=altcol_img,  command=lambda: InsertSpecialChar(self,b'\xFC',focused_widget))
    altcol_button.image = altcol_img
    altcol_button.grid(row=0, column=4)

    revvid_button = tk.Button(chars3, image=revvid_img,  command=lambda: InsertSpecialChar(self,b'\xFD',focused_widget))
    revvid_button.image = revvid_img
    revvid_button.grid(row=0, column=5)

    flash_button = tk.Button(chars3, image=flash_img,  command=lambda: InsertSpecialChar(self,b'\xFE',focused_widget))
    flash_button.image = flash_img
    flash_button.grid(row=0, column=6)
    return

def GetFocusedWidget():
    global focused_widget
    focused_widget = root.focus_get()
    return

# Initialze the GUI
root = tk.Tk()
root.title("SpectraGen Page Editor")
root.geometry("+10+10")
root.resizable(False, False)
gui = CoreGUI(root)
focused_widget = root.focus_get()
root.mainloop()