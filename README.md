# sg3_4-reverse
Texscan MSI CompuVID SpectraGen 3/4 Operations Reverse Engineering  
A project to understand the internal workings and communications protocols of the Texscan MSI CompuVID 3 and 4 systems.  

The SpectraGen series was available with several extra features and a companion software package for the IBM PC. There is no technical information on how these systems work, and the PC software package is lost to time. This project aims to reverse engineer these functions and provide modern equivalents.  

# Info about the SpectraGen Systems
https://cg-wiki.org/texscan_msi/sg4b

# Scripts
## Prerequesites
PowerShell scripts require PowerShell 2 or newer on Windows 64 bit  
  
Python scrips require a GUI based system, Python 3, PySerial and Pillow  
PySerial: pip install pyserial  
Pillow: pip install pillow  

## Demonstration Scripts
**WXWrite.ps1**: Requires Windows PowerShell  
A PowerShell Script with GUI that will take weather data from the user, format it correctly, and send it to the SpectraGen.  

**BatchFetch_WithGUI.py**: Requires Python3 and pySerial *(pip install pyserial)*  
GUI based script that allows the user to fetch a series of pages from a SpectraGen  

**BatchSend_WithGUI.py**: Requires Python3 and pySerial *(pip install pyserial)*  
GUI based script that allows the user to send a series of pages from a previouisly fetched file to a SpectraGen  

**PageEditor_WithGUI.py**  
Requires Python3, pySerial *(pip install pyserial)* and Pillow *(pip install pillow)*  
Requires the TTF Font and PNG file to reside in the same directory as the Page Editor Script.  
Allows creation of new pages directly on a computer, or editing pages you've downloaded from a SpectraGen.  
  
## Scripts To Do/Plans
**WXWrite** - needs to be converted to python for cross platform support  
**WXProcessor** - a script that can receive piped weather data, format it, and stream it to the Spectragen. Useful for integration into other toolchains.  
**SendProcessor** - a script that can receive piped page data, format it, and stream it to the Spectragen. Useful for integration into other toolchains.  
**FetchProcessor** - a script that can receive piped fetch commands, format them, and stream them to the SpectraGen, then save the result to file or pipe it elsewhere. Useful for integration into other toolchains.  

According to the user manual, The SpectraGen has other functions to allow downloading other state data, like page sequencing, etc. Needs to be reverse engineered.

# Super Nerdy Assembly File Stuff from fstark:

## ROMs:

U20.BIN : Main Boot ROM, 16K, mapped 0x0000 - 0x3fff
U21.BIN : 16K, mapped 0x8000 - 0x7fff
U22.BIN : Mostly data, 16K, mapped 0xc000 - 0xffff

## How to use

Under linux, install ``pasmo``. Run the ``doit.sh`` script and start hacking the ``rom-57.asm`` file. Any discrepancy in generation will immediately be highligted in the terminal.

## Personal notes on the initial generation of assembly files

First, generation of a simple assembly file at correct address
Then assembly of this file to generate the correct symbol file
Then concatenation of all symbol file to get a symbol accross all ROMs
Then re-generation of assembly files with all symbols

z80dasm -l -a -t -g 0x8000 ROMs/U21-57.BIN > u21-57.asm
pasmo --alocal u21-57.asm u21-57.bin u21-57.sys

z80dasm -l -a -t -g 0xc000 ROMs/U22-57.BIN > u22-57.asm
pasmo --alocal u22-57.asm u22-57.bin u22-57.sys

cat u20-57.sys u21-57.sys u22-57.sys | sed -e 's/[ \t]*EQU 0\(....\)H/: equ 0x\1/g' > all.sym
z80dasm -l -a -t -g 0x8000 -S all.sym ROMs/U21-57.BIN > u21-57.asm
z80dasm -l -a -t -g 0xc000 -S all.sym ROMs/U22-57.BIN > u22-57.asm

pasmo --alocal u21-57.asm u21-57.bin u21-57.sys

pasmo --alocal rom.asm rom.bin rom.sys
