04          : inc b
06 nn       : ld b,nn
11 nn mm    : ld de,mmnn
18 xx       : jr xx
1d          : dec e
21 nn mm    : ld hl,mmnn
23          : inc hl
28 xx       : jr z,xx
2a nn mm    : ld hl,(mmnn)
2b          : dec hl
32 nn mm    : ld (mmnn),a
7b          : ld a,e
7e          : ld a,(hl)
e5		    : push hl
af          : xor a
c1          : pop bc
c3 nn mm    : jp mmnn
c5          : push bc
c9          : ret
ed 5b nn mm : ld de,(mmnn)
f1          : pop af
f5          : push af
fd 23       : inc iy
fe nn       : cp nn
