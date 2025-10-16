#!/bin/bash

# cat u20-57.sys | sed -e 's/[ \t]*EQU 0\(....\)H/: equ 0x\1/g' > u20-57.sym
# z80dasm -l -t -g 0 -a Otrona_Attaché_U252_Rev_D.BIN > otrona_d2.asm
# z80dasm -l -a -t -g 0x8000 ROMs/U21-57.BIN > u21-57.asm

while true; do
    inotifywait -qq -e close_write rom-57.asm
    echo -n "Checking..."
    # z80asm otrona_d.asm -o otrona_d.bin
    pasmo --alocal rom-57.asm rom-57.bin rom-57.sys
    echo "done"

    if [ -f rom-57.bin ]; then
        if ! diff -q rom-57.bin ROMs/ROM-57.BIN; then
            echo "ERROR!"
            hexdump -C ROMs/ROM-57.BIN > /tmp/a.hex
            hexdump -C rom-57.bin > /tmp/b.hex
            # git diff -U0  --no-index --no-prefix --word-diff=plain --word-diff --word-diff-regex=. /tmp/a.hex /tmp/b.hex
            diff /tmp/a.hex /tmp/b.hex | head -10
        else
            ( dd if=rom-57.bin of=rom-hack.bin bs=16384 count=1 2>&1 ) > /dev/null
            cp rom-57.asm rom-57-lastgood.asm
        fi
    fi
done
