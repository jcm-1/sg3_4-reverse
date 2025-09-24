# sg3_4-reverse
Texscan MSI SpectraGen CompuVID 3/4 Operations Reverse Engineering
A project to understand the internal workings and communications protocols of the Texscan MSI CompuVID 3 and 4 systems.

# Texscan
https://cg-wiki.org/texscan_msi/sg4b

# Super Nerdy Assembly File Stuff:

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
