HACK_ROM: equ 0

; variables:
v4f89: equ 0x4f89
p4f84: equ 0x4f84
v53c2: equ 0x53c2

vDBG_LEVEL: equ 0x5cb9
DBG_SERIAL: equ 6

MAGIC1: equ 0xff
MAGIC2: equ 0xfa
MAGIC3: equ 0xf5



WEATHER_PARSE_INDEX: equ 0x55d7	; current index in parsing serial intput
WEATHER_COUNTER_UNK: equ 0x55dd  ; Some sort of 0 to 5 counter
WEATHER_PREVIOUS_XXX: equ 0x55de

SCRN_WEATHER_START: equ 0x55e5
SCRN_WEATHER_LEN: equ 40*4

; "TEMP. nnn\F^    HI nnn\ LO nnn\"
SCRN_TEMP_LBL: equ SCRN_WEATHER_START
SCRN_TEMP_VAL: equ 0x55eb		; Current temperature value
SCRN_TEMP_DEG: equ 0x055ee		; 'degree' character
SCRN_TEMP_DIR: equ 0x055f0		; Temperature direction (up or down)
SCRN_TEMP_HI: equ 0x55f8
SCRN_TEMP_LO: equ 0x5600

LAST_TEMP: equ 0x55db			; Previous temp
LAST_LAST_TEMP: equ 0x55dc		; Previous temps saved (for when we alrady have overriden LAST_TEMP)

LAST_BARO: equ 0x55df			; Previous baro
LAST_LAST_BARO: equ 0x55e0

; "WIND nn-bb MPH      CHIL  nnn\"
SCRN_WIND_LBL: equ SCRN_WEATHER_START+40
SCRN_WIND_SPEED: equ 0x5612
SCRN_WIND_GUSTS: equ 0x5615
SCRN_WIND_FROM_LBL:equ 0x0561d		; "FROM" or "   CHILL"
SCRN_WIND_CHILL_LBL: equ SCRN_WIND_FROM_LBL+2	; CHILLs starts after

SCRN_WIND_DIRECTION: equ 0x5622

SCRN_WIND_SPACES: equ 05633h	; Two chars (habitually spaces)
								; that will be displayed before "CHILL"
								; and replaced byt spaces...


; "BARO. nn.nn" ^  HUMIDITY  nn%"
SCRN_BARO_LBL: equ 0x5635
SCRN_BARO_HUM_LBL: equ 0x5645
SCRN_BARO_HUM_VAL: equ 0x564f
SCRN_BARO_DIRECTON: equ 0x5642
SCRN_BARO_VAL: equ 0x563b

; "RAIN DAY n.nn'  MONTH nn.nn' "
SCRN_RAIN_LBL: equ 0x565d
SCRN_RAIN_DAY: equ 0x5673
SCRN_RAIN_MONTH: equ 0x5666
SCRN_RAIN_DAY_VAL: equ 0x5669
SCRN_RAIN_MONTH_VAL: equ 0x5677

DEGREE_US: equ 0x5C		; 'degree' character on US systems (0x5c or '\')
DEGREE_DE: equ 0x60		; 'degree' character on German systems (0x60 or '`')
ARROW_DOWN: equ 0x5e		; Arrows up and down
ARROW_UP: equ 0x5f		; for temperature direction

; I have no idea where this is set
TEMP_LOCALE: equ 0x5685 ; bit 0 = 1 for Celcius

RAIN_COUNTER_XXX: equ 0x5bb3

; Interesting addresses:
; 0x55e5 = location in ram the machine uses to actually show the weather data to the screen. If I modify this memory space, I can modify what the weather panel shows. 
; 0x55B7 = locaion in ram the machine uses to manufacture a date/time screen I think'
; The weather space in memory is just below the date/time area at 55B7. SOOO CLOSE
; 55EB,3    current temperature
; 55F8,3    low temperature    (calculated from past history)
; 5600,3    high temperature (calculated from past history)
; 5612,2    wind speed
; 5622,2    wind direction
; 563B,?    Barometer (4 or 5 digits?)
; 564F,2    Humidity
; 5666,?    rain total today (3 or 4 digits?) (calculated ?)
; 5673,?    rain this month (4 or 5 digits?) (calculated from past history) 
; sub_ca45h: is probably "Copy Current Temp into High Temp Field" 
; sub_ca3dh: is probably "Copy Current Temp into Low Temp Field" 
; Found where the code is checking to see if the screen actually contains something other than a space where it should say TEMP or RAIN or whatever..
; lc963h: for example is checking to see if TEMP (or, rather, that it does NOT contain a space) exists.
; The code that is rendering this RAM data to the screen is right after HANDLE_SERIAL in the ROM.


v55eb: equ 0x55eb

; Strange: overwrites other. Either there is a memory mapping, or this is only scracth space
vUserCodes: equ 0x53c3	; See manual page 3-51
						; 24 entries of 10 bytes
						;  6 char code, 2 bytes start page, 2 bytes stop page

v52bf: equ 0x52bf		; Related to v52c0. Related to DMS/interrupt 10
v52c0: equ 0x52c0

v53c4: equ 0x53c4
v53c6: equ 0x53c6
v53c7: equ 0x53c7
v53c8: equ 0x53c8
v53c9: equ 0x53c9
v53ca: equ 0x53ca
v53cc: equ 0x53cc
v53ce: equ 0x53ce
v53cf: equ 0x53cf
v53d0: equ 0x53d0
v53d2: equ 0x53d2
v53d3: equ 0x53d3
v53d4: equ 0x53d4
v53d5: equ 0x53d5
v53dc: equ 0x53dc
v53e0: equ 0x53e0
v53e2: equ 0x53e2
v545f: equ 0x545f
v548a: equ 0x548a
f5b6d: equ 0x5b6d
v5cbf: equ 0x5cbf
v5fa4: equ 0x5fa4
v5fa7: equ 0x5fa7
f5fb6: equ 0x5fb6
v6030: equ 0x6030
v6031: equ 0x6031
v60c7: equ 0x60c7

fUS_SI: equ 0x5466			;	Flags. Bit 0 = US TEMP, Bit 1 = SI TEMP
pWEATHER_CONF: equ 0x5467	;	Config for weather display, one entry for each *digits* with a 'X' if skipped
SCRATCH4: equ 0x4f7a		;	Used a 4 bytes zone for STR/NUM conversions

							;	Display codes
CLEAR: equ 0x02
CLEAR_EOL: equ 0x03
HOME: equ 0x04
CRLF: equ 0x05
LEFT: equ 0x08
RIGHT: equ 0x09
DOWN: equ 0x0b
UP: equ 0x0c

; 0x10(CTRL-p)    "COLOR SEL" key
; 0x11(CTRL-q)    "BLUE" key
; 0x12(CTRL-r)    "RED" key
; 0x13(CTRL-s)    "GREEN" key
; 0x14(CTRL-t)    "WHITE" key
; 0x15(CTRL-u)    "YEL" key
; 0x16(CTRL-v)    "BRN" key
; 0x17(CTRL-w)    "VIOLET" key
; 0x18(CTRL-x)    "BLACK" key
; 0x19(CTRL-y)    "EDGE" key
; 0x1A(CTRL-z)    "FONTS" key

KEY_EOP: equ 0x02
KEY_EOL: equ 0x03

KEY_GRAPH_ARROW_DOWN: equ 0x5f
KEY_GRAPH_ARROW_UP: equ 0x73
KEY_CTRL_RESET: equ 0x90
KEY_SHIFT_RESET: equ 0xd0
KEY_BACKTAB: equ 0xa6
KEY_RESET:equ 0xF0
KEY_SET_WTR: equ 0xf7   ; see FUN_F7
KEY_RESUME: equ 0xf8
KEY_EDIT: equ 0xf9
KEY_RECALL: equ 0xfb
KEY_STORE: equ 0xfd

KEY_LINE_INSERT: equ 0x01 ; With CTRL = 0x81
KEY_ATTR_ERASE: equ 0x07 ; With CTRL = 0x87

; TODO:
;	Find all inlines ( ex (sp),hl )
; OUT_C_INLINE/DOWN_INLINE/LEFT_INLINE/RIGHT_INLINE are inline function to fix
; 0xc5f3 is a date/time function
; 0xc60b just below it pushes date/time/month strings from data into stack locations? 
; 0xc5cb is another date/time (RTC setup?) function
; 0xc45e - more RTC functions
; Suspicion on l9814h being the WEATHER display

; RAM base
RAM_BASE:	equ 0x4000
CUR_MAP:	equ 0x4122
; RAM TEST ADRESS
RAM_TEST:	equ 0x4f8d
; Stack base
STACK_BASE:	equ 0x52ad
; Warm boot/cold boot -- contains aa in warm boots
WARM_FLAG:	equ 0x53bb
MAGIC: equ 0xaa	; Stored in WARM_FLAG to see if we're doing a warm boot
MAGIC5: equ 0xaa ; Stored in NEEDSOFFSETDE (0x0005) if we need to offset DE by 75

; Some sort of display control. If bit 4 is set, no display
FLAGS: equ 0x4f79
FLAG_DISP: equ 4		;	Display control flag? -- may be also be something like I/O redirection

CURSORX: equ 0x4f86		;	Horizontal cursor position (0-39)

; Port list
PORT_SERIAL_DATA: equ 0x00		; Serial port A (external) data
PORT_DATAKBD_DATA: equ 0x01		; Keyboard data port
PORT_SERIAL_CMD: equ 0x02		; Serial port A (external) command
PORT_DATAKBD_CMD: equ 0x03		; Keyboard command port

PORT_04: equ 0x04				; Unknown
PORT_05: equ 0x05				; Unknown

PORT_06: equ 0x06				; Unknown
PORT_07: equ 0x07				; Unknown

PORT_12: equ 0x12				; Unknown (DART Command)

PORT_13: equ 0x13				; Something serial command (of PORT_14?)
PORT_14: equ 0x14				; Unknown

PORT_16: equ 0x16				; Unknown
PORT_17: equ 0x17				; Unknown

PORT_20: equ 0x20				; Unknown
PORT_21: equ 0x21				; Unknown
PORT_22: equ 0x22				; Unknown
PORT_23: equ 0x23				; Unknown
PORT_24: equ 0x24				; Unknown
PORT_25: equ 0x25				; Unknown
PORT_26: equ 0x26				; Unknown
PORT_27: equ 0x27				; Unknown
; PORT_22 to PORT_2F exists (see usage of PORT_20 around c4a9)
PORT_2C: equ 0x2c				; Unknown (link with 2D)
PORT_2D: equ 0x2d				; Unknown (link with 2C)
PORT_2E: equ 0x2e				; Unknown
PORT_2F: equ 0x2f				; Unknown


PORT_30: equ 0x30				; Unknown (datetime?) -- link with PORT_31 and PORT_20 too?
PORT_31: equ 0x31				; Unknown

PORT_DMA: equ 0x62				; DMA port

PORT_70: equ 0x70				; Unknown (battery? shutdown?)

PORT_MEM: equ 0xfe				; Memory mapping
PORT_FF: equ 0xff				; Unknown

; Pointers to circular buffers (32 bytes) to handle data input
; First two bytes = where to insert
; Last two bytes = where to read
; Buffers need to be aligned on 32 bytes boundaries
FIFO_SERIAL: equ 0x40e0			;	Serial
FIFO_KBD: equ 0x40e4			;	Keyboard
FIFO3: equ 0x40e8				;	PORT: 0x10 Serial?
FIFO4: equ 0x40ec				;	PORT: 0x11
FIFO5: equ 0x40f0				;	PORT: 0x14 Serial?
FIFO6: equ 0x40f4				;	PORT: 0x15
FIFO7: equ 0x40f8				;	Not sure if I/O related
; For port 0x00, 0x10, 0x14, it seems that 0x38 is written to the port+2 after the data is read
; (so 0x02, 0x12 and 0x16)

;	32 bytes buffers
FIFO_BUF_SERIAL: equ 0x4000
FIFO_BUF_KBD: equ 0x4020
FIFO_BUF3: equ 0x4040
FIFO_BUF4: equ 0x4060
FIFO_BUF5: equ 0x4080
FIFO_BUF6: equ 0x40a0
FIFO_BUF7: equ 0x40c0


TMPHL: equ 0x04f87	;	A temporary 2 bytes location to save HL

; When calling with restored map, registers and current maps are saved here
CALLMAPSAVE_A: equ 0x5fd9
CALLMAPSAVE_DE: equ 0x5fdb
CALLMAPSAVE_HL: equ 0x5fdd
CALLMAPSAVE_MAP: equ 0x5fdf


; If this is set, the macro will be typed as if it was entered from the keyboard
KEYMACRO: equ 0x5bb0


; Some macros to call functions that have inlined arguments
MACRO M_CALL_WITH_MMAP0, ADRS
	call CALL_WITH_MMAP0_INLINE
	dw ADRS
ENDM
MACRO M_OUT_CH, CHAR
	call OUT_CH_INLINE
	db CHAR
ENDM
MACRO M_OUT_MSG, MSG, LEN
	call OUT_MSG_INLINE
	dw MSG
	db LEN
ENDM
MACRO M_INPUT, ADRS, FLAGS
	call INPUT_INLINE
	dw ADRS
	db FLAGS
ENDM
MACRO M_SOMETHING1, ADRS, LEN
	call SOMETHING1_INLINE
	dw ADRS
	db LEN
ENDM
MACRO M_SOMETHING2, VAL
	call SOMETHING2_INLINE
	db VAL
ENDM
MACRO M_GOTO_YX, NUMB, NUM9
	call GOTO_YX_INLINE
	db NUMB
	db NUM9
ENDM
MACRO M_OUT_UP, NUM
	call OUT_C_INLINE
	db NUM
ENDM
MACRO M_DOWN, NUM
	call DOWN_INLINE
	db NUM
ENDM
MACRO M_LEFT, NUM
	call LEFT_INLINE
	db NUM
ENDM
MACRO M_RIGHT, NUM
	call RIGHT_INLINE
	db NUM
ENDM
MACRO M_OUT_VAR, ADRS, FLAGS
	call OUT_VAR_INLINE
	dw ADRS
	db FLAGS
ENDM

	; ---------------------------------------
	;	16K ROM U20
	;   ORG : 0000
	; ---------------------------------------
	org 00000h

COLD_START:
	di
	jp BOOT
VERSION:
	db 0x57			;	Version number

	; Hard coded configs, loaded/checked from other parts

;	#### In ADJUSTDE, if (NEEDSOFFSETDE) is 55, then DE is offset by 75. Called often.
NEEDSOFFSETDE:
	db 0xff
CFG1:
	db 0xff
CFG2:
	db 0xff, 0xff, 0xff
CFG3:
	db 0xff
CFG4_LANG:
LANG_US: equ 0xff
LANG_DE: equ 0xaa
	db 0xff				;	0xaa for German
CFG5:
	db 0xaa
CFG6:
	db 0xff
CFG10:
	db 0xff, 0xff
	
	dw INTER_10

;	Unknown
	db 0xff, 0xff
CFG12:
	db 0xff
CFG9:
	db 0xff
	db 0xff

CFG13:
	db 0xff

; DART documentation (https://www.cpcwiki.eu/index.php?title=Z80-DART/Z80-SIO_chip)

; WR0 Write register 0
;  0-2  Register Index (0-5 for write, 0-2 for read) (SIO: 0-7 for write)
;  3-5  Command (0..7)
;        0=No action
;        1=DART: Reserved / SIO: Send Abort (SDLC)
;        2=Reset Ext/Status Interrupts
;        3=Reset Channel
;        4=Enable Interrupt on next Rx character
;        5=Reset Tx Int pending
;        6=Reset Error
;        7=Return from Int (Ch-A only)
;  6-7  CRC Reset Code (DART: Reserved, should be 0) (SIO: 0..3)
;        0=No action
;        1=DART: Reserved, SIO: Reset Receive CRC Checker
;        2=DART: Reserved, SIO: Reset Transmit CRC Generator
;        3=DART: Reserved, SIO: Reset Tx Underrun/End of Message latch

; WR1 Write register 1
;  0   External Interrupts Enable
;  1   Tx Interrupt Enable
;  2   Status Affects Vector (Channel B only) (see WR2/RR2)
;  3-4 Rx Interrupt Mode (0..3)
;       0=None
;       1=On first Rx char
;       2=On all Rx chars (Parity affects vector)
;       3=On all Rx chars (Parity does not affect vector)
;  5   Wait/Ready on Receive/Transmit
;  6   Wait/Ready Function
;  7   Wait/Ready Enable

; WR2 Write register 2 - Interrupt Vector (Channel B only)
;  0-7 Interrupt Vector (Bit1-3=no effect when WR1.Bit2=1, see RR2 for details)

; WR3 Write register 3 - Rx Control
;  0   Rx Enable
;  1   DART: Reserved (must be 0), SIO: Sync Char Load Inhibit
;  2   DART: Reserved (must be 0), SIO: Address Search Mode
;  3   DART: Reserved (must be 0), SIO: Receiver CRC Enable
;  4   DART: Reserved (must be 0), SIO: Enter Hunt Phase
;  5   Enable automatic hardware handshaking using RTS/CTS
;  6-7 Rx data bits          (0..3 = 5bits, 7bits, 6bits, 8bits)

; WR4 Write register 4 - Rx/Tx Control
;  0   Rx/Tx Parity bit      (0=None, 1=Enable)
;  1   Rx/Tx Parity type     (0=Odd, 1=Even)
;  2-3 Rx/Tx Stop bits (0..3=Reserved, 1bit, 1.5bits, 2bits) (SIO: 0=Sync Modes)
;  4-5 DART: Reserved (must be 0), SIO: Sync Mode (enabled when Bit2-3=zero)
;       0=8bit SYNC Character        (SIO only, not DART)
;       1=16bit SYNC Character       (SIO only, not DART)
;       2=SDLC Mode (0111 1110 Flag) (SIO only, not DART)
;       3=External SYNC Mode         (SIO only, not DART)
;  6-7 Rx/Tx DART clock mode (0..3=X1, X16, X32, X64)

; WR5 Write register 5 - Tx Control
;  0   DART: Reserved (must be 0), SIO: Tx CRC Enable
;  1   RTS enabled/disabled
;  2   DART: Reserved (must be 0), SIO: Rx/Tx CRC Type (0=SDLC, 1=CRC-16)
;  3   Tx Enable
;  4   Tx Send break
;  6-5 Tx data bits          (0..3 = 5bits, 7bits, 6bits, 8bits)
;  7   DTR enabled/disabled

; WR6 Write register 6 - Sync Character or SDLC address (Z80 SIO only)
;  0-7 DART: N/A, SIO: LSBs of 8bit/16bit sync char, or SDLC address

; WR7 Write register 7 - Sync Character or SDLC flag (Z80 SIO only)
;  0-7 DART: N/A, SIO: MSBs of 16bit sync char, or SDLC flag (should be 7Eh)


KEYBOARD_INIT2:
	db 0x04, 0x4c, 0x05, 0x60, 0x03, 0xc1, 0x01, 0x1c
	; 0x04 0x4c : %01 00 11 0 0   =>	No Parity + 2 stop bits + Clock mode = x16
	; 0x05 0x60 : %0 11 0 0 0 0 0 =>	RTS disabled
	;									8 bits
	;									DTR disabled
	; 0x03 0xc1 : %11 0 0 0 0 0 1 => 	8bits
	;									no RTS/CTS handshake
	; 0x01 0x1c : %0 0 0 11 1 0 0 =>	No ext interrupt
	; 									Tx interrupt disable
	;									Status affect vector
	;									Rx interrupt on all chars, parity does not affects vector
	;									Wait/Ready disable

PORT_SERIAL_INIT:
	db 0x04, 0x84, 0x05, 0x68, 0x03, 0xc1, 0x01, 0x1c
	; 0x04 0x4c : %01 00 11 0 0   =>	No Parity + 2 stop bits + Clock mode = x16
	; 0x05 0x68 : %0 11 0 1 0 0 0 =>	RTS disabled
	;									Tx enabled
	;									8 bits
	;									DTR disabled
	; 0x03 0xc1 : %11 0 0 0 0 0 1 => 	8bits
	;									no RTS/CTS handshake
	; 0x01 0x1c : %0 0 0 11 1 0 0 =>	No ext interrupt
	; 									Tx interrupt disable
	;									Status affect vector
	;									Rx interrupt on all chars, parity does not affects vector
	;									Wait/Ready disable

PORT_12_INITA:
; Other DART init
	db 0x04, 0x4c, 0x05, 0xe8, 0x03, 0x01, 0x01, 0x1c
	; 0x04 0x4c : %01 00 11 0 0   =>	No Parity + 2 stop bits + Clock mode = x16
	; 0x05 0xe8 : %1 11 0 1 0 0 0 =>	RTS disabled
	;									Tx enabled
	;									8 bits
	;									DTR enabled
	; 0x03 0x01 : %00 0 0 0 0 0 1 => 	5bits (?)
	;									no RTS/CTS handshake
	; 0x01 0x1c : %0 0 0 11 1 0 0 =>	No ext interrupt
	; 									Tx interrupt disable
	;									Status affect vector
	;									Rx interrupt on all chars, parity does not affects vector
	;									Wait/Ready disable

PORT13_INIT2A:
	db 0x04, 0x4c, 0x05, 0xe8, 0x03, 0x01, 0x01, 0x1c
	; 0x04 0x4c : %01 00 11 0 0   =>	No Parity + 2 stop bits + Clock mode = x16
	; 0x05 0xe8 : %1 11 0 1 0 0 0 =>	RTS disabled
	;									Tx enabled
	;									8 bits
	;									DTR enabled
	; 0x03 0x01 : %00 0 0 0 0 0 1 => 	5bits (?)
	;									no RTS/CTS handshake
	; 0x01 0x1c : %0 0 0 11 1 0 0 =>	No ext interrupt
	; 									Tx interrupt disable
	;									Status affect vector
	;									Rx interrupt on all chars, parity does not affects vector
	;									Wait/Ready disable

; RST-38 entry point (warm boot?)
	di
	jp BOOT

CFG7:
	db 0xbb		; Hard coded config
CFG8:
	db 0x00		; Hard coded config
				; & 0x08 == 0 => imperial, ==0x08 => metric
CFG11:
	db 0xff

	db 0x00

PORT_16_INIT:
	db 0x04, 0x4c, 0x05, 0xe8, 0x03, 0xc1, 0x01, 0x1c
	; 0x04 0x4c : %01 00 11 0 0   =>	No Parity + 2 stop bits + Clock mode = x16
	; 0x05 0xe8 : %1 11 0 1 0 0 0 =>	RTS disabled
	;									Tx enabled
	;									8 bits
	;									DTR enabled
	; 0x03 0xc1 : %11 0 0 0 0 0 1 => 	8bits
	;									no RTS/CTS handshake
	; 0x01 0x1c : %0 0 0 11 1 0 0 =>	No ext interrupt
	; 									Tx interrupt disable
	;									Status affect vector
	;									Rx interrupt on all chars, parity does not affects vector
	;									Wait/Ready disable

PORT_17_INIT2:
	db 0x04, 0x4c, 0x05, 0xe8, 0x03, 0xc1, 0x01, 0x1c
	; Idem above

PORT_17_INIT3:
	db 0x04, 0x8c, 0x05, 0xe8, 0x03, 0x01, 0x01, 0x1c
	; 0x04 0x4c : %01 00 11 0 0   =>	No Parity + 2 stop bits + Clock mode = x16
	; 0x05 0xe8 : %1 11 0 1 0 0 0 =>	RTS disabled
	;									Tx enabled
	;									8 bits
	;									DTR enabled
	; 0x03 0x01 : %00 0 0 0 0 0 1 => 	5bits (?)
	;									no RTS/CTS handshake
	; 0x01 0x1c : %0 0 0 11 1 0 0 =>	No ext interrupt
	; 									Tx interrupt disable
	;									Status affect vector
	;									Rx interrupt on all chars, parity does not affects vector
	;									Wait/Ready disable

PORT_12_INITB:
	db 0x04, 0xcc, 0x05, 0xe8, 0x03, 0x01, 0x01, 0x1c
	; 0x04 0x4c : %11 00 11 0 0   =>	No Parity + 2 stop bits + Clock mode = x64
	; 0x05 0xe8 : %1 11 0 1 0 0 0 =>	RTS disabled
	;									Tx enabled
	;									8 bits
	;									DTR enabled
	; 0x03 0x01 : %00 0 0 0 0 0 1 => 	5bits (?)
	;									no RTS/CTS handshake
	; 0x01 0x1c : %0 0 0 11 1 0 0 =>	No ext interrupt
	; 									Tx interrupt disable
	;									Status affect vector
	;									Rx interrupt on all chars, parity does not affects vector
	;									Wait/Ready disable

	;	Interrupt vectors

	;	In general SIO devices capture 8 addresses
    ; Transmit Interrupt (T): This is usually bit 0 of the interrupt vector. It indicates that the transmit buffer is empty and ready for new data.

    ; Receive Interrupt (R): This is usually bit 1 of the interrupt vector. It indicates that the receive buffer has received new data.

    ; Channel Identifier (C): This is usually bit 2 of the interrupt vector. It identifies which channel generated the interrupt, helpful when dealing with multiple serial channels.

	;	Valid indexes in mode 2 are 64, 66, 6C, 6E, 74, 76, 7C, 7E, 84, 86, 8C, 8E


	dw INTER_DEFAULT
	dw INTER_DEFAULT
	dw INTER_64
	dw INTER_66
	dw INTER_DEFAULT
	dw INTER_DEFAULT
IF HACK_ROM
	dw FRED_HACK	;	Capture the interrupt 0x6C
ELSE
	dw INTER_6C
ENDIF
	dw INTER_6E
	dw INTER_DEFAULT
	dw INTER_DEFAULT
	dw INTER_74
	dw INTER_76
	dw INTER_DEFAULT
	dw INTER_DEFAULT
	dw INTER_7C
	dw INTER_7E
	dw INTER_DEFAULT
	dw INTER_DEFAULT
	dw INTER_84
	dw INTER_86
	dw INTER_DEFAULT
	dw INTER_DEFAULT
	dw INTER_8C
	dw INTER_8E

PORT13_INIT2C:		; Reused for port 17
	db 0x04, 0x44, 0x05, 0x60, 0x03, 0x81, 0x01, 0x1c
	; 0x04 0x44 : %01 00 01 0 0   =>	No Parity + 1 stop bits + Clock mode = x16
	; 0x05 0x60 : %0 11 0 0 0 0 0 =>	RTS disabled
	;									Tx disable
	;									8 bits
	;									DTR disabled
	; 0x03 0x81 : %10 0 0 0 0 0 1 => 	6bits (?)
	;									no RTS/CTS handshake
	; 0x01 0x1c : %0 0 0 11 1 0 0 =>	No ext interrupt
	; 									Tx interrupt disable
	;									Status affect vector
	;									Rx interrupt on all chars, parity does not affects vector
	;									Wait/Ready disable


PORT13_INIT2B:
	db 0x04, 0x4c, 0x05, 0xe8, 0x03, 0x41, 0x01, 0x1c
	; 0x04 0x4c : %01 00 11 0 0   =>	No Parity + 2 stop bits + Clock mode = x16
	; 0x05 0xe8 : %1 11 0 1 0 0 0 =>	RTS disabled
	;									Tx enabled
	;									8 bits
	;									DTR enabled
	; 0x03 0x41 : %01 0 0 0 0 0 1 => 	7bits (?)
	;									no RTS/CTS handshake
	; 0x01 0x1c : %0 0 0 11 1 0 0 =>	No ext interrupt
	; 									Tx interrupt disable
	;									Status affect vector
	;									Rx interrupt on all chars, parity does not affects vector
	;									Wait/Ready disable


KEYBOARD_INIT:
	db 0x30, 0x10, 0x02, 0x60
; Common init for port 13
PORT13_INIT:
	db 0x30, 0x10, 0x02, 0x70
	; 0x30 : %00 110 000          => 	Reset error, next register 0
	; 0x10 : %00 010 000		  => 	Reset Ext/Status Interrupts, next register 0
	; 0x02 0x70 				  =>	Interrupt vector 0x70 + status

PORT_17_INIT:
	db 0x30, 0x10, 0x02, 0x80
	; Idem above, interrupt vector 0x80 + status

; [JCM-1] The keyboard interrupt handler starts at 00AC
INTER_64
	exx
	push af
	ld c,PORT_DATAKBD_DATA
	in a,(c)
	ld b,a
	cp 0d0h			;00b3	fe d0		. .
	jr nz,l00dch		;00b5	20 25		  %
	ld a,(05fd3h)		;00b7	3a d3 5f	: . _
l00bah:
	cp 091h			;00ba	fe 91		. .
	jr z,l00c6h		;00bc	28 08		( .
l00beh:
	ld a,(05cbah)		;00be	3a ba 5c	: . \
	cp 001h			;00c1	fe 01		. .
	jp nz,COLD_START	;00c3	c2 00 00	. . .
l00c6h:
	ld hl,FIFO_KBD		;00c6	21 e4 40	! . @
	ld a,b			;00c9	78		x
	call DATA2FIFO		;00ca	cd 09 0f	. . .

; From z8470 datasheet
; 0x38 == %00111000 == 00 111 000
;                      76 543 210
;  0-2  Register Index (0-5 for write, 0-2 for read) (SIO: 0-7 for write)
; => Writing 0 (keep writing to regiister 0)
; 3-5  Command (0..7)
;       0=No action
;       1=DART: Reserved / SIO: Send Abort (SDLC)
;       2=Reset Ext/Status Interrupts
;       3=Reset Channel
;       4=Enable Interrupt on next Rx character
;       5=Reset Tx Int pending
;       6=Reset Error
;       7=Return from Int (Ch-A only)
; => Writing 7 (return from interrupt)
; 6-7  CRC Reset Code (DART: Reserved, should be 0) (SIO: 0..3)
;       0=No action
;       1=DART: Reserved, SIO: Reset Receive CRC Checker
;       2=DART: Reserved, SIO: Reset Transmit CRC Generator
;       3=DART: Reserved, SIO: Reset Tx Underrun/End of Message latch
; => Writing 0 (no action)
; If port is even, the send 0x38 to PORT+2 (ACK?)
ACK_IF_NEEDED:
	bit 0,c
	jr nz,_exit
	ld a,0x38		; Return from interrupt
	inc c
	inc c
	out (c),a
_exit:
	exx
	pop af
	ei
	reti

l00dch:
	ld a,b			;00dc	78		x
	cp 091h			;00dd	fe 91		. .
	jr nz,l00c6h		;00df	20 e5		  .
	ld a,(05fd3h)		;00e1	3a d3 5f	: . _
	cp 091h			;00e4	fe 91		. .
l00e6h:
	jr nz,l00c6h		;00e6	20 de		  .
	jr l00beh		;00e8	18 d4		. .

; Command received
INTER_66:
	push bc
	ld c,003h
RESETANDACK:
	ld b,0x30		; Reset Error
l00efh:
	out (c),b
	push af
	bit 0,c	
	jr nz,_skip
	ld b,0x38		; Return from interrupt
	out (c),b
_skip:
	pop af
	pop bc
	ei
	reti

; Serial port data received
INTER_6C:
	exx
	push af
	ld c,PORT_SERIAL_DATA
	ld hl,FIFO_SERIAL
	call PORT2FIFO	; Read port 0x00 into FIFO_SERIAL
	jr ACK_IF_NEEDED

; Serial port command received
INTER_6E:
	push bc
	ld c,PORT_SERIAL_CMD
	jr RESETANDACK

; [JCM-1] There is a handler for interrupt 0x10 at 0110
INTER_7C:
	exx			;0110	d9		.
	push af			;0111	f5		.
	ld c,010h		;0112	0e 10		. .
	ld hl,FIFO3		;0114	21 e8 40	! . @
	call PORT2FIFO	;0117	cd 07 0f	. . .
	jr ACK_IF_NEEDED		;011a	18 b1		. .

INTER_7E:
	push bc			;011c	c5		.
	ld c,012h		;011d	0e 12		. .
	jr RESETANDACK		;011f	18 cc		. .

; [JCM-1] There is a handler for interrupt 0x11 at 0121
INTER_74:
	exx			;0121	d9		.
	push af			;0122	f5		.
	ld c,011h		;0123	0e 11		. .
	ld hl,FIFO4		;0125	21 ec 40	! . @
	call PORT2FIFO	;0128	cd 07 0f	. . .
	jr ACK_IF_NEEDED		;012b	18 a0		. .

INTER_76:
	push bc			;012d	c5		.
	ld c,013h		;012e	0e 13		. .
	jr RESETANDACK		;0130	18 bb		. .

; [JCM-1] There is a handler for interrupt 0x14 at 0132
INTER_8C:
	exx			;0132	d9		.
	push af			;0133	f5		.
	ld c,PORT_14
	in a,(c)		;0136	ed 78		. x
	ld b,a			;0138	47		G
	cp 013h			;0139	fe 13		. .
	ld a,000h		;013b	3e 00		> .
	jr nz,l0140h		;013d	20 01		  .
	inc a			;013f	3c		<
l0140h:
	ld (05eabh),a		;0140	32 ab 5e	2 . ^
	ld a,b			;0143	78		x
l0144h:
	ld hl,FIFO5		;0144	21 f0 40	! . @
l0147h:
	call DATA2FIFO		;0147	cd 09 0f	. . .
	ld a,(05eaah)		;014a	3a aa 5e	: . ^
	and a			;014d	a7		.
	jp nz,ACK_IF_NEEDED		;014e	c2 cd 00	. . .
	ld a,(hl)		;0151	7e		~
	and 01fh		;0152	e6 1f		. .
	ld b,a			;0154	47		G
	inc hl			;0155	23		#
	inc hl			;0156	23		#
	ld a,(hl)		;0157	7e		~
	dec a			;0158	3d		=
	and 01fh		;0159	e6 1f		. .
	cp b			;015b	b8		.
	jp z,08b49h		;015c	ca 49 8b	. I .
	dec a			;015f	3d		=
	and 01fh		;0160	e6 1f		. .
	cp b			;0162	b8		.
	jp z,08b49h		;0163	ca 49 8b	. I .
	jp ACK_IF_NEEDED		;0166	c3 cd 00	. . .

INTER_8E:
	push bc			;0169	c5		.
	ld c,016h		;016a	0e 16		. .
	jp RESETANDACK		;016c	c3 ed 00	. . .

INTER_84:
	exx			;016f	d9		.
l0170h:
	push af			;0170	f5		.
	ld c,015h		;0171	0e 15		. .
	ld hl,FIFO6		;0173	21 f4 40	! . @
	call PORT2FIFO	;0176	cd 07 0f	. . .
	jp ACK_IF_NEEDED		;0179	c3 cd 00	. . .

INTER_86:
	push bc			;017c	c5		.
	ld c,017h		;017d	0e 17		. .
	jp RESETANDACK		;017f	c3 ed 00	. . .

; 	Defaut handler?
;	(Looks like it reboot the machine)
INTER_DEFAULT:
	exx			;0182	d9		.
	push af			;0183	f5		.
	M_CALL_WITH_MMAP0 INIT
	pop af			;0189	f1		.
	exx			;018a	d9		.
	ei			;018b	fb		.
	reti			;018c	ed 4d		. M

; Cold start boot
BOOT:
	di
	ld sp,STACK_BASE

; Wait for RAM to stabilize
WAIT_RAM:
	ld a,%10101010
	ld (RAM_TEST),a
	ld a,(RAM_TEST)
	cp %10101010
	jr nz,WAIT_RAM
	ld a,(WARM_FLAG)
	cp MAGIC
	jp z,WARM_BOOT

COLD_BOOT:
	;	clear 0x4000-0x6fff (with a off-by-one bug)
	ld bc,l3000h
	ld de,RAM_BASE+1
	ld hl,RAM_BASE
	ld (hl),0
	ldir		; memset( RAM_BASE, 0, 0x3001 );

	ld a,003h		;01b3	3e 03		> .
	call SETMEMMAP	;01b5	cd 1a 0f	. . .

	;	clear 0xc000-0xffff (which is in ROM???)
	ld hl,0c000h
	ld de,0c001h
	ld bc,0x3fff
	ld (hl),0
	ldir		; memset( 0xc000, 0, 0x4000 );

	xor a
	call sub_087ch		;01c6	cd 7c 08	. | .

	ld hl,003e7h		;01c9	21 e7 03	! . .
	ld (052c2h),hl		;01cc	22 c2 52	" . R
	call sub_22f0h		;01cf	cd f0 22	. . "
	call sub_2318h		;01d2	cd 18 23	. . #
	call FUN_F9		;01d5	cd d2 23	. . #
	ld a,04eh		;01d8	3e 4e		> N
	ld (05b84h),a		;01da	32 84 5b	2 . [
	call sub_0968h		;01dd	cd 68 09	. h .
	ld (05b77h),hl		;01e0	22 77 5b	" w [
	ld hl,17		;01e3	21 11 00	! . .
	ld (05b79h),hl		;01e6	22 79 5b	" y [
	call 09edeh		;01e9	cd de 9e	. . .
	ld hl,053bdh		;01ec	21 bd 53	! . S
	ld a,00fh		;01ef	3e 0f		> .
	ld (hl),a		;01f1	77		w
	inc hl			;01f2	23		#
	inc hl			;01f3	23		#
	ld a,04eh		;01f4	3e 4e		> N
	ld (hl),a		;01f6	77		w
	inc hl			;01f7	23		#
	ld (hl),a		;01f8	77		w
	call 0b3a3h		;01f9	cd a3 b3	. . .
	ld a,(CFG3)		;01fc	3a 0a 00	: . .
	ld (05b88h),a		;01ff	32 88 5b	2 . [
	ld a,MAGIC
	ld (040fch),a		;0204	32 fc 40	2 . @
	ld (04f8ch),a		;0207	32 8c 4f	2 . O
	ld (WARM_FLAG),a	; We booted
	ld a,01ah		;020d	3e 1a		> .
	ld (05b71h),a		;020f	32 71 5b	2 q [
	ld hl,(05b77h)		;0212	2a 77 5b	* w [
	dec hl			;0215	2b		+
	ld (05b77h),hl		;0216	22 77 5b	" w [
	ld d,h			;0219	54		T
	ld e,l			;021a	5d		]
	ld hl,0	;021b	21 00 00	! . .
	call 0b05ch		;021e	cd 5c b0	. \ .
	ld a,00fh		;0221	3e 0f		> .
	ld (053bdh),a		;0223	32 bd 53	2 . S
	ld hl,05eb3h		;0226	21 b3 5e	! . ^
	ld b,006h		;0229	06 06		. .
l022bh:
	ld (hl),020h		;022b	36 20		6  
	inc hl			;022d	23		#
	djnz l022bh		;022e	10 fb		. .
l0230h:
	ld hl,05eb3h		;0230	21 b3 5e	! . ^
	ld de,05ebdh		;0233	11 bd 5e	. . ^
	ld bc,l00e6h		;0236	01 e6 00	. . .
	ldir			;0239	ed b0		. .
	call sub_0849h		;023b	cd 49 08	. I .
	xor a			;023e	af		.
	call SETMEMMAP	;023f	cd 1a 0f	. . .
	ld hl,(ROM_MAGIC)
	ld de,0aaaah
	call CMP_HLDE
	jr nz,WARM_BOOT
	ld hl,ROM_DEMO
	ld (KEYMACRO),hl		;0250	22 b0 5b	" . [
	ld a,0aah		;0253	3e aa		> .
	ld (04f78h),a		;0255	32 78 4f	2 x O
; Warm boot
WARM_BOOT:
	ld sp,STACK_BASE	;0258	31 ad 52	1 . R
	M_CALL_WITH_MMAP0 INIT

	;	Init FIFO bffers
	ld hl,FIFO_BUF_SERIAL
	ld (FIFO_SERIAL),hl
	ld (FIFO_SERIAL+2),hl
	ld hl,FIFO_BUF_KBD
	ld (FIFO_KBD),hl
	ld (FIFO_KBD+2),hl
	ld hl,FIFO_BUF3
	ld (FIFO3),hl
	ld (FIFO3+2),hl
	ld hl,FIFO_BUF4
	ld (FIFO4),hl
	ld (FIFO4+2),hl
	ld hl,FIFO_BUF5
	ld (FIFO5),hl
	ld (FIFO5+2),hl
	ld hl,FIFO_BUF6
	ld (FIFO6),hl
	ld (FIFO6+2),hl
	ld hl,FIFO_BUF7
	ld (FIFO7),hl
	ld (FIFO7+2),hl

	xor a
	ld (05b6eh),a
	ld (05cbah),a
	ld (05cbbh),a
	ld (05cbch),a
	ld (05eadh),a
	ld (05eabh),a
	call sub_b3a9h
	ld a,(05b87h)		;02b5	3a 87 5b	: . [
	ld b,a			;02b8	47		G
	in a,(PORT_05)		;02b9	db 05		. .
	and 030h		;02bb	e6 30		. 0
	ld (053bch),a		;02bd	32 bc 53	2 . S
	ld a,(053bdh)		;02c0	3a bd 53	: . S
	out (PORT_05),a		;02c3	d3 05		. .
	xor a			;02c5	af		.
	ld (f5fb6),a		;02c6	32 b6 5f	2 . _

	ld de,STACK_BASE+2		;02c9	11 af 52	. . R

	ld hl,TASK_1
	ld sp,04ff1h		;02cf	31 f1 4f	1 . O
	call sub_034eh		;02d2	cd 4e 03	. N .

	ld hl,TASK_2		;02d5	21 c1 24	! . $
	ld sp,05055h		;02d8	31 55 50	1 U P
	call sub_034eh		;02db	cd 4e 03	. N .

	ld hl,TASK_3		;02de	21 8c 2b	! . +
	ld sp,050b9h		;02e1	31 b9 50	1 . P
	call sub_034eh		;02e4	cd 4e 03	. N .

	ld hl,TASK_4		;02e7	21 47 31	! G 1
	ld sp,0511dh		;02ea	31 1d 51	1 . Q
	call sub_034eh		;02ed	cd 4e 03	. N .

	ld hl,TASK_5		;02f0	21 4a 91	! J .
	ld sp,05181h		;02f3	31 81 51	1 . Q
	call sub_034eh		;02f6	cd 4e 03	. N .

	ld hl,TASK_6		;02f9	21 71 8b	! q .
	ld sp,051e5h		;02fc	31 e5 51	1 . Q
	call sub_034eh		;02ff	cd 4e 03	. N .

	ld hl,TASK_7		;0302	21 ae 08	! . .
	ld sp,05249h		;0305	31 49 52	1 I R
	call sub_034eh		;0308	cd 4e 03	. N .

	xor a			;030b	af		.
	ld (de),a		;030c	12		.
	inc de			;030d	13		.
	ld (de),a		;030e	12		.
	call RETURN_FROM_INTER		;030f	cd 64 03	. d .
	call 08b2eh		;0312	cd 2e 8b	. . .
l0315h:
	ld hl,STACK_BASE+2
	in a,(PORT_FF)		; ???
l031ah:
	ld e,(hl)
	inc hl
	ld d,(hl)		; Get DE from TOP of stack
	ld a,d
	or e
	jr z,l0315h		; if no stack (DE==0) use STACK_BASE+2
	dec hl
	ld (STACK_BASE),hl	;Store at the bottom of the stack
	ex de,hl		;
	ld sp,hl		;
	pop af			;
	call SETMEMMAP
	pop iy
	pop ix
	pop hl
	pop de
	pop bc
	pop af
	ret

; All this needs a bit more investigation
; I think there is something stored at the bottom of the stack (STACK_BASE)
; and these routines restore everything for each
; "machine cycle" (treatment of one event)

sub_0334h:
	push af
	push bc
	push de
	push hl
	push ix
	push iy
	ld a,(CUR_MAP)	; Will be reset later
	push af
	ld hl,0
	add hl,sp
	ex de,hl		; DE = SP
	ld hl,(STACK_BASE)	; Get HL from pointer in the stack
	ld (hl),e		; Store previous SP	
	inc hl
	ld (hl),d
	inc hl
	jr l031ah		; Sort-of just undoes what we just did...

; Usage unclear
; This overwrites SP with 7 times HL + 0x0000
; Stores a pointer to that in (DE++)
; then jumps at the address that was initially top of stack
; INPUT SP,HL,DE
; (Maybe the 7 are space for registers AF,BC,DE,HL,IX,IY and PC?)
sub_034eh:
	pop bc			; Address of return address
	push hl			; Write 7 times HL
	push hl			;
	push hl			;
	push hl			;
	push hl			;
	push hl			;
	push hl			;
	ld hl,0
	push hl			; And a 0
	add hl,sp		; (As hl is 0, this is HL=SP)
	ex de,hl		;
	ld (hl),e		; Stores SP into DE
	inc hl			;
	ld (hl),d		;
	inc hl			;
	ex de,hl		; DE += 2
	ld h,b			;
	ld l,c			;
	jp (hl)			; Return

;	Called to return from an interrupt
RETURN_FROM_INTER:
	ei
	reti

; Off "something"
FUN_0F:
	ld a,0
	ld (05fcfh),a
	ret

; On "something"
FUN_07:
	ld a,0xaa
	ld (05fcfh),a
	ret

INTER_10:
	push af			;0373	f5		.
	push bc			;0374	c5		.
	push de			;0375	d5		.
	push hl			;0376	e5		.
	push ix			;0377	dd e5		. .
	push iy			;0379	fd e5		. .
	ld a,(CUR_MAP)		;037b	3a 22 41	: " A
	push af			;037e	f5		.

		;	Sends 19 bytes to DMA controller
	ld hl,OUT_DATA62
	ld c,PORT_DMA
	ld b,OUT_DATA62_END-OUT_DATA62
	otir

	ld hl,05fa3h		;0388	21 a3 5f	! . _
	inc (hl)		;038b	34		4
	ld hl,v52bf		;038c	21 bf 52	! . R
	inc (hl)		;038f	34		4
	call sub_1582h		;0390	cd 82 15	. . .
	call 0949bh		;0393	cd 9b 94	. . .
	ld a,0x05
	out (PORT_DATAKBD_CMD),a
	ld a,(05fcfh)		;039a	3a cf 5f	: . _
	cp 0xaa
	ld a,0e2h
	jr nz,_skip
	ld a,0e0h
_skip:
	out (PORT_DATAKBD_CMD),a		;03a5	d3 03		. .
	ld a,(05b6eh)		;03a7	3a 6e 5b	: n [
	or a			;03aa	b7		.
	jp nz,l06fah		;03ab	c2 fa 06	. . .
	ld a,001h		;03ae	3e 01		> .
	ld (05b6eh),a		;03b0	32 6e 5b	2 n [
	ld a,006h		;03b3	3e 06		> .
	ld (05687h),a		;03b5	32 87 56	2 . V
	ld ix,05688h		;03b8	dd 21 88 56	. ! . V
	call RETURN_FROM_INTER		;03bc	cd 64 03	. d .
l03bfh:
	ld a,(ix+01dh)		;03bf	dd 7e 1d	. ~ .
	cp 002h			;03c2	fe 02		. .
	jp c,l06e8h		;03c4	da e8 06	. . .
	jp z,l062ch		;03c7	ca 2c 06	. , .
	cp 004h			;03ca	fe 04		. .
	jr c,l03d9h		;03cc	38 0b		8 .
	jp z,l0461h		;03ce	ca 61 04	. a .
	cp 006h			;03d1	fe 06		. .
	jp c,l062dh		;03d3	da 2d 06	. - .
	jp l06e8h		;03d6	c3 e8 06	. . .
l03d9h:
	ld a,(ix+001h)		;03d9	dd 7e 01	. ~ .
	or a			;03dc	b7		.
	jr z,l043eh		;03dd	28 5f		( _
	ld h,(ix+003h)		;03df	dd 66 03	. f .
	ld l,(ix+002h)		;03e2	dd 6e 02	. n .
	ld a,(hl)		;03e5	7e		~
	sub (ix+004h)		;03e6	dd 96 04	. . .
	ld (hl),a		;03e9	77		w
	ld d,(ix+008h)		;03ea	dd 56 08	. V .
	ld e,(ix+007h)		;03ed	dd 5e 07	. ^ .
	cp 038h			;03f0	fe 38		. 8
	jr nc,l03f8h		;03f2	30 04		0 .
	ex de,hl		;03f4	eb		.
	ld (hl),020h		;03f5	36 20		6  
	ex de,hl		;03f7	eb		.
l03f8h:
	cp 080h			;03f8	fe 80		. .
	jr c,l0401h		;03fa	38 05		8 .
	sub (ix+005h)		;03fc	dd 96 05	. . .
	jr l0409h		;03ff	18 08		. .
l0401h:
	sub (ix+005h)		;0401	dd 96 05	. . .
	jr z,l0409h		;0404	28 03		( .
	jp nc,l06e8h		;0406	d2 e8 06	. . .
l0409h:
	add a,(ix+006h)		;0409	dd 86 06	. . .
	ld (hl),a		;040c	77		w
	ld b,000h		;040d	06 00		. .
l040fh:
	ld c,(ix+009h)		;040f	dd 4e 09	. N .
	push de			;0412	d5		.
	pop hl			;0413	e1		.
	inc hl			;0414	23		#
	ldir			;0415	ed b0		. .
	ld a,(ix+000h)		;0417	dd 7e 00	. ~ .
	call SETMEMMAP	;041a	cd 1a 0f	. . .
	ld h,(ix+00ch)		;041d	dd 66 0c	. f .
	ld l,(ix+00bh)		;0420	dd 6e 0b	. n .
	ld a,(hl)		;0423	7e		~
	cp 0f0h			;0424	fe f0		. .
	jr nz,l042ah		;0426	20 02		  .
	ld a,020h		;0428	3e 20		>  
l042ah:
	cp 0f1h			;042a	fe f1		. .
	jr nz,l0430h		;042c	20 02		  .
	ld a,020h		;042e	3e 20		>  
l0430h:
	ld (de),a		;0430	12		.
	inc hl			;0431	23		#
	ld (ix+00ch),h		;0432	dd 74 0c	. t .
	ld (ix+00bh),l		;0435	dd 75 0b	. u .
	dec (ix+001h)		;0438	dd 35 01	. 5 .
	jp nz,l06e8h		;043b	c2 e8 06	. . .
l043eh:
	ld a,(ix+00dh)		;043e	dd 7e 0d	. ~ .
	or a			;0441	b7		.
	jp z,l06e8h		;0442	ca e8 06	. . .
	ld (ix+001h),a		;0445	dd 77 01	. w .
	xor a			;0448	af		.
	ld (ix+00dh),a		;0449	dd 77 0d	. w .
	ld a,(ix+00eh)		;044c	dd 7e 0e	. ~ .
	ld (ix+00bh),a		;044f	dd 77 0b	. w .
;	Weird jump in the middle of the instruction
;	From a dozen of different places
;	ld a,(ix+00fh)		;0452	dd 7e 0f	. ~ .

	db 0xdd
l0453h:
	ld a,(hl)
	rrca
	ld (ix+00ch),a		;0455	dd 77 0c	. w .
	ld a,(ix+010h)		;0458	dd 7e 10	. ~ .
	ld (ix+000h),a		;045b	dd 77 00	. w .
	jp l06e8h		;045e	c3 e8 06	. . .
l0461h:
	bit 7,(ix+000h)		;0461	dd cb 00 7e	. . . ~
	jp nz,l06e8h		;0465	c2 e8 06	. . .
	ld a,(ix+006h)		;0468	dd 7e 06	. ~ .
	cp 020h			;046b	fe 20		.  
	jr z,l0492h		;046d	28 23		( #
	cp 010h			;046f	fe 10		. .
	jr z,l047fh		;0471	28 0c		( .
	dec (ix+007h)		;0473	dd 35 07	. 5 .
	jp nz,l06e8h		;0476	c2 e8 06	. . .
	ld (ix+007h),003h	;0479	dd 36 07 03	. 6 . .
	jr l0492h		;047d	18 13		. .
l047fh:
	in a,(PORT_05)		;047f	db 05		. .
	ld b,a			;0481	47		G
		;	b = b XOR 0xff if NEEDSOFFSETDE is MAGIC5
	ld a,(NEEDSOFFSETDE)
	cp MAGIC5
	jr nz,_skip
	ld a,0xff
	xor b
	ld b,a
_skip:
	bit 6,b			;048d	cb 70		. p
	jp z,l06e8h		;048f	ca e8 06	. . .

l0492h:
	ld a,(ix+013h)		;0492	dd 7e 13	. ~ .
	and a			;0495	a7		.
	jr nz,l04aeh		;0496	20 16		  .
	ld a,(ix+008h)		;0498	dd 7e 08	. ~ .
	and a			;049b	a7		.
	jr nz,l04aeh		;049c	20 10		  .
	set 0,(ix+000h)		;049e	dd cb 00 c6	. . . .
	ld a,(ix+019h)		;04a2	dd 7e 19	. ~ .
	cp 00ah			;04a5	fe 0a		. .
	jp nz,l06e8h		;04a7	c2 e8 06	. . .
	set 6,(ix+000h)		;04aa	dd cb 00 f6	. . . .
l04aeh:
	ld h,(ix+002h)		;04ae	dd 66 02	. f .
	ld l,(ix+001h)		;04b1	dd 6e 01	. n .
	ld de,0x2e		;04b4	11 2e 00	. . .
	add hl,de		;04b7	19		.
	bit 6,(hl)		;04b8	cb 76		. v
	jp z,l0581h		;04ba	ca 81 05	. . .
	bit 5,(hl)		;04bd	cb 6e		. n
	jp z,l0560h		;04bf	ca 60 05	. ` .
	push hl			;04c2	e5		.
	ld h,(ix+004h)		;04c3	dd 66 04	. f .
	ld l,(ix+003h)		;04c6	dd 6e 03	. n .
	add hl,de		;04c9	19		.
	ld b,h			;04ca	44		D
	ld c,l			;04cb	4d		M
	pop hl			;04cc	e1		.
	ld d,(ix+002h)		;04cd	dd 56 02	. V .
	ld e,(ix+001h)		;04d0	dd 5e 01	. ^ .
	ldir			;04d3	ed b0		. .
l04d5h:
	ld a,(ix+013h)		;04d5	dd 7e 13	. ~ .
	and a			;04d8	a7		.
	jr nz,l0552h		;04d9	20 77		  w
	ld h,(ix+012h)		;04db	dd 66 12	. f .
	ld l,(ix+011h)		;04de	dd 6e 11	. n .
	bit 6,(ix+000h)		;04e1	dd cb 00 76	. . . v
	jr nz,l053dh		;04e5	20 56		  V
	ld a,(ix+00ch)		;04e7	dd 7e 0c	. ~ .
	ld (ix+013h),a		;04ea	dd 77 13	. w .
	ld a,(ix+009h)		;04ed	dd 7e 09	. ~ .
	call SETMEMMAP	;04f0	cd 1a 0f	. . .
	call sub_0607h		;04f3	cd 07 06	. . .
	call sub_061eh		;04f6	cd 1e 06	. . .
	inc de			;04f9	13		.
	ld bc,00028h		;04fa	01 28 00	. ( .
	ld h,(ix+00bh)		;04fd	dd 66 0b	. f .
	ld l,(ix+00ah)		;0500	dd 6e 0a	. n .
	ldir			;0503	ed b0		. .
	ex de,hl		;0505	eb		.
	ld a,(ix+010h)		;0506	dd 7e 10	. ~ .
	ld (hl),038h		;0509	36 38		6 8
	inc hl			;050b	23		#
	ld (hl),a		;050c	77		w
	inc hl			;050d	23		#
	ld a,(ix+01ch)		;050e	dd 7e 1c	. ~ .
	and 0c0h		;0511	e6 c0		. .
	or 03fh			;0513	f6 3f		. ?
	ld (hl),a		;0515	77		w
	ld (ix+008h),000h	;0516	dd 36 08 00	. 6 . .
	set 0,(ix+005h)		;051a	dd cb 05 c6	. . . .
	ld a,(ix+00dh)		;051e	dd 7e 0d	. ~ .
	ld (ix+011h),a		;0521	dd 77 11	. w .
	ld a,(ix+00eh)		;0524	dd 7e 0e	. ~ .
	ld (ix+012h),a		;0527	dd 77 12	. w .
	ld a,(ix+00fh)		;052a	dd 7e 0f	. ~ .
	ld (ix+014h),a		;052d	dd 77 14	. w .
	ld a,(ix+01ch)		;0530	dd 7e 1c	. ~ .
	ld (ix+01bh),a		;0533	dd 77 1b	. w .
l0536h:
	set 1,(ix+005h)		;0536	dd cb 05 ce	. . . .
	jp l06e8h		;053a	c3 e8 06	. . .
l053dh:
	call sub_0607h		;053d	cd 07 06	. . .
	call sub_061eh		;0540	cd 1e 06	. . .
	set 1,(ix+005h)		;0543	dd cb 05 ce	. . . .
	set 7,(ix+000h)		;0547	dd cb 00 fe	. . . .
	res 6,(ix+000h)		;054b	dd cb 00 b6	. . . .
	jp l06e8h		;054f	c3 e8 06	. . .
l0552h:
	dec (ix+013h)		;0552	dd 35 13	. 5 .
	ld h,(ix+012h)		;0555	dd 66 12	. f .
	ld l,(ix+011h)		;0558	dd 6e 11	. n .
	call sub_0607h		;055b	cd 07 06	. . .
	jr l0536h		;055e	18 d6		. .
l0560h:
	ld d,(ix+002h)		;0560	dd 56 02	. V .
	ld e,(ix+001h)		;0563	dd 5e 01	. ^ .
	call sub_05fch		;0566	cd fc 05	. . .
	ld bc,3		;0569	01 03 00	. . .
	ldir			;056c	ed b0		. .
	dec hl			;056e	2b		+
	dec hl			;056f	2b		+
	dec hl			;0570	2b		+
	ex de,hl		;0571	eb		.
	ld hl,0x2e		;0572	21 2e 00	! . .
	add hl,de		;0575	19		.
	ld b,(ix+004h)		;0576	dd 46 04	. F .
	ld c,(ix+003h)		;0579	dd 4e 03	. N .
	ldir			;057c	ed b0		. .
	jp l04d5h		;057e	c3 d5 04	. . .
l0581h:
	push hl			;0581	e5		.
	call sub_05fch		;0582	cd fc 05	. . .
	ld d,(ix+002h)		;0585	dd 56 02	. V .
	ld e,(ix+001h)		;0588	dd 5e 01	. ^ .
	ld bc,3		;058b	01 03 00	. . .
	ldir			;058e	ed b0		. .
	pop de			;0590	d1		.
	ld b,(ix+004h)		;0591	dd 46 04	. F .
	ld c,(ix+003h)		;0594	dd 4e 03	. N .
	ldir			;0597	ed b0		. .
	bit 1,(ix+005h)		;0599	dd cb 05 4e	. . . N
	jr z,l05f3h		;059d	28 54		( T
	dec de			;059f	1b		.
	dec de			;05a0	1b		.
	dec de			;05a1	1b		.
	ld a,(de)		;05a2	1a		.
	and 01fh		;05a3	e6 1f		. .
	ld (de),a		;05a5	12		.
	inc de			;05a6	13		.
	ld a,(de)		;05a7	1a		.
	and 01fh		;05a8	e6 1f		. .
	ld (de),a		;05aa	12		.
	inc de			;05ab	13		.
	inc de			;05ac	13		.
	bit 0,(ix+005h)		;05ad	dd cb 05 46	. . . F
	jr z,l05efh		;05b1	28 3c		( <
	ld a,060h		;05b3	3e 60		> `
l05b5h:
	ld h,(ix+012h)		;05b5	dd 66 12	. f .
	ld l,(ix+011h)		;05b8	dd 6e 11	. n .
	or (hl)			;05bb	b6		.
	ld (de),a		;05bc	12		.
	inc hl			;05bd	23		#
	inc de			;05be	13		.
	and 0e0h		;05bf	e6 e0		. .
	or (hl)			;05c1	b6		.
	ld (de),a		;05c2	12		.
	inc de			;05c3	13		.
	inc hl			;05c4	23		#
	ld (ix+012h),h		;05c5	dd 74 12	. t .
	ld (ix+011h),l		;05c8	dd 75 11	. u .
	and 060h		;05cb	e6 60		. `
	cp 060h			;05cd	fe 60		. `
	jr nz,l05e3h		;05cf	20 12		  .
	ld a,(ix+01bh)		;05d1	dd 7e 1b	. ~ .
	bit 4,a			;05d4	cb 67		. g
	jr z,l05e3h		;05d6	28 0b		( .
	and 007h		;05d8	e6 07		. .
	ld b,a			;05da	47		G
	ld a,(ix+014h)		;05db	dd 7e 14	. ~ .
	and 0f8h		;05de	e6 f8		. .
	or b			;05e0	b0		.
	jr l05e6h		;05e1	18 03		. .
l05e3h:
	ld a,(ix+014h)		;05e3	dd 7e 14	. ~ .
l05e6h:
	ld (de),a		;05e6	12		.
	ld a,000h		;05e7	3e 00		> .
	ld (ix+005h),a		;05e9	dd 77 05	. w .
	jp l06e8h		;05ec	c3 e8 06	. . .
l05efh:
	ld a,040h		;05ef	3e 40		> @
	jr l05b5h		;05f1	18 c2		. .
l05f3h:
	ld bc,0x2b		;05f3	01 2b 00	. + .
	ldir			;05f6	ed b0		. .
	ld a,000h		;05f8	3e 00		> .
	jr l05b5h		;05fa	18 b9		. .
sub_05fch:
	ld a,(hl)		;05fc	7e		~
	or 060h			;05fd	f6 60		. `
	ld (hl),a		;05ff	77		w
	inc hl			;0600	23		#
	ld a,(hl)		;0601	7e		~
	or 060h			;0602	f6 60		. `
	ld (hl),a		;0604	77		w
	dec hl			;0605	2b		+
l0606h:
	ret			;0606	c9		.
sub_0607h:
	ld a,(hl)		;0607	7e		~
	or 040h			;0608	f6 40		. @
	ld (de),a		;060a	12		.
	inc hl			;060b	23		#
	inc de			;060c	13		.
	ld a,(hl)		;060d	7e		~
	or 040h			;060e	f6 40		. @
	ld (de),a		;0610	12		.
	inc de			;0611	13		.
	inc hl			;0612	23		#
	ld (ix+012h),h		;0613	dd 74 12	. t .
	ld (ix+011h),l		;0616	dd 75 11	. u .
	ld a,(ix+014h)		;0619	dd 7e 14	. ~ .
	ld (de),a		;061c	12		.
	ret			;061d	c9		.
sub_061eh:
	and 0f8h		;061e	e6 f8		. .
	ld b,a			;0620	47		G
	ld a,(ix+01bh)		;0621	dd 7e 1b	. ~ .
	bit 3,a			;0624	cb 5f		. _
	ret z			;0626	c8		.
	and 007h		;0627	e6 07		. .
	or b			;0629	b0		.
	ld (de),a		;062a	12		.
	ret			;062b	c9		.
l062ch:
	nop			;062c	00		.
l062dh:
	dec (ix+000h)		;062d	dd 35 00	. 5 .
	jp nz,l06e8h		;0630	c2 e8 06	. . .
	ld a,(ix+009h)		;0633	dd 7e 09	. ~ .
	ld (ix+000h),a		;0636	dd 77 00	. w .
	ld h,(ix+002h)		;0639	dd 66 02	. f .
	ld l,(ix+001h)		;063c	dd 6e 01	. n .
	ld d,(ix+004h)		;063f	dd 56 04	. V .
	ld e,(ix+003h)		;0642	dd 5e 03	. ^ .
	ld a,(ix+00ah)		;0645	dd 7e 0a	. ~ .
	call SETMEMMAP	;0648	cd 1a 0f	. . .
	ld bc,1		;064b	01 01 00	. . .
	ld a,(ix+01dh)		;064e	dd 7e 1d	. ~ .
	cp 002h			;0651	fe 02		. .
	jr nz,l065ch		;0653	20 07		  .
	ld c,(ix+007h)		;0655	dd 4e 07	. N .
	ld (ix+006h),001h	;0658	dd 36 06 01	. 6 . .
l065ch:
	ldir			;065c	ed b0		. .
	call sub_06dbh		;065e	cd db 06	. . .
	dec (ix+006h)		;0661	dd 35 06	. 5 .
	jp nz,l06e8h		;0664	c2 e8 06	. . .
	ld b,(ix+007h)		;0667	dd 46 07	. F .
	ld a,028h		;066a	3e 28		> (
	sub b			;066c	90		.
	ld c,a			;066d	4f		O
	ld b,000h		;066e	06 00		. .
	add hl,bc		;0670	09		.
	call sub_06dbh		;0671	cd db 06	. . .
	ld hl,24		;0674	21 18 00	! . .
	add hl,bc		;0677	09		.
l0678h:
	add hl,de		;0678	19		.
	dec (ix+008h)		;0679	dd 35 08	. 5 .
	jr z,l06d5h		;067c	28 57		( W
	bit 5,(hl)		;067e	cb 6e		. n
	jr nz,l0687h		;0680	20 05		  .
	ld de,00043h		;0682	11 43 00	. C .
	jr l0678h		;0685	18 f1		. .
l0687h:
	inc hl			;0687	23		#
	inc hl			;0688	23		#
	inc hl			;0689	23		#
	ld (ix+004h),h		;068a	dd 74 04	. t .
	ld (ix+003h),l		;068d	dd 75 03	. u .
	ld de,41		;0690	11 29 00	. ) .
	add hl,de		;0693	19		.
	ld a,(hl)		;0694	7e		~
	bit 3,a			;0695	cb 5f		. _
	jr nz,l069dh		;0697	20 04		  .
	ld a,028h		;0699	3e 28		> (
	jr l06a7h		;069b	18 0a		. .
l069dh:
	and 007h		;069d	e6 07		. .
	ld c,a			;069f	4f		O
	ld b,000h		;06a0	06 00		. .
	ld hl,TABLE1		;06a2	21 e1 22	! . "
	add hl,bc		;06a5	09		.
	ld a,(hl)		;06a6	7e		~
l06a7h:
	ld (ix+007h),a		;06a7	dd 77 07	. w .
	ld (ix+006h),a		;06aa	dd 77 06	. w .
	dec (ix+005h)		;06ad	dd 35 05	. 5 .
	jr nz,l06e8h		;06b0	20 36		  6
	ld h,(ix+002h)		;06b2	dd 66 02	. f .
	ld l,(ix+001h)		;06b5	dd 6e 01	. n .
	ld a,(ix+00ah)		;06b8	dd 7e 0a	. ~ .
	call sub_0f26h		;06bb	cd 26 0f	. & .
	ld (ix+00ah),a		;06be	dd 77 0a	. w .
	bit 1,(hl)		;06c1	cb 4e		. N
	jr z,l06d5h		;06c3	28 10		( .
	ld de,0x30		;06c5	11 30 00	. 0 .
	add hl,de		;06c8	19		.
	ld (ix+005h),008h	;06c9	dd 36 05 08	. 6 . .
	ld (ix+002h),h		;06cd	dd 74 02	. t .
	ld (ix+001h),l		;06d0	dd 75 01	. u .
	jr l06e8h		;06d3	18 13		. .
l06d5h:
	ld (ix+01dh),000h	;06d5	dd 36 1d 00	. 6 . .
	jr l06e8h		;06d9	18 0d		. .
sub_06dbh:
	ld (ix+002h),h		;06db	dd 74 02	. t .
	ld (ix+001h),l		;06de	dd 75 01	. u .
	ld (ix+004h),d		;06e1	dd 72 04	. r .
	ld (ix+003h),e		;06e4	dd 73 03	. s .
	ret			;06e7	c9		.
l06e8h:
	ld bc,30		;06e8	01 1e 00	. . .
	add ix,bc		;06eb	dd 09		. .
	ld hl,05687h		;06ed	21 87 56	! . V
	dec (hl)		;06f0	35		5
	jp nz,l03bfh		;06f1	c2 bf 03	. . .
	di			;06f4	f3		.
	ld a,000h		;06f5	3e 00		> .
	ld (05b6eh),a		;06f7	32 6e 5b	2 n [
l06fah:
	pop af			;06fa	f1		.
	call SETMEMMAP	;06fb	cd 1a 0f	. . .
	pop iy			;06fe	fd e1		. .
	pop ix			;0700	dd e1		. .
	pop hl			;0702	e1		.
	pop de			;0703	d1		.
	pop bc			;0704	c1		.
	pop af			;0705	f1		.
	call RETURN_FROM_INTER		;0706	cd 64 03	. d .
	ret			;0709	c9		.

; Out to port 0x62 (DMA)
OUT_DATA62:
	db 0x83, 0xc3, 0xc3, 0xc3, 0xc3, 0xc3, 0xc3, 0x7e
	db 0x23, 0x41, 0x00, 0x0a, 0x14, 0x90, 0xff, 0xc1
	db 0x92, 0xcf, 0x87
OUT_DATA62_END:
	db 0x00, 0x00

sub_071fh:
	ld e,000h		;071f	1e 00		. .
	ld c,000h		;0721	0e 00		. .
	ld b,009h		;0723	06 09		. .
l0725h:
	call CMP_HLDE		;0725	cd 20 0f	.   .
	ld a,001h		;0728	3e 01		> .
	scf			;072a	37		7
	jp p,l072fh		;072b	f2 2f 07	. / .
	xor a			;072e	af		.
l072fh:
	rl c			;072f	cb 11		. .
	jr nc,l073ah		;0731	30 07		0 .
	ld a,000h		;0733	3e 00		> .
	ld hl,0	;0735	21 00 00	! . .
	jr l0747h		;0738	18 0d		. .
l073ah:
	or a			;073a	b7		.
	jr z,l0740h		;073b	28 03		( .
	xor a			;073d	af		.
	sbc hl,de		;073e	ed 52		. R
l0740h:
	srl d			;0740	cb 3a		. :
	rr e			;0742	cb 1b		. .
	djnz l0725h		;0744	10 df		. .
	ld a,c			;0746	79		y
l0747h:
	ret			;0747	c9		.
sub_0748h:
	push bc			;0748	c5		.
	push de			;0749	d5		.
	push af			;074a	f5		.
	ld a,001h		;074b	3e 01		> .
	ld (0602ah),a		;074d	32 2a 60	2 * `
	ld de,(05b77h)		;0750	ed 5b 77 5b	. [ w [
	inc de			;0754	13		.
	call CMP_HLDE		;0755	cd 20 0f	.   .
	pop bc			;0758	c1		.
	jp c,l0807h		;0759	da 07 08	. . .
	ld a,(05b84h)		;075c	3a 84 5b	: . [
	and 080h		;075f	e6 80		. .
	jp z,l0836h		;0761	ca 36 08	. 6 .
	push bc			;0764	c5		.
	push hl			;0765	e5		.
	ex de,hl		;0766	eb		.
	call sub_09e4h		;0767	cd e4 09	. . .
	ex de,hl		;076a	eb		.
	dec hl			;076b	2b		+
	xor a			;076c	af		.
	sbc hl,de		;076d	ed 52		. R
	jp c,l0834h		;076f	da 34 08	. 4 .
	inc hl			;0772	23		#
	pop de			;0773	d1		.
	ld (05fe5h),hl		;0774	22 e5 5f	" . _
	ld b,010h		;0777	06 10		. .
	ld c,000h		;0779	0e 00		. .
	ld hl,05fe9h		;077b	21 e9 5f	! . _
l077eh:
	ld a,(hl)		;077e	7e		~
	cp e			;077f	bb		.
	inc hl			;0780	23		#
	jr nz,l078fh		;0781	20 0c		  .
	ld a,(hl)		;0783	7e		~
	cp d			;0784	ba		.
	inc hl			;0785	23		#
	jr nz,l0790h		;0786	20 08		  .
	pop af			;0788	f1		.
	cp (hl)			;0789	be		.
	jr z,l07ceh		;078a	28 42		( B
	push af			;078c	f5		.
	jr l0790h		;078d	18 01		. .
l078fh:
	inc hl			;078f	23		#
l0790h:
	call sub_07eeh		;0790	cd ee 07	. . .
	djnz l077eh		;0793	10 e9		. .
	ld b,010h		;0795	06 10		. .
	ld c,000h		;0797	0e 00		. .
	ld hl,05fe9h		;0799	21 e9 5f	! . _
l079ch:
	ld a,(hl)		;079c	7e		~
	inc hl			;079d	23		#
	or (hl)			;079e	b6		.
	jr z,l07a9h		;079f	28 08		( .
	inc hl			;07a1	23		#
	call sub_07eeh		;07a2	cd ee 07	. . .
	djnz l079ch		;07a5	10 f5		. .
	jr l07e5h		;07a7	18 3c		. <
l07a9h:
	ld a,(05fe1h)		;07a9	3a e1 5f	: . _
	or a			;07ac	b7		.
	jr nz,l07e5h		;07ad	20 36		  6
	dec hl			;07af	2b		+
	ld (hl),e		;07b0	73		s
	inc hl			;07b1	23		#
	ld (hl),d		;07b2	72		r
	pop af			;07b3	f1		.
	inc hl			;07b4	23		#
	ld (hl),a		;07b5	77		w
	ld (05fe1h),a		;07b6	32 e1 5f	2 . _
	inc hl			;07b9	23		#
	ld (0602ch),hl		;07ba	22 2c 60	" , `
	ld hl,(05b85h)		;07bd	2a 85 5b	* . [
	ld b,000h		;07c0	06 00		. .
	add hl,bc		;07c2	09		.
	ld (05fe2h),hl		;07c3	22 e2 5f	" . _
	ld hl,(05fe5h)		;07c6	2a e5 5f	* . _
	ld (05fe7h),hl		;07c9	22 e7 5f	" . _
	jr l07e6h		;07cc	18 18		. .
l07ceh:
	ld a,(05fe1h)		;07ce	3a e1 5f	: . _
	cp (hl)			;07d1	be		.
	jr z,l07e6h		;07d2	28 12		( .
	inc hl			;07d4	23		#
	ld a,(hl)		;07d5	7e		~
	ld (0602ah),a		;07d6	32 2a 60	2 * `
	xor a			;07d9	af		.
	ld (0602bh),a		;07da	32 2b 60	2 + `
	ld hl,(05b85h)		;07dd	2a 85 5b	* . [
	ld b,000h		;07e0	06 00		. .
	add hl,bc		;07e2	09		.
	jr l0807h		;07e3	18 22		. "
l07e5h:
	pop hl			;07e5	e1		.
l07e6h:
	ld a,0feh		;07e6	3e fe		> .
	ld hl,0	;07e8	21 00 00	! . .
	pop de			;07eb	d1		.
	pop bc			;07ec	c1		.
	ret			;07ed	c9		.
sub_07eeh:
	inc hl			;07ee	23		#
	inc hl			;07ef	23		#
	ld a,c			;07f0	79		y
	add a,004h		;07f1	c6 04		. .
	ld c,a			;07f3	4f		O
	ret			;07f4	c9		.
sub_07f5h:
	push bc			;07f5	c5		.
	push de			;07f6	d5		.
	jr l0807h		;07f7	18 0e		. .
sub_07f9h:
	push bc			;07f9	c5		.
	push de			;07fa	d5		.
	ld de,(05b77h)		;07fb	ed 5b 77 5b	. [ w [
	dec de			;07ff	1b		.
	ex de,hl		;0800	eb		.
	call CMP_HLDE		;0801	cd 20 0f	.   .
	ex de,hl		;0804	eb		.
	jr c,l0836h		;0805	38 2f		8 /
l0807h:
	ld de,21		;0807	11 15 00	. . .
	xor a			;080a	af		.
	sbc hl,de		;080b	ed 52		. R
	jp p,l0818h		;080d	f2 18 08	. . .
	add hl,de		;0810	19		.
	ld de,060deh		;0811	11 de 60	. . `
	push af			;0814	f5		.
	push hl			;0815	e5		.
	jr l0840h		;0816	18 28		. (
l0818h:
	ld d,02ch		;0818	16 2c		. ,
	call sub_071fh		;081a	cd 1f 07	. . .
	add a,004h		;081d	c6 04		. .
	ld c,a			;081f	4f		O
	ld a,(05b87h)		;0820	3a 87 5b	: . [
	inc a			;0823	3c		<
	ld b,a			;0824	47		G
	ld a,c			;0825	79		y
	cp b			;0826	b8		.
	jr c,l0830h		;0827	38 07		8 .
	ld c,b			;0829	48		H
	sub c			;082a	91		.
	inc a			;082b	3c		<
	cp 004h			;082c	fe 04		. .
	jr nc,l0836h		;082e	30 06		0 .
l0830h:
	push af			;0830	f5		.
	push hl			;0831	e5		.
	jr l083dh		;0832	18 09		. .
l0834h:
	pop hl			;0834	e1		.
	pop af			;0835	f1		.
l0836h:
	ld hl,0	;0836	21 00 00	! . .
	ld a,0ffh		;0839	3e ff		> .
	jr l0846h		;083b	18 09		. .
l083dh:
	ld de,0c000h		;083d	11 00 c0	. . .
l0840h:
	pop hl			;0840	e1		.
	call MUL368
	pop af			;0844	f1		.
	add hl,de		;0845	19		.
l0846h:
	pop de			;0846	d1		.
	pop bc			;0847	c1		.
	ret			;0848	c9		.
sub_0849h:
	ld bc,1		;0849	01 01 00	. . .
	ld hl,1		;084c	21 01 00	! . .
	call sub_07f9h		;084f	cd f9 07	. . .
l0852h:
	ld de,l0170h		;0852	11 70 01	. p .
	add hl,de		;0855	19		.
	push hl			;0856	e5		.
	inc bc			;0857	03		.
	ld h,b			;0858	60		`
	ld l,c			;0859	69		i
	call SETMEMMAP	;085a	cd 1a 0f	. . .
	call sub_07f9h		;085d	cd f9 07	. . .
	cp 0ffh			;0860	fe ff		. .
	pop de			;0862	d1		.
	jr z,l086ah		;0863	28 05		( .
	call CMP_HLDE		;0865	cd 20 0f	.   .
	jr z,l0852h		;0868	28 e8		( .
l086ah:
	ex de,hl		;086a	eb		.
	ld (hl),0ffh		;086b	36 ff		6 .
	inc hl			;086d	23		#
	ld (hl),0aah		;086e	36 aa		6 .
	inc hl			;0870	23		#
	ld (hl),a		;0871	77		w
	inc hl			;0872	23		#
	ld (hl),e		;0873	73		s
	inc hl			;0874	23		#
	ld (hl),d		;0875	72		r
	ex de,hl		;0876	eb		.
	cp 0ffh			;0877	fe ff		. .
	jr nz,l0852h		;0879	20 d7		  .
	ret			;087b	c9		.
sub_087ch:
	push bc			;087c	c5		.
	push de			;087d	d5		.
	push hl			;087e	e5		.
	ld b,010h		;087f	06 10		. .
	ex de,hl		;0881	eb		.
	ld hl,05fe9h		;0882	21 e9 5f	! . _
l0885h:
	and a			;0885	a7		.
	push af			;0886	f5		.
	jr z,l089ah		;0887	28 11		( .
	ld a,(hl)		;0889	7e		~
	cp e			;088a	bb		.
	inc hl			;088b	23		#
	jr nz,l08a4h		;088c	20 16		  .
	ld a,(hl)		;088e	7e		~
	cp d			;088f	ba		.
	jr nz,l08a4h		;0890	20 12		  .
	inc hl			;0892	23		#
	pop af			;0893	f1		.
	push af			;0894	f5		.
	cp (hl)			;0895	be		.
	jr nz,l08a5h		;0896	20 0d		  .
	dec hl			;0898	2b		+
	dec hl			;0899	2b		+
l089ah:
	xor a
	ld (hl),a
	inc hl
	ld (hl),a
	inc hl
	ld (hl),a
	inc hl
	ld (hl),a
	jr l08a6h		;08a2	18 02		. .
l08a4h:
	inc hl			;08a4	23		#
l08a5h:
	inc hl			;08a5	23		#
l08a6h:
	inc hl			;08a6	23		#
	pop af			;08a7	f1		.
	djnz l0885h		;08a8	10 db		. .
	pop hl			;08aa	e1		.
	pop de			;08ab	d1		.
	pop bc			;08ac	c1		.
	ret			;08ad	c9		.

TASK_7:
	ld sp,05249h
	ld b,7
_loop:
	call sub_0334h
	djnz _loop
	ld hl,TASK_7
	push hl
	ld a,(05fe1h)		;08bc	3a e1 5f	: . _
	or a			;08bf	b7		.
	ret z			;08c0	c8		.
	ld a,(05fe0h)		;08c1	3a e0 5f	: . _
	and a			;08c4	a7		.
	jr nz,l08dfh		;08c5	20 18		  .
	ld a,042h		;08c7	3e 42		> B
	ld (05cc1h),a		;08c9	32 c1 5c	2 . \
	call sub_094dh		;08cc	cd 4d 09	. M .
	ld a,003h		;08cf	3e 03		> .
	ld (05cbbh),a		;08d1	32 bb 5c	2 . \
	call 08910h		;08d4	cd 10 89	. . .
	and a			;08d7	a7		.
	ret nz			;08d8	c0		.
	ld a,001h		;08d9	3e 01		> .
	ld (05fe0h),a		;08db	32 e0 5f	2 . _
	ret			;08de	c9		.
l08dfh:
	ld a,(0602bh)		;08df	3a 2b 60	: + `
	and a			;08e2	a7		.
	jr nz,l08edh		;08e3	20 08		  .
	ld hl,(0602ch)		;08e5	2a 2c 60	* , `
	ld (hl),a		;08e8	77		w
	inc a			;08e9	3c		<
	ld (0602bh),a		;08ea	32 2b 60	2 + `
l08edh:
	ld a,007h		;08ed	3e 07		> .
	ld (05cbah),a		;08ef	32 ba 5c	2 . \
	ld hl,(05fe7h)		;08f2	2a e7 5f	* . _
	call sub_094dh		;08f5	cd 4d 09	. M .
	ld a,(05ea7h)		;08f8	3a a7 5e	: . ^
	ld (06029h),a		;08fb	32 29 60	2 ) `
	call 0887dh		;08fe	cd 7d 88	. } .
	cp 0feh			;0901	fe fe		. .
	ret z			;0903	c8		.
	push af			;0904	f5		.
	ld hl,(05fe2h)		;0905	2a e2 5f	* . _
	call sub_07f5h		;0908	cd f5 07	. . .
	call SETMEMMAP	;090b	cd 1a 0f	. . .
	ex de,hl		;090e	eb		.
	ld hl,05cc6h		;090f	21 c6 5c	! . \
	ld bc,l0170h		;0912	01 70 01	. p .
	ldir			;0915	ed b0		. .
	push hl			;0917	e5		.
	ld hl,(0602ch)		;0918	2a 2c 60	* , `
	inc (hl)		;091b	34		4
	ld a,(hl)		;091c	7e		~
	cp 4			;091d	fe 04		. .
	pop hl			;091f	e1		.
	jr nc,l0941h		;0920	30 1f		0 .
	ld hl,(05fe2h)		;0922	2a e2 5f	* . _
	inc hl			;0925	23		#
	ld (05fe2h),hl		;0926	22 e2 5f	" . _
	call sub_07f5h		;0929	cd f5 07	. . .
	call SETMEMMAP	;092c	cd 1a 0f	. . .
	ld (hl),000h		;092f	36 00		6 .
	ld a,(05e36h)		;0931	3a 36 5e	: 6 ^
	bit 1,a			;0934	cb 4f		. O
	jr z,l0941h		;0936	28 09		( .
	ld hl,(05fe7h)		;0938	2a e7 5f	* . _
	inc hl			;093b	23		#
	ld (05fe7h),hl		;093c	22 e7 5f	" . _
	pop af			;093f	f1		.
	ret			;0940	c9		.
l0941h:
	xor a			;0941	af		.
	ld (0602bh),a		;0942	32 2b 60	2 + `
	ld (05fe1h),a		;0945	32 e1 5f	2 . _
	ld (05cbah),a		;0948	32 ba 5c	2 . \
	pop af			;094b	f1		.
	ret			;094c	c9		.

sub_094dh:
	ld a,044h		;094d	3e 44		> D
	ld (05cbfh),a		;094f	32 bf 5c	2 . \
	ld a,031h		;0952	3e 31		> 1
	ld (05cc0h),a		;0954	32 c0 5c	2 . \
	ret			;0957	c9		.

; Multiplies HL by 368
MUL368:
	push de
	ld d,h
	ld e,l
	add hl,hl	; *2
	add hl,hl	; *4
	add hl,de	; *5
	add hl,hl	; *10
	add hl,de	; *11
	add hl,hl	; *22
	add hl,de	; *23
	add hl,hl	; *46
	add hl,hl	; *92
	add hl,hl	; *184
	add hl,hl	; *368
	pop de
	ret

sub_0968h:
	push bc			;0968	c5		.
	push de			;0969	d5		.
	ld a,(CUR_MAP)		;096a	3a 22 41	: " A
	push af			;096d	f5		.
	ld a,002h		;096e	3e 02		> .
l0970h:
	push af			;0970	f5		.
	call SETMEMMAP	;0971	cd 1a 0f	. . .
	ld a,05ah		;0974	3e 5a		> Z
	ld hl,0fffbh		;0976	21 fb ff	! . .
	ld (hl),a		;0979	77		w
	; FReD Strange
	ld a,(0)	;097a	3a 00 00	: . .
	ld a,(hl)		;097d	7e		~
	cp 05ah			;097e	fe 5a		. Z
	jr nz,l0995h		;0980	20 13		  .
	ld a,0a5h		;0982	3e a5		> .
	ld (hl),a		;0984	77		w
	ld a,(0)	;0985	3a 00 00	: . .
	ld a,(hl)		;0988	7e		~
	cp 0a5h			;0989	fe a5		. .
	jr nz,l0995h		;098b	20 08		  .
	pop af			;098d	f1		.
	inc a			;098e	3c		<
	jr nz,l0970h		;098f	20 df		  .
	ld a,0ffh		;0991	3e ff		> .
	jr l0997h		;0993	18 02		. .
l0995h:
	pop af			;0995	f1		.
	dec a			;0996	3d		=
l0997h:
	ld l,a			;0997	6f		o
	pop af			;0998	f1		.
	call SETMEMMAP	;0999	cd 1a 0f	. . .
	ld a,l			;099c	7d		}
	ld (05b87h),a		;099d	32 87 5b	2 . [
	ld c,000h		;09a0	0e 00		. .
	ld de,0x2c		;09a2	11 2c 00	. , .
	M_CALL_WITH_MMAP0 sub_c0e5h
	ld de,20		;09aa	11 14 00	. . .
	add hl,de		;09ad	19		.
	pop de			;09ae	d1		.
	pop bc			;09af	c1		.
	ret			;09b0	c9		.

; Call the inlined address with cleared memory map, then restores the map and returns 
; Non-reentrant
CALL_WITH_MMAP0_INLINE:
		; Save registers and MAP
	ld (CALLMAPSAVE_A),a
	ld (CALLMAPSAVE_DE),de
	ld (CALLMAPSAVE_HL),hl
	ld a,(CUR_MAP)
	ld (CALLMAPSAVE_MAP),a

		;	Retrieve address to jump to
	pop hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl

		;	New return address
	push hl

		;	Will return at RESTORE_MAP
	ld hl,RESTORE_MAP
	push hl

		;	Address to call
	push de
	xor a
	call SETMEMMAP

		;	Restore registers
	ld a,(CALLMAPSAVE_A)
	ld de,(CALLMAPSAVE_DE)
	ld hl,(CALLMAPSAVE_HL)

		;	Call inlined address
	ret

; Restore the memory map after a CALL_WITH_MMAP0
RESTORE_MAP:
		;	Restore the memory map
	push af
	ld a,(CALLMAPSAVE_MAP)
	call SETMEMMAP
	pop af

		;	Go back to original caller
	ret


sub_09e4h:
	push af			;09e4	f5		.
	push bc			;09e5	c5		.
	push de			;09e6	d5		.
	ld bc,003e8h		;09e7	01 e8 03	. . .
	ld hl,0	;09ea	21 00 00	! . .
	ld de,(05b77h)		;09ed	ed 5b 77 5b	. [ w [
l09f1h:
	add hl,bc		;09f1	09		.
	call CMP_HLDE		;09f2	cd 20 0f	.   .
	jr c,l09f1h		;09f5	38 fa		8 .
	pop de			;09f7	d1		.
	pop bc			;09f8	c1		.
	pop af			;09f9	f1		.
	ret			;09fa	c9		.
sub_09fbh:
	ld l,a			;09fb	6f		o
	ld a,(CUR_MAP)		;09fc	3a 22 41	: " A
	push af			;09ff	f5		.
	ld a,l			;0a00	7d		}
	call sub_0a09h		;0a01	cd 09 0a	. . .
	pop af			;0a04	f1		.
	ld (CUR_MAP),a		;0a05	32 22 41	2 " A
	ret			;0a08	c9		.
sub_0a09h:
	ld (04105h),de		;0a09	ed 53 05 41	. S . A
	ld (04107h),bc		;0a0d	ed 43 07 41	. C . A
	ld (04102h),a		;0a11	32 02 41	2 . A
	ld a,000h		;0a14	3e 00		> .
	ld (0410fh),a		;0a16	32 0f 41	2 . A
	ld hl,04108h		;0a19	21 08 41	! . A
	add hl,bc		;0a1c	09		.
	ld a,(hl)		;0a1d	7e		~
	or a			;0a1e	b7		.
	ret z			;0a1f	c8		.
	ld (040fdh),a		;0a20	32 fd 40	2 . @
	ld a,(04102h)		;0a23	3a 02 41	: . A
	or a			;0a26	b7		.
	jr nz,l0a37h		;0a27	20 0e		  .
	ld hl,04a4eh		;0a29	21 4e 4a	! N J
	ld (040feh),hl		;0a2c	22 fe 40	" . @
	ld hl,04ac6h		;0a2f	21 c6 4a	! . J
	ld (04100h),hl		;0a32	22 00 41	" . A
	jr l0a54h		;0a35	18 1d		. .
l0a37h:
	ld hl,16		;0a37	21 10 00	! . .
	add hl,de		;0a3a	19		.
	ld (040feh),hl		;0a3b	22 fe 40	" . @
	ld a,(04102h)		;0a3e	3a 02 41	: . A
	cp 001h			;0a41	fe 01		. .
	jr nz,l0a4eh		;0a43	20 09		  .
	ld de,32		;0a45	11 20 00	.   .
	add hl,de		;0a48	19		.
	ld (04100h),hl		;0a49	22 00 41	" . A
	jr l0a54h		;0a4c	18 06		. .
l0a4eh:
	ld hl,0575bh		;0a4e	21 5b 57	! [ W
	ld (04100h),hl		;0a51	22 00 41	" . A
l0a54h:
	ld hl,04114h		;0a54	21 14 41	! . A
	call sub_0db5h		;0a57	cd b5 0d	. . .
	push de			;0a5a	d5		.
	pop ix			;0a5b	dd e1		. .
	ld iy,(04100h)		;0a5d	fd 2a 00 41	. * . A
	ld hl,(040feh)		;0a61	2a fe 40	* . @
	ld (04103h),hl		;0a64	22 03 41	" . A
l0a67h:
	ld a,(040fdh)		;0a67	3a fd 40	: . @
	ld d,a			;0a6a	57		W
	or a			;0a6b	b7		.
	jp z,l0e72h		;0a6c	ca 72 0e	. r .
	ld hl,(04103h)		;0a6f	2a 03 41	* . A
	inc hl			;0a72	23		#
	ld a,(hl)		;0a73	7e		~
	and 007h		;0a74	e6 07		. .
	inc a			;0a76	3c		<
	ld b,a			;0a77	47		G
	ld e,0ffh		;0a78	1e ff		. .
l0a7ah:
	inc e			;0a7a	1c		.
	dec d			;0a7b	15		.
	jr z,l0a80h		;0a7c	28 02		( .
	djnz l0a7ah		;0a7e	10 fa		. .
l0a80h:
	ld a,d			;0a80	7a		z
	ld (040fdh),a		;0a81	32 fd 40	2 . @
	dec hl			;0a84	2b		+
	ld c,(hl)		;0a85	4e		N
	inc hl			;0a86	23		#
	ld a,(hl)		;0a87	7e		~
	and 0f8h		;0a88	e6 f8		. .
	rrca			;0a8a	0f		.
	rrca			;0a8b	0f		.
	rrca			;0a8c	0f		.
	ld (05bb2h),a		;0a8d	32 b2 5b	2 . [
	inc hl			;0a90	23		#
	ld a,(hl)		;0a91	7e		~
	inc hl			;0a92	23		#
	ld b,a			;0a93	47		G
	ld a,(hl)		;0a94	7e		~
	ld (05fd4h),a		;0a95	32 d4 5f	2 . _
	ld a,b			;0a98	78		x
	inc hl			;0a99	23		#
	ld (04103h),hl		;0a9a	22 03 41	" . A
	ld b,e			;0a9d	43		C
	ld d,000h		;0a9e	16 00		. .
	ld hl,l0b65h		;0aa0	21 65 0b	! e .
	add hl,de		;0aa3	19		.
	add hl,de		;0aa4	19		.
	ld e,(hl)		;0aa5	5e		^
	inc hl			;0aa6	23		#
	ld d,(hl)		;0aa7	56		V
	inc b			;0aa8	04		.
	ex de,hl		;0aa9	eb		.
	ld e,a			;0aaa	5f		_
	ld d,008h		;0aab	16 08		. .
	ld a,000h		;0aad	3e 00		> .
l0aafh:
	add a,d			;0aaf	82		.
	djnz l0aafh		;0ab0	10 fd		. .
	ld b,a			;0ab2	47		G
	ld a,(hl)		;0ab3	7e		~
	or 060h			;0ab4	f6 60		. `
	ld (ix+000h),a		;0ab6	dd 77 00	. w .
	inc hl			;0ab9	23		#
	ld a,(hl)		;0aba	7e		~
	or 060h			;0abb	f6 60		. `
	ld (ix+001h),a		;0abd	dd 77 01	. w .
	ld a,(05bb2h)		;0ac0	3a b2 5b	: . [
	bit 4,a			;0ac3	cb 67		. g
	jr z,l0acch		;0ac5	28 05		( .
	call sub_0b51h		;0ac7	cd 51 0b	. Q .
	jr l0acfh		;0aca	18 03		. .
l0acch:
	call sub_0b46h		;0acc	cd 46 0b	. F .
l0acfh:
	push bc			;0acf	c5		.
	ld b,028h		;0ad0	06 28		. (
l0ad2h:
	ld a,(iy+000h)		;0ad2	fd 7e 00	. ~ .
	ld (ix+000h),a		;0ad5	dd 77 00	. w .
	inc ix			;0ad8	dd 23		. #
	inc iy			;0ada	fd 23		. #
	djnz l0ad2h		;0adc	10 f4		. .
	ld (ix+000h),038h	;0ade	dd 36 00 38	. 6 . 8
	ld (ix+001h),e		;0ae2	dd 73 01	. s .
	ld a,(05fd4h)		;0ae5	3a d4 5f	: . _
	or 03fh			;0ae8	f6 3f		. ?
	ld (ix+002h),a		;0aea	dd 77 02	. w .
	inc ix			;0aed	dd 23		. #
	inc ix			;0aef	dd 23		. #
	inc ix			;0af1	dd 23		. #
	pop bc			;0af3	c1		.
	dec b			;0af4	05		.
l0af5h:
	ld a,b			;0af5	78		x
	and 007h		;0af6	e6 07		. .
	jr nz,l0b11h		;0af8	20 17		  .
	ld a,(hl)		;0afa	7e		~
	or 040h			;0afb	f6 40		. @
	ld (ix+000h),a		;0afd	dd 77 00	. w .
	inc hl			;0b00	23		#
	ld a,(hl)		;0b01	7e		~
	or 040h			;0b02	f6 40		. @
	ld (ix+001h),a		;0b04	dd 77 01	. w .
	call sub_0b46h		;0b07	cd 46 0b	. F .
	ld de,0x2b		;0b0a	11 2b 00	. + .
	add ix,de		;0b0d	dd 19		. .
	djnz l0af5h		;0b0f	10 e4		. .
l0b11h:
	ld a,b			;0b11	78		x
	cp 001h			;0b12	fe 01		. .
	jr nz,l0b28h		;0b14	20 12		  .
	ld a,(040fdh)		;0b16	3a fd 40	: . @
	or a			;0b19	b7		.
	jr nz,l0b28h		;0b1a	20 0c		  .
	ld a,(hl)		;0b1c	7e		~
	or 040h			;0b1d	f6 40		. @
	ld (ix+000h),a		;0b1f	dd 77 00	. w .
	inc hl			;0b22	23		#
	ld a,(hl)		;0b23	7e		~
	or 040h			;0b24	f6 40		. @
	jr l0b2eh		;0b26	18 06		. .
l0b28h:
	ld a,(hl)		;0b28	7e		~
	ld (ix+000h),a		;0b29	dd 77 00	. w .
	inc hl			;0b2c	23		#
	ld a,(hl)		;0b2d	7e		~
l0b2eh:
	ld (ix+001h),a		;0b2e	dd 77 01	. w .
	call sub_0b46h		;0b31	cd 46 0b	. F .
	djnz l0af5h		;0b34	10 bf		. .
	ld a,(05bb2h)		;0b36	3a b2 5b	: . [
	bit 3,a			;0b39	cb 5f		. _
	jp z,l0dbbh		;0b3b	ca bb 0d	. . .
l0b3eh:
	dec ix			;0b3e	dd 2b		. +
	call sub_0b55h		;0b40	cd 55 0b	. U .
	jp l0dbbh		;0b43	c3 bb 0d	. . .
sub_0b46h:
	inc hl			;0b46	23		#
	ld (ix+002h),c		;0b47	dd 71 02	. q .
	inc ix			;0b4a	dd 23		. #
	inc ix			;0b4c	dd 23		. #
	inc ix			;0b4e	dd 23		. #
	ret			;0b50	c9		.
sub_0b51h:
	inc ix			;0b51	dd 23		. #
	inc ix			;0b53	dd 23		. #
sub_0b55h:
	and 007h		;0b55	e6 07		. .
	push bc			;0b57	c5		.
	ld b,a			;0b58	47		G
	ld a,c			;0b59	79		y
	and 0f8h		;0b5a	e6 f8		. .
	or b			;0b5c	b0		.
	pop bc			;0b5d	c1		.
	inc hl			;0b5e	23		#
	ld (ix+000h),a		;0b5f	dd 77 00	. w .
	inc ix			;0b62	dd 23		. #
	ret			;0b64	c9		.

; start of data
l0b65h:
	db 0x75, 0x0b, 0x85                                 ; 0b60 
	db 0x0b, 0xa5, 0x0b, 0xd5, 0x0b, 0x15, 0x0c, 0x65   ; 0b68
	db 0x0c, 0xc5, 0x0c, 0x35, 0x0d, 0x00, 0x02, 0x04   ; 0b70
	db 0x06, 0x08, 0x0a, 0x0c, 0x0e, 0x10, 0x12, 0x14   ; 0b78
	db 0x16, 0x18, 0x1a, 0x1c, 0x1e, 0x00, 0x01, 0x02   ; 0b80
	db 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a   ; 0b88
	db 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x10, 0x11, 0x12   ; 0b90
	db 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a   ; 0b98
	db 0x1b, 0x1c, 0x1d, 0x1e, 0x1f, 0x00, 0x80, 0x01   ; 0ba0
	db 0x02, 0x82, 0x03, 0x04, 0x84, 0x05, 0x06, 0x86   ; 0ba8
	db 0x07, 0x08, 0x88, 0x09, 0x0a, 0x8a, 0x0b, 0x0c   ; 0bb0
	db 0x8c, 0x0d, 0x0e, 0x8e, 0x0f, 0x10, 0x90, 0x11   ; 0bb8
	db 0x12, 0x92, 0x13, 0x14, 0x94, 0x15, 0x16, 0x96   ; 0bc0
	db 0x17, 0x18, 0x98, 0x19, 0x1a, 0x9a, 0x1b, 0x1c   ; 0bc8
	db 0x9c, 0x1d, 0x1e, 0x9e, 0x1f, 0x00, 0x80, 0x01   ; 0bd0
	db 0x81, 0x02, 0x82, 0x03, 0x83, 0x04, 0x84, 0x05   ; 0bd8
	db 0x85, 0x06, 0x86, 0x07, 0x87, 0x08, 0x88, 0x09   ; 0be0
	db 0x89, 0x0a, 0x8a, 0x0b, 0x8b, 0x0c, 0x8c, 0x0d   ; 0be8
	db 0x8d, 0x0e, 0x8e, 0x0f, 0x8f, 0x10, 0x90, 0x11   ; 0bf0
	db 0x91, 0x12, 0x92, 0x13, 0x93, 0x14, 0x94, 0x15   ; 0bf8
	db 0x95, 0x16, 0x96, 0x17, 0x97, 0x18, 0x98, 0x19   ; 0c00
	db 0x99, 0x1a, 0x9a, 0x1b, 0x9b, 0x1c, 0x9c, 0x1d   ; 0c08
	db 0x9d, 0x1e, 0x9e, 0x1f, 0x9f, 0x00, 0x00, 0x80   ; 0c10
	db 0x01, 0x81, 0x02, 0x02, 0x82, 0x03, 0x83, 0x04   ; 0c18
	db 0x04, 0x84, 0x05, 0x85, 0x06, 0x06, 0x86, 0x07   ; 0c20
	db 0x87, 0x08, 0x08, 0x88, 0x09, 0x89, 0x0a, 0x0a   ; 0c28
	db 0x8a, 0x0b, 0x8b, 0x0c, 0x0c, 0x8c, 0x0d, 0x8d   ; 0c30
	db 0x0e, 0x0e, 0x8e, 0x0f, 0x8f, 0x10, 0x10, 0x90   ; 0c38
	db 0x11, 0x91, 0x12, 0x12, 0x92, 0x13, 0x93, 0x14   ; 0c40
	db 0x14, 0x94, 0x15, 0x95, 0x16, 0x16, 0x96, 0x17   ; 0c48
	db 0x97, 0x18, 0x18, 0x98, 0x19, 0x99, 0x1a, 0x1a   ; 0c50
	db 0x9a, 0x1b, 0x9b, 0x1c, 0x1c, 0x9c, 0x1d, 0x9d   ; 0c58
	db 0x1e, 0x1e, 0x9e, 0x1f, 0x9f, 0x00, 0x00, 0x80   ; 0c60
	db 0x01, 0x01, 0x81, 0x02, 0x02, 0x82, 0x03, 0x03   ; 0c68
	db 0x83, 0x04, 0x04, 0x84, 0x05, 0x05, 0x85, 0x06   ; 0c70
	db 0x06, 0x86, 0x07, 0x07, 0x87, 0x08, 0x08, 0x88   ; 0c78
	db 0x09, 0x09, 0x89, 0x0a, 0x0a, 0x8a, 0x0b, 0x0b   ; 0c80
	db 0x8b, 0x0c, 0x0c, 0x8c, 0x0d, 0x0d, 0x8d, 0x0e   ; 0c88
	db 0x0e, 0x8e, 0x0f, 0x0f, 0x8f, 0x10, 0x10, 0x90   ; 0c90
	db 0x11, 0x11, 0x91, 0x12, 0x12, 0x92, 0x13, 0x13   ; 0c98
	db 0x93, 0x14, 0x14, 0x94, 0x15, 0x15, 0x95, 0x16   ; 0ca0
	db 0x16, 0x96, 0x17, 0x17, 0x97, 0x18, 0x18, 0x98   ; 0ca8
	db 0x19, 0x19, 0x99, 0x1a, 0x1a, 0x9a, 0x1b, 0x1b   ; 0cb0
	db 0x9b, 0x1c, 0x1c, 0x9c, 0x1d, 0x1d, 0x9d, 0x1e   ; 0cb8
	db 0x1e, 0x9e, 0x1f, 0x1f, 0x9f, 0x00, 0x00, 0x80   ; 0cc0
	db 0x80, 0x01, 0x01, 0x81, 0x02, 0x02, 0x82, 0x82   ; 0cc8
	db 0x03, 0x03, 0x83, 0x04, 0x04, 0x84, 0x84, 0x05   ; 0cd0
	db 0x05, 0x85, 0x06, 0x06, 0x86, 0x86, 0x07, 0x07   ; 0cd8
	db 0x87, 0x08, 0x08, 0x88, 0x88, 0x09, 0x09, 0x89   ; 0ce0
	db 0x0a, 0x0a, 0x8a, 0x8a, 0x0b, 0x0b, 0x8b, 0x0c   ; 0ce8
	db 0x0c, 0x8c, 0x8c, 0x0d, 0x0d, 0x8d, 0x0e, 0x0e   ; 0cf0
	db 0x8e, 0x8e, 0x0f, 0x0f, 0x8f, 0x10, 0x10, 0x90   ; 0cf8
	db 0x90, 0x11, 0x11, 0x91, 0x12, 0x12, 0x92, 0x92   ; 0d00
	db 0x13, 0x13, 0x93, 0x14, 0x14, 0x94, 0x94, 0x15   ; 0d08
	db 0x15, 0x95, 0x16, 0x16, 0x96, 0x96, 0x17, 0x17   ; 0d10
	db 0x97, 0x18, 0x18, 0x98, 0x98, 0x19, 0x19, 0x99   ; 0d18
	db 0x1a, 0x1a, 0x9a, 0x9a, 0x1b, 0x1b, 0x9b, 0x1c   ; 0d20
	db 0x1c, 0x9c, 0x9c, 0x1d, 0x1d, 0x9d, 0x1e, 0x1e   ; 0d28
	db 0x9e, 0x9e, 0x1f, 0x1f, 0x9f, 0x00, 0x00, 0x80   ; 0d30
	db 0x80, 0x01, 0x01, 0x81, 0x81, 0x02, 0x02, 0x82   ; 0d38
	db 0x82, 0x03, 0x03, 0x83, 0x83, 0x04, 0x04, 0x84   ; 0d40
	db 0x84, 0x05, 0x05, 0x85, 0x85, 0x06, 0x06, 0x86   ; 0d48
	db 0x86, 0x07, 0x07, 0x87, 0x87, 0x08, 0x08, 0x88   ; 0d50
	db 0x88, 0x09, 0x09, 0x89, 0x89, 0x0a, 0x0a, 0x8a   ; 0d58
	db 0x8a, 0x0b, 0x0b, 0x8b, 0x8b, 0x0c, 0x0c, 0x8c   ; 0d60
	db 0x8c, 0x0d, 0x0d, 0x8d, 0x8d, 0x0e, 0x0e, 0x8e   ; 0d68
	db 0x8e, 0x0f, 0x0f, 0x8f, 0x8f, 0x10, 0x10, 0x90   ; 0d70
	db 0x90, 0x11, 0x11, 0x91, 0x91, 0x12, 0x12, 0x92   ; 0d78
	db 0x92, 0x13, 0x13, 0x93, 0x93, 0x14, 0x14, 0x94   ; 0d80
	db 0x94, 0x15, 0x15, 0x95, 0x95, 0x16, 0x16, 0x96   ; 0d88
	db 0x96, 0x17, 0x17, 0x97, 0x97, 0x18, 0x18, 0x98   ; 0d90
	db 0x98, 0x19, 0x19, 0x99, 0x99, 0x1a, 0x1a, 0x9a   ; 0d98
	db 0x9a, 0x1b, 0x1b, 0x9b, 0x9b, 0x1c, 0x1c, 0x9c   ; 0da0
	db 0x9c, 0x1d, 0x1d, 0x9d, 0x9d, 0x1e, 0x1e, 0x9e   ; 0da8
	db 0x9e, 0x1f, 0x1f, 0x9f, 0x9f

sub_0db5h:
	add hl,bc		;0db5	09		.
	add hl,bc		;0db6	09		.
	ld e,(hl)		;0db7	5e		^
	inc hl			;0db8	23		#
	ld d,(hl)		;0db9	56		V
	ret			;0dba	c9		.
l0dbbh:
	ld a,(040fdh)		;0dbb	3a fd 40	: . @
	or a			;0dbe	b7		.
	jp z,l0e72h		;0dbf	ca 72 0e	. r .
	ld a,(0410fh)		;0dc2	3a 0f 41	: . A
	inc a			;0dc5	3c		<
	ld (0410fh),a		;0dc6	32 0f 41	2 . A
	cp 008h			;0dc9	fe 08		. .
	jp nz,l0a67h		;0dcb	c2 67 0a	. g .
	ld a,(04102h)		;0dce	3a 02 41	: . A
	or a			;0dd1	b7		.
	jp z,l0a67h		;0dd2	ca 67 0a	. g .
	ld hl,(04103h)		;0dd5	2a 03 41	* . A
	ld de,l0140h		;0dd8	11 40 01	. @ .
	add hl,de		;0ddb	19		.
	ld a,(CUR_MAP)		;0ddc	3a 22 41	: " A
	call sub_0f26h		;0ddf	cd 26 0f	. & .
	ld a,(hl)		;0de2	7e		~
	bit 1,a			;0de3	cb 4f		. O
	jr z,l0e05h		;0de5	28 1e		( .
	ld de,16		;0de7	11 10 00	. . .
	add hl,de		;0dea	19		.
	ld (04103h),hl		;0deb	22 03 41	" . A
	ld a,000h		;0dee	3e 00		> .
	ld (0410fh),a		;0df0	32 0f 41	2 . A
	ld a,(04102h)		;0df3	3a 02 41	: . A
	cp 001h			;0df6	fe 01		. .
	jp nz,l0a67h		;0df8	c2 67 0a	. g .
	ld de,32		;0dfb	11 20 00	.   .
	add hl,de		;0dfe	19		.
	push hl			;0dff	e5		.
	pop iy			;0e00	fd e1		. .
	jp l0a67h		;0e02	c3 67 0a	. g .
l0e05h:
	push ix			;0e05	dd e5		. .
	dec ix			;0e07	dd 2b		. +
	dec ix			;0e09	dd 2b		. +
	dec ix			;0e0b	dd 2b		. +
	dec ix			;0e0d	dd 2b		. +
	ld a,(ix+000h)		;0e0f	dd 7e 00	. ~ .
	ld c,a			;0e12	4f		O
	pop ix			;0e13	dd e1		. .
	ld a,(040fdh)		;0e15	3a fd 40	: . @
	ld b,a			;0e18	47		G
	ld de,0	;0e19	11 00 00	. . .
l0e1ch:
	ld a,060h		;0e1c	3e 60		> `
	ld (ix+000h),a		;0e1e	dd 77 00	. w .
	ld (ix+001h),a		;0e21	dd 77 01	. w .
	ld (ix+002h),c		;0e24	dd 71 02	. q .
	inc ix			;0e27	dd 23		. #
	inc ix			;0e29	dd 23		. #
	inc ix			;0e2b	dd 23		. #
	push bc			;0e2d	c5		.
	ld b,028h		;0e2e	06 28		. (
l0e30h:
	ld (ix+000h),020h	;0e30	dd 36 00 20	. 6 .  
	inc ix			;0e34	dd 23		. #
	djnz l0e30h		;0e36	10 f8		. .
	ld (ix+000h),038h	;0e38	dd 36 00 38	. 6 . 8
	ld (ix+001h),000h	;0e3c	dd 36 01 00	. 6 . .
	ld (ix+002h),03fh	;0e40	dd 36 02 3f	. 6 . ?
	inc ix			;0e44	dd 23		. #
	inc ix			;0e46	dd 23		. #
	inc ix			;0e48	dd 23		. #
	ld b,006h		;0e4a	06 06		. .
	ld e,002h		;0e4c	1e 02		. .
l0e4eh:
	ld (ix+000h),d		;0e4e	dd 72 00	. r .
	ld (ix+001h),d		;0e51	dd 72 01	. r .
	ld (ix+002h),c		;0e54	dd 71 02	. q .
	inc ix			;0e57	dd 23		. #
	inc ix			;0e59	dd 23		. #
	inc ix			;0e5b	dd 23		. #
	djnz l0e4eh		;0e5d	10 ef		. .
	dec e			;0e5f	1d		.
	jr z,l0e6fh		;0e60	28 0d		( .
	pop bc			;0e62	c1		.
	push bc			;0e63	c5		.
	ld a,b			;0e64	78		x
	cp 001h			;0e65	fe 01		. .
	ld b,001h		;0e67	06 01		. .
	jr nz,l0e4eh		;0e69	20 e3		  .
	set 6,d			;0e6b	cb f2		. .
	jr l0e4eh		;0e6d	18 df		. .
l0e6fh:
	pop bc			;0e6f	c1		.
	djnz l0e1ch		;0e70	10 aa		. .
l0e72h:
	dec ix			;0e72	dd 2b		. +
	dec ix			;0e74	dd 2b		. +
	dec ix			;0e76	dd 2b		. +
	ld a,(04107h)		;0e78	3a 07 41	: . A
	cp 001h			;0e7b	fe 01		. .
	jr nz,l0ea2h		;0e7d	20 23		  #
	ld a,(NEEDSOFFSETDE)		;0e7f	3a 05 00	: . . (xxx)
	cp MAGIC5			;0e82	fe aa		. .
	jr nz,l0e90h		;0e84	20 0a		  .
	ld a,(041d4h)		;0e86	3a d4 41	: . A
	ld hl,04123h		;0e89	21 23 41	! # A
	ld b,02bh		;0e8c	06 2b		. +
	jr l0e98h		;0e8e	18 08		. .
l0e90h:
	ld a,(04189h)		;0e90	3a 89 41	: . A
	ld hl,04123h		;0e93	21 23 41	! # A
	ld b,012h		;0e96	06 12		. .
l0e98h:
	ld (hl),000h		;0e98	36 00		6 .
	inc hl			;0e9a	23		#
	ld (hl),000h		;0e9b	36 00		6 .
	inc hl			;0e9d	23		#
	ld (hl),a		;0e9e	77		w
	inc hl			;0e9f	23		#
	djnz l0e98h		;0ea0	10 f6		. .
l0ea2h:
	ld de,(04107h)		;0ea2	ed 5b 07 41	. [ . A
	ld hl,04108h		;0ea6	21 08 41	! . A
	ld a,006h		;0ea9	3e 06		> .
	sub e			;0eab	93		.
	jr z,l0eb7h		;0eac	28 09		( .
	add hl,de		;0eae	19		.
	ld b,a			;0eaf	47		G
	ld a,000h		;0eb0	3e 00		> .
l0eb2h:
	inc hl			;0eb2	23		#
	cp (hl)			;0eb3	be		.
	ret nz			;0eb4	c0		.
	djnz l0eb2h		;0eb5	10 fb		. .
l0eb7h:
	dec ix			;0eb7	dd 2b		. +
	ld c,(ix+000h)		;0eb9	dd 4e 00	. N .
	push ix			;0ebc	dd e5		. .
	pop hl			;0ebe	e1		.
	ld de,0x2f		;0ebf	11 2f 00	. / .
	add hl,de		;0ec2	19		.
	ld (hl),060h		;0ec3	36 60		6 `
	inc hl			;0ec5	23		#
	ld (hl),060h		;0ec6	36 60		6 `
	inc hl			;0ec8	23		#
	ld (hl),c		;0ec9	71		q
	inc hl			;0eca	23		#
	ld b,02ah		;0ecb	06 2a		. *
l0ecdh:
	ld (hl),020h		;0ecd	36 20		6  
	inc hl			;0ecf	23		#
	djnz l0ecdh		;0ed0	10 fb		. .
	ld (hl),030h		;0ed2	36 30		6 0
	ld b,032h		;0ed4	06 32		. 2
l0ed6h:
	inc hl			;0ed6	23		#
	ld (hl),000h		;0ed7	36 00		6 .
	inc hl			;0ed9	23		#
	ld (hl),000h		;0eda	36 00		6 .
	inc hl			;0edc	23		#
	ld (hl),c		;0edd	71		q
	djnz l0ed6h		;0ede	10 f6		. .
	ret			;0ee0	c9		.

; #### Some FIFO test, maybe full or empty?
; INPUT
;   DE contains a FIFO pointer (to two pointers to FIFO buffer)
; OUTPUT
;   C = 1 is FIFO empty
;   A = char from FIFO
;   Z = 1 if char is 
; FIFO have 0x20 bytes so first 3 bits of lower address of buffer is the FIFO number
; And starts at memory ending in 00000
FIFO_READ:
	push bc
	push de
	push hl
	ex de,hl
	ld a,(hl)		; Low byte of FIFO pointer
	inc hl
	inc hl
	cp (hl)			; Other FIFO pointer
	scf				; Carry = 1
	jr z,_exit		; Empty
	ld e,(hl)
	inc hl
	ld d,(hl)
	ex de,HL		; HL = second FIFO pointer
	ld b,(hl)
	and %11100000	; Keep top 3 bits (FIFO #)
	ld c,a			; C += FIFO number
	inc hl			; Increment pointer
	ld a,l			;
	and %00011111	; Wrap around
	or c			; Add back top 3 bits
	dec de			;
	ld (de),a		; Store back
	ld a,e			;
	cp LOW(FIFO_KBD)+2	; Special case for FIFO_KBD
	ld a,b			; 
	call z,KBD_TRANSLATE ; If KBD translate key to German
	or a
_exit:
	pop hl
	pop de
	pop bc
	ret

; Port reading into FIFO
;	C: port to read from
;	HL: FIFO to write to
PORT2FIFO:
	in a,(c)
; Pushes data in FIFO
;	A: data to push
; 	HL: FIFO to push to
DATA2FIFO:
		;	Get head
	ld e,(hl)
	inc hl
	ld d,(hl)
		;	Store data
	ld (de),a
		; Increments e, modulo 32
	ld a,e
	and %11100000		; Keep top 3 bits of adrs
	ld b,a
	ld a,e
	inc a			; Increment and modulo 32
	and %00011111
	or b			; Combine with top 3 bits
	ld e,a
		; Store new head
	dec hl
	ld (hl),e
	ret

;	Memory Mapping?
SETMEMMAP:
	ld (CUR_MAP),a
	out (PORT_MEM),a
	ret

;	Compare HL and DE
CMP_HLDE:
	push hl
	and a				; Clear carry
	sbc hl,de			; Compare (substract and restore)
	pop hl
	ret

sub_0f26h:
	call SETMEMMAP	;0f26	cd 1a 0f	. . .
	push af			;0f29	f5		.
	ld a,(hl)		;0f2a	7e		~
	cp 0ffh			;0f2b	fe ff		. .
	jr z,l0f31h		;0f2d	28 02		( .
	pop af			;0f2f	f1		.
	ret			;0f30	c9		.
l0f31h:
	inc hl			;0f31	23		#
	ld a,(hl)		;0f32	7e		~
	cp 0aah			;0f33	fe aa		. .
	jp z,l0f3bh		;0f35	ca 3b 0f	. ; .
	dec hl			;0f38	2b		+
	pop af			;0f39	f1		.
	ret			;0f3a	c9		.
l0f3bh:
	inc hl			;0f3b	23		#
	pop af			;0f3c	f1		.
	push de			;0f3d	d5		.
	ld a,(hl)		;0f3e	7e		~
	inc hl			;0f3f	23		#
	ld e,(hl)		;0f40	5e		^
	inc hl			;0f41	23		#
	ld d,(hl)		;0f42	56		V
	call SETMEMMAP	;0f43	cd 1a 0f	. . .
	ex de,hl		;0f46	eb		.
	pop de			;0f47	d1		.
	cp 0ffh			;0f48	fe ff		. .
	ret nz			;0f4a	c0		.
	ld a,000h		;0f4b	3e 00		> .
	call SETMEMMAP	;0f4d	cd 1a 0f	. . .
	ld hl,060deh		;0f50	21 de 60	! . `
	ret			;0f53	c9		.

; Unsure of usage
; C == # of digits
; INPUT
; 	DE = Address of string
; OUTPUT
; 	HL = Decimal value
STR2NUM:
	push iy
	push de
	pop iy			; IY = DE
	ld hl,0
	ld a,c
	cp 2
	jr c,_units
	jr z,_tens
	cp 3
	jr z,_hundreds
	call STR2NUM_HELPER
	jr z,_hundreds		; Leading zero for thousands
	ld de,1000
_loop1:
	add hl,de
	djnz _loop1
_hundreds:
	call STR2NUM_HELPER
	jr z,_tens		; Leading zero for hundreds
	ld de,100
_loop2:
	add hl,de
	djnz _loop2
_tens:
	call STR2NUM_HELPER
	jr z,_units		; Leading zero for tens
	ld de,10
_loop3:
	add hl,de
	djnz _loop3
_units:
	ld a,(iy+000h)
	and 00fh
	ld d,0
	ld e,a
	add hl,de
	pop iy
	ret
; Get a digits from IY, convert from ASCII
; OUTPUT
;   B = Digit
;   Z is number is zero
STR2NUM_HELPER:
	ld a,(iy+000h)		;0f94	fd 7e 00	. ~ .
	inc iy			;0f97	fd 23		. #
	and 00fh		;0f99	e6 0f		. .
	ld b,a			;0f9b	47		G
	or a			;0f9c	b7		.
	ret			;0f9d	c9		.

; HL = Number to print
; DE = Memory to print into
; C = Number of digits to print`
NUM2STR:
	push iy
	push de
	pop iy		; iy = de
	push bc
	ld a,c
	cp 2
	jr c,_units		; ARG = 0 or 1
	jr z,_tens		; ARG = 2
	cp 3
	jr z,_hundreds		; ARG =3
	xor a			; ARG = 4,5,6,7
_thousands:
	call PRT_HELPER1		; BC=HL; A++
	ld de,1000
	sbc hl,de
	jr nc,_thousands
	call PRT_HELPER2
_hundreds: ; ARG = 3
	xor a
_loop1:
	call PRT_HELPER1
	ld de,100
	sbc hl,de
	jr nc,_loop1
	call PRT_HELPER2		; Ouputs digit
_tens:	; ARG = 2
	xor a
_loop2:
	call PRT_HELPER1		; BC=HL; A++
	ld de,10
	sbc hl,de
	jr nc,_loop2
	call PRT_HELPER2		; Ouputs digit
_units:
	ld a,l
	or 030h
	ld (iy+000h),a
	pop bc
	pop iy
	ret

; BC = HL; A++
PRT_HELPER1:
	ld b,h
	ld c,l
	inc a
	ret

; Print A-1 as a ascii digit into IY, put BC in HL
PRT_HELPER2:
	dec a
	ld h,b
	ld l,c
	or '0'
	ld (iy+000h),a
	inc iy
	ret

; Find char corresponding to key (probably)
KEY2CHAR:
	and 0x3f
	push hl
	push de
	ld hl,KEYTABLE
	ld d,0
	ld e,a
	add hl,de
	ld a,(hl)
	pop de
	pop hl
	ret

; Looks like the key to char table for the keyboard
KEYTABLE:
	db " E.A", 0x8b, "SIU", 0x8a
	db "DRJNFCKTZLWHYPQOBG&MXV", 0x88, 0x20
	db 0x94, 0x84, 0x91, 0x9e, 0x93, 0x8f, 0x20, 0x90
	db 0x92, 0x9e, 0x9e, 0x20, 0x99, 0x85, 0x9e, 0x9a 
	db 0x8d, 0x86, 0x96, 0x89, 0x8e, 0x87, 0x98, 0x9c
	db 0x97, 0x95, 0x81, 0x8c, 0x82, 0x83, 0x20
	
KBD_TRANSLATE:
	push bc
	push hl
	ld b,a
	ld a,(CFG4_LANG)
	cp LANG_DE
	ld a,b
	jr nz,_skiptranslate
	ld b,19
	ld hl,EN2DE
_loop:
	cp (hl)
	inc hl
	jr z,_notfound
	inc hl
	djnz _loop
	jr _skiptranslate
_notfound:
	ld a,(hl)
_skiptranslate:
	pop hl
	pop bc
	ret

; English to German key translation table for keyboard input
EN2DE:
	db "*[+\\:{;|<;>:@*YZZY[]\\`]@`+yzzy{}|<}~~>"

; Output characters from A
; Chars 0 to 15 are mapped to function from JTABLE
; Chars 16 to 31 are ignored
OUT_CH:
	push hl
	ld hl,FLAGS
	bit FLAG_DISP,(hl)
	pop hl
	ret nz			; Aborts if FLAG_DISP is not set
	cp ' '  
	jr nc,OUTPRNT
	cp 0x10
	ret nc 			; > 0x10-0x1f => aborts
	ld (TMPHL),hl

		;	We lookup in the jump table
	push de
	push af
	add a,a		; de = a*2
	ld e,a
	ld d,0
	ld hl,JTABLE
	add hl,de
	ld e,(hl)	; get low byte
	inc hl
	ld d,(hl)	; get high byte
	ex de,hl
	pop af
	pop de
	push hl		; Push jump table target
	ld hl,(TMPHL)
	ret			; Jumps to target
JTABLE:
	dw JNONE
	dw JNONE		; CTRL-A
	dw TARGET2		; CTRL-B
	dw TARGET3		; CTRL-C
	dw TARGET4		; CTRL-D
	dw TARGET_CRLF	; CTRL-E
	dw JNONE
	dw JNONE
	dw TARGET8      ; 0x08 - CTRL-H - LEFT
	dw TARGET_RIGHT	; 0x09 - CTRL-I - RIGHT
	dw TARGETA      ; 0x0A - CTRL-J
	dw TARGETB      ; 0x0B - CTRL-K - UP
	dw TARGETC		; CTRL-L
	dw JNONE
	dw TARGETE		; CTRL-N
	dw TARGETF		; CTRL-O
JNONE:
	ret
; Printable character?
OUTPRNT:
	push af
	push bc
	push de
	push hl
	ld hl,(p4f84)	; hl = *p4f84
	ld b,a
	push bc
	ld a,(CURSORX)
	ld c,a
	ld b,0
	ld de,42
	or a			; Reset carry
	sbc hl,de		; hl = *p4f84 - 42
	add hl,bc		; hl = *p4f84 - 42 + cursorx
	pop bc
	ld (hl),b		; Store char
	inc a
	ld (CURSORX),a	; CURSORX++
	ld hl,(p4f84)
	ld b,a
	ld a,(hl)
	and 0c0h
	or b
	ld (hl),a		; *p4f84 = (*p4f84 & 0xc0) | cursorx
	call sub_1191h
	ld a,(CURSORX)
	cp 40
	call nc,TARGET_CRLF	; Next line ?
	pop hl
	pop de
	pop bc
	pop af
	ret



; Weird routine that adds 75 to DE depending on content of ROM address 0x5
; (does nothing on ROM 57)
ADJUSTDE:
	push hl
	push af
	ld a,(NEEDSOFFSETDE)
	cp MAGIC5
	jr nz,_exit
	ld hl,0x4b		; Adds 75 (0x4b) to de and exit
	add hl,de
	ex de,hl
_exit:
	pop af
	pop hl
	ret


;	Starting a 0x4186, do 26 times: OR a byte with 0x3c every 67 bytes
sub_1112h:
	push bc
	push de
	push hl
	push af
	ld de,04186h
	call ADJUSTDE
	ld h,d
	ld l,e
	ld de,67
	ld b,26
_loop:
	ld a,(hl)
	or 0x3f
	ld (hl),a
	add hl,de
	djnz _loop
	pop af
	pop hl
	pop de
	pop bc
	ret

; Complicated. Finds the Ath position from 04159h where bit 5 is set, looking at every 67 bytes. Returns this location plus 43 or 88 depending wether we got to position A.
; Looks at at most 26 values
; => It looks to me that there are 26 control blocs of 67 bytes. Bit 5 is some sort of flag.
; It seems the goal is to return the "right" HL for some purpose.
sub_112fh:
	push bc
	push de
	ld de,04159h
	call ADJUSTDE
	ld h,d
	ld l,e
	ld b,26
	ld de,67
	ld c,-1
_loop:
	bit 5,(hl)
	jr z,_skip
	inc c			; Increments C
	cp c			; Until it is equal to A
	jr z,_done
_skip:
	add hl,de
	djnz _loop
	ld de,43
	add hl,de
_done:
	ld de,45
	add hl,de
	pop de
	pop bc
	ret


TARGETA:
	push af			;1156	f5		.
	push hl			;1157	e5		.
	call sub_1112h		;1158	cd 12 11	. . .
	ld a,(04f83h)		;115b	3a 83 4f	: . O
	call sub_112fh		;115e	cd 2f 11	. / .
	ld (p4f84),hl		;1161	22 84 4f	" . O
	ld a,(hl)		;1164	7e		~
	and 0c0h		;1165	e6 c0		. .
	ld (hl),a		;1167	77		w
	ld a,(04f82h)		;1168	3a 82 4f	: . O
	ld (CURSORX),a		;116b	32 86 4f	2 . O
	or (hl)			;116e	b6		.
	ld (hl),a		;116f	77		w
	call sub_1191h		;1170	cd 91 11	. . .
	pop hl			;1173	e1		.
	pop af			;1174	f1		.
	ret			;1175	c9		.

; Home?
TARGET4:
	push af
	push hl
	call sub_1112h
	xor a
	call sub_112fh
	ld (p4f84),hl		;117f	22 84 4f	" . O
	ld a,(hl)		;1182	7e		~
	and 0c0h		;1183	e6 c0		. .
	ld (hl),a		;1185	77		w
	ld a,000h		;1186	3e 00		> .
	ld (CURSORX),a		;1188	32 86 4f	2 . O
	call sub_1191h		;118b	cd 91 11	. . .
	pop hl			;118e	e1		.
	pop af			;118f	f1		.
	ret			;1190	c9		.

; If f5b6d then set two last bits of (hl) to 1
sub_1191h:
	ld a,(f5b6d)
	or a
	ret z
	ld a,(hl)
	or 03fh
	ld (hl),a
	ret

; Forward a character
TARGET_RIGHT:
	push af
	push hl
	ld hl,(p4f84)
	ld a,(hl)
	and 0c0h
	ld (hl),a
	ld a,(CURSORX)
	inc a
	ld (CURSORX),a
	or (hl)
	ld (hl),a
	call sub_1191h
	ld a,(CURSORX)
	cp 40
	call nc,TARGET_CRLF
	pop hl
	pop af
	ret

; Backward a character ?
TARGET8:
	push af			;11bb	f5		.
	push hl			;11bc	e5		.
	ld hl,(p4f84)		;11bd	2a 84 4f	* . O
	ld a,(hl)		;11c0	7e		~
	and 0c0h		;11c1	e6 c0		. .
	ld (hl),a		;11c3	77		w
	ld a,(CURSORX)		;11c4	3a 86 4f	: . O
	dec a			;11c7	3d		=
	ld (CURSORX),a		;11c8	32 86 4f	2 . O
	or (hl)			;11cb	b6		.
	ld (hl),a		;11cc	77		w
	call sub_1191h		;11cd	cd 91 11	. . .
	ld a,(CURSORX)		;11d0	3a 86 4f	: . O
	cp 0ffh			;11d3	fe ff		. .
	jr nz,l11ebh		;11d5	20 14		  .
	call TARGETC		;11d7	cd ee 11	. . .
	ld hl,(p4f84)		;11da	2a 84 4f	* . O
	ld a,(hl)		;11dd	7e		~
	and 0c0h		;11de	e6 c0		. .
	ld (hl),a		;11e0	77		w
	ld a,027h		;11e1	3e 27		> '
	ld (CURSORX),a		;11e3	32 86 4f	2 . O
	or (hl)			;11e6	b6		.
	ld (hl),a		;11e7	77		w
	call sub_1191h		;11e8	cd 91 11	. . .
l11ebh:
	pop hl			;11eb	e1		.
	pop af			;11ec	f1		.
	ret			;11ed	c9		.

TARGETC:
	push af			;11ee	f5		.
	push bc			;11ef	c5		.
	push de			;11f0	d5		.
	push hl			;11f1	e5		.
	ld hl,(p4f84)		;11f2	2a 84 4f	* . O
	ld de,04186h		;11f5	11 86 41	. . A
	call ADJUSTDE		;11f8	cd 01 11	. . .
	call CMP_HLDE		;11fb	cd 20 0f	.   .
	jr z,l1234h		;11fe	28 34		( 4
	ld a,(hl)		;1200	7e		~
	or 03fh			;1201	f6 3f		. ?
	ld (hl),a		;1203	77		w
	ld bc,00070h		;1204	01 70 00	. p .
	or a			;1207	b7		.
	sbc hl,bc		;1208	ed 42		. B
	ld de,04159h		;120a	11 59 41	. Y A
	call ADJUSTDE		;120d	cd 01 11	. . .
	ld bc,00043h		;1210	01 43 00	. C .
l1213h:
	call CMP_HLDE		;1213	cd 20 0f	.   .
	jr z,l1221h		;1216	28 09		( .
	bit 5,(hl)		;1218	cb 6e		. n
	jr nz,l1221h		;121a	20 05		  .
	or a			;121c	b7		.
	sbc hl,bc		;121d	ed 42		. B
	jr l1213h		;121f	18 f2		. .
l1221h:
	ld bc,0x2d		;1221	01 2d 00	. - .
	add hl,bc		;1224	09		.
	ld a,(hl)		;1225	7e		~
	and 0c0h		;1226	e6 c0		. .
	ld (hl),a		;1228	77		w
	ld a,(CURSORX)		;1229	3a 86 4f	: . O
	or (hl)			;122c	b6		.
	ld (hl),a		;122d	77		w
	ld (p4f84),hl		;122e	22 84 4f	" . O
	call sub_1191h		;1231	cd 91 11	. . .
l1234h:
	pop hl			;1234	e1		.
	pop de			;1235	d1		.
	pop bc			;1236	c1		.
	pop af			;1237	f1		.
	ret			;1238	c9		.

TARGETB:
	push af
	push bc
	push de
	push hl
	ld hl,(p4f84)
	ld de,04811h
	call ADJUSTDE
	call CMP_HLDE
	jr z,l127bh
	ld a,(hl)
	or 03fh
	ld (hl),a
	ld bc,22
	add hl,bc		; hl = *p4f84 + 22
	ld de,047e4h
	call ADJUSTDE
	ld bc,67
_loop:
	call CMP_HLDE
	jr z,l1268h
	bit 5,(hl)
	jr nz,l1268h
	add hl,bc
	jr _loop
l1268h:
	ld bc,0x2d		;1268	01 2d 00	. - .
	add hl,bc		;126b	09		.
	ld a,(hl)		;126c	7e		~
	and 0c0h		;126d	e6 c0		. .
	ld (hl),a		;126f	77		w
	ld a,(CURSORX)		;1270	3a 86 4f	: . O
	or (hl)			;1273	b6		.
	ld (hl),a		;1274	77		w
	ld (p4f84),hl		;1275	22 84 4f	" . O
	call sub_1191h		;1278	cd 91 11	. . .
l127bh:
	pop hl			;127b	e1		.
	pop de			;127c	d1		.
	pop bc			;127d	c1		.
	pop af			;127e	f1		.
	ret			;127f	c9		.

FUN_DD:
	ld a,(f5fb6)
	xor 0ffh
	ld (f5fb6),a
	jr nz,TARGETF
TARGETE:
	push af
	push hl
	ld a,(f5fb6)
	or a
	jr nz,_skip
	ld hl,(p4f84)
	ld a,(hl)
	and 0c0h
	ld (hl),a
	ld a,(CURSORX)
	or (hl)
	ld (hl),a
	ld a,0
	ld (f5b6d),a
_skip:
	pop hl
	pop af
	ret

TARGETF:
	push af
	call sub_1112h
	ld a,1
	ld (f5b6d),a
	pop af
	ret

; CRLF
TARGET_CRLF:
	push af
	push hl
	call TARGETB
	ld a,0
	ld (CURSORX),a	; CURSORX = 0
	ld hl,(p4f84)
	ld a,(hl)
	and 0c0h
	ld (hl),a
	call sub_1191h
	pop hl
	pop af
	ret

TARGET3:
	push af			;12c8	f5		.
	push bc			;12c9	c5		.
	push de			;12ca	d5		.
	push hl			;12cb	e5		.
	ld hl,(p4f84)		;12cc	2a 84 4f	* . O
	ld a,(CURSORX)		;12cf	3a 86 4f	: . O
	ld c,a			;12d2	4f		O
	ld b,000h		;12d3	06 00		. .
	ld de,42		;12d5	11 2a 00	. * .
	or a			;12d8	b7		.
	sbc hl,de		;12d9	ed 52		. R
	add hl,bc		;12db	09		.
	ld a,027h		;12dc	3e 27		> '
	sub c			;12de	91		.
	ld c,a			;12df	4f		O
	ld (hl),020h		;12e0	36 20		6  
	ld d,h			;12e2	54		T
	ld e,l			;12e3	5d		]
	inc de			;12e4	13		.
	ld a,b			;12e5	78		x
	or c			;12e6	b1		.
	jr z,l12ebh		;12e7	28 02		( .
	ldir			;12e9	ed b0		. .
l12ebh:
	pop hl			;12eb	e1		.
	pop de			;12ec	d1		.
	pop bc			;12ed	c1		.
	pop af			;12ee	f1		.
	ret			;12ef	c9		.

TARGET2:
	push bc			;12f0	c5		.
	push de			;12f1	d5		.
	push hl			;12f2	e5		.
	call TARGET3		;12f3	cd c8 12	. . .
	ld hl,(p4f84)		;12f6	2a 84 4f	* . O
	ld bc,25		;12f9	01 19 00	. . .
	add hl,bc		;12fc	09		.
	ld de,0482ah		;12fd	11 2a 48	. * H
	call ADJUSTDE		;1300	cd 01 11	. . .
	ld c,01bh		;1303	0e 1b		. .
l1305h:
	call CMP_HLDE		;1305	cd 20 0f	.   .
	jr nc,l1314h		;1308	30 0a		0 .
	ld b,028h		;130a	06 28		. (
l130ch:
	ld (hl),020h		;130c	36 20		6  
	inc hl			;130e	23		#
	djnz l130ch		;130f	10 fb		. .
	add hl,bc		;1311	09		.
	jr l1305h		;1312	18 f1		. .
l1314h:
	pop hl			;1314	e1		.
	pop de			;1315	d1		.
	pop bc			;1316	c1		.
	ret			;1317	c9		.

; Out character inlined by caller
; arg db CHAR
OUT_CH_INLINE:
	ex (sp),hl		;1318	e3		.
	ld a,(hl)		;1319	7e		~
	inc hl			;131a	23		#
	ex (sp),hl		;131b	e3		.
	jp OUT_CH		;131c	c3 84 10	. . .

; Input string in an address inlined by caller
; arg dw VAR
; arg db FLAGS
INPUT_INLINE:
	ex (sp),hl
	push de
	push bc
	push af
	call GET_WORD_AND_BYTE	; HL, C
	push de
	ld a,c
	and 040h
	jr z,_l1369h
	ld d,1			; flags bit 7 is set
	ld e,020h

_input_loop:
	call NEXT_MACRO_OR_KEY
	cp "\n"
	jr z,_return_key
	call CLASSIFY_LETTER
	jr c,_input_loop		; Control char and other "garbage"
	call sub_147bh
	jr _input_loop

_return_key:
	bit 7,c			;1341	cb 79		. y
	jr nz,_l1363h		;1343	20 1e		  .
	ld a,c			;1345	79		y
	and 00fh		;1346	e6 0f		. .
	dec a			;1348	3d		=
	ld c,a			;1349	4f		O
	ld b,000h		;134a	06 00		. .
	add hl,bc		;134c	09		.
	ld b,c			;134d	41		A
_l134eh:
	ld a,(hl)		;134e	7e		~
	cp ' '
	jr nz,_l1363h		;1351	20 10		  .
	push bc			;1353	c5		.
	push hl			;1354	e5		.
	ld b,c			;1355	41		A
_l1356h:
	dec hl			;1356	2b		+
	ld a,(hl)		;1357	7e		~
	inc hl			;1358	23		#
	ld (hl),a		;1359	77		w
	dec hl			;135a	2b		+
	djnz _l1356h		;135b	10 f9		. .
	ld (hl),020h		;135d	36 20		6  
	pop hl			;135f	e1		.
	pop bc			;1360	c1		.
	djnz _l134eh		;1361	10 eb		. .
_l1363h:
	pop hl
	pop af
	pop bc
	pop de
	ex (sp),hl
	ret

_l1369h:
	ld a,c			;1369	79		y
	and 03fh		;136a	e6 3f		. ?
	ld c,a			;136c	4f		O
	ld e,001h		;136d	1e 01		. .
_l136fh:
	call NEXT_MACRO_OR_KEY	;136f	cd a7 17	. . .
_l1372h:
	cp 00ah			;1372	fe 0a		. .
	jr z,_l13b9h		;1374	28 43		( C
	cp 07fh			;1376	fe 7f		. .
	jr z,_l139ah		;1378	28 20		(  
	call sub_14bdh		;137a	cd bd 14	. . .
	jr c,_l136fh		;137d	38 f0		8 .
	ld (hl),a		;137f	77		w
	ld a,e			;1380	7b		{
	cp c			;1381	b9		.
	jr z,_l138ch		;1382	28 08		( .
	ld a,(hl)		;1384	7e		~
	call OUT_CH		;1385	cd 84 10	. . .
	inc hl			;1388	23		#
	inc e			;1389	1c		.
	jr _l136fh		;138a	18 e3		. .
_l138ch:
	M_OUT_CH 0x0f
	ld a,(hl)		;1390	7e		~
	call OUT_CH		;1391	cd 84 10	. . .
	M_LEFT 1		;1394	cd 6c 15	. l .
	jr _l13b3h
_l139ah:
	ld (hl),020h		;139a	36 20		6  
	M_OUT_CH 0x0f
	M_OUT_CH ' ' 
	M_LEFT 1
	ld a,e
	cp 1
	jr z,_l13b3h
	M_LEFT 1
	dec hl
	dec e
_l13b3h:
	M_OUT_CH 0x0e
	jr _l136fh
_l13b9h:
	ld a,020h		;13b9	3e 20		>  
	cp (hl)			;13bb	be		.
	jr c,_l13bfh		;13bc	38 01		8 .
	ld (hl),a		;13be	77		w
_l13bfh:
	inc hl			;13bf	23		#
	inc e			;13c0	1c		.
	ld a,c			;13c1	79		y
	cp e			;13c2	bb		.
	jr nc,_l13b9h		;13c3	30 f4		0 .
	jp _l1363h		;13c5	c3 63 13	. c .

; Print message (inline address + length)
; If addrs is 0x00nn, then message is at iy+nn
OUT_MSG_INLINE:
	ex (sp),hl
	push de
	push bc
	push af
	call GET_WORD_AND_BYTE	; HL, C
	push de					; DE is the place where we need to jump back (HL+3)
	M_CALL_WITH_MMAP0 OUTSTR
	pop hl
	pop af
	pop bc
	pop de
	ex (sp),hl
	ret

; OUT c characters from (HL)
OUTSTR:
	ld b,c			;13db	41		A
_loop:
	ld a,(hl)		;13dc	7e		~
	call OUT_CH		;13dd	cd 84 10	. . .
	inc hl			;13e0	23		#
	djnz _loop		;13e1	10 f9		. .
	ret			;13e3	c9		.

SOMETHING1_INLINE:
	pop hl			;13e4	e1		.
	push de			;13e5	d5		.
	push bc			;13e6	c5		.
	push af			;13e7	f5		.
	call GET_WORD_AND_BYTE	; HL, C
	push de			;13eb	d5		.
	push hl			;13ec	e5		.
	call VAR2STR		;13ed	cd 5e 14	. ^ .

l13f0h:
	ld d,1
	ld e,'0'

_loop:
	call NEXT_MACRO_OR_KEY
	cp "\n"
	jr z,_entry
	call IS_DIGIT
	jr c,_loop
	call sub_147bh
	jr _loop

_entry:
	ld a,c
	and %00000111	; # of digits
	push bc
	ld c,a
	ex de,hl
	push de			;140b	d5		.
	call STR2NUM		;140c	cd 54 0f	. T .
	pop de			;140f	d1		.
	pop bc			;1410	c1		.
	ex de,hl		;1411	eb		.
	ld a,c			;1412	79		y
	and %01000000
	jr z,l1425h		;1415	28 0e		( .
	ld a,d			;1417	7a		z
	or a			;1418	b7		.
	jr nz,l141eh		;1419	20 03		  .
	inc a			;141b	3c		<
	jr l1425h		;141c	18 07		. .
l141eh:
	ld e,023h		;141e	1e 23		. #
	call sub_1501h		;1420	cd 01 15	. . .
	jr l13f0h		;1423	18 cb		. .

l1425h:
	pop hl			;1425	e1		.
	ld (hl),e		;1426	73		s
	jr nz,l142bh		;1427	20 02		  .
	inc hl			;1429	23		#
	ld (hl),d		;142a	72		r
l142bh:
	pop hl			;142b	e1		.
	pop af			;142c	f1		.
	pop bc			;142d	c1		.
	ex (sp),hl		;142e	e3		.
	ex de,hl		;142f	eb		.
	ret			;1430	c9		.

; OUT_VAR_INLINE (FReD TODO)
OUT_VAR_INLINE:
	ex (sp),hl
	push de
	push bc
	push af
	call GET_WORD_AND_BYTE	; HL, C
	push de
	call VAR2STR

	ld a,c
	and %00000111
	ld b,a
_loop:
	ld a,(hl)
	call OUT_CH
	inc hl
	djnz _loop

	pop hl			;1447	e1		.
	pop af			;1448	f1		.
	pop bc			;1449	c1		.
	pop de			;144a	d1		.
	ex (sp),hl		;144b	e3		.
	ret			;144c	c9		.

; hl points to the code, we extract a word and a byte
; OUTPUT:
;	HL = Word
; 	C = Byte
GET_WORD_AND_BYTE:
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	ld c,(hl)
	inc hl
	ex de,hl
		; Now HL points to the message
		; C = length
	dec h
	inc h
	ret nz			; Normal case, get out

		; If H=0 we get the word from IY+L
		; byte from HL+2
	push de
	push iy
	pop de
	add hl,de
	pop de
	ret

; Take content of (HL) and output it with C&0x7 digits
; If C&0x40, content is 8 bits, else 16 bits
; OUTPUT: HL points to a mem zone with the string
VAR2STR:
	ld a,c
	and %01000000
	jr z,_word		; Word based pointer
	; hl = *hl (as byte)
	ld l,(hl)
	ld h,0
	jr _doit
_word:
	; hl = *hl (as word)
	ld e,(hl)
	inc hl
	ld d,(hl)
	ex de,hl
_doit:
	ld a,c
	and %00000111
	push bc
	ld c,a
	ld de,SCRATCH4
	push de
	call NUM2STR
	pop hl
	pop bc
	ret

sub_147bh:
	push af			;147b	f5		.
	M_OUT_CH 0x0f
	dec d			;1480	15		.
	jr nz,l1495h		;1481	20 12		  .
	ld a,c			;1483	79		y
	and 00fh		;1484	e6 0f		. .
	ld b,a			;1486	47		G
	push hl			;1487	e5		.
l1488h:
	ld (hl),e		;1488	73		s
	inc hl			;1489	23		#
	djnz l1488h		;148a	10 fc		. .
	pop hl			;148c	e1		.
	ld a,c			;148d	79		y
	and 030h		;148e	e6 30		. 0
	ld e,020h		;1490	1e 20		.  
	call nz,sub_1501h	;1492	c4 01 15	. . .
l1495h:
	ld a,c			;1495	79		y
	and 00fh		;1496	e6 0f		. .
	ld d,h			;1498	54		T
	ld e,l			;1499	5d		]
	dec a			;149a	3d		=
	jr z,l14afh		;149b	28 12		( .
	ld b,a			;149d	47		G
	ld a,008h		;149e	3e 08		> .
	push bc			;14a0	c5		.
	call OUT_CH_REPEAT		;14a1	cd 7c 15	. | .
	pop bc			;14a4	c1		.
l14a5h:
	inc de			;14a5	13		.
	ld a,(de)		;14a6	1a		.
	dec de			;14a7	1b		.
	ld (de),a		;14a8	12		.
	inc de			;14a9	13		.
	call OUT_CH		;14aa	cd 84 10	. . .
	djnz l14a5h		;14ad	10 f6		. .
l14afh:
	pop af			;14af	f1		.
	ld (de),a		;14b0	12		.
	call OUT_CH		;14b1	cd 84 10	. . .
	M_LEFT 1
	M_OUT_CH 0x0e
	ret

sub_14bdh:
	cp 020h			;14bd	fe 20		.  
	ret z			;14bf	c8		.
	cp 041h			;14c0	fe 41		. A
	jr c,IS_DIGIT		;14c2	38 06		8 .
	and 0dfh		;14c4	e6 df		. .
	cp 05bh			;14c6	fe 5b		. [
	ccf			;14c8	3f		?
	ret			;14c9	c9		.

; nc if character in A is a digit
IS_DIGIT:
	cp '0'
	ret c
	cp '9'+1
	ccf
	ret

; Input
; 	A = Char
; Output
; 	Cflag set if char is to be ignored
;	Zflag (and CFlag) if '#'
;	Letters are converted to uppercase
CLASSIFY_LETTER:
	cp ' '
	ret c			; <' ', aka Control char
	cp '#'
	ccf
	ret z			; '#'
	cp '['
	ccf
	ret nc			; Normal char (up to uppercase letters)
	sub 0x20		; To uppercase
	cp 'A'
	ret c			; Not a letter, ignore
	cp '['
	ccf
	ret				; Letters have no cflag

SOMETHING2_INLINE:
	ex (sp),hl
	push de
	push bc
	push af
	ld c,(hl)
	inc hl
	ld a,c
	add a,0x10
	ld c,a
	M_OUT_CH 0x0f
	ld e,0xfe
	call sub_1501h
	M_OUT_CH 0x0e
	pop af
	pop bc
	pop de
	ex (sp),hl
	ret

sub_1501h:
	ld a,c
	and %00000111
	ld b,a
	push bc
	ld a,LEFT
	call OUT_CH_REPEAT
	ld a,e
	call OUT_CH
	ld a,RIGHT
	pop bc
	call OUT_CH_REPEAT
	ld a,' '
	and c
	jr nz,_skip_erase
	ld a,e
	call OUT_CH
	M_LEFT 1
_skip_erase:
	M_LEFT 1
	ret 

; Emit '0x0b' times the first argument and '0x09' times the second one.
; Probably GOTOYX
GOTO_YX_INLINE:
	M_OUT_CH 0x0f
	M_OUT_CH 0x04
	ex (sp),hl
	push bc
	ld a,0x0b
	ld b,(hl)
	inc hl
	dec b
	call nz,OUT_CH_REPEAT
	ld a,0x09
	ld b,(hl)
	inc hl
	dec b
	call nz,OUT_CH_REPEAT
	pop bc
	ex (sp),hl
	M_OUT_CH 0x0e
	ret

; Output 0x0f, 0x04, B*0x0b, C*0x09, 0x0e
; Probably GOTO_BC
U_OUT_0F040B_09_0E:
	push af
	M_OUT_CH 0x0f
	M_OUT_CH 0x04
	ld a,0x0b
	dec b
	call nz,OUT_CH_REPEAT
	ld a,0x09
	ld b,c
	dec b
	call nz,OUT_CH_REPEAT
	M_OUT_CH 0x0e
	pop af
	ret

; OUT_0C_REPEAT_INLINE
OUT_C_INLINE:
	ld a,UP
	jr OUT_HELPER_INLINE
; OUT_0B_REPEAT_INLINE
DOWN_INLINE:
	ld a,DOWN
	jr OUT_HELPER_INLINE
; OUT_08_REPEAT_INLINE
LEFT_INLINE:
	ld a,LEFT
	jr OUT_HELPER_INLINE
; OUT_09_REPEAT_INLINE
RIGHT_INLINE:
	ld a,RIGHT
OUT_HELPER_INLINE:
	ex (sp),hl		;1572	e3		.
	push bc			;1573	c5		.
	ld b,(hl)		;1574	46		F
	inc hl			;1575	23		#
	call OUT_CH_REPEAT		;1576	cd 7c 15	. | .
	pop bc			;1579	c1		.
	ex (sp),hl		;157a	e3		.
	ret			;157b	c9		.

OUT_CH_REPEAT:
	call OUT_CH		;157c	cd 84 10	. . .
	djnz OUT_CH_REPEAT		;157f	10 fb		. .
	ret			;1581	c9		.

sub_1582h:
	ld a,(0602eh)		;1582	3a 2e 60	: . `
	or a			;1585	b7		.
	ret z			;1586	c8		.
	push hl			;1587	e5		.
	dec a			;1588	3d		=
	ld (0602eh),a		;1589	32 2e 60	2 . `
	inc a			;158c	3c		<
	ld hl,0602fh		;158d	21 2f 60	! / `
	cp 003h			;1590	fe 03		. .
	jr c,l1599h		;1592	38 05		8 .
	ld a,00fh		;1594	3e 0f		> .
	and (hl)		;1596	a6		.
	jr l15a3h		;1597	18 0a		. .
l1599h:
	cp 002h			;1599	fe 02		. .
	jr nz,l15a0h		;159b	20 03		  .
	ld a,(hl)		;159d	7e		~
	jr l15a3h		;159e	18 03		. .
l15a0h:
	ld a,00fh		;15a0	3e 0f		> .
	and (hl)		;15a2	a6		.
l15a3h:
	cpl			;15a3	2f		/
	out (PORT_04),a		;15a4	d3 04		. .
	ld a,(0602eh)		;15a6	3a 2e 60	: . `
	cp 000h			;15a9	fe 00		. .
	jr nz,l15aeh		;15ab	20 01		  .
	ld (hl),a		;15ad	77		w
l15aeh:
	pop hl			;15ae	e1		.
	ret			;15af	c9		.
sub_15b0h:
	ld a,(CFG5)		;15b0	3a 0c 00	: . .
	cp 0aah			;15b3	fe aa		. .
	ret nz			;15b5	c0		.
	push bc			;15b6	c5		.
	push iy			;15b7	fd e5		. .
	M_OUT_MSG 0x174c, 0x1a ; "TAPE ACTION" CRLF "PLAYER NUMBER "
	ld a,(hl)		;15bf	7e		~
	push af			;15c0	f5		.
	or a			;15c1	b7		.
	jr z,l15e2h		;15c2	28 1e		( .
	and 00fh		;15c4	e6 0f		. .
	ld (hl),a		;15c6	77		w
	ld b,042h		;15c7	06 42		. B
	jr z,l15d1h		;15c9	28 06		( .
	ld b,041h		;15cb	06 41		. A
	cp 00fh			;15cd	fe 0f		. .
	jr nz,l15e2h		;15cf	20 11		  .
l15d1h:
	M_RIGHT 1
	xor a
	ld (v6030),a
	ld a,b			;15d9	78		x
	ld (v6031),a		;15da	32 31 60	2 1 `
	call OUT_CH		;15dd	cd 84 10	. . .
	jr l1603h		;15e0	18 21		. !
l15e2h:
	pop af			;15e2	f1		.
	push af			;15e3	f5		.
	and 00fh		;15e4	e6 0f		. .
	ld b,a			;15e6	47		G
	sub 009h		;15e7	d6 09		. .
	ld c,a			;15e9	4f		O
	ld a,030h		;15ea	3e 30		> 0
	jr c,l15f1h		;15ec	38 03		8 .
	ld a,031h		;15ee	3e 31		> 1
	ld b,c			;15f0	41		A
l15f1h:
	ld (06030h),a		;15f1	32 30 60	2 0 `
	ld a,b			;15f4	78		x
	or 030h			;15f5	f6 30		. 0
	ld (06031h),a		;15f7	32 31 60	2 1 `
	push hl			;15fa	e5		.
	pop iy			;15fb	fd e1		. .
	M_OUT_VAR 0x0000, 0x42
l1603h:
	pop af			;1603	f1		.
	ld (hl),a		;1604	77		w
	and 0f0h		;1605	e6 f0		. .
	ld b,050h		;1607	06 50		. P
	cp 010h			;1609	fe 10		. .
	jr z,l161bh		;160b	28 0e		( .
	ld b,053h		;160d	06 53		. S
	cp 020h			;160f	fe 20		.  
	jr z,l161bh		;1611	28 08		( .
	ld b,052h		;1613	06 52		. R
	cp 040h			;1615	fe 40		. @
	jr z,l161bh		;1617	28 02		( .
	ld b,04eh		;1619	06 4e		. N
l161bh:
	M_OUT_UP 1
	M_LEFT 2
	ld a,b			;1623	78		x
	call OUT_CH		;1624	cd 84 10	. . .
	pop iy			;1627	fd e1		. .
	pop bc			;1629	c1		.
	ret			;162a	c9		.
sub_162bh:
	ld a,(CFG5)		;162b	3a 0c 00	: . .
	cp 0aah			;162e	fe aa		. .
	ret nz			;1630	c0		.
	call sub_3b86h		;1631	cd 86 3b	. . ;
	push bc			;1634	c5		.
	ld b,008h		;1635	06 08		. .
	call sub_3866h		;1637	cd 66 38	. f 8
	pop bc			;163a	c1		.
	call U_OUT_0F040B_09_0E		;163b	cd 48 15	. H .
	M_RIGHT 15
l1642h:
	M_LEFT 1
_loop:
	call NEXT_MACRO_OR_KEY
	cp "\n"
	jr z,l1671h
	and %01011111	; Uppercase
	ld b,0
	cp "N"
	jr z,l1667h
	ld b,010h
	cp "P"
	jr z,l1667h
	ld b,020h
	cp "S"
	jr z,l1667h
	ld b,040h
	cp "R"
	jr nz,_loop
l1667h:
	call OUT_CH		;1667	cd 84 10	. . .
	ld a,(hl)		;166a	7e		~
	and 00fh		;166b	e6 0f		. .
	or b			;166d	b0		.
	ld (hl),a		;166e	77		w
	jr l1642h		;166f	18 d1		. .
l1671h:
	ld a,(hl)		;1671	7e		~
	and 0f0h		;1672	e6 f0		. .
	jr nz,l1679h		;1674	20 03		  .
	ld (hl),000h		;1676	36 00		6 .
	ret			;1678	c9		.
l1679h:
	call sub_3b86h		;1679	cd 86 3b	. . ;
	push bc			;167c	c5		.
	ld b,009h		;167d	06 09		. .
	call sub_3866h		;167f	cd 66 38	. f 8
	pop bc			;1682	c1		.
	call U_OUT_0F040B_09_0E		;1683	cd 48 15	. H .
	M_DOWN 1
	M_RIGHT 1
	ld a,(hl)
	push af
	push hl			;1690	e5		.
l1691h:
	M_INPUT v6030, 0xd2
	ld hl, v6031
	ld a,(hl)
	cp 'A'
	ld b,0x0f
	jr z,l16a7h		;169f	28 06		( .
	cp 'B'
	ld b,000h		;16a3	06 00		. .
	jr nz,l16b0h		;16a5	20 09		  .
l16a7h:
	dec hl			;16a7	2b		+
	ld a,(hl)		;16a8	7e		~
	or a			;16a9	b7		.
	jr z,l16e7h		;16aa	28 3b		( ;
	cp ' '
	jr z,l16e7h		;16ae	28 37		( 7
l16b0h:
	ld a,(hl)		;16b0	7e		~
	ld b,a			;16b1	47		G
	dec hl			;16b2	2b		+
	and 0f0h		;16b3	e6 f0		. .
	cp '0'
	jr nz,l16e1h		;16b7	20 28		  (
	ld a,b			;16b9	78		x
	and 00fh		;16ba	e6 0f		. .
	cp 00ah			;16bc	fe 0a		. .
	jr nc,l16e1h		;16be	30 21		0 !
	ld b,a			;16c0	47		G
	ld a,(hl)		;16c1	7e		~
	or a			;16c2	b7		.
	jr z,l16d3h		;16c3	28 0e		( .
	cp ' '  
	jr z,l16d3h		;16c7	28 0a		( .
	cp '0'
	jr z,l16d3h		;16cb	28 06		( .
	cp '1'
	jr z,l16d6h		;16cf	28 05		( .
	jr l16e1h		;16d1	18 0e		. .
l16d3h:
	xor a			;16d3	af		.
	jr l16d8h		;16d4	18 02		. .
l16d6h:
	ld a,00ah		;16d6	3e 0a		> .
l16d8h:
	add a,b			;16d8	80		.
	ld b,a			;16d9	47		G
	or a			;16da	b7		.
	jr z,l16e1h		;16db	28 04		( .
	cp 00fh			;16dd	fe 0f		. .
	jr c,l16e7h		;16df	38 06		8 .
l16e1h:
	M_SOMETHING2 0x02
	jr l1691h		;16e5	18 aa		. .
l16e7h:
	pop hl			;16e7	e1		.
	pop af			;16e8	f1		.
	and 0f0h		;16e9	e6 f0		. .
	or b			;16eb	b0		.
	ld (hl),a		;16ec	77		w
	ret			;16ed	c9		.
sub_16eeh:
	or a			;16ee	b7		.
	ret z			;16ef	c8		.
	push de			;16f0	d5		.
	push hl			;16f1	e5		.
	ld hl,FIFO7		;16f2	21 f8 40	! . @
	ld d,a			;16f5	57		W
l16f6h:
	and 0f0h		;16f6	e6 f0		. .
	ld e,a			;16f8	5f		_
	ld a,d			;16f9	7a		z
	inc a			;16fa	3c		<
	and 00fh		;16fb	e6 0f		. .
	or e			;16fd	b3		.
	call DATA2FIFO		;16fe	cd 09 0f	. . .
	pop hl			;1701	e1		.
	pop de			;1702	d1		.
	ret			;1703	c9		.
sub_1704h:
	ld a,(0602eh)		;1704	3a 2e 60	: . `
	or a			;1707	b7		.
	ret nz			;1708	c0		.
	ld de,FIFO7		;1709	11 f8 40	. . @
	call FIFO_READ		;170c	cd e1 0e	. . .
	ret c			;170f	d8		.
	ld (0602fh),a		;1710	32 2f 60	2 / `
	ld a,003h		;1713	3e 03		> .
	ld (0602eh),a		;1715	32 2e 60	2 . `
	ret			;1718	c9		.
	call sub_2a82h		;1719	cd 82 2a	. . *
	M_GOTO_YX 5,1
	ld hl,v53c2
	ld (hl),0x00
	call sub_15b0h		;1726	cd b0 15	. . .
	M_GOTO_YX 5,1
	call sub_162bh
	ld a,(05cbah)
	cp 005h			;1734	fe 05		. .
	jr z,l173fh		;1736	28 07		( .
	ld a,(hl)		;1738	7e		~
	call sub_16eeh		;1739	cd ee 16	. . .
	jp l1925h		;173c	c3 25 19	. % .
l173fh:
	ld de,05cc6h		;173f	11 c6 5c	. . \
	ld bc,5		;1742	01 05 00	. . .
	ldir			;1745	ed b0		. .
	ld a,044h		;1747	3e 44		> D
	jp 0893fh		;1749	c3 3f 89	. ? .

	db "TAPE ACTION" ; 174c
	db 5 ; 1757
	db "PLAYER NUMBER " ; 1758

; edition management task?
TASK_1:
	ld sp,0x4ff1
	call NEXT_MACRO_OR_KEY
	ld hl,FLAGS
	bit FLAG_DISP,(hl)
	jr z,l178fh
	cp KEY_EDIT
	jr z,l178fh
	cp 0a4h
	jr z,l178fh
	cp 09ch
	jr z,l178fh
	cp 09dh
	jr z,l178fh
	cp 0f4h
	jr z,l178fh
	cp 00fh
	jr z,l178fh
	cp 006h
	jr nz,TASK_1
l178fh:
	xor a
	call SETMEMMAP

	; JUMP TABLE_FUN_KEY[*(04f76h)] + RETURN TO TASK_1
l1793h:
	ld hl,TABLE_FUN_KEY
	ld a,(04f76h)
	ld e,a
	ld d,0
	add hl,de
	add hl,de
	ld e,(hl)
	inc hl
	ld d,(hl)
	ld hl,TASK_1
	push hl
	push de
FUN_00:	; And others FUN_00
	ret

; Enters next macro or typed key
; 0xff is used as marker for end of macro
NEXT_MACRO_OR_KEY:
	push bc			;17a7	c5		.
	push de			;17a8	d5		.
	push hl			;17a9	e5		.
l17aah:
	xor a			;17aa	af		.
	call SETMEMMAP	;17ab	cd 1a 0f	. . .
l17aeh:
	ld hl,(KEYMACRO)
	or h
	jr z,NEXT_KEY		; Macro is deactivated
	ld a,(hl)
	cp 0xff
	jr nz,_type_macro	; Type macro
	inc hl
	ld a,(hl)
	cp 0xff
	dec hl
	ld a,0xff
	jr nz,_type_macro	; Sends a 0xff is there is only one (?)

	; Two 0xff, end of macro	
	ld hl,0
	ld (KEYMACRO),hl	; Clear macro
	ld a,0
	ld (04f78h),a
	jr NEXT_KEY

_type_macro:
	inc hl
	ld (KEYMACRO),HL	; Increment pointer
	ld b,a
	jr TYPE_KEY			; Type key

NEXT_KEY:
	ld de,FIFO_KBD
	ld a,(04f76h)
	cp 005h
	ld b,00ah		;17de	06 0a		. .
	jr z,TYPE_KEY		;17e0	28 13		( .
	call FIFO_READ		;17e2	cd e1 0e	. . .
	jr nc,l17ech		;17e5	30 05		0 .
	call sub_0334h		;17e7	cd 34 03	. 4 .
	jr NEXT_KEY		;17ea	18 ea		. .
l17ech:
	ld b,001h		;17ec	06 01		. .
	call LOG_CHAR		;17ee	cd e6 1a	. . .
	ld b,a			;17f1	47		G
	call sub_82b6h		; Some kind of key mapping
TYPE_KEY:
	in a,(PORT_FF)		;17f5	db ff		. .
	ld hl,04f78h		;17f7	21 78 4f	! x O
	cp 0ffh			;17fa	fe ff		. .
	jr z,l1839h		;17fc	28 3b		( ;
	ld d,a			;17fe	57		W
	ld a,(05cbah)		;17ff	3a ba 5c	: . \
	or a			;1802	b7		.
	jr nz,l1839h		;1803	20 34		  4
	ld a,b			;1805	78		x
	cp 09bh			;1806	fe 9b		. .
	jr nz,l180fh		;1808	20 05		  .
	ld a,055h		;180a	3e 55		> U
	ld (hl),a		;180c	77		w
	jr NEXT_KEY		;180d	18 c7		. .
l180fh:
	ld a,(hl)		;180f	7e		~
	cp 055h			;1810	fe 55		. U
	jr nz,l181eh		;1812	20 0a		  .
	ld c,b			;1814	48		H
	inc (hl)		;1815	34		4
	ld a,b			;1816	78		x
	cp d			;1817	ba		.
	jr nz,NEXT_KEY		;1818	20 bc		  .
	ld (hl),0aah		;181a	36 aa		6 .
	jr NEXT_KEY		;181c	18 b8		. .
l181eh:
	cp 056h			;181e	fe 56		. V
	jr nz,l1834h		;1820	20 12		  .
	ld (hl),000h		;1822	36 00		6 .
	ld a,(05b70h)		;1824	3a 70 5b	: p [
	cp b			;1827	b8		.
	jr nz,NEXT_KEY		;1828	20 ac		  .
	ld a,(05b6fh)		;182a	3a 6f 5b	: o [
	cp c			;182d	b9		.
	jr nz,NEXT_KEY		;182e	20 a6		  .
	ld (hl),0aah		;1830	36 aa		6 .
	jr NEXT_KEY		;1832	18 a2		. .
l1834h:
	ld a,(hl)		;1834	7e		~
	cp 0aah			;1835	fe aa		. .
	jr nz,NEXT_KEY		;1837	20 9d		  .
l1839h:
	push bc			;1839	c5		.
	ld a,(05b7bh)		;183a	3a 7b 5b	: { [
	and 001h		;183d	e6 01		. .
	jp z,l1863h		;183f	ca 63 18	. c .
	ld a,b			;1842	78		x
	cp 01bh			;1843	fe 1b		. .
	jp nz,l185bh		;1845	c2 5b 18	. [ .
	ld a,(0609dh)		;1848	3a 9d 60	: . `
	or a			;184b	b7		.
	call z,09ca7h		;184c	cc a7 9c	. . .
	ld a,001h		;184f	3e 01		> .
	ld (060cdh),a		;1851	32 cd 60	2 . `
	sub a			;1854	97		.
	ld (06054h),a		;1855	32 54 60	2 T `
	jp l1863h		;1858	c3 63 18	. c .
l185bh:
	ld a,(0609dh)		;185b	3a 9d 60	: . `
	or a			;185e	b7		.
	ld a,b			;185f	78		x
	call nz,09d61h		;1860	c4 61 9d	. a .
l1863h:
	pop bc			;1863	c1		.
	ld a,b			;1864	78		x
	ld hl,FLAGS		;1865	21 79 4f	! y O
	cp 0a1h			;1868	fe a1		. .
	jr nz,l1871h		;186a	20 05		  .
	res 0,(hl)		;186c	cb 86		. .
	jp l1916h		;186e	c3 16 19	. . .
l1871h:
	cp 0b1h			;1871	fe b1		. .
	jr nz,l187ah		;1873	20 05		  .
	set 0,(hl)		;1875	cb c6		. .
	jp l1916h		;1877	c3 16 19	. . .
l187ah:
	cp 0a0h			;187a	fe a0		. .
	jr nz,l1883h		;187c	20 05		  .
	res 7,(hl)		;187e	cb be		. .
	jp l1916h		;1880	c3 16 19	. . .
l1883h:
	cp 0b0h			;1883	fe b0		. .
	jr nz,l188ch		;1885	20 05		  .
	set 7,(hl)		;1887	cb fe		. .
	jp l1916h		;1889	c3 16 19	. . .
l188ch:
	ld a,(04f76h)		;188c	3a 76 4f	: v O
	ld (04f77h),a		;188f	32 77 4f	2 w O
	ld a,(CFG7)		;1892	3a 3c 00	: < .
	cp 0bbh			;1895	fe bb		. .
	jr nz,l18b0h		;1897	20 17		  .
	ld a,(04f76h)		;1899	3a 76 4f	: v O
	cp 098h			;189c	fe 98		. .
	jr nz,l18b0h		;189e	20 10		  .
	ld a,b			;18a0	78		x
	cp 013h			;18a1	fe 13		. .
	jp z,l19a4h		;18a3	ca a4 19	. . .
	cp 08fh			;18a6	fe 8f		. .
	jp z,l19a4h		;18a8	ca a4 19	. . .
	cp 009h			;18ab	fe 09		. .
	jp z,l19a4h		;18ad	ca a4 19	. . .
l18b0h:
	ld a,(05cbah)		;18b0	3a ba 5c	: . \
	cp 001h			;18b3	fe 01		. .
	jr nz,l18c3h		;18b5	20 0c		  .
	ld a,b			;18b7	78		x
	cp 099h			;18b8	fe 99		. .
	call z,08fa5h		;18ba	cc a5 8f	. . .
	ld a,b			;18bd	78		x
	out (PORT_14),a		;18be	d3 14		. .
	jp NEXT_KEY		;18c0	c3 d6 17	. . .
l18c3h:
	ld a,b			;18c3	78		x
	ld (04f76h),a		;18c4	32 76 4f	2 v O
	bit 4,(hl)		;18c7	cb 66		. f
	jr nz,l190ah		;18c9	20 3f		  ?
	cp 091h			;18cb	fe 91		. .
l18cdh:
	jr c,l18f7h		;18cd	38 28		8 (
	cp 09eh			;18cf	fe 9e		. .
	jr c,l190eh		;18d1	38 3b		8 ;
	cp 0e4h			;18d3	fe e4		. .
	jr z,l190eh		;18d5	28 37		( 7
	cp 0f0h			;18d7	fe f0		. .
	jr nc,l190eh		;18d9	30 33		0 3
	cp 0dch			;18db	fe dc		. .
	jr z,l190eh		;18dd	28 2f		( /
	cp 0d2h			;18df	fe d2		. .
	jr z,l190eh		;18e1	28 2b		( +
	cp 0d3h			;18e3	fe d3		. .
	jr z,l190eh		;18e5	28 27		( '
	cp 0d4h			;18e7	fe d4		. .
	jr z,l190eh		;18e9	28 23		( #
	cp 0d5h			;18eb	fe d5		. .
	jr z,l190eh		;18ed	28 1f		( .
	cp 0a4h			;18ef	fe a4		. .
	jr z,l190eh		;18f1	28 1b		( .
	cp 0a5h			;18f3	fe a5		. .
	jr z,l190eh		;18f5	28 17		( .
l18f7h:
	bit 1,(hl)		;18f7	cb 4e		. N
	jr z,l190ah		;18f9	28 0f		( .
	res 1,(hl)		;18fb	cb 8e		. .
	call sub_2295h		;18fd	cd 95 22	. . "
	call FUN_05		;1900	cd dd 1b	. . .
	M_OUT_CH 0x0e
	ld a,(04f76h)
l190ah:
	pop hl			;190a	e1		.
	pop de			;190b	d1		.
	pop bc			;190c	c1		.
	ret			;190d	c9		.
l190eh:
	res 1,(hl)		;190e	cb 8e		. .
	ld sp,04ff1h		;1910	31 f1 4f	1 . O
	jp l178fh		;1913	c3 8f 17	. . .
l1916h:
	ld b,a			;1916	47		G
	ld a,(05cbah)		;1917	3a ba 5c	: . \
	cp 001h			;191a	fe 01		. .
	jp nz,l17aah		;191c	c2 aa 17	. . .
	ld a,b			;191f	78		x
	out (PORT_14),a		;1920	d3 14		. .
	jp l17aah		;1922	c3 aa 17	. . .
l1925h:
	xor a			;1925	af		.
	call SETMEMMAP	;1926	cd 1a 0f	. . .
	call sub_223fh		;1929	cd 3f 22	. ? "
	call FUN_05		;192c	cd dd 1b	. . .
	M_OUT_CH 0x0e
	ret
l1934h:
	ld hl,FLAGS		;1934	21 79 4f	! y O
	set 1,(hl)		;1937	cb ce		. .
	xor a			;1939	af		.
	jp SETMEMMAP	;193a	c3 1a 0f	. . .
	add a,a			;193d	87		.
	add a,l			;193e	85		.
	ld l,a			;193f	6f		o
	ld a,000h		;1940	3e 00		> .
	adc a,h			;1942	8c		.
	ld h,a			;1943	67		g
	ld a,(hl)		;1944	7e		~
	inc hl			;1945	23		#
	ld h,(hl)		;1946	66		f
	ld l,a			;1947	6f		o
	ret			;1948	c9		.

; SHIFT + EDIT in main menu
FUN_D9:
	call sub_1b0dh		;1949	cd 0d 1b	. . .
	M_OUT_MSG 0xd000, 0x11 ; "SOFTWARE VERSION "
	ld a,(05cbah)
	cp 005h
	jr nz,OUTVERSION
	ld a,0x56
	ld hl,0
	call 088dch
	ld a,(05cc6h)
	jr OUTA44

OUTVERSION:
	ld a,(VERSION)
OUTA44:	; Outputs A as a 4.4 fixed point number
	call NUM2_2HEX2
	ld a,b
	call OUT_CH
	ld a,'.'
	call OUT_CH
	ld a,c
	call OUT_CH
	ld a,CRLF
	call OUT_CH
l197eh:
	call NEXT_MACRO_OR_KEY
	cp 0x1b				; ESC
	jp nz,l1925h
SHIFT_EDIT_CMDS:	; SHIFT-EDIT ESC-CMDS
	call NEXT_MACRO_OR_KEY
	cp 'F'
	jr z,CMD_FILL_WORDS
	cp 'D'
	jp z,CMD_DUMP
	cp 'S'
	jp z,CMD_STORE_BYTES
	cp 'P'
	jp z,l1a78h		;1999	ca 78 1a	. x .
	cp 'C'
	jp l1a95h		;
	jp l1925h		; Never called, prob bug (jp z on previous line) or obfuscation to prevent commands discovery

l19a4h:
	ld sp,04ff1h		;19a4	31 f1 4f	1 . O
	ld hl,TASK_1		;19a7	21 66 17	! f .
	push hl			;19aa	e5		.
	call sub_2a82h		;19ab	cd 82 2a	. . *
	M_OUT_MSG 0xd011, 0x36 ; "TO DISCONNECT BATTERY BACKUP" CRLF "FOR SHIPPING TYPE CTRL-D" CRLF 
	ld de,FIFO_KBD		;19b4	11 e4 40	. . @
l19b7h:
	call FIFO_READ		;19b7	cd e1 0e	. . .
	jr nc,l19c1h		;19ba	30 05		0 .
	call sub_0334h		;19bc	cd 34 03	. 4 .
	jr l19b7h		;19bf	18 f6		. .
l19c1h:
	cp 004h			;19c1	fe 04		. .
	jr nz,l19d0h		;19c3	20 0b		  .
	M_OUT_MSG 0xd047, 0x23 ; "BATTERY DISCONNECTED" CRLF "TURN POWER OFF"
	out (PORT_70),a		;19cb	d3 70		. p
	jp l1934h		;19cd	c3 34 19	. 4 .
l19d0h:
	M_OUT_MSG 0xd06a, 0x10 ; "REQUEST CANCELED"
	jp l1934h

OUT_A_HEX2:
	push bc
	call NUM2_2HEX2
	ld a,b
	call OUT_CH
	ld a,c
	call OUT_CH
	pop bc
	ret

; CMD_FILL_WORDS
; 	Enter ADRS, DATA, LENGTH (in bytes)
;   Fills ADRS to ADRS+LENGTH-1 with DATA, as words, big endian
CMD_FILL_WORDS:
	call INPUT_HEX4
	ld h,b
	ld l,c
	ld d,b
	ld e,c
	call INPUT_HEX4
	ld (hl),b
	inc hl
	ld (hl),c
	inc hl
	ex de,hl
	call INPUT_HEX4
	dec bc
	dec bc
	ldir
	jp l197eh

; Reads between 0x0000 and 0xffff on the keyboard
; result in BC
INPUT_HEX4:
	call INPUT_HEX2		;1a00	cd 0b 1a	. . .
	push af			;1a03	f5		.
	call INPUT_HEX2		;1a04	cd 0b 1a	. . .
	ld c,a			;1a07	4f		O
	pop af			;1a08	f1		.
	ld b,a			;1a09	47		G
	ret			;1a0a	c9		.

; Reads between 0x00 and 0xff on the keyboard
; result in b
INPUT_HEX2:
	call NEXT_MACRO_OR_KEY	;1a0b	cd a7 17	. . .
	ld b,a			;1a0e	47		G
	call OUT_CH		;1a0f	cd 84 10	. . .
	call NEXT_MACRO_OR_KEY	;1a12	cd a7 17	. . .
	call OUT_CH		;1a15	cd 84 10	. . .
	ld c,a			;1a18	4f		O
	call HEX2_2NUM		;1a19	cd c0 1a	. . .
	ret			;1a1c	c9		.

; Dumpts from an address
CMD_DUMP:
	call READ_ADRS		;1a1d	cd 6a 1a	. j .
	ld b,018h		;1a20	06 18		. .
l1a22h:
	ld a,005h		;1a22	3e 05		> .
	call OUT_CH		;1a24	cd 84 10	. . .
	ld a,h			;1a27	7c		|
	call OUT_A_HEX2		;1a28	cd d9 19	. . .
	ld a,l			;1a2b	7d		}
	call OUT_A_HEX2		;1a2c	cd d9 19	. . .
	push hl			;1a2f	e5		.
l1a30h:
	M_RIGHT 1
	ld a,(hl)
	call OUT_A_HEX2
	inc hl			;1a38	23		#
	ld a,l			;1a39	7d		}
	and 007h		;1a3a	e6 07		. .
	jr nz,l1a30h		;1a3c	20 f2		  .
	M_RIGHT 2
	pop hl			;1a42	e1		.
l1a43h:
	ld a,(hl)		;1a43	7e		~
	cp 020h			;1a44	fe 20		.  
	jr c,l1a50h		;1a46	38 08		8 .
	cp 0a0h			;1a48	fe a0		. .
	jr nc,l1a50h		;1a4a	30 04		0 .
	cp 07fh			;1a4c	fe 7f		. .
	jr nz,l1a52h		;1a4e	20 02		  .
l1a50h:
	ld a,02eh		;1a50	3e 2e		> .
l1a52h:
	call OUT_CH		;1a52	cd 84 10	. . .
	inc hl			;1a55	23		#
	ld a,l			;1a56	7d		}
	and 007h		;1a57	e6 07		. .
	jr nz,l1a43h		;1a59	20 e8		  .
	djnz l1a22h		;1a5b	10 c5		. .
	jp l197eh		;1a5d	c3 7e 19	. ~ .

; Fill data at an address
CMD_STORE_BYTES:
	call READ_ADRS
_loop:
	call INPUT_HEX2
	ld (hl),a
	inc hl
	jr _loop

; READs AN ADDRESS + CRLF
READ_ADRS:
	call sub_1b0dh
	call INPUT_HEX4
	ld a,CRLF
	call OUT_CH
	ld h,b
	ld l,c
	ret

l1a78h:
	call sub_1b0dh		;1a78	cd 0d 1b	. . .
	call NEXT_MACRO_OR_KEY
	call OUT_CH
	and %00001111
	ld (vDBG_LEVEL),a
_loop:
	call NEXT_MACRO_OR_KEY
	cp 0x1b				; ESC
	jr nz,_loop
	ld a,000h		;1a8d	3e 00		> .
	ld (vDBG_LEVEL),a		;1a8f	32 b9 5c	2 . \
	jp SHIFT_EDIT_CMDS		;1a92	c3 86 19	. . .

l1a95h:
	ld a,0x0f
	out (PORT_20),a
	ld a,0x00
	out (PORT_2F),a
	call NEXT_MACRO_OR_KEY
	jp l1925h

; Input a = 0xNM
; Output (b,c) ascii values of N and M
; Example : 13 => b=0x31, c=0x33
;         : 3F => b=0x33, c=0x46
NUM2_2HEX2:
	ld b,a
	and %00001111
	call NUM1_2HEX1
	ld c,a
	ld a,b
	srl a
	srl a
	srl a
	srl a
	call NUM1_2HEX1
	ld b,a
	ret

; Input a = 0..f
; Output a = '0'..'9','A'..'F'
NUM1_2HEX1:
	add a,'0'
	cp '9'+1
	ret c
	add a,'A'-('9'+1)
	ret

; INPUT (b,c) = 2 ASCII chars
; OUTPUT B = value of the hex number represented by the 2 chars
; 0x33, 0x37 => 0x37
; 0x42, 0x43 => 0xB3
HEX2_2NUM:
	ld a,b			;1ac0	78		x
	call HEX1_2NUM1		;1ac1	cd d3 1a	. . .
	ld b,a			;1ac4	47		G
	ld a,c			;1ac5	79		y
	call HEX1_2NUM1		;1ac6	cd d3 1a	. . .
	sla b			;1ac9	cb 20		.  
	sla b			;1acb	cb 20		.  
	sla b			;1acd	cb 20		.  
	sla b			;1acf	cb 20		.  
	or b			;1ad1	b0		.
	ret			;1ad2	c9		.

; ASCII to HEX
; INPUT : A = ASCII
; OUTPUT : A = HEX
; '3' 0x33 => 0x03
; 'B' 0x42 => 0x0B
; carry flag set if result is valid
; Error handling seems incoherent (A<'0' will have different behavior than A>'F')
HEX1_2NUM1:
	sub '0'
	cp 10
	ret c			; lower than '0', just return with carry set
	sub 'A'-('9'+1)	; 'A' => '9'+1
	res 5,a			; ASCII to number
	cp 10			; 
	jr c,_throw		; higher than 'F', return with carry set but one stack frame earlier
	cp 16
	ret
_throw:
	pop bc			; Skip one return!
	scf
	ret

; Weird routine maybe some debug. Displays a as char or '*HEX2'. Does nothing if the content of vDBG_LEVEL is zero or not equal to b.
LOG_CHAR:
	push af
	ld a,(vDBG_LEVEL)
	or a
	jr z,_exit		; exit if A==0
	cp b
	jr nz,_exit		; exit if A!=B
	pop af
	push af
	cp ' '
	jr c,_print_star_hex		;1af4	38 09		8 .
	cp 'z'+1
	jr nc,_print_star_hex		;1af8	30 05		0 .
	call OUT_CH		;1afa	cd 84 10	. . .
	jr _exit		;1afd	18 0c		. .

_print_star_hex:
	push bc
	ld b,a
	ld a,'*'
	call OUT_CH
	ld a,b
	call OUT_A_HEX2
	pop bc
_exit:
	pop af
	ret

sub_1b0dh:
	call sub_2a82h
	ld de,04185h
	call ADJUSTDE
	ld h,d			;1b16	62		b
	ld l,e			;1b17	6b		k
	ld de,67
	ld b,26
_loop:
	ld (hl),0c8h		;1b1d	36 c8		6 .
	add hl,de		;1b1f	19		.
	djnz _loop		;1b20	10 fb		. .
	ret			;1b22	c9		.

; This is "handle printables characters"
FUN_20: ; and others
	ld a,(FLAGS)		;1b23	3a 79 4f	: y O
	bit 7,a			;1b26	cb 7f		. .
	jr z,l1b6ah		;1b28	28 40		( @
	ld a,(04f76h)		;1b2a	3a 76 4f	: v O
	cp 040h			;1b2d	fe 40		. @
	jr nc,l1b5bh		;1b2f	30 2a		0 *
	res 4,a			;1b31	cb a7		. .
	cp 02bh			;1b33	fe 2b		. +
	jr nz,l1b3bh		;1b35	20 04		  .
	ld a,09ch		;1b37	3e 9c		> .
	jr l1b67h		;1b39	18 2c		. ,
l1b3bh:
	cp 02ah			;1b3b	fe 2a		. *
	jr nz,l1b43h		;1b3d	20 04		  .
	ld a,09dh		;1b3f	3e 9d		> .
	jr l1b67h		;1b41	18 24		. $
l1b43h:
	cp 02ch			;1b43	fe 2c		. ,
	jr nz,l1b4bh		;1b45	20 04		  .
	ld a,09eh		;1b47	3e 9e		> .
	jr l1b67h		;1b49	18 1c		. .
l1b4bh:
	cp 02eh			;1b4b	fe 2e		. .
	jr nz,l1b53h		;1b4d	20 04		  .
	ld a,09fh		;1b4f	3e 9f		> .
	jr l1b67h		;1b51	18 14		. .
l1b53h:
	cp 02fh			;1b53	fe 2f		. /
	jr nz,l1b6ah		;1b55	20 13		  .
	ld a,080h		;1b57	3e 80		> .
	jr l1b67h		;1b59	18 0c		. .
l1b5bh:
	set 5,a			;1b5b	cb ef		. .
	cp 060h			;1b5d	fe 60		. `
	jr z,l1b6ah		;1b5f	28 09		( .
	cp 07ch			;1b61	fe 7c		. |
	jr nc,l1b6ah		;1b63	30 05		0 .
	add a,020h		;1b65	c6 20		.  
l1b67h:
	ld (04f76h),a		;1b67	32 76 4f	2 v O
l1b6ah:
	ld a,(04f76h)		;1b6a	3a 76 4f	: v O
l1b6dh:
	ld hl,(04f80h)		;1b6d	2a 80 4f	* . O
	ld (hl),a		;1b70	77		w
	call OUT_CH		;1b71	cd 84 10	. . .
	inc hl			;1b74	23		#
	ld (04f80h),hl		;1b75	22 80 4f	" . O
	ld a,(04f82h)		;1b78	3a 82 4f	: . O
	inc a			;1b7b	3c		<
	ld b,a			;1b7c	47		G
	call sub_22bah		;1b7d	cd ba 22	. . "
	ld c,a			;1b80	4f		O
	ld a,b			;1b81	78		x
	cp c			;1b82	b9		.
	jr z,l1b89h		;1b83	28 04		( .
	ld (04f82h),a		;1b85	32 82 4f	2 . O
	ret			;1b88	c9		.
l1b89h:
	ld a,(04f8bh)		;1b89	3a 8b 4f	: . O
	dec a			;1b8c	3d		=
	ld b,a			;1b8d	47		G
	ld a,(04f83h)		;1b8e	3a 83 4f	: . O
	cp b			;1b91	b8		.
	jr z,l1b9ch		;1b92	28 08		( .
	inc a			;1b94	3c		<
	ld (04f83h),a		;1b95	32 83 4f	2 . O
	xor a			;1b98	af		.
	ld (04f82h),a		;1b99	32 82 4f	2 . O
l1b9ch:
	call sub_22a1h		;1b9c	cd a1 22	. . "
	call sub_2290h		;1b9f	cd 90 22	. . "
	ret			;1ba2	c9		.
sub_1ba3h:
	ld a,(04f76h)		;1ba3	3a 76 4f	: v O
	call OUT_CH		;1ba6	cd 84 10	. . .
	ret			;1ba9	c9		.

; Backspace + space + backspace
FUN_7F:
	ld hl,04f76h
	ld (hl),008h
	push hl
	call FUN_08
	pop hl
	ld (hl),' '
	push hl
	call FUN_20
	pop hl
	ld (hl),008h
	call FUN_08
	ret

FUN_C1:
	ld a,0fah
	jr l1b6dh

FUN_C2:
	ld a,0fdh
	jr l1b6dh

FUN_C3:
	ld a,0f1h
	jr l1b6dh

FUN_E3:
	ld a,0f0h
	jr l1b6dh

FUN_E0:
	ld a,0fbh
	jr l1b6dh

FUN_E1:
	ld a,0feh
	jr l1b6dh

FUN_E2:
	ld a,0fch
	jr l1b6dh

FUN_05:
	call sub_1be6h		;1bdd	cd e6 1b	. . .
	ld a,004h		;1be0	3e 04		> .
	call OUT_CH		;1be2	cd 84 10	. . .
	ret			;1be5	c9		.

sub_1be6h:
	ld hl,04ac6h		;1be6	21 c6 4a	! . J
	ld (04f80h),hl		;1be9	22 80 4f	" . O
	xor a			;1bec	af		.
	ld (04f82h),a		;1bed	32 82 4f	2 . O
	ld (04f83h),a		;1bf0	32 83 4f	2 . O
	ret			;1bf3	c9		.

FUN_06:
	ld a,(04f8bh)		;1bf4	3a 8b 4f	: . O
	dec a			;1bf7	3d		=
	ld b,a			;1bf8	47		G
	ld a,(04f83h)		;1bf9	3a 83 4f	: . O
	cp b			;1bfc	b8		.
	jr z,l1c03h		;1bfd	28 04		( .
	inc a			;1bff	3c		<
	ld (04f83h),a		;1c00	32 83 4f	2 . O
l1c03h:
	xor a			;1c03	af		.
	ld (04f82h),a		;1c04	32 82 4f	2 . O
	call sub_22a1h		;1c07	cd a1 22	. . "
	call sub_2290h		;1c0a	cd 90 22	. . "
	ret			;1c0d	c9		.

FUN_0B:
	ld a,(04f8bh)		;1c0e	3a 8b 4f	: . O
	dec a			;1c11	3d		=
	ld b,a			;1c12	47		G
	ld a,(04f83h)		;1c13	3a 83 4f	: . O
	cp b			;1c16	b8		.
	ret z			;1c17	c8		.
	inc a			;1c18	3c		<
	ld (04f83h),a		;1c19	32 83 4f	2 . O
	ld hl,(04f80h)		;1c1c	2a 80 4f	* . O
	ld de,00028h		;1c1f	11 28 00	. ( .
	add hl,de		;1c22	19		.
	ld (04f80h),hl		;1c23	22 80 4f	" . O
	call sub_2242h		;1c26	cd 42 22	. B "
	ret			;1c29	c9		.

FUN_0C:
	ld a,(04f83h)		;1c2a	3a 83 4f	: . O
	dec a			;1c2d	3d		=
	ret m			;1c2e	f8		.
	ld (04f83h),a		;1c2f	32 83 4f	2 . O
	ld hl,(04f80h)		;1c32	2a 80 4f	* . O
	ld de,00028h		;1c35	11 28 00	. ( .
	xor a			;1c38	af		.
	sbc hl,de		;1c39	ed 52		. R
	ld (04f80h),hl		;1c3b	22 80 4f	" . O
	call sub_1ba3h		;1c3e	cd a3 1b	. . .
	ret			;1c41	c9		.

FUN_09:
	call sub_22bah		;1c42	cd ba 22	. . "
	ld b,a			;1c45	47		G
	dec b			;1c46	05		.
	ld a,(04f82h)		;1c47	3a 82 4f	: . O
	cp b			;1c4a	b8		.
	jr nc,l1c5ch		;1c4b	30 0f		0 .
	inc a			;1c4d	3c		<
	ld (04f82h),a		;1c4e	32 82 4f	2 . O
	ld hl,(04f80h)		;1c51	2a 80 4f	* . O
	inc hl			;1c54	23		#
	ld (04f80h),hl		;1c55	22 80 4f	" . O
	call sub_1ba3h		;1c58	cd a3 1b	. . .
	ret			;1c5b	c9		.
l1c5ch:
	ld a,(04f8bh)		;1c5c	3a 8b 4f	: . O
	dec a			;1c5f	3d		=
	ld b,a			;1c60	47		G
	ld a,(04f83h)		;1c61	3a 83 4f	: . O
	cp b			;1c64	b8		.
	ret z			;1c65	c8		.
	inc a			;1c66	3c		<
	ld (04f83h),a		;1c67	32 83 4f	2 . O
	xor a			;1c6a	af		.
	ld (04f82h),a		;1c6b	32 82 4f	2 . O
	call sub_22a1h		;1c6e	cd a1 22	. . "
	call sub_2242h		;1c71	cd 42 22	. B "
	ret			;1c74	c9		.

FUN_08:
	ld a,(04f82h)		;1c75	3a 82 4f	: . O
	or a			;1c78	b7		.
	jr z,l1c8ah		;1c79	28 0f		( .
	dec a			;1c7b	3d		=
	ld (04f82h),a		;1c7c	32 82 4f	2 . O
	ld hl,(04f80h)		;1c7f	2a 80 4f	* . O
	dec hl			;1c82	2b		+
	ld (04f80h),hl		;1c83	22 80 4f	" . O
	call sub_1ba3h		;1c86	cd a3 1b	. . .
	ret			;1c89	c9		.
l1c8ah:
	ld a,(04f83h)		;1c8a	3a 83 4f	: . O
	or a			;1c8d	b7		.
	ret z			;1c8e	c8		.
	dec a			;1c8f	3d		=
	ld (04f83h),a		;1c90	32 83 4f	2 . O
	call sub_22bah		;1c93	cd ba 22	. . "
	dec a			;1c96	3d		=
	ld (04f82h),a		;1c97	32 82 4f	2 . O
	call sub_22a1h		;1c9a	cd a1 22	. . "
	call sub_2290h		;1c9d	cd 90 22	. . "
	ret			;1ca0	c9		.

FUN_03:
	ld hl,04ed5h		;1ca1	21 d5 4e	! . N
	ld bc,(04f80h)		;1ca4	ed 4b 80 4f	. K . O
	xor a			;1ca8	af		.
	sbc hl,bc		;1ca9	ed 42		. B
	ld b,h			;1cab	44		D
	ld c,l			;1cac	4d		M
	jr l1cb9h		;1cad	18 0a		. .

FUN_04:
	ld a,027h		;1caf	3e 27		> '
	ld hl,04f82h		;1cb1	21 82 4f	! . O
	ld b,(hl)		;1cb4	46		F
	sub b			;1cb5	90		.
	ld c,a			;1cb6	4f		O
	ld b,000h		;1cb7	06 00		. .
l1cb9h:
	ld a,020h		;1cb9	3e 20		>  
	ld hl,(04f80h)		;1cbb	2a 80 4f	* . O
	ld (hl),a		;1cbe	77		w
	ld d,h			;1cbf	54		T
	ld e,l			;1cc0	5d		]
	inc de			;1cc1	13		.
	ld a,b			;1cc2	78		x
	or c			;1cc3	b1		.
	jr z,l1cc8h		;1cc4	28 02		( .
	ldir			;1cc6	ed b0		. .
l1cc8h:
	call sub_1ba3h		;1cc8	cd a3 1b	. . .
	ret			;1ccb	c9		.

FUN_82:
	ld ix,(04f80h)		;1ccc	dd 2a 80 4f	. * . O
	ld hl,04ac6h		;1cd0	21 c6 4a	! . J
	ld (04f80h),hl		;1cd3	22 80 4f	" . O
	call sub_2249h		;1cd6	cd 49 22	. I "
	call FUN_03		;1cd9	cd a1 1c	. . .
	ld (04f80h),ix		;1cdc	dd 22 80 4f	. " . O
	jr l1cfch		;1ce0	18 1a		. .

FUN_83:
	ld hl,(04f80h)		;1ce2	2a 80 4f	* . O
	push hl			;1ce5	e5		.
	ld a,(04f82h)		;1ce6	3a 82 4f	: . O
	ld e,a			;1ce9	5f		_
	ld d,000h		;1cea	16 00		. .
	or a			;1cec	b7		.
	sbc hl,de		;1ced	ed 52		. R
	ld (04f80h),hl		;1cef	22 80 4f	" . O
	call sub_2249h		;1cf2	cd 49 22	. I "
	call FUN_04		;1cf5	cd af 1c	. . .
	pop hl			;1cf8	e1		.
	ld (04f80h),hl		;1cf9	22 80 4f	" . O
l1cfch:
	call sub_2295h		;1cfc	cd 95 22	. . "
	call sub_2249h		;1cff	cd 49 22	. I "
	call sub_2290h		;1d02	cd 90 22	. . "
	ret			;1d05	c9		.
sub_1d06h:
	push hl			;1d06	e5		.
	push de			;1d07	d5		.
	push bc			;1d08	c5		.
	push af			;1d09	f5		.
	ld a,(04f83h)		;1d0a	3a 83 4f	: . O
	push af			;1d0d	f5		.
	ld a,b			;1d0e	78		x
	ld (04f83h),a		;1d0f	32 83 4f	2 . O
	call sub_22bah		;1d12	cd ba 22	. . "
	ld (05bb4h),a		;1d15	32 b4 5b	2 . [
	inc c			;1d18	0c		.
	sub c			;1d19	91		.
	ld e,a			;1d1a	5f		_
	ld d,000h		;1d1b	16 00		. .
	ld (05bb6h),de		;1d1d	ed 53 b6 5b	. S . [
	pop af			;1d21	f1		.
	ld (04f83h),a		;1d22	32 83 4f	2 . O
	pop af			;1d25	f1		.
	pop bc			;1d26	c1		.
	push bc			;1d27	c5		.
	push af			;1d28	f5		.
	ld hl,04a9eh		;1d29	21 9e 4a	! . J
	inc b			;1d2c	04		.
	ld de,00028h		;1d2d	11 28 00	. ( .
l1d30h:
	add hl,de		;1d30	19		.
	djnz l1d30h		;1d31	10 fd		. .
	ld a,(05bb4h)		;1d33	3a b4 5b	: . [
	dec a			;1d36	3d		=
	ld e,a			;1d37	5f		_
	ld d,000h		;1d38	16 00		. .
	add hl,de		;1d3a	19		.
	ld d,h			;1d3b	54		T
	ld e,l			;1d3c	5d		]
	dec hl			;1d3d	2b		+
	ld a,(de)		;1d3e	1a		.
	pop bc			;1d3f	c1		.
	push af			;1d40	f5		.
	push bc			;1d41	c5		.
	ld bc,(05bb6h)		;1d42	ed 4b b6 5b	. K . [
	ld a,c			;1d46	79		y
	or a			;1d47	b7		.
	jr z,l1d50h		;1d48	28 06		( .
	cp 028h			;1d4a	fe 28		. (
	jr nc,l1d50h		;1d4c	30 02		0 .
	lddr			;1d4e	ed b8		. .
l1d50h:
	pop af			;1d50	f1		.
	ld (de),a		;1d51	12		.
	pop af			;1d52	f1		.
	pop bc			;1d53	c1		.
	pop de			;1d54	d1		.
	pop hl			;1d55	e1		.
	ret			;1d56	c9		.

FUN_8F:
	ld a,(04f82h)		;1d57	3a 82 4f	: . O
	ld c,a			;1d5a	4f		O
	ld a,(04f83h)		;1d5b	3a 83 4f	: . O
	ld b,a			;1d5e	47		G
	ld a,020h		;1d5f	3e 20		>  
	call sub_1d06h		;1d61	cd 06 1d	. . .
	ld d,a			;1d64	57		W
	ld a,(FLAGS)
	bit 0,a			;1d68	cb 47		. G
	jr z,l1d7bh		;1d6a	28 0f		( .
	ld c,000h		;1d6c	0e 00		. .
l1d6eh:
	inc b			;1d6e	04		.
	ld a,b			;1d6f	78		x
	cp 01ah			;1d70	fe 1a		. .
	jr nc,l1d7bh		;1d72	30 07		0 .
	ld a,d			;1d74	7a		z
	call sub_1d06h		;1d75	cd 06 1d	. . .
	ld d,a			;1d78	57		W
	jr l1d6eh		;1d79	18 f3		. .
l1d7bh:
	call l1cfch		;1d7b	cd fc 1c	. . .
	ret			;1d7e	c9		.
sub_1d7fh:
	push hl			;1d7f	e5		.
	push af			;1d80	f5		.
	push bc			;1d81	c5		.
	push de			;1d82	d5		.
	ld hl,04a9eh		;1d83	21 9e 4a	! . J
	ld de,00028h		;1d86	11 28 00	. ( .
	inc b			;1d89	04		.
l1d8ah:
	add hl,de		;1d8a	19		.
	djnz l1d8ah		;1d8b	10 fd		. .
	add hl,bc		;1d8d	09		.
	pop de			;1d8e	d1		.
	cp 001h			;1d8f	fe 01		. .
	jr nz,l1d95h		;1d91	20 02		  .
	ld a,(hl)		;1d93	7e		~
	ld (de),a		;1d94	12		.
l1d95h:
	pop bc			;1d95	c1		.
	push bc			;1d96	c5		.
	ld a,(04f83h)		;1d97	3a 83 4f	: . O
	push af			;1d9a	f5		.
	ld a,b			;1d9b	78		x
	ld (04f83h),a		;1d9c	32 83 4f	2 . O
	call sub_22bah		;1d9f	cd ba 22	. . "
	sub c			;1da2	91		.
	ld c,a			;1da3	4f		O
	ld b,000h		;1da4	06 00		. .
	pop af			;1da6	f1		.
	ld (04f83h),a		;1da7	32 83 4f	2 . O
	ld d,h			;1daa	54		T
	ld e,l			;1dab	5d		]
	inc hl			;1dac	23		#
	dec c			;1dad	0d		.
	ld a,c			;1dae	79		y
	jr z,l1db7h		;1daf	28 06		( .
	cp 028h			;1db1	fe 28		. (
	jr nc,l1db7h		;1db3	30 02		0 .
	ldir			;1db5	ed b0		. .
l1db7h:
	ld a,020h		;1db7	3e 20		>  
	ld (de),a		;1db9	12		.
	pop bc			;1dba	c1		.
	pop af			;1dbb	f1		.
	pop hl			;1dbc	e1		.
	ret			;1dbd	c9		.

FUN_86:
	ld a,(04f82h)		;1dbe	3a 82 4f	: . O
	ld c,a			;1dc1	4f		O
	ld a,(04f83h)		;1dc2	3a 83 4f	: . O
	ld b,a			;1dc5	47		G
	ld a,000h		;1dc6	3e 00		> .
	call sub_1d7fh		;1dc8	cd 7f 1d	. . .
	ld a,(FLAGS)
	bit 0,a			;1dce	cb 47		. G
	jr z,l1de1h		;1dd0	28 0f		( .
	ld c,000h		;1dd2	0e 00		. .
l1dd4h:
	inc b			;1dd4	04		.
	ld a,b			;1dd5	78		x
	cp 01ah			;1dd6	fe 1a		. .
	jr nc,l1de1h		;1dd8	30 07		0 .
	ld a,001h		;1dda	3e 01		> .
	call sub_1d7fh		;1ddc	cd 7f 1d	. . .
	jr l1dd4h		;1ddf	18 f3		. .
l1de1h:
	call l1cfch		;1de1	cd fc 1c	. . .
	ret			;1de4	c9		.
FUN_81:
	ld a,(04f83h)		;1de5	3a 83 4f	: . O
	ld b,a			;1de8	47		G
	ld a,019h		;1de9	3e 19		> .
	sub b			;1deb	90		.
	ld hl,0fffch		;1dec	21 fc ff	! . .
	ld de,4		;1def	11 04 00	. . .
	ld b,a			;1df2	47		G
	push bc			;1df3	c5		.
	inc b			;1df4	04		.
l1df5h:
	add hl,de		;1df5	19		.
	djnz l1df5h		;1df6	10 fd		. .
	ld b,h			;1df8	44		D
	ld c,l			;1df9	4d		M
	ld de,04ab5h		;1dfa	11 b5 4a	. . J
	ld hl,04ab1h		;1dfd	21 b1 4a	! . J
	ld a,b			;1e00	78		x
	or c			;1e01	b1		.
	jr z,l1e06h		;1e02	28 02		( .
	lddr			;1e04	ed b8		. .
l1e06h:
	pop bc			;1e06	c1		.
	inc b			;1e07	04		.
	ld hl,0ffd8h		;1e08	21 d8 ff	! . .
	ld de,00028h		;1e0b	11 28 00	. ( .
l1e0eh:
	add hl,de		;1e0e	19		.
	djnz l1e0eh		;1e0f	10 fd		. .
	ld b,h			;1e11	44		D
	ld c,l			;1e12	4d		M
	ld de,04ed5h		;1e13	11 d5 4e	. . N
	ld hl,04eadh		;1e16	21 ad 4e	! . N
	ld a,b			;1e19	78		x
	or c			;1e1a	b1		.
	jr z,l1e1fh		;1e1b	28 02		( .
	lddr			;1e1d	ed b8		. .
l1e1fh:
	inc hl			;1e1f	23		#
	ld d,h			;1e20	54		T
	ld e,l			;1e21	5d		]
	inc de			;1e22	13		.
	ld (hl),020h		;1e23	36 20		6  
	ld bc,00027h		;1e25	01 27 00	. ' .
	ldir			;1e28	ed b0		. .
	ld hl,(v4f89)		;1e2a	2a 89 4f	* . O
	inc hl			;1e2d	23		#
	inc hl			;1e2e	23		#
	call sub_1eeah		;1e2f	cd ea 1e	. . .
	jp nz,l1cfch		;1e32	c2 fc 1c	. . .
	ld a,(04f83h)		;1e35	3a 83 4f	: . O
	cp 010h			;1e38	fe 10		. .
	jp nc,l1cfch		;1e3a	d2 fc 1c	. . .
	ld hl,04a8eh		;1e3d	21 8e 4a	! . J
	ld de,v53c2		;1e40	11 c2 53	. . S
	ld bc,4		;1e43	01 04 00	. . .
	ldir			;1e46	ed b0		. .
	ld hl,04d46h		;1e48	21 46 4d	! F M
	ld bc,00028h		;1e4b	01 28 00	. ( .
	ldir			;1e4e	ed b0		. .
	ld bc,00027h		;1e50	01 27 00	. ' .
	ld hl,04d46h		;1e53	21 46 4d	! F M
	ld de,04d47h		;1e56	11 47 4d	. G M
	ld (hl),020h		;1e59	36 20		6  
	ldir			;1e5b	ed b0		. .
	call sub_2048h		;1e5d	cd 48 20	. H  
	call l1cfch		;1e60	cd fc 1c	. . .
	ret			;1e63	c9		.

FUN_8E:
	ld a,(04f83h)		;1e64	3a 83 4f	: . O
	ld b,a			;1e67	47		G
	ld a,019h		;1e68	3e 19		> .
	sub b			;1e6a	90		.
	ld b,a			;1e6b	47		G
	inc b			;1e6c	04		.
	push bc			;1e6d	c5		.
	ld hl,0fffch		;1e6e	21 fc ff	! . .
	ld de,4		;1e71	11 04 00	. . .
l1e74h:
	add hl,de		;1e74	19		.
	djnz l1e74h		;1e75	10 fd		. .
	push hl			;1e77	e5		.
	ld a,(04f83h)		;1e78	3a 83 4f	: . O
	ld b,a			;1e7b	47		G
	ld hl,04a4ah		;1e7c	21 4a 4a	! J J
	inc b			;1e7f	04		.
l1e80h:
	add hl,de		;1e80	19		.
	djnz l1e80h		;1e81	10 fd		. .
	push hl			;1e83	e5		.
	add hl,de		;1e84	19		.
	pop de			;1e85	d1		.
	pop bc			;1e86	c1		.
	ld a,b			;1e87	78		x
	or c			;1e88	b1		.
	jr z,l1e8dh		;1e89	28 02		( .
	ldir			;1e8b	ed b0		. .
l1e8dh:
	pop bc			;1e8d	c1		.
	ld hl,0ffd8h		;1e8e	21 d8 ff	! . .
	ld de,00028h		;1e91	11 28 00	. ( .
l1e94h:
	add hl,de		;1e94	19		.
	djnz l1e94h		;1e95	10 fd		. .
	push hl			;1e97	e5		.
	ld a,(04f83h)		;1e98	3a 83 4f	: . O
	ld b,a			;1e9b	47		G
	ld hl,04a9eh		;1e9c	21 9e 4a	! . J
	inc b			;1e9f	04		.
l1ea0h:
	add hl,de		;1ea0	19		.
	djnz l1ea0h		;1ea1	10 fd		. .
	push hl			;1ea3	e5		.
	add hl,de		;1ea4	19		.
	pop de			;1ea5	d1		.
	pop bc			;1ea6	c1		.
	ld a,b			;1ea7	78		x
	or c			;1ea8	b1		.
	jr z,l1eadh		;1ea9	28 02		( .
	ldir			;1eab	ed b0		. .
l1eadh:
	ld h,d			;1ead	62		b
	ld l,e			;1eae	6b		k
	ld bc,00027h		;1eaf	01 27 00	. ' .
	inc de			;1eb2	13		.
	ld (hl),020h		;1eb3	36 20		6  
	ldir			;1eb5	ed b0		. .
	ld hl,(v4f89)		;1eb7	2a 89 4f	* . O
	inc hl			;1eba	23		#
	inc hl			;1ebb	23		#
	call sub_1eeah		;1ebc	cd ea 1e	. . .
	jp nz,l1cfch		;1ebf	c2 fc 1c	. . .
	ld a,(04f83h)		;1ec2	3a 83 4f	: . O
	cp 010h			;1ec5	fe 10		. .
	jp nc,l1cfch		;1ec7	d2 fc 1c	. . .
	call sub_206ah		;1eca	cd 6a 20	. j  
	ld hl,v53c2		;1ecd	21 c2 53	! . S
	ld a,(hl)		;1ed0	7e		~
	cp 0ffh			;1ed1	fe ff		. .
	jp z,l1cfch		;1ed3	ca fc 1c	. . .
	ld de,04a8ah		;1ed6	11 8a 4a	. . J
	ld bc,4		;1ed9	01 04 00	. . .
	ldir			;1edc	ed b0		. .
	ld de,04d1eh		;1ede	11 1e 4d	. . M
	ld bc,00028h		;1ee1	01 28 00	. ( .
	ldir			;1ee4	ed b0		. .
	call l1cfch		;1ee6	cd fc 1c	. . .
	ret			;1ee9	c9		.
sub_1eeah:
	push hl			;1eea	e5		.
	push de			;1eeb	d5		.
	push af			;1eec	f5		.
	push iy			;1eed	fd e5		. .
	ld iy,05faeh		;1eef	fd 21 ae 5f	. ! . _
	ld a,(05cbah)		;1ef3	3a ba 5c	: . \
	cp 005h			;1ef6	fe 05		. .
	jr nz,l1efeh		;1ef8	20 04		  .
	ld iy,05fb2h		;1efa	fd 21 b2 5f	. ! . _
l1efeh:
	ld a,(iy+002h)		;1efe	fd 7e 02	. ~ .
	or (iy+003h)		;1f01	fd b6 03	. . .
	ld b,a			;1f04	47		G
	ld a,000h		;1f05	3e 00		> .
	jr z,l1f21h		;1f07	28 18		( .
	ex de,hl		;1f09	eb		.
	ld h,(iy+003h)		;1f0a	fd 66 03	. f .
	ld l,b			;1f0d	68		h
	call CMP_HLDE		;1f0e	cd 20 0f	.   .
	jr c,l1f21h		;1f11	38 0e		8 .
	ex de,hl		;1f13	eb		.
	ld d,(iy+001h)		;1f14	fd 56 01	. V .
	ld e,(iy+000h)		;1f17	fd 5e 00	. ^ .
	call CMP_HLDE		;1f1a	cd 20 0f	.   .
	jr c,l1f21h		;1f1d	38 02		8 .
	ld a,001h		;1f1f	3e 01		> .
l1f21h:
	cp 001h			;1f21	fe 01		. .
	pop iy			;1f23	fd e1		. .
	pop hl			;1f25	e1		.
	ld a,h			;1f26	7c		|
	pop de			;1f27	d1		.
	pop hl			;1f28	e1		.
	ret			;1f29	c9		.
sub_1f2ah:
	push hl			;1f2a	e5		.
	ld hl,(v4f89)		;1f2b	2a 89 4f	* . O
	inc hl			;1f2e	23		#
	call sub_1eeah		;1f2f	cd ea 1e	. . .
	pop hl			;1f32	e1		.
	ret			;1f33	c9		.
sub_1f34h:
	ld hl,(v4f89)		;1f34	2a 89 4f	* . O
	inc hl			;1f37	23		#
	inc hl			;1f38	23		#
	ld (0542ah),hl		;1f39	22 2a 54	" * T
	ex de,hl		;1f3c	eb		.
	ld hl,(05fb0h)		;1f3d	2a b0 5f	* . _
	call CMP_HLDE		;1f40	cd 20 0f	.   .
	ret			;1f43	c9		.
l1f44h:
	call sub_1f34h		;1f44	cd 34 1f	. 4 .
	ret c			;1f47	d8		.
l1f48h:
	ld hl,(0542ah)		;1f48	2a 2a 54	* * T
	call sub_07f9h		;1f4b	cd f9 07	. . .
	call SETMEMMAP	;1f4e	cd 1a 0f	. . .
	cp 0ffh			;1f51	fe ff		. .
	ret z			;1f53	c8		.
	push hl			;1f54	e5		.
	ld de,0x2c		;1f55	11 2c 00	. , .
	add hl,de		;1f58	19		.
	ld de,053eeh		;1f59	11 ee 53	. . S
	ld bc,4		;1f5c	01 04 00	. . .
	ldir			;1f5f	ed b0		. .
	pop hl			;1f61	e1		.
	push hl			;1f62	e5		.
	ld de,l0147h+1		;1f63	11 48 01	. H .
	add hl,de		;1f66	19		.
	ld de,053f2h		;1f67	11 f2 53	. . S
	ld bc,00028h		;1f6a	01 28 00	. ( .
	ldir			;1f6d	ed b0		. .
	pop hl			;1f6f	e1		.
	ld de,l0147h		;1f70	11 47 01	. G .
	add hl,de		;1f73	19		.
	push hl			;1f74	e5		.
	ld de,00028h		;1f75	11 28 00	. ( .
	add hl,de		;1f78	19		.
	ex de,hl		;1f79	eb		.
	pop hl			;1f7a	e1		.
	ld bc,00118h		;1f7b	01 18 01	. . .
	lddr			;1f7e	ed b8		. .
	ld hl,053edh		;1f80	21 ed 53	! . S
	ld bc,00028h		;1f83	01 28 00	. ( .
	lddr			;1f86	ed b8		. .
	ld h,d			;1f88	62		b
	ld l,e			;1f89	6b		k
	ld bc,4		;1f8a	01 04 00	. . .
	or a			;1f8d	b7		.
	sbc hl,bc		;1f8e	ed 42		. B
	ld bc,28		;1f90	01 1c 00	. . .
	lddr			;1f93	ed b8		. .
	ld bc,4		;1f95	01 04 00	. . .
	ld hl,053c5h		;1f98	21 c5 53	! . S
	lddr			;1f9b	ed b8		. .
	ld de,v53c2		;1f9d	11 c2 53	. . S
	ld hl,053eeh		;1fa0	21 ee 53	! . S
	ld bc,0x2c		;1fa3	01 2c 00	. , .
	ldir			;1fa6	ed b0		. .
	ld hl,(0542ah)		;1fa8	2a 2a 54	* * T
	inc hl			;1fab	23		#
	ld (0542ah),hl		;1fac	22 2a 54	" * T
	ex de,hl		;1faf	eb		.
	ld hl,(05fb0h)		;1fb0	2a b0 5f	* . _
	call CMP_HLDE		;1fb3	cd 20 0f	.   .
	jr nc,l1f48h		;1fb6	30 90		0 .
	ret			;1fb8	c9		.
sub_1fb9h:
	ld hl,(0542ah)		;1fb9	2a 2a 54	* * T
	call sub_07f9h		;1fbc	cd f9 07	. . .
	call SETMEMMAP	;1fbf	cd 1a 0f	. . .
	ld de,16		;1fc2	11 10 00	. . .
	add hl,de		;1fc5	19		.
	push hl			;1fc6	e5		.
	ld de,v53c2		;1fc7	11 c2 53	. . S
	ld bc,4		;1fca	01 04 00	. . .
	ldir			;1fcd	ed b0		. .
	pop de			;1fcf	d1		.
	ld bc,28		;1fd0	01 1c 00	. . .
	ldir			;1fd3	ed b0		. .
	ld de,053c6h		;1fd5	11 c6 53	. . S
	push hl			;1fd8	e5		.
	ld bc,00028h		;1fd9	01 28 00	. ( .
	ldir			;1fdc	ed b0		. .
	ld bc,00118h		;1fde	01 18 01	. . .
	pop de			;1fe1	d1		.
	ldir			;1fe2	ed b0		. .
	ret			;1fe4	c9		.
l1fe5h:
	ld a,0ffh		;1fe5	3e ff		> .
	ld (v53c2),a		;1fe7	32 c2 53	2 . S
	call sub_1f34h		;1fea	cd 34 1f	. 4 .
	ret c			;1fed	d8		.
	ld hl,(05fb0h)		;1fee	2a b0 5f	* . _
	ld (0542ah),hl		;1ff1	22 2a 54	" * T
	call sub_07f9h		;1ff4	cd f9 07	. . .
	cp 0ffh			;1ff7	fe ff		. .
	jr nz,l2004h		;1ff9	20 09		  .
	ld hl,(05fb0h)		;1ffb	2a b0 5f	* . _
	dec hl			;1ffe	2b		+
	ld (05fb0h),hl		;1fff	22 b0 5f	" . _
	jr l1fe5h		;2002	18 e1		. .
l2004h:
	call sub_1fb9h		;2004	cd b9 1f	. . .
	ld h,d			;2007	62		b
	ld l,e			;2008	6b		k
	ld b,028h		;2009	06 28		. (
l200bh:
	ld (hl),020h		;200b	36 20		6  
	inc hl			;200d	23		#
	djnz l200bh		;200e	10 fb		. .
l2010h:
	ld hl,(0542ah)		;2010	2a 2a 54	* * T
	dec hl			;2013	2b		+
	ld (0542ah),hl		;2014	22 2a 54	" * T
	ex de,hl		;2017	eb		.
	ld hl,(v4f89)		;2018	2a 89 4f	* . O
	inc hl			;201b	23		#
	call CMP_HLDE		;201c	cd 20 0f	.   .
	ret z			;201f	c8		.
	ld hl,v53c2		;2020	21 c2 53	! . S
	ld de,053eeh		;2023	11 ee 53	. . S
	ld bc,0x2c		;2026	01 2c 00	. , .
	ldir			;2029	ed b0		. .
	call sub_1fb9h		;202b	cd b9 1f	. . .
	ld hl,053f2h		;202e	21 f2 53	! . S
	ld bc,00028h		;2031	01 28 00	. ( .
	ldir			;2034	ed b0		. .
	or a			;2036	b7		.
	ex de,hl		;2037	eb		.
	ld de,l0144h		;2038	11 44 01	. D .
	sbc hl,de		;203b	ed 52		. R
	ld de,053eeh		;203d	11 ee 53	. . S
	ld bc,4		;2040	01 04 00	. . .
	ex de,hl		;2043	eb		.
	ldir			;2044	ed b0		. .
	jr l2010h		;2046	18 c8		. .
sub_2048h:
	ld a,(05cbah)		;2048	3a ba 5c	: . \
	cp 005h			;204b	fe 05		. .
	jp nz,l1f44h		;204d	c2 44 1f	. D .
	ld hl,(v4f89)		;2050	2a 89 4f	* . O
	ld (05cc3h),hl		;2053	22 c3 5c	" . \
	ld de,05cc6h		;2056	11 c6 5c	. . \
	ld hl,v53c2		;2059	21 c2 53	! . S
	ld bc,0x2c		;205c	01 2c 00	. , .
	ldir			;205f	ed b0		. .
	ld a,049h		;2061	3e 49		> I
	ld (05cc2h),a		;2063	32 c2 5c	2 . \
	call 0893fh		;2066	cd 3f 89	. ? .
	ret			;2069	c9		.
sub_206ah:
	ld a,(05cbah)		;206a	3a ba 5c	: . \
	cp 005h			;206d	fe 05		. .
	jp nz,l1fe5h		;206f	c2 e5 1f	. . .
	ld hl,(v4f89)		;2072	2a 89 4f	* . O
	ld a,049h		;2075	3e 49		> I
	call 088dch		;2077	cd dc 88	. . .
	ret			;207a	c9		.
FUN_84:
	ld a,(FLAGS)
	bit 0,a			;207e	cb 47		. G
	jr z,l2090h		;2080	28 0e		( .
	ld a,000h		;2082	3e 00		> .
	ld b,01ah		;2084	06 1a		. .
l2086h:
	call sub_209ah		;2086	cd 9a 20	. .  
	inc a			;2089	3c		<
	djnz l2086h		;208a	10 fa		. .
	call l1cfch		;208c	cd fc 1c	. . .
	ret			;208f	c9		.
l2090h:
	ld a,(04f83h)		;2090	3a 83 4f	: . O
	call sub_209ah		;2093	cd 9a 20	. .  
	call l1cfch		;2096	cd fc 1c	. . .
	ret			;2099	c9		.
sub_209ah:
	push hl			;209a	e5		.
	push de			;209b	d5		.
	push bc			;209c	c5		.
	push af			;209d	f5		.
	ld b,a			;209e	47		G
	ld hl,04a4ch		;209f	21 4c 4a	! L J
	ld de,4		;20a2	11 04 00	. . .
	inc b			;20a5	04		.
l20a6h:
	add hl,de		;20a6	19		.
	djnz l20a6h		;20a7	10 fd		. .
	ld a,(hl)		;20a9	7e		~
	bit 3,a			;20aa	cb 5f		. _
	jp z,l2158h		;20ac	ca 58 21	. X !
	and 007h		;20af	e6 07		. .
	ld d,000h		;20b1	16 00		. .
	ld e,a			;20b3	5f		_
	ld hl,TABLE1		;20b4	21 e1 22	! . "
	add hl,de		;20b7	19		.
	ld a,(hl)		;20b8	7e		~
	ld c,a			;20b9	4f		O
	pop af			;20ba	f1		.
	push af			;20bb	f5		.
	ld hl,04a9eh		;20bc	21 9e 4a	! . J
	inc a			;20bf	3c		<
	ld b,a			;20c0	47		G
	ld de,00028h		;20c1	11 28 00	. ( .
l20c4h:
	add hl,de		;20c4	19		.
	djnz l20c4h		;20c5	10 fd		. .
	push hl			;20c7	e5		.
	ld b,c			;20c8	41		A
	ld d,028h		;20c9	16 28		. (
l20cbh:
	ld a,(hl)		;20cb	7e		~
	cp 0f0h			;20cc	fe f0		. .
	jr nz,l20d2h		;20ce	20 02		  .
	ld (hl),020h		;20d0	36 20		6  
l20d2h:
	cp 0f1h			;20d2	fe f1		. .
	jr nz,l20d8h		;20d4	20 02		  .
	ld (hl),020h		;20d6	36 20		6  
l20d8h:
	inc hl			;20d8	23		#
	dec d			;20d9	15		.
	djnz l20cbh		;20da	10 ef		. .
	ld b,d			;20dc	42		B
	push hl			;20dd	e5		.
	ld a,d			;20de	7a		z
	or a			;20df	b7		.
	jr z,l20e7h		;20e0	28 05		( .
l20e2h:
	ld (hl),020h		;20e2	36 20		6  
	inc hl			;20e4	23		#
	djnz l20e2h		;20e5	10 fb		. .
l20e7h:
	pop de			;20e7	d1		.
	pop hl			;20e8	e1		.
	push hl			;20e9	e5		.
	push de			;20ea	d5		.
	ld b,c			;20eb	41		A
	ld d,000h		;20ec	16 00		. .
l20eeh:
	ld a,(hl)		;20ee	7e		~
	cp 020h			;20ef	fe 20		.  
	jr nz,l20fbh		;20f1	20 08		  .
	inc d			;20f3	14		.
	inc hl			;20f4	23		#
	djnz l20eeh		;20f5	10 f7		. .
	pop hl			;20f7	e1		.
	pop hl			;20f8	e1		.
	jr l2158h		;20f9	18 5d		. ]
l20fbh:
	ld e,000h		;20fb	1e 00		. .
	pop hl			;20fd	e1		.
	dec hl			;20fe	2b		+
l20ffh:
	ld a,(hl)		;20ff	7e		~
	cp 020h			;2100	fe 20		.  
	jr nz,l2108h		;2102	20 04		  .
	inc e			;2104	1c		.
	dec hl			;2105	2b		+
	jr l20ffh		;2106	18 f7		. .
l2108h:
	pop hl			;2108	e1		.
	ld a,d			;2109	7a		z
	sub e			;210a	93		.
	jr z,l2158h		;210b	28 4b		( K
	jr nc,l213ah		;210d	30 2b		0 +
	ld a,e			;210f	7b		{
	sub d			;2110	92		.
	or a			;2111	b7		.
	rra			;2112	1f		.
	ld b,020h		;2113	06 20		.  
	jr nc,l211ah		;2115	30 03		0 .
	ld b,0f1h		;2117	06 f1		. .
	inc a			;2119	3c		<
l211ah:
	ld e,c			;211a	59		Y
	ld d,000h		;211b	16 00		. .
	add hl,de		;211d	19		.
	dec hl			;211e	2b		+
	ld d,h			;211f	54		T
	ld e,l			;2120	5d		]
	push bc			;2121	c5		.
	ld b,a			;2122	47		G
	ld a,c			;2123	79		y
	sub b			;2124	90		.
	ld c,a			;2125	4f		O
	ld a,b			;2126	78		x
l2127h:
	dec hl			;2127	2b		+
	djnz l2127h		;2128	10 fd		. .
	lddr			;212a	ed b8		. .
	inc hl			;212c	23		#
	pop bc			;212d	c1		.
	ld (hl),b		;212e	70		p
	dec a			;212f	3d		=
	jr z,l2158h		;2130	28 26		( &
	ld b,a			;2132	47		G
l2133h:
	inc hl			;2133	23		#
	ld (hl),020h		;2134	36 20		6  
	djnz l2133h		;2136	10 fb		. .
	jr l2158h		;2138	18 1e		. .
l213ah:
	or a			;213a	b7		.
	rra			;213b	1f		.
	jr nc,l2140h		;213c	30 02		0 .
	ld (hl),0f1h		;213e	36 f1		6 .
l2140h:
	inc hl			;2140	23		#
	or a			;2141	b7		.
	jr z,l2158h		;2142	28 14		( .
	ld b,a			;2144	47		G
	ld a,c			;2145	79		y
	sub b			;2146	90		.
	dec a			;2147	3d		=
	ld c,a			;2148	4f		O
	ld d,h			;2149	54		T
	ld e,l			;214a	5d		]
	ld a,b			;214b	78		x
l214ch:
	inc hl			;214c	23		#
	djnz l214ch		;214d	10 fd		. .
	ldir			;214f	ed b0		. .
	ld b,a			;2151	47		G
	ex de,hl		;2152	eb		.
l2153h:
	ld (hl),020h		;2153	36 20		6  
	inc hl			;2155	23		#
	djnz l2153h		;2156	10 fb		. .
l2158h:
	pop af			;2158	f1		.
	pop bc			;2159	c1		.
	pop de			;215a	d1		.
	pop hl			;215b	e1		.
	ret			;215c	c9		.

FUN_8C:
	ld a,(FLAGS)
	bit 0,a			;2160	cb 47		. G
	jr z,l2179h		;2162	28 15		( .
	ld a,(04f83h)		;2164	3a 83 4f	: . O
	or a			;2167	b7		.
	jr z,_skip		;2168	28 07		( .
	dec a			;216a	3d		=
	ld (04f83h),a		;216b	32 83 4f	2 . O
	call sub_22a1h		;216e	cd a1 22	. . "
_skip:
	ld a,000h		;2171	3e 00		> .
	ld (04f83h),a		;2173	32 83 4f	2 . O
	jp FUN_8E		;2176	c3 64 1e	. d .

l2179h:
	ld a,(04f83h)		;2179	3a 83 4f	: . O
	or a			;217c	b7		.
	ret z			;217d	c8		.
	ld c,a			;217e	4f		O
	dec a			;217f	3d		=
	ld (04f83h),a		;2180	32 83 4f	2 . O
	call sub_22a1h		;2183	cd a1 22	. . "
	call sub_218dh		;2186	cd 8d 21	. . !
	call l1cfch		;2189	cd fc 1c	. . .
	ret			;218c	c9		.
sub_218dh:
	ld de,4		;218d	11 04 00	. . .
	ld hl,04a4ah		;2190	21 4a 4a	! J J
	ld b,c			;2193	41		A
l2194h:
	add hl,de		;2194	19		.
	djnz l2194h		;2195	10 fd		. .
	ex de,hl		;2197	eb		.
	add hl,de		;2198	19		.
	ld b,004h		;2199	06 04		. .
	call sub_21b0h		;219b	cd b0 21	. . !
	ld b,c			;219e	41		A
	ld hl,04a9eh		;219f	21 9e 4a	! . J
	ld de,00028h		;21a2	11 28 00	. ( .
l21a5h:
	add hl,de		;21a5	19		.
	djnz l21a5h		;21a6	10 fd		. .
	ex de,hl		;21a8	eb		.
	add hl,de		;21a9	19		.
	ld b,028h		;21aa	06 28		. (
	call sub_21b0h		;21ac	cd b0 21	. . !
	ret			;21af	c9		.
sub_21b0h:
	push bc			;21b0	c5		.
l21b1h:
	ld c,(hl)		;21b1	4e		N
	ld a,(de)		;21b2	1a		.
	ld (hl),a		;21b3	77		w
	ld a,c			;21b4	79		y
	ld (de),a		;21b5	12		.
	inc hl			;21b6	23		#
	inc de			;21b7	13		.
	djnz l21b1h		;21b8	10 f7		. .
	pop bc			;21ba	c1		.
	ret			;21bb	c9		.

FUN_8B:
	ld a,(FLAGS)
	bit 0,a			;21bf	cb 47		. G
	jr z,l21d9h		;21c1	28 16		( .
	ld a,(04f83h)		;21c3	3a 83 4f	: . O
	cp 019h			;21c6	fe 19		. .
	jr z,_skip		;21c8	28 07		( .
	inc a			;21ca	3c		<
	ld (04f83h),a		;21cb	32 83 4f	2 . O
	call sub_22a1h		;21ce	cd a1 22	. . "
_skip:
	ld a,000h		;21d1	3e 00		> .
	ld (04f83h),a		;21d3	32 83 4f	2 . O
	jp FUN_81		;21d6	c3 e5 1d	. . .

l21d9h:
	ld a,(04f83h)		;21d9	3a 83 4f	: . O
	cp 019h			;21dc	fe 19		. .
	ret z			;21de	c8		.
	inc a			;21df	3c		<
	ld c,a			;21e0	4f		O
	ld (04f83h),a		;21e1	32 83 4f	2 . O
	call sub_22a1h		;21e4	cd a1 22	. . "
	call sub_218dh		;21e7	cd 8d 21	. . !
	call l1cfch		;21ea	cd fc 1c	. . .
	ret			;21ed	c9		.

FUN_89:
	ld a,(FLAGS)
	bit 0,a			;21f1	cb 47		. G
	jr z,l2209h		;21f3	28 14		( .
	ld c,000h		;21f5	0e 00		. .
	ld b,019h		;21f7	06 19		. .
l21f9h:
	ld a,020h		;21f9	3e 20		>  
	call sub_1d06h		;21fb	cd 06 1d	. . .
	djnz l21f9h		;21fe	10 f9		. .
	ld a,020h		;2200	3e 20		>  
	call sub_1d06h		;2202	cd 06 1d	. . .
	call l1cfch		;2205	cd fc 1c	. . .
	ret			;2208	c9		.
l2209h:
	ld c,a			;2209	4f		O
	ld a,(04f83h)		;220a	3a 83 4f	: . O
	ld b,a			;220d	47		G
	ld a,020h		;220e	3e 20		>  
	call sub_1d06h		;2210	cd 06 1d	. . .
	call l1cfch		;2213	cd fc 1c	. . .
	ret			;2216	c9		.

FUN_88:
	ld a,(FLAGS)		;2217	3a 79 4f	: y O
	bit 0,a			;221a	cb 47		. G
	jr z,l2230h		;221c	28 12		( .
	ld c,000h		;221e	0e 00		. .
	ld b,019h		;2220	06 19		. .
	ld a,000h		;2222	3e 00		> .
l2224h:
	call sub_1d7fh		;2224	cd 7f 1d	. . .
	djnz l2224h		;2227	10 fb		. .
	call sub_1d7fh		;2229	cd 7f 1d	. . .
	call l1cfch		;222c	cd fc 1c	. . .
	ret			;222f	c9		.
l2230h:
	ld a,(04f83h)		;2230	3a 83 4f	: . O
	ld b,a			;2233	47		G
	ld a,000h		;2234	3e 00		> .
	ld c,000h		;2236	0e 00		. .
	call sub_1d7fh		;2238	cd 7f 1d	. . .
	call l1cfch		;223b	cd fc 1c	. . .
	ret			;223e	c9		.
sub_223fh:
	call sub_2295h		;223f	cd 95 22	. . "
sub_2242h:
	call sub_2249h		;2242	cd 49 22	. I "
	call sub_2290h		;2245	cd 90 22	. . "
	ret			;2248	c9		.
sub_2249h:
	ld hl,04a4fh		;2249	21 4f 4a	! O J
	ld de,4		;224c	11 04 00	. . .
	ld b,000h		;224f	06 00		. .
	ld c,019h		;2251	0e 19		. .
l2253h:
	inc b			;2253	04		.
	ld a,(hl)		;2254	7e		~
	and 007h		;2255	e6 07		. .
	inc a			;2257	3c		<
	ld d,a			;2258	57		W
	ld a,c			;2259	79		y
	sub d			;225a	92		.
	jr c,l2263h		;225b	38 06		8 .
	ld c,a			;225d	4f		O
	ld d,000h		;225e	16 00		. .
	add hl,de		;2260	19		.
	jr l2253h		;2261	18 f0		. .
l2263h:
	ld hl,(04f80h)		;2263	2a 80 4f	* . O
	ld de,04ac6h		;2266	11 c6 4a	. . J
	ld a,b			;2269	78		x
	ld (04f8bh),a		;226a	32 8b 4f	2 . O
	xor a			;226d	af		.
	sbc hl,de		;226e	ed 52		. R
	dec a			;2270	3d		=
l2271h:
	ld de,00028h		;2271	11 28 00	. ( .
	push hl			;2274	e5		.
	inc a			;2275	3c		<
	sbc hl,de		;2276	ed 52		. R
	pop de			;2278	d1		.
	jr nc,l2271h		;2279	30 f6		0 .
	cp b			;227b	b8		.
	jr c,l2288h		;227c	38 0a		8 .
	ld a,b			;227e	78		x
	dec a			;227f	3d		=
	ld (04f83h),a		;2280	32 83 4f	2 . O
	call sub_22a1h		;2283	cd a1 22	. . "
	jr sub_2249h		;2286	18 c1		. .
l2288h:
	ld (04f83h),a		;2288	32 83 4f	2 . O
	ld a,e			;228b	7b		{
	ld (04f82h),a		;228c	32 82 4f	2 . O
	ret			;228f	c9		.
sub_2290h:
	M_OUT_CH 0x0a
	ret			;2294	c9		.
sub_2295h:
	ld bc,1		;2295	01 01 00	. . .
	ld de,04a3eh		;2298	11 3e 4a	. > J
	ld a,000h		;229b	3e 00		> .
	call sub_09fbh		;229d	cd fb 09	. . .
	ret			;22a0	c9		.
sub_22a1h:
	ld hl,04a9eh		;22a1	21 9e 4a	! . J
	ld a,(04f83h)		;22a4	3a 83 4f	: . O
	inc a			;22a7	3c		<
	ld b,a			;22a8	47		G
	ld de,00028h		;22a9	11 28 00	. ( .
l22ach:
	add hl,de		;22ac	19		.
	djnz l22ach		;22ad	10 fd		. .
	ld d,000h		;22af	16 00		. .
	ld a,(04f82h)		;22b1	3a 82 4f	: . O
	ld e,a			;22b4	5f		_
	add hl,de		;22b5	19		.
	ld (04f80h),hl		;22b6	22 80 4f	" . O
	ret			;22b9	c9		.
sub_22bah:
	push hl			;22ba	e5		.
	push de			;22bb	d5		.
	push bc			;22bc	c5		.
	ld hl,04a4ch		;22bd	21 4c 4a	! L J
	ld de,4		;22c0	11 04 00	. . .
	ld a,(04f83h)		;22c3	3a 83 4f	: . O
	inc a			;22c6	3c		<
	ld b,a			;22c7	47		G
l22c8h:
	add hl,de		;22c8	19		.
	djnz l22c8h		;22c9	10 fd		. .
	ld a,(TABLE1)		;22cb	3a e1 22	: . "
	bit 3,(hl)		;22ce	cb 5e		. ^
	jr z,l22ddh		;22d0	28 0b		( .
	ld a,(hl)		;22d2	7e		~
	and 007h		;22d3	e6 07		. .
	ld d,000h		;22d5	16 00		. .
	ld e,a			;22d7	5f		_
	ld hl,TABLE1		;22d8	21 e1 22	! . "
	add hl,de		;22db	19		.
	ld a,(hl)		;22dc	7e		~
l22ddh:
	pop bc			;22dd	c1		.
	pop de			;22de	d1		.
	pop hl			;22df	e1		.
	ret			;22e0	c9		.

TABLE1:	; 8 chars index table (purpose unclear)
	db 0x28, 0x20, 0x19, 0x14, 0x10, 0x0c, 0x0a, 0x08

FUN_87:
	call sub_22f0h		;22e9	cd f0 22	. . "
	call sub_223fh		;22ec	cd 3f 22	. ? "
	ret			;22ef	c9		.

sub_22f0h:
	ld de,04a3eh		;22f0	11 3e 4a	. > J
l22f3h:
	ld hl,l2304h		;22f3	21 04 23	! . #
	ld bc,20		;22f6	01 14 00	. . .
	ldir			;22f9	ed b0		. .
	ld hl,04a4eh		;22fb	21 4e 4a	! N J
	ld bc,00074h		;22fe	01 74 00	. t .
	ldir			;2301	ed b0		. .
l2303h:
	ret			;2303	c9		.
l2304h:
	nop			;2304	00		.
	rrca			;2305	0f		.
	djnz l230ah		;2306	10 02		. .
	nop			;2308	00		.
	nop			;2309	00		.
l230ah:
	nop			;230a	00		.
	nop			;230b	00		.
	nop			;230c	00		.
	nop			;230d	00		.
	nop			;230e	00		.
	nop			;230f	00		.
	nop			;2310	00		.
	nop			;2311	00		.
	nop			;2312	00		.
	nop			;2313	00		.
	add a,b			;2314	80		.
	ld bc,030c9h		;2315	01 c9 30	. . 0
sub_2318h:
	ld hl,04ac6h		;2318	21 c6 4a	! . J
	ld de,04ac7h		;231b	11 c7 4a	. . J
	ld bc,l040fh+1		;231e	01 10 04	. . .
	ld (hl),020h		;2321	36 20		6  
	ldir			;2323	ed b0		. .
	ret			;2325	c9		.
sub_2326h:
	ld hl,FLAGS		;2326	21 79 4f	! y O
	res FLAG_DISP,(hl)		;2329	cb a6		. .
	ld hl,04109h		;232b	21 09 41	! . A
	ld (hl),01ah		;232e	36 1a		6 .
	ld b,005h		;2330	06 05		. .
l2332h:
	inc hl			;2332	23		#
	ld (hl),000h		;2333	36 00		6 .
	djnz l2332h		;2335	10 fb		. .
	ld a,001h		;2337	3e 01		> .
	ld b,006h		;2339	06 06		. .
l233bh:
	call sub_3381h		;233b	cd 81 33	. . 3
	inc a			;233e	3c		<
	djnz l233bh		;233f	10 fa		. .
	ld de,04159h		;2341	11 59 41	. Y A
	call ADJUSTDE		;2344	cd 01 11	. . .
	ld h,d			;2347	62		b
	ld l,e			;2348	6b		k
	ld (04116h),hl		;2349	22 16 41	" . A
	ld hl,04118h		;234c	21 18 41	! . A
	ld b,00ah		;234f	06 0a		. .
_loop:
	ld (hl),0
	inc hl
	djnz _loop
	ld a,0
	ld (vDBG_LEVEL),a
	ret			;235b	c9		.

FUN_F8:
	ld hl,FLAGS		;235c	21 79 4f	! y O
	set FLAG_DISP,(hl)		;235f	cb e6		. .
	xor a			;2361	af		.
	ld (05fe0h),a		;2362	32 e0 5f	2 . _
	call sub_087ch		;2365	cd 7c 08	. | .
	call FUN_9D		;2368	cd 1f 33	. . 3
	ld de,04109h		;236b	11 09 41	. . A
	ld hl,05b71h		;236e	21 71 5b	! q [
	ld bc,6		;2371	01 06 00	. . .
	ldir			;2374	ed b0		. .
	ld b,006h		;2376	06 06		. .
	ld de,04159h		;2378	11 59 41	. Y A
	call ADJUSTDE		;237b	cd 01 11	. . .
	push de			;237e	d5		.
	pop ix			;237f	dd e1		. .
	ld hl,04116h		;2381	21 16 41	! . A
	ld de,04109h		;2384	11 09 41	. . A
l2387h:
	push bc			;2387	c5		.
	push ix			;2388	dd e5		. .
	pop bc			;238a	c1		.
	ld (hl),c		;238b	71		q
	inc hl			;238c	23		#
	ld (hl),b		;238d	70		p
	inc hl			;238e	23		#
	ld a,(de)		;238f	1a		.
	inc de			;2390	13		.
	or a			;2391	b7		.
	jr z,l23a1h		;2392	28 0d		( .
	ld bc,00043h		;2394	01 43 00	. C .
l2397h:
	add ix,bc		;2397	dd 09		. .
	dec a			;2399	3d		=
	jr nz,l2397h		;239a	20 fb		  .
	ld bc,0x2b		;239c	01 2b 00	. + .
	add ix,bc		;239f	dd 09		. .
l23a1h:
	pop bc			;23a1	c1		.
	djnz l2387h		;23a2	10 e3		. .
	ld de,0575bh		;23a4	11 5b 57	. [ W
	ld hl,l2304h		;23a7	21 04 23	! . #
	ld bc,20		;23aa	01 14 00	. . .
	ldir			;23ad	ed b0		. .
	ld hl,0576bh		;23af	21 6b 57	! k W
	ld bc,28		;23b2	01 1c 00	. . .
	ldir			;23b5	ed b0		. .
	push de			;23b7	d5		.
	pop hl			;23b8	e1		.
	inc de			;23b9	13		.
	ld (hl),020h		;23ba	36 20		6  
	ld bc,l0230h		;23bc	01 30 02	. 0 .
	ldir			;23bf	ed b0		. .
	ld bc,6		;23c1	01 06 00	. . .
l23c4h:
	ld de,0575bh		;23c4	11 5b 57	. [ W
	ld a,001h		;23c7	3e 01		> .
	push bc			;23c9	c5		.
	call sub_09fbh		;23ca	cd fb 09	. . .
	pop bc			;23cd	c1		.
	dec c			;23ce	0d		.
	jr nz,l23c4h		;23cf	20 f3		  .
	ret			;23d1	c9		.

FUN_F9:
	call sub_2326h		;23d2	cd 26 23	. & #
	call FUN_05		;23d5	cd dd 1b	. . .
	call sub_223fh		;23d8	cd 3f 22	. ? "
	ret			;23db	c9		.

FUN_1D:
	ld a,000h		;23dc	3e 00		> .
	ld b,003h		;23de	06 03		. .
	ld c,001h		;23e0	0e 01		. .
	ld d,007h		;23e2	16 07		. .
	call sub_247fh		;23e4	cd 7f 24	. . $
	ret			;23e7	c9		.

FUN_1E:
	ld a,000h		;23e8	3e 00		> .
	ld b,002h		;23ea	06 02		. .
	ld c,001h		;23ec	0e 01		. .
	ld d,007h		;23ee	16 07		. .
	call sub_247fh		;23f0	cd 7f 24	. . $
	ret			;23f3	c9		.

FUN_10:
	ld a,000h		;23f4	3e 00		> .
	ld b,001h		;23f6	06 01		. .
	ld c,010h		;23f8	0e 10		. .
	ld d,010h		;23fa	16 10		. .
	call sub_247fh		;23fc	cd 7f 24	. . $
	ret			;23ff	c9		.

FUN_11:	; and others
	ld a,(04f76h)		;2400	3a 76 4f	: v O
	ld b,a			;2403	47		G
	dec a			;2404	3d		=
	and 007h		;2405	e6 07		. .
	ld c,a			;2407	4f		O
	ld a,(04f77h)		;2408	3a 77 4f	: w O
	cp b			;240b	b8		.
	jr nz,l2415h		;240c	20 07		  .
	set 3,c			;240e	cb d9		. .
	ld a,000h		;2410	3e 00		> .
	ld (04f76h),a		;2412	32 76 4f	2 v O
l2415h:
	ld a,0ffh		;2415	3e ff		> .
	ld b,001h		;2417	06 01		. .
	ld d,00fh		;2419	16 0f		. .
	call sub_247fh		;241b	cd 7f 24	. . $
	ret			;241e	c9		.

FUN_19:
	ld a,000h		;241f	3e 00		> .
	ld b,003h		;2421	06 03		. .
	ld c,040h		;2423	0e 40		. @
	ld d,0c0h		;2425	16 c0		. .
	call sub_247fh		;2427	cd 7f 24	. . $
	ret			;242a	c9		.

FUN_1A:
	ld a,000h		;242b	3e 00		> .
	ld b,003h		;242d	06 03		. .
	ld c,010h		;242f	0e 10		. .
	ld d,030h		;2431	16 30		. 0
	call sub_247fh		;2433	cd 7f 24	. . $
	ret			;2436	c9		.

FUN_1C:
	ld a,000h		;2437	3e 00		> .
	ld b,003h		;2439	06 03		. .
	ld c,008h		;243b	0e 08		. .
	ld d,008h		;243d	16 08		. .
	call sub_247fh		;243f	cd 7f 24	. . $
	ret			;2442	c9		.

FUN_FF:
	ld a,000h		;2443	3e 00		> .
	ld b,001h		;2445	06 01		. .
	ld c,080h		;2447	0e 80		. .
	ld d,080h		;2449	16 80		. .
	call sub_247fh		;244b	cd 7f 24	. . $
	ret			;244e	c9		.

FUN_9E:
	ld a,000h		;244f	3e 00		> .
	ld b,002h		;2451	06 02		. .
	ld c,008h		;2453	0e 08		. .
	ld d,038h		;2455	16 38		. 8
	call sub_247fh		;2457	cd 7f 24	. . $
	ret			;245a	c9		.

FUN_FE:
	ld a,000h		;245b	3e 00		> .
	ld b,002h		;245d	06 02		. .
	ld c,040h		;245f	0e 40		. @
	ld d,040h		;2461	16 40		. @
	call sub_247fh		;2463	cd 7f 24	. . $
	ret			;2466	c9		.

FUN_DE:
	ld a,000h		;2467	3e 00		> .
	ld b,002h		;2469	06 02		. .
	ld c,080h		;246b	0e 80		. .
	ld d,080h		;246d	16 80		. .
	call sub_247fh		;246f	cd 7f 24	. . $
	ret			;2472	c9		.

FUN_1F:
	ld a,000h		;2473	3e 00		> .
	ld b,004h		;2475	06 04		. .
	ld c,040h		;2477	0e 40		. @
	ld d,0c0h		;2479	16 c0		. .
	call sub_247fh		;247b	cd 7f 24	. . $
	ret			;247e	c9		.
sub_247fh:
	push af			;247f	f5		.
	ld a,(FLAGS)		;2480	3a 79 4f	: y O
	bit 0,a			;2483	cb 47		. G
	jr z,l24aah		;2485	28 23		( #
	ld hl,04a4dh		;2487	21 4d 4a	! M J
	ld e,01eh		;248a	1e 1e		. .

l248ch:
_loop:
	inc hl
	djnz _loop
	pop af			;248f	f1		.
	inc a			;2490	3c		<
	jr z,l2497h		;2491	28 04		( .
	ld a,(hl)		;2493	7e		~
	add a,c			;2494	81		.
	and d			;2495	a2		.
	ld c,a			;2496	4f		O
l2497h:
	ld b,e			;2497	43		C
	ld a,0ffh		;2498	3e ff		> .
	xor d			;249a	aa		.
	ld d,a			;249b	57		W
_loop2:
	ld a,(hl)		;249c	7e		~
	and d			;249d	a2		.
	or c			;249e	b1		.
	ld (hl),a		;249f	77		w
	inc hl			;24a0	23		#
	inc hl			;24a1	23		#
	inc hl			;24a2	23		#
	inc hl			;24a3	23		#
	djnz _loop2		;24a4	10 f6		. .
	call sub_223fh		;24a6	cd 3f 22	. ? "
	ret			;24a9	c9		.
l24aah:
	call sub_24b2h		;24aa	cd b2 24	. . $
	dec hl			;24ad	2b		+
	ld e,001h		;24ae	1e 01		. .
	jr l248ch		;24b0	18 da		. .
sub_24b2h:
	ld a,(04f83h)		;24b2	3a 83 4f	: . O
	rlca			;24b5	07		.
	rlca			;24b6	07		.
	ld h,000h		;24b7	26 00		& .
	ld l,a			;24b9	6f		o
	push de			;24ba	d5		.
	ld de,04a4eh		;24bb	11 4e 4a	. N J
	add hl,de		;24be	19		.
	pop de			;24bf	d1		.
	ret			;24c0	c9		.

TASK_2:
	ld sp,05055h		;24c1	31 55 50	1 U P
	call sub_0334h		;24c4	cd 34 03	. 4 .
	ld hl,TASK_2		;24c7	21 c1 24	! . $
	push hl			;24ca	e5		.
	call sub_1704h		;24cb	cd 04 17	. . .
	ld a,(FLAGS)		;24ce	3a 79 4f	: y O
	bit FLAG_DISP,a			;24d1	cb 67		. g
	ret z			;24d3	c8		.
	ld ix,052cbh		;24d4	dd 21 cb 52	. ! . R
	ld hl,0	;24d8	21 00 00	! . .
l24dbh:
	push hl			;24db	e5		.
	ld a,l			;24dc	7d		}
	inc a			;24dd	3c		<
	ld (060cbh),a		;24de	32 cb 60	2 . `
	ld de,04109h		;24e1	11 09 41	. . A
	add hl,de		;24e4	19		.
	xor a			;24e5	af		.
	cp (hl)			;24e6	be		.
	jp z,l2621h		;24e7	ca 21 26	. ! &
	ld a,(ix+002h)		;24ea	dd 7e 02	. ~ .
	or (ix+003h)		;24ed	dd b6 03	. . .
	jp nz,l2621h		;24f0	c2 21 26	. ! &
	ld a,(ix+005h)		;24f3	dd 7e 05	. ~ .
	or (ix+006h)		;24f6	dd b6 06	. . .
	jp z,l25d9h		;24f9	ca d9 25	. . %
l24fch:
	pop de			;24fc	d1		.
	push de			;24fd	d5		.
	ld hl,05fb7h		;24fe	21 b7 5f	! . _
	add hl,de		;2501	19		.
	add hl,de		;2502	19		.
	add hl,de		;2503	19		.
	add hl,de		;2504	19		.
	ld (05fach),hl		;2505	22 ac 5f	" . _
	ld e,(hl)		;2508	5e		^
	inc hl			;2509	23		#
	ld d,(hl)		;250a	56		V
	ld a,e			;250b	7b		{
	or d			;250c	b2		.
	jr z,l2577h		;250d	28 68		( h
	inc hl			;250f	23		#
	ld c,(hl)		;2510	4e		N
	inc hl			;2511	23		#
	ld b,(hl)		;2512	46		F
	push hl			;2513	e5		.
	push bc			;2514	c5		.
	pop hl			;2515	e1		.
	call CMP_HLDE		;2516	cd 20 0f	.   .
	pop hl			;2519	e1		.
	jr nc,l2526h		;251a	30 0a		0 .
	ld b,004h		;251c	06 04		. .
l251eh:
	ld (hl),000h		;251e	36 00		6 .
	dec hl			;2520	2b		+
	djnz l251eh		;2521	10 fb		. .
	jp l2621h		;2523	c3 21 26	. ! &
l2526h:
	ld h,d			;2526	62		b
	ld l,e			;2527	6b		k
	ld a,(060cbh)		;2528	3a cb 60	: . `
	call sub_0748h		;252b	cd 48 07	. H .
	cp 0feh			;252e	fe fe		. .
	jp z,l2621h		;2530	ca 21 26	. ! &
	push af			;2533	f5		.
	push hl			;2534	e5		.
	ld h,d			;2535	62		b
	ld l,e			;2536	6b		k
	call 0a04ah		;2537	cd 4a a0	. J .
	ld hl,(05fach)		;253a	2a ac 5f	* . _
	ld a,(0602ah)		;253d	3a 2a 60	: * `
	add a,(hl)		;2540	86		.
	ld (hl),a		;2541	77		w
	jr nc,l2546h		;2542	30 02		0 .
	inc hl			;2544	23		#
	inc (hl)		;2545	34		4
l2546h:
	pop hl			;2546	e1		.
	pop af			;2547	f1		.
	cp 0ffh			;2548	fe ff		. .
	jr z,l24fch		;254a	28 b0		( .
	call SETMEMMAP	;254c	cd 1a 0f	. . .
	bit 0,(hl)		;254f	cb 46		. F
	jr nz,l24fch		;2551	20 a9		  .
	bit 1,(hl)		;2553	cb 4e		. N
	jr nz,l24fch		;2555	20 a5		  .
	bit 2,(hl)		;2557	cb 56		. V
	jr z,l2563h		;2559	28 08		( .
	bit 3,(hl)		;255b	cb 5e		. ^
	jr z,l24fch		;255d	28 9d		( .
	ld a,(hl)		;255f	7e		~
	and 0c7h		;2560	e6 c7		. .
	ld (hl),a		;2562	77		w
l2563h:
	call sub_26aah		;2563	cd aa 26	. . &
	jr nz,l24fch		;2566	20 94		  .
	ld (ix+002h),l		;2568	dd 75 02	. u .
	ld (ix+003h),h		;256b	dd 74 03	. t .
	ld a,(CUR_MAP)		;256e	3a 22 41	: " A
	ld (ix+000h),a		;2571	dd 77 00	. w .
	jp l2621h		;2574	c3 21 26	. ! &
l2577h:
	nop			;2577	00		.
	ld a,(ix+004h)		;2578	dd 7e 04	. ~ .
	and 003h		;257b	e6 03		. .
	call sub_269bh		;257d	cd 9b 26	. . &
	ld l,(iy+006h)		;2580	fd 6e 06	. n .
	ld h,(iy+007h)		;2583	fd 66 07	. f .
	ld a,(060cbh)		;2586	3a cb 60	: . `
	call sub_0748h		;2589	cd 48 07	. H .
	cp 0feh			;258c	fe fe		. .
	jp z,l2621h		;258e	ca 21 26	. ! &
	push hl			;2591	e5		.
	ld l,(iy+006h)		;2592	fd 6e 06	. n .
	ld h,(iy+007h)		;2595	fd 66 07	. f .
	call 0a04ah		;2598	cd 4a a0	. J .
	pop hl			;259b	e1		.
	cp 0ffh			;259c	fe ff		. .
	jp z,l261eh		;259e	ca 1e 26	. . &
	call SETMEMMAP	;25a1	cd 1a 0f	. . .
	bit 1,(hl)		;25a4	cb 4e		. N
	jr nz,l261eh		;25a6	20 76		  v
	bit 2,(hl)		;25a8	cb 56		. V
	jr z,l25deh		;25aa	28 32		( 2
	bit 3,(hl)		;25ac	cb 5e		. ^
	jr z,l25b6h		;25ae	28 06		( .
	ld a,(hl)		;25b0	7e		~
	and 0c7h		;25b1	e6 c7		. .
	ld (hl),a		;25b3	77		w
	jr l25deh		;25b4	18 28		. (
l25b6h:
	bit 4,(hl)		;25b6	cb 66		. f
	jr z,l25bfh		;25b8	28 05		( .
	call sub_2632h		;25ba	cd 32 26	. 2 &
	jr l2621h		;25bd	18 62		. b
l25bfh:
	bit 5,(hl)		;25bf	cb 6e		. n
	jr nz,l25cdh		;25c1	20 0a		  .
	ld a,(052c4h)		;25c3	3a c4 52	: . R
	ld (ix+001h),a		;25c6	dd 77 01	. w .
	set 5,(hl)		;25c9	cb ee		. .
	jr l2621h		;25cb	18 54		. T
l25cdh:
	ld a,(052c4h)		;25cd	3a c4 52	: . R
	sub (ix+001h)		;25d0	dd 96 01	. . .
	cp 014h			;25d3	fe 14		. .
	jr c,l2621h		;25d5	38 4a		8 J
	set 4,(hl)		;25d7	cb e6		. .
l25d9h:
	call sub_2632h		;25d9	cd 32 26	. 2 &
	jr l2621h		;25dc	18 43		. C
l25deh:
	bit 0,(hl)		;25de	cb 46		. F
	jr nz,l261eh		;25e0	20 3c		  <
	bit 6,(hl)		;25e2	cb 76		. v
	jr z,l25edh		;25e4	28 07		( .
	bit 3,(hl)		;25e6	cb 5e		. ^
	jp z,l261eh		;25e8	ca 1e 26	. . &
	res 3,(hl)		;25eb	cb 9e		. .
l25edh:
	call sub_26aah		;25ed	cd aa 26	. . &
	jr nz,l261eh		;25f0	20 2c		  ,
	call sub_2774h		;25f2	cd 74 27	. t '
	jr nz,l261eh		;25f5	20 27		  '
	ld (ix+002h),l		;25f7	dd 75 02	. u .
	ld (ix+003h),h		;25fa	dd 74 03	. t .
	ld a,(CUR_MAP)		;25fd	3a 22 41	: " A
	ld (ix+000h),a		;2600	dd 77 00	. w .
	res 2,(ix+004h)		;2603	dd cb 04 96	. . . .
	call sub_265dh		;2607	cd 5d 26	. ] &
	ld l,(ix+005h)		;260a	dd 6e 05	. n .
	ld h,(ix+006h)		;260d	dd 66 06	. f .
	dec hl			;2610	2b		+
	ld (ix+005h),l		;2611	dd 75 05	. u .
	ld (ix+006h),h		;2614	dd 74 06	. t .
	ld a,l			;2617	7d		}
	or h			;2618	b4		.
	call z,sub_2632h	;2619	cc 32 26	. 2 &
	jr l2621h		;261c	18 03		. .
l261eh:
	call sub_265dh		;261e	cd 5d 26	. ] &
l2621h:
	pop hl			;2621	e1		.
	call sub_0334h		;2622	cd 34 03	. 4 .
	ld de,00027h		;2625	11 27 00	. ' .
	add ix,de		;2628	dd 19		. .
	inc l			;262a	2c		,
	ld a,005h		;262b	3e 05		> .
	cp l			;262d	bd		.
	jp nc,l24dbh		;262e	d2 db 24	. . $
	ret			;2631	c9		.
sub_2632h:
	ld b,004h		;2632	06 04		. .
l2634h:
	ld a,(ix+004h)		;2634	dd 7e 04	. ~ .
	and 003h		;2637	e6 03		. .
	inc a			;2639	3c		<
	cp 004h			;263a	fe 04		. .
	jr c,l263fh		;263c	38 01		8 .
	xor a			;263e	af		.
l263fh:
	ld (ix+004h),a		;263f	dd 77 04	. w .
	call sub_269bh		;2642	cd 9b 26	. . &
	ld a,(iy+004h)		;2645	fd 7e 04	. ~ .
	or (iy+005h)		;2648	fd b6 05	. . .
	jr nz,l2650h		;264b	20 03		  .
	djnz l2634h		;264d	10 e5		. .
	ret			;264f	c9		.
l2650h:
	ld a,(iy+004h)		;2650	fd 7e 04	. ~ .
	ld (ix+005h),a		;2653	dd 77 05	. w .
	ld a,(iy+005h)		;2656	fd 7e 05	. ~ .
	ld (ix+006h),a		;2659	dd 77 06	. w .
	ret			;265c	c9		.
sub_265dh:
	ld l,(iy+006h)		;265d	fd 6e 06	. n .
	ld h,(iy+007h)		;2660	fd 66 07	. f .
	ld e,(iy+002h)		;2663	fd 5e 02	. ^ .
	ld d,(iy+003h)		;2666	fd 56 03	. V .
	call CMP_HLDE		;2669	cd 20 0f	.   .
	ld e,(iy+000h)		;266c	fd 5e 00	. ^ .
	ld d,(iy+001h)		;266f	fd 56 01	. V .
	jr nc,l2679h		;2672	30 05		0 .
	call CMP_HLDE		;2674	cd 20 0f	.   .
	jr nc,l268dh		;2677	30 14		0 .
l2679h:
	ex de,hl		;2679	eb		.
	bit 2,(ix+004h)		;267a	dd cb 04 56	. . . V
	set 2,(ix+004h)		;267e	dd cb 04 d6	. . . .
	jr z,l2694h		;2682	28 10		( .
	push iy			;2684	fd e5		. .
	call sub_2632h		;2686	cd 32 26	. 2 &
	pop iy			;2689	fd e1		. .
	jr l2694h		;268b	18 07		. .
l268dh:
	ld a,(0602ah)		;268d	3a 2a 60	: * `
	ld e,a			;2690	5f		_
	ld d,000h		;2691	16 00		. .
	add hl,de		;2693	19		.
l2694h:
	ld (iy+006h),l		;2694	fd 75 06	. u .
	ld (iy+007h),h		;2697	fd 74 07	. t .
	ret			;269a	c9		.
sub_269bh:
	add a,a			;269b	87		.
	add a,a			;269c	87		.
	add a,a			;269d	87		.
	add a,007h		;269e	c6 07		. .
	ld d,000h		;26a0	16 00		. .
	ld e,a			;26a2	5f		_
	push ix			;26a3	dd e5		. .
	pop iy			;26a5	fd e1		. .
	add iy,de		;26a7	fd 19		. .
	ret			;26a9	c9		.
sub_26aah:
	push ix			;26aa	dd e5		. .
	push hl			;26ac	e5		.
	push hl			;26ad	e5		.
	pop ix			;26ae	dd e1		. .
	ld a,(ix+004h)		;26b0	dd 7e 04	. ~ .
	or a			;26b3	b7		.
	jp z,l2770h		;26b4	ca 70 27	. p '
	ld a,008h		;26b7	3e 08		> .
	cp (ix+004h)		;26b9	dd be 04	. . .
	jr z,l26c7h		;26bc	28 09		( .
	ld a,(05b93h)		;26be	3a 93 5b	: . [
	inc a			;26c1	3c		<
	cp (ix+004h)		;26c2	dd be 04	. . .
	jr nz,l26eah		;26c5	20 23		  #
l26c7h:
	ld a,(ix+005h)		;26c7	dd 7e 05	. ~ .
	or a			;26ca	b7		.
	jr z,l26eah		;26cb	28 1d		( .
	ld b,a			;26cd	47		G
	and 07fh		;26ce	e6 7f		. .
	cp 00ch			;26d0	fe 0c		. .
	jr nz,l26d8h		;26d2	20 04		  .
	ld a,b			;26d4	78		x
	and 080h		;26d5	e6 80		. .
	ld b,a			;26d7	47		G
l26d8h:
	ld a,(05b9ah)		;26d8	3a 9a 5b	: . [
	rrca			;26db	0f		.
	ld h,a			;26dc	67		g
	ld a,(05b97h)		;26dd	3a 97 5b	: . [
	or h			;26e0	b4		.
	cp b			;26e1	b8		.
	jr nz,l26eah		;26e2	20 06		  .
	ld a,(05b98h)		;26e4	3a 98 5b	: . [
	cp (ix+006h)		;26e7	dd be 06	. . .
l26eah:
	ld d,000h		;26ea	16 00		. .
	rl d			;26ec	cb 12		. .
	ld a,008h		;26ee	3e 08		> .
	cp (ix+004h)		;26f0	dd be 04	. . .
	jr z,l26feh		;26f3	28 09		( .
	ld a,(05b93h)		;26f5	3a 93 5b	: . [
	inc a			;26f8	3c		<
	cp (ix+007h)		;26f9	dd be 07	. . .
	jr nz,l2726h		;26fc	20 28		  (
l26feh:
	ld a,(ix+005h)		;26fe	dd 7e 05	. ~ .
	or a			;2701	b7		.
	jr z,l2727h		;2702	28 23		( #
	ld a,(ix+008h)		;2704	dd 7e 08	. ~ .
	ld b,a			;2707	47		G
	and 07fh		;2708	e6 7f		. .
	cp 00ch			;270a	fe 0c		. .
	jr nz,l2712h		;270c	20 04		  .
	ld a,b			;270e	78		x
	and 080h		;270f	e6 80		. .
	ld b,a			;2711	47		G
l2712h:
	ld a,(05b9ah)		;2712	3a 9a 5b	: . [
	rrca			;2715	0f		.
	ld h,a			;2716	67		g
	ld a,(05b97h)		;2717	3a 97 5b	: . [
	or h			;271a	b4		.
	cp b			;271b	b8		.
	jr nz,l2726h		;271c	20 08		  .
	ld a,(05b98h)		;271e	3a 98 5b	: . [
	cp (ix+009h)		;2721	dd be 09	. . .
	jr z,l2727h		;2724	28 01		( .
l2726h:
	ccf			;2726	3f		?
l2727h:
	ld e,000h		;2727	1e 00		. .
	rl e			;2729	cb 13		. .
	ld a,d			;272b	7a		z
	or e			;272c	b3		.
	jr z,l2770h		;272d	28 41		( A
	ld a,d			;272f	7a		z
	and e			;2730	a3		.
	jr nz,l2770h		;2731	20 3d		  =
	ld a,(ix+004h)		;2733	dd 7e 04	. ~ .
	cp 008h			;2736	fe 08		. .
	jr z,l273fh		;2738	28 05		( .
	cp (ix+007h)		;273a	dd be 07	. . .
	jr nz,l276ch		;273d	20 2d		  -
l273fh:
	ld a,(ix+005h)		;273f	dd 7e 05	. ~ .
	or a			;2742	b7		.
	scf			;2743	37		7
	jr z,l276ch		;2744	28 26		( &
	ld b,a			;2746	47		G
	and 07fh		;2747	e6 7f		. .
	cp 00ch			;2749	fe 0c		. .
	jr nz,l2751h		;274b	20 04		  .
	ld a,b			;274d	78		x
	and 080h		;274e	e6 80		. .
	ld b,a			;2750	47		G
l2751h:
	ld a,(ix+008h)		;2751	dd 7e 08	. ~ .
	ld c,a			;2754	4f		O
	and 07fh		;2755	e6 7f		. .
	cp 00ch			;2757	fe 0c		. .
	jr nz,l275fh		;2759	20 04		  .
	ld a,c			;275b	79		y
	and 080h		;275c	e6 80		. .
	ld c,a			;275e	4f		O
l275fh:
	ld a,b			;275f	78		x
	cp c			;2760	b9		.
	jr nz,l276ch		;2761	20 09		  .
	ld a,(ix+006h)		;2763	dd 7e 06	. ~ .
	cp (ix+009h)		;2766	dd be 09	. . .
	jr nz,l276ch		;2769	20 01		  .
	scf			;276b	37		7
l276ch:
	ld a,000h		;276c	3e 00		> .
	rla			;276e	17		.
	or a			;276f	b7		.
l2770h:
	pop hl			;2770	e1		.
	pop ix			;2771	dd e1		. .
	ret			;2773	c9		.
sub_2774h:
	xor a			;2774	af		.
	ret			;2775	c9		.

FUN_FD:
	call sub_2a82h		;2776	cd 82 2a	. . *
	call sub_2aeeh		;2779	cd ee 2a	. . *
	ld a,(05cbah)		;277c	3a ba 5c	: . \
	cp 005h			;277f	fe 05		. .
	jr nz,l2788h		;2781	20 05		  .
l2783h:
	ld hl,05cc6h		;2783	21 c6 5c	! . \
	jr l2790h		;2786	18 08		. .
l2788h:
	call sub_2b05h		;2788	cd 05 2b	. . +
	cp 0ffh			;278b	fe ff		. .
	jp z,l1934h		;278d	ca 34 19	. 4 .
l2790h:
	ld bc,0x30		;2790	01 30 00	. 0 .
	ex de,hl		;2793	eb		.
	ld hl,04a3eh		;2794	21 3e 4a	! > J
	call sub_28e4h		;2797	cd e4 28	. . (
	ldir			;279a	ed b0		. .
	ld hl,04ac6h		;279c	21 c6 4a	! . J
	ld bc,l0140h		;279f	01 40 01	. @ .
	call sub_28e4h		;27a2	cd e4 28	. . (
	ldir			;27a5	ed b0		. .
	ld a,(05cbah)		;27a7	3a ba 5c	: . \
	cp 005h			;27aa	fe 05		. .
	jr nz,l27cdh		;27ac	20 1f		  .
	ld hl,(v4f89)		;27ae	2a 89 4f	* . O
	call sub_2b25h		;27b1	cd 25 2b	. % +
	cp 0ffh			;27b4	fe ff		. .
	jp z,l2b17h		;27b6	ca 17 2b	. . +
	ld a,(05cc3h)		;27b9	3a c3 5c	: . \
	bit 1,a			;27bc	cb 4f		. O
	jr nz,l27c6h		;27be	20 06		  .
	call sub_1f2ah		;27c0	cd 2a 1f	. * .
	jp nz,l28dbh		;27c3	c2 db 28	. . (
l27c6h:
	ld hl,05cc6h		;27c6	21 c6 5c	! . \
	ld (hl),0ffh		;27c9	36 ff		6 .
	jr l27e6h		;27cb	18 19		. .
l27cdh:
	ld hl,(v4f89)		;27cd	2a 89 4f	* . O
	inc hl			;27d0	23		#
	call sub_07f9h		;27d1	cd f9 07	. . .
	cp 0ffh			;27d4	fe ff		. .
	jp z,l28dbh		;27d6	ca db 28	. . (
	call SETMEMMAP	;27d9	cd 1a 0f	. . .
	bit 1,(hl)		;27dc	cb 4e		. N
	jr nz,l27e6h		;27de	20 06		  .
	call sub_1f2ah		;27e0	cd 2a 1f	. * .
	jp nz,l28dbh		;27e3	c2 db 28	. . (
l27e6h:
	ld de,16		;27e6	11 10 00	. . .
	add hl,de		;27e9	19		.
	ex de,hl		;27ea	eb		.
	ld bc,32		;27eb	01 20 00	.   .
	ld hl,04a6eh		;27ee	21 6e 4a	! n J
	call sub_28e4h		;27f1	cd e4 28	. . (
	ldir			;27f4	ed b0		. .
	ld hl,04c06h		;27f6	21 06 4c	! . L
	ld bc,l0140h		;27f9	01 40 01	. @ .
	call sub_28e4h		;27fc	cd e4 28	. . (
	ldir			;27ff	ed b0		. .
	ld a,(05cbah)		;2801	3a ba 5c	: . \
	cp 005h			;2804	fe 05		. .
	jr nz,l2828h		;2806	20 20		   
	ld hl,(v4f89)		;2808	2a 89 4f	* . O
	inc hl			;280b	23		#
	call sub_2b25h		;280c	cd 25 2b	. % +
	or a			;280f	b7		.
	jp nz,l2783h		;2810	c2 83 27	. . '
	ld a,(05cc3h)		;2813	3a c3 5c	: . \
	bit 1,a			;2816	cb 4f		. O
	jp z,l28dbh		;2818	ca db 28	. . (
	call sub_1f2ah		;281b	cd 2a 1f	. * .
	jp z,l28dbh		;281e	ca db 28	. . (
	ld hl,05cc6h		;2821	21 c6 5c	! . \
	ld (hl),0ffh		;2824	36 ff		6 .
	jr l2843h		;2826	18 1b		. .
l2828h:
	ld hl,(v4f89)		;2828	2a 89 4f	* . O
	inc hl			;282b	23		#
	inc hl			;282c	23		#
	call sub_07f9h		;282d	cd f9 07	. . .
	cp 0ffh			;2830	fe ff		. .
	jp z,l28dbh		;2832	ca db 28	. . (
	call sub_1f2ah		;2835	cd 2a 1f	. * .
	jp z,l28dbh		;2838	ca db 28	. . (
	call SETMEMMAP	;283b	cd 1a 0f	. . .
	bit 1,(hl)		;283e	cb 4e		. N
	jp z,l28dbh		;2840	ca db 28	. . (
l2843h:
	ld de,16		;2843	11 10 00	. . .
	add hl,de		;2846	19		.
	ex de,hl		;2847	eb		.
	ld hl,04a8eh		;2848	21 8e 4a	! . J
	ld bc,32		;284b	01 20 00	.   .
	call sub_28e4h		;284e	cd e4 28	. . (
	ldir			;2851	ed b0		. .
	ld hl,04d46h		;2853	21 46 4d	! F M
	ld bc,l0140h		;2856	01 40 01	. @ .
	call sub_28e4h		;2859	cd e4 28	. . (
	ldir			;285c	ed b0		. .
	ld a,(05cbah)		;285e	3a ba 5c	: . \
	cp 005h			;2861	fe 05		. .
	jr nz,l2880h		;2863	20 1b		  .
	ld hl,(v4f89)		;2865	2a 89 4f	* . O
	inc hl			;2868	23		#
	inc hl			;2869	23		#
	call sub_2b25h		;286a	cd 25 2b	. % +
	or a			;286d	b7		.
	jp nz,l2783h		;286e	c2 83 27	. . '
	ld a,(05cc3h)		;2871	3a c3 5c	: . \
	bit 1,a			;2874	cb 4f		. O
	jp z,l28dbh		;2876	ca db 28	. . (
	ld hl,05cc6h		;2879	21 c6 5c	! . \
	ld (hl),0ffh		;287c	36 ff		6 .
	jr l2896h		;287e	18 16		. .
l2880h:
	ld hl,(v4f89)		;2880	2a 89 4f	* . O
	inc hl			;2883	23		#
	inc hl			;2884	23		#
	inc hl			;2885	23		#
	call sub_07f9h		;2886	cd f9 07	. . .
	cp 0ffh			;2889	fe ff		. .
	jp z,l28dbh		;288b	ca db 28	. . (
	call SETMEMMAP	;288e	cd 1a 0f	. . .
	bit 1,(hl)		;2891	cb 4e		. N
	jp z,l28dbh		;2893	ca db 28	. . (
l2896h:
	ld de,16		;2896	11 10 00	. . .
	add hl,de		;2899	19		.
	ex de,hl		;289a	eb		.
	ld hl,04aaeh		;289b	21 ae 4a	! . J
	ld bc,8		;289e	01 08 00	. . .
	call sub_28e4h		;28a1	cd e4 28	. . (
	ldir			;28a4	ed b0		. .
	push de			;28a6	d5		.
	pop hl			;28a7	e1		.
	dec hl			;28a8	2b		+
	dec hl			;28a9	2b		+
	dec hl			;28aa	2b		+
	dec hl			;28ab	2b		+
	ld bc,24		;28ac	01 18 00	. . .
	ldir			;28af	ed b0		. .
	ld hl,04e86h		;28b1	21 86 4e	! . N
	ld bc,00050h		;28b4	01 50 00	. P .
	call sub_28e4h		;28b7	cd e4 28	. . (
	ldir			;28ba	ed b0		. .
	push de			;28bc	d5		.
	pop hl			;28bd	e1		.
	inc de			;28be	13		.
	ld (hl),020h		;28bf	36 20		6  
	ld bc,l00efh		;28c1	01 ef 00	. . .
	ldir			;28c4	ed b0		. .
	ld a,(05cbah)		;28c6	3a ba 5c	: . \
	cp 005h			;28c9	fe 05		. .
	jp nz,l28dbh		;28cb	c2 db 28	. . (
	ld hl,(v4f89)		;28ce	2a 89 4f	* . O
	inc hl			;28d1	23		#
	inc hl			;28d2	23		#
	inc hl			;28d3	23		#
	call sub_2b25h		;28d4	cd 25 2b	. % +
	or a			;28d7	b7		.
	jp nz,l2783h		;28d8	c2 83 27	. . '
l28dbh:
	M_OUT_MSG 0xd07a, 0x08 ; RIGHT RIGHT "STORED"
	jp l1934h		;28e1	c3 34 19	. 4 .
sub_28e4h:
	push hl			;28e4	e5		.
	push de			;28e5	d5		.
	push bc			;28e6	c5		.
l28e7h:
	ld a,(de)		;28e7	1a		.
	cp (hl)			;28e8	be		.
	call nz,sub_28f7h	;28e9	c4 f7 28	. . (
	inc hl			;28ec	23		#
	inc de			;28ed	13		.
	dec bc			;28ee	0b		.
	ld a,c			;28ef	79		y
	or b			;28f0	b0		.
	jr nz,l28e7h		;28f1	20 f4		  .
	pop bc			;28f3	c1		.
	pop de			;28f4	d1		.
	pop hl			;28f5	e1		.
	ret			;28f6	c9		.
sub_28f7h:
	ld hl,(v4f89)		;28f7	2a 89 4f	* . O
	ld a,h			;28fa	7c		|
	cp 000h			;28fb	fe 00		. .
	jr nz,l291eh		;28fd	20 1f		  .
	ld a,l			;28ff	7d		}
	cp 064h			;2900	fe 64		. d
	jr nc,l291eh		;2902	30 1a		0 .
	and 007h		;2904	e6 07		. .
	inc a			;2906	3c		<
	ld b,a			;2907	47		G
	ld a,080h		;2908	3e 80		> .
l290ah:
	rlca			;290a	07		.
	djnz l290ah		;290b	10 fd		. .
	ld c,a			;290d	4f		O
	ld a,l			;290e	7d		}
	and 078h		;290f	e6 78		. x
	rrca			;2911	0f		.
	rrca			;2912	0f		.
	rrca			;2913	0f		.
	ld l,a			;2914	6f		o
	ld h,000h		;2915	26 00		& .
	ld de,060d0h		;2917	11 d0 60	. . `
	add hl,de		;291a	19		.
	ld a,(hl)		;291b	7e		~
	or c			;291c	b1		.
	ld (hl),a		;291d	77		w
l291eh:
	ld bc,1		;291e	01 01 00	. . .
	ret			;2921	c9		.

FUN_FB:
	call sub_2a82h		;2922	cd 82 2a	. . *
	call sub_2aeeh		;2925	cd ee 2a	. . *
	ld a,(05cbah)		;2928	3a ba 5c	: . \
	cp 005h			;292b	fe 05		. .
	jr nz,l2943h		;292d	20 14		  .
	ld de,(05e9dh)		;292f	ed 5b 9d 5e	. [ . ^
	call 08b36h		;2933	cd 36 8b	. 6 .
	call 08879h		;2936	cd 79 88	. y .
	cp 0ffh			;2939	fe ff		. .
	jp z,l2b10h		;293b	ca 10 2b	. . +
	ld hl,05cc6h		;293e	21 c6 5c	! . \
	jr l2949h		;2941	18 06		. .
l2943h:
	call sub_2b05h		;2943	cd 05 2b	. . +
	cp 0ffh			;2946	fe ff		. .
	ret z			;2948	c8		.
l2949h:
	ld bc,0x30		;2949	01 30 00	. 0 .
	ld de,04a3eh		;294c	11 3e 4a	. > J
	ldir			;294f	ed b0		. .
	ld de,04ac6h		;2951	11 c6 4a	. . J
	ld bc,l0140h		;2954	01 40 01	. @ .
	ldir			;2957	ed b0		. .
	ld hl,(v4f89)		;2959	2a 89 4f	* . O
	inc hl			;295c	23		#
	call sub_2b3fh		;295d	cd 3f 2b	. ? +
	cp 0ffh			;2960	fe ff		. .
	jp z,l29ech		;2962	ca ec 29	. . )
	call SETMEMMAP	;2965	cd 1a 0f	. . .
	bit 1,(hl)		;2968	cb 4e		. N
	jr nz,l297dh		;296a	20 11		  .
	call sub_1f2ah		;296c	cd 2a 1f	. * .
	jp nz,l29ech		;296f	c2 ec 29	. . )
	push hl			;2972	e5		.
	ld hl,(v4f89)		;2973	2a 89 4f	* . O
	call sub_1eeah		;2976	cd ea 1e	. . .
	pop hl			;2979	e1		.
	jp nz,l29ech		;297a	c2 ec 29	. . )
l297dh:
	ld de,16		;297d	11 10 00	. . .
	add hl,de		;2980	19		.
	ld bc,32		;2981	01 20 00	.   .
	ld de,04a6eh		;2984	11 6e 4a	. n J
	ldir			;2987	ed b0		. .
	ld de,04c06h		;2989	11 06 4c	. . L
	ld bc,l0140h		;298c	01 40 01	. @ .
	ldir			;298f	ed b0		. .
	ld hl,(v4f89)		;2991	2a 89 4f	* . O
	inc hl			;2994	23		#
	inc hl			;2995	23		#
	call sub_2b3fh		;2996	cd 3f 2b	. ? +
	cp 0ffh			;2999	fe ff		. .
	jr z,l2a06h		;299b	28 69		( i
	call SETMEMMAP	;299d	cd 1a 0f	. . .
	bit 1,(hl)		;29a0	cb 4e		. N
	jr z,l2a06h		;29a2	28 62		( b
	call sub_1f2ah		;29a4	cd 2a 1f	. * .
	jr z,l2a06h		;29a7	28 5d		( ]
	ld de,16		;29a9	11 10 00	. . .
	add hl,de		;29ac	19		.
	ld bc,32		;29ad	01 20 00	.   .
	ld de,04a8eh		;29b0	11 8e 4a	. . J
	ldir			;29b3	ed b0		. .
	ld de,04d46h		;29b5	11 46 4d	. F M
	ld bc,l0140h		;29b8	01 40 01	. @ .
	ldir			;29bb	ed b0		. .
	ld hl,(v4f89)		;29bd	2a 89 4f	* . O
	inc hl			;29c0	23		#
	inc hl			;29c1	23		#
	inc hl			;29c2	23		#
	call sub_2b3fh		;29c3	cd 3f 2b	. ? +
	cp 0ffh			;29c6	fe ff		. .
	jr z,l2a20h		;29c8	28 56		( V
	call SETMEMMAP	;29ca	cd 1a 0f	. . .
	bit 1,(hl)		;29cd	cb 4e		. N
	jr z,l2a20h		;29cf	28 4f		( O
	ld de,16		;29d1	11 10 00	. . .
	add hl,de		;29d4	19		.
	ld bc,8		;29d5	01 08 00	. . .
	ld de,04aaeh		;29d8	11 ae 4a	. . J
	ldir			;29db	ed b0		. .
	ld de,24		;29dd	11 18 00	. . .
	add hl,de		;29e0	19		.
	ld de,04e86h		;29e1	11 86 4e	. . N
	ld bc,00050h		;29e4	01 50 00	. P .
	ldir			;29e7	ed b0		. .
l29e9h:
	jp l1925h		;29e9	c3 25 19	. % .
l29ech:
	ld hl,04a6ah		;29ec	21 6a 4a	! j J
	ld de,04a6eh		;29ef	11 6e 4a	. n J
	ld bc,00048h		;29f2	01 48 00	. H .
	ldir

		; Copy 720 ' ' at 04c06
	ld hl,04c06h
	ld de,04c07h
	ld (hl),020h
	ld bc,719
	ldir			;2a02	ed b0		. .

	jr l29e9h		;2a04	18 e3		. .
l2a06h:
	ld hl,04a8ah		;2a06	21 8a 4a	! . J
	ld de,04a8eh		;2a09	11 8e 4a	. . J
	ld bc,00028h		;2a0c	01 28 00	. ( .
	ldir			;2a0f	ed b0		. .
	ld hl,04d46h		;2a11	21 46 4d	! F M
	ld de,04d47h		;2a14	11 47 4d	. G M
	ld (hl),020h		;2a17	36 20		6  
	ld bc,0x18f		;2a19	01 8f 01	. . .
	ldir			;2a1c	ed b0		. .
	jr l29e9h		;2a1e	18 c9		. .
l2a20h:
	ld hl,04aaah		;2a20	21 aa 4a	! . J
	ld de,04aaeh		;2a23	11 ae 4a	. . J
	ld bc,8		;2a26	01 08 00	. . .
	ldir			;2a29	ed b0		. .
	ld hl,04e86h		;2a2b	21 86 4e	! . N
	ld de,04e87h		;2a2e	11 87 4e	. . N
	ld (hl),020h		;2a31	36 20		6  
	ld bc,0004fh		;2a33	01 4f 00	. O .
	ldir			;2a36	ed b0		. .
	jr l29e9h		;2a38	18 af		. .

FUN_FC:
	ld hl,(v4f89)		;2a3a	2a 89 4f	* . O
	inc hl			;2a3d	23		#
	ld (v4f89),hl		;2a3e	22 89 4f	" . O
	call sub_2b73h		;2a41	cd 73 2b	. s +
	cp 0ffh			;2a44	fe ff		. .
	jp z,l2b10h		;2a46	ca 10 2b	. . +
	call SETMEMMAP	;2a49	cd 1a 0f	. . .
	bit 1,(hl)		;2a4c	cb 4e		. N
	jp z,l2949h		;2a4e	ca 49 29	. I )
	push hl			;2a51	e5		.
	ld hl,(v4f89)		;2a52	2a 89 4f	* . O
	call sub_1eeah		;2a55	cd ea 1e	. . .
	pop hl			;2a58	e1		.
	jp z,l2949h		;2a59	ca 49 29	. I )
	jr FUN_FC		;2a5c	18 dc		. .

FUN_DC:
	ld hl,(v4f89)		;2a5e	2a 89 4f	* . O
	dec hl			;2a61	2b		+
	ld (v4f89),hl		;2a62	22 89 4f	" . O
	call sub_2b73h		;2a65	cd 73 2b	. s +
	cp 0ffh			;2a68	fe ff		. .
	jp z,l2b10h		;2a6a	ca 10 2b	. . +
	call SETMEMMAP	;2a6d	cd 1a 0f	. . .
	bit 1,(hl)		;2a70	cb 4e		. N
	jp z,l2949h		;2a72	ca 49 29	. I )
	push hl			;2a75	e5		.
	ld hl,(v4f89)		;2a76	2a 89 4f	* . O
	call sub_1eeah		;2a79	cd ea 1e	. . .
	pop hl			;2a7c	e1		.
	jp z,l2949h		;2a7d	ca 49 29	. I )
	jr FUN_DC		;2a80	18 dc		. .

sub_2a82h:
	ld hl,FLAGS		;2a82	21 79 4f	! y O
	bit FLAG_DISP,(hl)		;2a85	cb 66		. f
	ret nz			;2a87	c0		.
	ld hl,04123h		;2a88	21 23 41	! # A
	ld b,036h		;2a8b	06 36		. 6
	ld a,(NEEDSOFFSETDE)		;2a8d	3a 05 00	: . .
	cp MAGIC5			;2a90	fe aa		. .
	jr nz,l2a96h		;2a92	20 02		  .
	ld b,081h		;2a94	06 81		. .
l2a96h:
	ld a,(05cbah)		;2a96	3a ba 5c	: . \
	cp 005h			;2a99	fe 05		. .
	ld c,080h		;2a9b	0e 80		. .
	jr nz,l2aa1h		;2a9d	20 02		  .
	ld c,082h		;2a9f	0e 82		. .
l2aa1h:
	ld (hl),c		;2aa1	71		q
	inc hl			;2aa2	23		#
	djnz l2aa1h		;2aa3	10 fc		. .
	ld b,01ah		;2aa5	06 1a		. .
l2aa7h:
	ld a,0feh		;2aa7	3e fe		> .
	push bc			;2aa9	c5		.
	ld (hl),060h		;2aaa	36 60		6 `
	inc hl			;2aac	23		#
	ld (hl),060h		;2aad	36 60		6 `
	inc hl			;2aaf	23		#
	ld (hl),084h		;2ab0	36 84		6 .
	ld b,028h		;2ab2	06 28		. (
l2ab4h:
	inc hl			;2ab4	23		#
	ld (hl),020h		;2ab5	36 20		6  
	djnz l2ab4h		;2ab7	10 fb		. .
	inc hl			;2ab9	23		#
	ld (hl),038h		;2aba	36 38		6 8
	inc hl			;2abc	23		#
	ld (hl),0c9h		;2abd	36 c9		6 .
	inc hl			;2abf	23		#
	ld (hl),030h		;2ac0	36 30		6 0
	ld b,007h		;2ac2	06 07		. .
l2ac4h:
	inc hl			;2ac4	23		#
	inc a			;2ac5	3c		<
	inc a			;2ac6	3c		<
	ld (hl),a		;2ac7	77		w
	inc hl			;2ac8	23		#
	inc a			;2ac9	3c		<
	inc a			;2aca	3c		<
	ld (hl),a		;2acb	77		w
	inc hl			;2acc	23		#
	ld (hl),c		;2acd	71		q
	djnz l2ac4h		;2ace	10 f4		. .
	pop bc			;2ad0	c1		.
	inc hl			;2ad1	23		#
	djnz l2aa7h		;2ad2	10 d3		. .
	ld b,036h		;2ad4	06 36		. 6
	ld a,(NEEDSOFFSETDE)		;2ad6	3a 05 00	: . .
	cp MAGIC5			;2ad9	fe aa		. .
	jr nz,l2adfh		;2adb	20 02		  .
	ld b,0fah		;2add	06 fa		. .
l2adfh:
	ld (hl),c		;2adf	71		q
	inc hl			;2ae0	23		#
	djnz l2adfh		;2ae1	10 fc		. .
	ld a,004h		;2ae3	3e 04		> .
	call OUT_CH		;2ae5	cd 84 10	. . .
	ld a,000h		;2ae8	3e 00		> .
	call SETMEMMAP	;2aea	cd 1a 0f	. . .
	ret			;2aed	c9		.
sub_2aeeh:
	M_OUT_MSG 0xd082, 0x05 ; "PAGE "
	M_OUT_VAR 0x4f89, 0x04
	M_LEFT 1
	M_SOMETHING1 v4f89, 4
	ret
sub_2b05h:
	call sub_07f9h		;2b05	cd f9 07	. . .
	cp 0ffh			;2b08	fe ff		. .
	jr z,l2b10h		;2b0a	28 04		( .
	call SETMEMMAP	;2b0c	cd 1a 0f	. . .
	ret			;2b0f	c9		.
l2b10h:
	M_OUT_MSG 0xd087, 0x14 ; 04 "INVALID PAGE NUMBER"
	ret			;2b16	c9		.
l2b17h:
	ld a,(05cbch)		;2b17	3a bc 5c	: . \
	cp 055h			;2b1a	fe 55		. U
	jp z,l2783h		;2b1c	ca 83 27	. . '
	call l2b10h		;2b1f	cd 10 2b	. . +
	jp l1934h		;2b22	c3 34 19	. 4 .
sub_2b25h:
	call 08b36h		;2b25	cd 36 8b	. 6 .
	ld (05cc3h),hl		;2b28	22 c3 5c	" . \
	ld hl,(05e9dh)		;2b2b	2a 9d 5e	* . ^
	ld (05cbfh),hl		;2b2e	22 bf 5c	" . \
	ld a,053h		;2b31	3e 53		> S
	ld (05cc1h),a		;2b33	32 c1 5c	2 . \
	ld a,050h		;2b36	3e 50		> P
	ld (05cc2h),a		;2b38	32 c2 5c	2 . \
	call 0878fh		;2b3b	cd 8f 87	. . .
	ret			;2b3e	c9		.
sub_2b3fh:
	ld a,(05cbah)		;2b3f	3a ba 5c	: . \
	cp 005h			;2b42	fe 05		. .
	jr z,l2b4ah		;2b44	28 04		( .
	call sub_07f9h		;2b46	cd f9 07	. . .
	ret			;2b49	c9		.
l2b4ah:
	ld a,(05e36h)		;2b4a	3a 36 5e	: 6 ^
	bit 1,a			;2b4d	cb 4f		. O
	ld a,0ffh		;2b4f	3e ff		> .
	jr nz,l2b60h		;2b51	20 0d		  .
	call sub_1eeah		;2b53	cd ea 1e	. . .
	ret nz			;2b56	c0		.
	ld de,(v4f89)		;2b57	ed 5b 89 4f	. [ . O
l2b5bh:
	inc de			;2b5b	13		.
	call CMP_HLDE		;2b5c	cd 20 0f	.   .
	ret nz			;2b5f	c0		.
l2b60h:
	ld de,(05e9dh)		;2b60	ed 5b 9d 5e	. [ . ^
	call 08b36h		;2b64	cd 36 8b	. 6 .
	call 08879h		;2b67	cd 79 88	. y .
	cp 0ffh			;2b6a	fe ff		. .
	ret z			;2b6c	c8		.
	ld hl,05cc6h		;2b6d	21 c6 5c	! . \
	ld a,000h		;2b70	3e 00		> .
	ret			;2b72	c9		.
sub_2b73h:
	ld a,(05cbah)		;2b73	3a ba 5c	: . \
	cp 005h			;2b76	fe 05		. .
	jr z,l2b7eh		;2b78	28 04		( .
	call sub_07f9h		;2b7a	cd f9 07	. . .
	ret			;2b7d	c9		.
l2b7eh:
	ld de,(05e9dh)		;2b7e	ed 5b 9d 5e	. [ . ^
	call 08b36h		;2b82	cd 36 8b	. 6 .
	call 08879h		;2b85	cd 79 88	. y .
	ld hl,05cc6h		;2b88	21 c6 5c	! . \
	ret			;2b8b	c9		.

TASK_3:
	ld sp,050b9h		;2b8c	31 b9 50	1 . P
	call sub_0334h		;2b8f	cd 34 03	. 4 .
	ld hl,TASK_3		;2b92	21 8c 2b	! . +
	push hl			;2b95	e5		.
	ld a,(FLAGS)		;2b96	3a 79 4f	: y O
	bit FLAG_DISP,a			;2b99	cb 67		. g
	ret z			;2b9b	c8		.
	ld a,(05754h)		;2b9c	3a 54 57	: T W
	inc a			;2b9f	3c		<
	ld ix,(05755h)		;2ba0	dd 2a 55 57	. * U W
	ld de,4		;2ba4	11 04 00	. . .
	add ix,de		;2ba7	dd 19		. .
	cp 007h			;2ba9	fe 07		. .
	jr c,l2bafh		;2bab	38 02		8 .
	ld a,001h		;2bad	3e 01		> .
l2bafh:
	cp 001h			;2baf	fe 01		. .
	jr nz,l2bb7h		;2bb1	20 04		  .
	ld ix,0573ch		;2bb3	dd 21 3c 57	. ! < W
l2bb7h:
	ld (05755h),ix		;2bb7	dd 22 55 57	. " U W
	ld (05754h),a		;2bbb	32 54 57	2 T W
	ld c,a			;2bbe	4f		O
	ld b,000h		;2bbf	06 00		. .
	ld hl,04108h		;2bc1	21 08 41	! . A
	add hl,bc		;2bc4	09		.
	ld a,(hl)		;2bc5	7e		~
	or a			;2bc6	b7		.
	ret z			;2bc7	c8		.
	ld a,(ix+000h)		;2bc8	dd 7e 00	. ~ .
	cp 002h			;2bcb	fe 02		. .
l2bcdh:
	jp c,l2e0eh		;2bcd	da 0e 2e	. . .
	jp z,l2df4h		;2bd0	ca f4 2d	. . -
	cp 004h			;2bd3	fe 04		. .
	jr c,l2be2h		;2bd5	38 0b		8 .
	jp z,l2d1bh		;2bd7	ca 1b 2d	. . -
	cp 006h			;2bda	fe 06		. .
	jp c,l2df5h		;2bdc	da f5 2d	. . -
	jp l2e13h		;2bdf	c3 13 2e	. . .
l2be2h:
	ld h,(ix+002h)		;2be2	dd 66 02	. f .
	ld l,(ix+001h)		;2be5	dd 6e 01	. n .
	push hl			;2be8	e5		.
	pop iy			;2be9	fd e1		. .
	ld a,000h		;2beb	3e 00		> .
	ld (ix+003h),a		;2bed	dd 77 03	. w .
	ld a,(iy+00dh)		;2bf0	fd 7e 0d	. ~ .
	or a			;2bf3	b7		.
	jp nz,l2e13h		;2bf4	c2 13 2e	. . .
	ld hl,l311fh		;2bf7	21 1f 31	! . 1
	ld d,(iy+00fh)		;2bfa	fd 56 0f	. V .
	ld e,(iy+00eh)		;2bfd	fd 5e 0e	. ^ .
	call CMP_HLDE		;2c00	cd 20 0f	.   .
	jr nz,l2c0fh		;2c03	20 0a		  .
	ld a,(iy+001h)		;2c05	fd 7e 01	. ~ .
	or a			;2c08	b7		.
	jp z,l2e0eh		;2c09	ca 0e 2e	. . .
	jp l2e13h		;2c0c	c3 13 2e	. . .
l2c0fh:
	ld h,(iy+00fh)		;2c0f	fd 66 0f	. f .
	ld l,(iy+00eh)		;2c12	fd 6e 0e	. n .
	ld de,00028h		;2c15	11 28 00	. ( .
	add hl,de		;2c18	19		.
	ld a,(iy+011h)		;2c19	fd 7e 11	. ~ .
	cp 008h			;2c1c	fe 08		. .
	jr c,l2c62h		;2c1e	38 42		8 B
	ld a,(iy+010h)		;2c20	fd 7e 10	. ~ .
	call sub_0f26h		;2c23	cd 26 0f	. & .
	ld (iy+010h),a		;2c26	fd 77 10	. w .
	bit 1,(hl)		;2c29	cb 4e		. N
	jp z,l2c92h		;2c2b	ca 92 2c	. . ,
l2c2eh:
	ld a,001h		;2c2e	3e 01		> .
	ld (iy+011h),a		;2c30	fd 77 11	. w .
	ld bc,18		;2c33	01 12 00	. . .
	add hl,bc		;2c36	09		.
	ld (iy+015h),h		;2c37	fd 74 15	. t .
	ld (iy+014h),l		;2c3a	fd 75 14	. u .
	ld a,(hl)		;2c3d	7e		~
	ld bc,30		;2c3e	01 1e 00	. . .
	add hl,bc		;2c41	09		.
l2c42h:
	ld (iy+00fh),h		;2c42	fd 74 0f	. t .
	ld (iy+00eh),l		;2c45	fd 75 0e	. u .
	call sub_2c54h		;2c48	cd 54 2c	. T ,
	call sub_2d02h		;2c4b	cd 02 2d	. . -
	or a			;2c4e	b7		.
	jr z,l2c0fh		;2c4f	28 be		( .
	jp l2e13h		;2c51	c3 13 2e	. . .
sub_2c54h:
	and 007h		;2c54	e6 07		. .
	ld c,a			;2c56	4f		O
	ld b,000h		;2c57	06 00		. .
	ld hl,TABLE1		;2c59	21 e1 22	! . "
	add hl,bc		;2c5c	09		.
	ld a,(hl)		;2c5d	7e		~
	ld (iy+00dh),a		;2c5e	fd 77 0d	. w .
	ret			;2c61	c9		.
l2c62h:
	inc (iy+011h)		;2c62	fd 34 11	. 4 .
	ld a,(iy+010h)		;2c65	fd 7e 10	. ~ .
	call SETMEMMAP	;2c68	cd 1a 0f	. . .
	push hl			;2c6b	e5		.
	ld h,(iy+015h)		;2c6c	fd 66 15	. f .
	ld l,(iy+014h)		;2c6f	fd 6e 14	. n .
	ld c,004h		;2c72	0e 04		. .
	add hl,bc		;2c74	09		.
	ld a,(hl)		;2c75	7e		~
	ld (iy+015h),h		;2c76	fd 74 15	. t .
	ld (iy+014h),l		;2c79	fd 75 14	. u .
	pop hl			;2c7c	e1		.
	jr l2c42h		;2c7d	18 c3		. .
l2c7fh:
	ld hl,l311fh		;2c7f	21 1f 31	! . 1
	ld (iy+00fh),h		;2c82	fd 74 0f	. t .
	ld (iy+00eh),l		;2c85	fd 75 0e	. u .
	ld a,(iy+009h)		;2c88	fd 7e 09	. ~ .
	inc a			;2c8b	3c		<
	ld (iy+00dh),a		;2c8c	fd 77 0d	. w .
	jp l2e13h		;2c8f	c3 13 2e	. . .
l2c92h:
	ld a,(05fd5h)		;2c92	3a d5 5f	: . _
	or a			;2c95	b7		.
	jr z,l2c7fh		;2c96	28 e7		( .
	call sub_2e3ah		;2c98	cd 3a 2e	. : .
	jr z,l2c7fh		;2c9b	28 e2		( .
	ld c,b			;2c9d	48		H
	ld b,003h		;2c9e	06 03		. .
	ld hl,0603ah		;2ca0	21 3a 60	! : `
l2ca3h:
	ld a,(hl)		;2ca3	7e		~
	cp c			;2ca4	b9		.
	jr nz,l2cb3h		;2ca5	20 0c		  .
	inc hl			;2ca7	23		#
	ld a,(hl)		;2ca8	7e		~
	cp e			;2ca9	bb		.
	jr nz,l2cb4h		;2caa	20 08		  .
	inc hl			;2cac	23		#
	ld a,(hl)		;2cad	7e		~
	cp d			;2cae	ba		.
	jr nz,l2cb5h		;2caf	20 04		  .
	jr l2cc2h		;2cb1	18 0f		. .
l2cb3h:
	inc hl			;2cb3	23		#
l2cb4h:
	inc hl			;2cb4	23		#
l2cb5h:
	inc hl			;2cb5	23		#
	djnz l2ca3h		;2cb6	10 eb		. .
	push de			;2cb8	d5		.
	call sub_2e3ah		;2cb9	cd 3a 2e	. : .
	pop de			;2cbc	d1		.
	ld (hl),d		;2cbd	72		r
	dec hl			;2cbe	2b		+
	ld (hl),e		;2cbf	73		s
	jr l2c7fh		;2cc0	18 bd		. .
l2cc2h:
	ld a,003h		;2cc2	3e 03		> .
	sub b			;2cc4	90		.
	push af			;2cc5	f5		.
	ld a,c			;2cc6	79		y
	call SETMEMMAP	;2cc7	cd 1a 0f	. . .
	ld (iy+010h),a		;2cca	fd 77 10	. w .
	ex de,hl		;2ccd	eb		.
	res 7,(hl)		;2cce	cb be		. .
	push iy			;2cd0	fd e5		. .
	pop bc			;2cd2	c1		.
	inc bc			;2cd3	03		.
	inc bc			;2cd4	03		.
	inc bc			;2cd5	03		.
	inc bc			;2cd6	03		.
	ld (06050h),bc		;2cd7	ed 43 50 60	. C P `
	ld a,(06052h)		;2cdb	3a 52 60	: R `
	ld e,a			;2cde	5f		_
	pop af			;2cdf	f1		.
	inc a			;2ce0	3c		<
	cp 003h			;2ce1	fe 03		. .
	jr c,l2ce7h		;2ce3	38 02		8 .
	ld a,000h		;2ce5	3e 00		> .
l2ce7h:
	ld d,a			;2ce7	57		W
	ld a,(06049h)		;2ce8	3a 49 60	: I `
	cp d			;2ceb	ba		.
	jr nz,l2cfch		;2cec	20 0e		  .
	ld a,(06044h)		;2cee	3a 44 60	: D `
	cp 004h			;2cf1	fe 04		. .
	jr c,l2cf8h		;2cf3	38 03		8 .
	ld a,e			;2cf5	7b		{
	jr l2cfeh		;2cf6	18 06		. .
l2cf8h:
	ld a,e			;2cf8	7b		{
	dec a			;2cf9	3d		=
	jr l2cfeh		;2cfa	18 02		. .
l2cfch:
	ld a,e			;2cfc	7b		{
	inc a			;2cfd	3c		<
l2cfeh:
	ld (bc),a		;2cfe	02		.
	jp l2c2eh		;2cff	c3 2e 2c	. . ,
sub_2d02h:
	ld a,(iy+010h)		;2d02	fd 7e 10	. ~ .
	call SETMEMMAP	;2d05	cd 1a 0f	. . .
	ld a,020h		;2d08	3e 20		>  
	ld b,(iy+00dh)		;2d0a	fd 46 0d	. F .
	ld h,(iy+00fh)		;2d0d	fd 66 0f	. f .
	ld l,(iy+00eh)		;2d10	fd 6e 0e	. n .
l2d13h:
	cp (hl)			;2d13	be		.
	ret nz			;2d14	c0		.
	inc hl			;2d15	23		#
	djnz l2d13h		;2d16	10 fb		. .
	ld a,000h		;2d18	3e 00		> .
	ret			;2d1a	c9		.
l2d1bh:
	ld h,(ix+002h)		;2d1b	dd 66 02	. f .
	ld l,(ix+001h)		;2d1e	dd 6e 01	. n .
	push hl			;2d21	e5		.
	pop iy			;2d22	fd e1		. .
	ld (ix+003h),000h	;2d24	dd 36 03 00	. 6 . .
	ld a,(iy+008h)		;2d28	fd 7e 08	. ~ .
	or a			;2d2b	b7		.
	jp nz,l2e13h		;2d2c	c2 13 2e	. . .
	ld a,(iy+01ah)		;2d2f	fd 7e 1a	. ~ .
	call SETMEMMAP	;2d32	cd 1a 0f	. . .
	ld a,(iy+019h)		;2d35	fd 7e 19	. ~ .
	cp 00ah			;2d38	fe 0a		. .
	jp nc,l2de4h		;2d3a	d2 e4 2d	. . -
	cp 009h			;2d3d	fe 09		. .
	jp nz,l2d7ah		;2d3f	c2 7a 2d	. z -
	ld h,(iy+018h)		;2d42	fd 66 18	. f .
	ld l,(iy+017h)		;2d45	fd 6e 17	. n .
	ld a,(iy+01ah)		;2d48	fd 7e 1a	. ~ .
	call sub_0f26h		;2d4b	cd 26 0f	. & .
	ld (iy+01ah),a		;2d4e	fd 77 1a	. w .
	bit 1,(hl)		;2d51	cb 4e		. N
	jr nz,l2d5bh		;2d53	20 06		  .
	inc (iy+019h)		;2d55	fd 34 19	. 4 .
	jp l2e13h		;2d58	c3 13 2e	. . .
l2d5bh:
	ld (iy+019h),001h	;2d5b	fd 36 19 01	. 6 . .
	res 7,(iy+000h)		;2d5f	fd cb 00 be	. . . .
	ld de,16		;2d63	11 10 00	. . .
	add hl,de		;2d66	19		.
	ld (iy+016h),h		;2d67	fd 74 16	. t .
	ld (iy+015h),l		;2d6a	fd 75 15	. u .
	ld de,32		;2d6d	11 20 00	.   .
	add hl,de		;2d70	19		.
	ld (iy+018h),h		;2d71	fd 74 18	. t .
	ld (iy+017h),l		;2d74	fd 75 17	. u .
	jp l2e13h		;2d77	c3 13 2e	. . .
l2d7ah:
	ld a,(iy+01ah)		;2d7a	fd 7e 1a	. ~ .
	ld (iy+009h),a		;2d7d	fd 77 09	. w .
	ld h,(iy+018h)		;2d80	fd 66 18	. f .
	ld l,(iy+017h)		;2d83	fd 6e 17	. n .
	ld de,00028h		;2d86	11 28 00	. ( .
	ld (iy+00bh),h		;2d89	fd 74 0b	. t .
	ld (iy+00ah),l		;2d8c	fd 75 0a	. u .
	add hl,de		;2d8f	19		.
	ld (iy+018h),h		;2d90	fd 74 18	. t .
	ld (iy+017h),l		;2d93	fd 75 17	. u .
	ld h,(iy+016h)		;2d96	fd 66 16	. f .
	ld l,(iy+015h)		;2d99	fd 6e 15	. n .
	ld a,(hl)		;2d9c	7e		~
	ld (iy+00fh),a		;2d9d	fd 77 0f	. w .
	inc hl			;2da0	23		#
	ld a,(hl)		;2da1	7e		~
	rrca			;2da2	0f		.
	rrca			;2da3	0f		.
	rrca			;2da4	0f		.
	and 01fh		;2da5	e6 1f		. .
	ld (iy+01ch),a		;2da7	fd 77 1c	. w .
	ld a,(hl)		;2daa	7e		~
	push hl			;2dab	e5		.
	and 007h		;2dac	e6 07		. .
	ld (iy+00ch),a		;2dae	fd 77 0c	. w .
	add a,a			;2db1	87		.
	ld e,a			;2db2	5f		_
	ld d,000h		;2db3	16 00		. .
	ld hl,l0b65h		;2db5	21 65 0b	! e .
	add hl,de		;2db8	19		.
	ld e,(hl)		;2db9	5e		^
	inc hl			;2dba	23		#
	ld d,(hl)		;2dbb	56		V
	ld (iy+00eh),d		;2dbc	fd 72 0e	. r .
	ld (iy+00dh),e		;2dbf	fd 73 0d	. s .
	pop hl			;2dc2	e1		.
	inc hl			;2dc3	23		#
	ld a,(hl)		;2dc4	7e		~
	ld (iy+010h),a		;2dc5	fd 77 10	. w .
	inc hl			;2dc8	23		#
	ld a,(hl)		;2dc9	7e		~
	and 0c0h		;2dca	e6 c0		. .
	ld d,a			;2dcc	57		W
	ld a,(iy+01ch)		;2dcd	fd 7e 1c	. ~ .
	or d			;2dd0	b2		.
	ld (iy+01ch),a		;2dd1	fd 77 1c	. w .
	inc hl			;2dd4	23		#
	inc (iy+019h)		;2dd5	fd 34 19	. 4 .
	ld (iy+016h),h		;2dd8	fd 74 16	. t .
	ld (iy+015h),l		;2ddb	fd 75 15	. u .
	ld (iy+008h),001h	;2dde	fd 36 08 01	. 6 . .
	jr l2e13h		;2de2	18 2f		. /
l2de4h:
	bit 7,(iy+000h)		;2de4	fd cb 00 7e	. . . ~
	jr z,l2e13h		;2de8	28 29		( )
	ld (ix+000h),000h	;2dea	dd 36 00 00	. 6 . .
	ld (ix+003h),001h	;2dee	dd 36 03 01	. 6 . .
	jr l2e13h		;2df2	18 1f		. .
l2df4h:
	nop			;2df4	00		.
l2df5h:
	ld h,(ix+002h)		;2df5	dd 66 02	. f .
	ld l,(ix+001h)		;2df8	dd 6e 01	. n .
	push hl			;2dfb	e5		.
	pop iy			;2dfc	fd e1		. .
	ld (ix+003h),000h	;2dfe	dd 36 03 00	. 6 . .
	ld a,(iy+01dh)		;2e02	fd 7e 1d	. ~ .
	or a			;2e05	b7		.
	jr nz,l2e13h		;2e06	20 0b		  .
	ld (ix+000h),000h	;2e08	dd 36 00 00	. 6 . .
	jr l2e0eh		;2e0c	18 00		. .
l2e0eh:
	ld a,001h		;2e0e	3e 01		> .
	ld (ix+003h),a		;2e10	dd 77 03	. w .
l2e13h:
	ld a,(ix+003h)		;2e13	dd 7e 03	. ~ .
	or a			;2e16	b7		.
	ret z			;2e17	c8		.
	ld a,(05754h)		;2e18	3a 54 57	: T W
	ld d,000h		;2e1b	16 00		. .
	ld e,a			;2e1d	5f		_
	ld hl,053b4h		;2e1e	21 b4 53	! . S
	add hl,de		;2e21	19		.
	ld a,(hl)		;2e22	7e		~
	ld (05759h),hl		;2e23	22 59 57	" Y W
	or a			;2e26	b7		.
	jr z,l2e2fh		;2e27	28 06		( .
	ld a,000h		;2e29	3e 00		> .
	ld (ix+000h),a		;2e2b	dd 77 00	. w .
	ret			;2e2e	c9		.
l2e2fh:
	call sub_2e3ah		;2e2f	cd 3a 2e	. : .
	jr nz,l2e54h		;2e32	20 20		   
l2e34h:
	ld a,000h		;2e34	3e 00		> .
	ld (ix+000h),a		;2e36	dd 77 00	. w .
	ret			;2e39	c9		.
sub_2e3ah:
	ld de,00027h		;2e3a	11 27 00	. ' .
	ld hl,052a4h		;2e3d	21 a4 52	! . R
	ld a,(05754h)		;2e40	3a 54 57	: T W
	ld b,a			;2e43	47		G
l2e44h:
	add hl,de		;2e44	19		.
	djnz l2e44h		;2e45	10 fd		. .
	ld b,(hl)		;2e47	46		F
	inc hl			;2e48	23		#
	inc hl			;2e49	23		#
	ld e,(hl)		;2e4a	5e		^
	ld (hl),000h		;2e4b	36 00		6 .
	inc hl			;2e4d	23		#
	ld a,(hl)		;2e4e	7e		~
	ld (hl),000h		;2e4f	36 00		6 .
	ld d,a			;2e51	57		W
	or e			;2e52	b3		.
	ret			;2e53	c9		.
l2e54h:
	ld a,b			;2e54	78		x
	call SETMEMMAP	;2e55	cd 1a 0f	. . .
	ld a,(de)		;2e58	1a		.
	bit 0,a			;2e59	cb 47		. G
	jr nz,l2e34h		;2e5b	20 d7		  .
	res 7,a			;2e5d	cb bf		. .
	ld (de),a		;2e5f	12		.
	ld (05b6bh),de		;2e60	ed 53 6b 5b	. S k [
	ld hl,12		;2e64	21 0c 00	! . .
	add hl,de		;2e67	19		.
	ld a,(hl)		;2e68	7e		~
	call sub_16eeh		;2e69	cd ee 16	. . .
	dec hl			;2e6c	2b		+
	dec hl			;2e6d	2b		+
	ld a,(hl)		;2e6e	7e		~
	or a			;2e6f	b7		.
	call nz,09474h		;2e70	c4 74 94	. t .
	inc de			;2e73	13		.
	ld hl,(05759h)		;2e74	2a 59 57	* Y W
	ld a,(de)		;2e77	1a		.
	ld (hl),a		;2e78	77		w
	ex de,hl		;2e79	eb		.
	inc hl			;2e7a	23		#
	inc hl			;2e7b	23		#
	ld a,(hl)		;2e7c	7e		~
	cp 002h			;2e7d	fe 02		. .
	jr c,l2e93h		;2e7f	38 12		8 .
	jp z,l2f5fh		;2e81	ca 5f 2f	. _ /
	cp 004h			;2e84	fe 04		. .
	jp c,l3016h		;2e86	da 16 30	. . 0
	jr z,l2eaah		;2e89	28 1f		( .
	cp 006h			;2e8b	fe 06		. .
	jp c,l2f80h		;2e8d	da 80 2f	. . /
	jp l311eh		;2e90	c3 1e 31	. . 1
l2e93h:
	call sub_30f6h		;2e93	cd f6 30	. . 0
	ld (iy+01dh),001h	;2e96	fd 36 1d 01	. 6 . .
	ld a,(05754h)		;2e9a	3a 54 57	: T W
	ld c,a			;2e9d	4f		O
	ld b,000h		;2e9e	06 00		. .
	ld de,(05b6bh)		;2ea0	ed 5b 6b 5b	. [ k [
	ld a,001h		;2ea4	3e 01		> .
	call sub_09fbh		;2ea6	cd fb 09	. . .
	ret			;2ea9	c9		.
l2eaah:
	call sub_30f6h		;2eaa	cd f6 30	. . 0
	ld (ix+000h),004h	;2ead	dd 36 00 04	. 6 . .
	ld hl,04114h		;2eb1	21 14 41	! . A
	call sub_0db5h		;2eb4	cd b5 0d	. . .
	ld (iy+002h),d		;2eb7	fd 72 02	. r .
	ld (iy+001h),e		;2eba	fd 73 01	. s .
	ld hl,04108h		;2ebd	21 08 41	! . A
	add hl,bc		;2ec0	09		.
	ld b,(hl)		;2ec1	46		F
	ld hl,0ffcfh		;2ec2	21 cf ff	! . .
	ld de,00043h		;2ec5	11 43 00	. C .
l2ec8h:
	add hl,de		;2ec8	19		.
	djnz l2ec8h		;2ec9	10 fd		. .
	ld (iy+004h),h		;2ecb	fd 74 04	. t .
	ld (iy+003h),l		;2ece	fd 75 03	. u .
	set 0,(iy+005h)		;2ed1	fd cb 05 c6	. . . .
	set 1,(iy+005h)		;2ed5	fd cb 05 ce	. . . .
	ld hl,(05b6bh)		;2ed9	2a 6b 5b	* k [
	inc hl			;2edc	23		#
	inc hl			;2edd	23		#
	ld a,(hl)		;2ede	7e		~
	ld (iy+006h),a		;2edf	fd 77 06	. w .
	ld de,14		;2ee2	11 0e 00	. . .
	add hl,de		;2ee5	19		.
	ld a,(hl)		;2ee6	7e		~
	ld (iy+014h),a		;2ee7	fd 77 14	. w .
	inc hl			;2eea	23		#
	ld a,(hl)		;2eeb	7e		~
	rrca			;2eec	0f		.
	rrca			;2eed	0f		.
	rrca			;2eee	0f		.
	and 01fh		;2eef	e6 1f		. .
	ld (iy+01bh),a		;2ef1	fd 77 1b	. w .
	dec hl			;2ef4	2b		+
	push hl			;2ef5	e5		.
	ld de,32		;2ef6	11 20 00	.   .
	add hl,de		;2ef9	19		.
	push hl			;2efa	e5		.
	ld h,(iy+002h)		;2efb	fd 66 02	. f .
	ld l,(iy+001h)		;2efe	fd 6e 01	. n .
	ld d,(iy+004h)		;2f01	fd 56 04	. V .
	ld e,(iy+003h)		;2f04	fd 5e 03	. ^ .
	add hl,de		;2f07	19		.
	ld de,0x31		;2f08	11 31 00	. 1 .
	add hl,de		;2f0b	19		.
	pop de			;2f0c	d1		.
	ld bc,00028h		;2f0d	01 28 00	. ( .
	ex de,hl		;2f10	eb		.
	ldir			;2f11	ed b0		. .
	ld (iy+018h),h		;2f13	fd 74 18	. t .
	ld (iy+017h),l		;2f16	fd 75 17	. u .
	ex de,hl		;2f19	eb		.
	pop de			;2f1a	d1		.
	inc de			;2f1b	13		.
	ld a,(de)		;2f1c	1a		.
	ld b,a			;2f1d	47		G
	inc de			;2f1e	13		.
	ld a,(de)		;2f1f	1a		.
	ld (hl),038h		;2f20	36 38		6 8
	inc hl			;2f22	23		#
	ld (hl),a		;2f23	77		w
	inc hl			;2f24	23		#
	inc de			;2f25	13		.
	ld a,(de)		;2f26	1a		.
	or 03fh			;2f27	f6 3f		. ?
	ld (hl),a		;2f29	77		w
	inc de			;2f2a	13		.
	ld (iy+016h),d		;2f2b	fd 72 16	. r .
	ld (iy+015h),e		;2f2e	fd 73 15	. s .
	ld (iy+019h),002h	;2f31	fd 36 19 02	. 6 . .
	ld a,b			;2f35	78		x
	and 007h		;2f36	e6 07		. .
	ld (iy+013h),a		;2f38	fd 77 13	. w .
	add a,a			;2f3b	87		.
	ld hl,l0b65h		;2f3c	21 65 0b	! e .
	ld e,a			;2f3f	5f		_
	ld d,000h		;2f40	16 00		. .
	add hl,de		;2f42	19		.
	ld e,(hl)		;2f43	5e		^
	inc hl			;2f44	23		#
	ld d,(hl)		;2f45	56		V
	ld (iy+012h),d		;2f46	fd 72 12	. r .
	ld (iy+011h),e		;2f49	fd 73 11	. s .
	ld (iy+008h),000h	;2f4c	fd 36 08 00	. 6 . .
	ld a,(CUR_MAP)		;2f50	3a 22 41	: " A
	ld (iy+01ah),a		;2f53	fd 77 1a	. w .
	ld (iy+000h),001h	;2f56	fd 36 00 01	. 6 . .
	ld (iy+01dh),004h	;2f5a	fd 36 1d 04	. 6 . .
	ret			;2f5e	c9		.
l2f5fh:
	call sub_30f6h		;2f5f	cd f6 30	. . 0
	ld a,002h		;2f62	3e 02		> .
	ld (ix+000h),a		;2f64	dd 77 00	. w .
	ld (iy+01dh),000h	;2f67	fd 36 1d 00	. 6 . .
	push af			;2f6b	f5		.
	ld hl,(05b6bh)		;2f6c	2a 6b 5b	* k [
	inc hl			;2f6f	23		#
	inc hl			;2f70	23		#
	ld a,(hl)		;2f71	7e		~
	ld b,00ah		;2f72	06 0a		. .
	cp 010h			;2f74	fe 10		. .
	jr z,l2f9fh		;2f76	28 27		( '
	ld b,003h		;2f78	06 03		. .
	jr nc,l2f9fh		;2f7a	30 23		0 #
	ld b,012h		;2f7c	06 12		. .
	jr l2f9fh		;2f7e	18 1f		. .
l2f80h:
	call sub_30f6h		;2f80	cd f6 30	. . 0
	ld a,005h		;2f83	3e 05		> .
	ld (ix+000h),a		;2f85	dd 77 00	. w .
	ld (iy+01dh),000h	;2f88	fd 36 1d 00	. 6 . .
	push af			;2f8c	f5		.
	ld hl,(05b6bh)		;2f8d	2a 6b 5b	* k [
	inc hl			;2f90	23		#
	inc hl			;2f91	23		#
	ld a,(hl)		;2f92	7e		~
	ld b,003h		;2f93	06 03		. .
	cp 010h			;2f95	fe 10		. .
	jr z,l2f9fh		;2f97	28 06		( .
	ld b,001h		;2f99	06 01		. .
	jr nc,l2f9fh		;2f9b	30 02		0 .
	ld b,006h		;2f9d	06 06		. .
l2f9fh:
	ld (iy+000h),b		;2f9f	fd 70 00	. p .
	ld (iy+009h),b		;2fa2	fd 70 09	. p .
	ld de,16		;2fa5	11 10 00	. . .
	add hl,de		;2fa8	19		.
	ld a,(hl)		;2fa9	7e		~
	ld de,30		;2faa	11 1e 00	. . .
	add hl,de		;2fad	19		.
	ld (iy+002h),h		;2fae	fd 74 02	. t .
	ld (iy+001h),l		;2fb1	fd 75 01	. u .
	bit 3,a			;2fb4	cb 5f		. _
	jr nz,l2fbch		;2fb6	20 04		  .
	ld a,028h		;2fb8	3e 28		> (
	jr l2fc6h		;2fba	18 0a		. .
l2fbch:
	and 007h		;2fbc	e6 07		. .
	ld c,a			;2fbe	4f		O
	ld b,000h		;2fbf	06 00		. .
	ld hl,TABLE1		;2fc1	21 e1 22	! . "
	add hl,bc		;2fc4	09		.
	ld a,(hl)		;2fc5	7e		~
l2fc6h:
	ld (iy+006h),a		;2fc6	fd 77 06	. w .
	ld (iy+007h),a		;2fc9	fd 77 07	. w .
	ld (iy+005h),008h	;2fcc	fd 36 05 08	. 6 . .
	ld hl,04114h		;2fd0	21 14 41	! . A
	ld a,(05754h)		;2fd3	3a 54 57	: T W
	ld c,a			;2fd6	4f		O
	ld b,000h		;2fd7	06 00		. .
	call sub_0db5h		;2fd9	cd b5 0d	. . .
	inc de			;2fdc	13		.
	inc de			;2fdd	13		.
	inc de			;2fde	13		.
	ld (iy+004h),d		;2fdf	fd 72 04	. r .
	ld (iy+003h),e		;2fe2	fd 73 03	. s .
	ld hl,04108h		;2fe5	21 08 41	! . A
	add hl,bc		;2fe8	09		.
	ld a,(hl)		;2fe9	7e		~
	ld (iy+008h),a		;2fea	fd 77 08	. w .
	ld a,(CUR_MAP)		;2fed	3a 22 41	: " A
	ld (iy+00ah),a		;2ff0	fd 77 0a	. w .
	ld hl,0575bh		;2ff3	21 5b 57	! [ W
	ld de,0575ch		;2ff6	11 5c 57	. \ W
	ld bc,l040fh		;2ff9	01 0f 04	. . .
	ld (hl),020h		;2ffc	36 20		6  
	ldir			;2ffe	ed b0		. .
l3000h:
	ld a,(05754h)		;3000	3a 54 57	: T W
	ld c,a			;3003	4f		O
	ld de,(05b6bh)		;3004	ed 5b 6b 5b	. [ k [
	ld a,002h		;3008	3e 02		> .
	push iy			;300a	fd e5		. .
	call sub_09fbh		;300c	cd fb 09	. . .
	pop iy			;300f	fd e1		. .
	pop af			;3011	f1		.
	ld (iy+01dh),a		;3012	fd 77 1d	. w .
	ret			;3015	c9		.
l3016h:
	ld hl,0575bh		;3016	21 5b 57	! [ W
	ld de,0575ch		;3019	11 5c 57	. \ W
l301ch:
	ld bc,l040fh		;301c	01 0f 04	. . .
	ld (hl),020h		;301f	36 20		6  
	ldir			;3021	ed b0		. .
	ld hl,04114h		;3023	21 14 41	! . A
	ld a,(05754h)		;3026	3a 54 57	: T W
	ld c,a			;3029	4f		O
	ld b,000h		;302a	06 00		. .
	call sub_0db5h		;302c	cd b5 0d	. . .
	ld hl,04108h		;302f	21 08 41	! . A
	add hl,bc		;3032	09		.
	ld a,(hl)		;3033	7e		~
	ld b,a			;3034	47		G
	ex de,hl		;3035	eb		.
	ld de,0575bh		;3036	11 5b 57	. [ W
l3039h:
	push bc			;3039	c5		.
	ld a,(hl)		;303a	7e		~
	bit 5,a			;303b	cb 6f		. o
	jr z,l3049h		;303d	28 0a		( .
	ld bc,00028h		;303f	01 28 00	. ( .
	push hl			;3042	e5		.
	inc hl			;3043	23		#
	inc hl			;3044	23		#
	inc hl			;3045	23		#
	ldir			;3046	ed b0		. .
	pop hl			;3048	e1		.
l3049h:
	ld bc,00043h		;3049	01 43 00	. C .
	add hl,bc		;304c	09		.
	pop bc			;304d	c1		.
	djnz l3039h		;304e	10 e9		. .
	ld a,(05754h)		;3050	3a 54 57	: T W
	ld c,a			;3053	4f		O
	ld b,000h		;3054	06 00		. .
	ld de,(05b6bh)		;3056	ed 5b 6b 5b	. [ k [
	ld hl,18		;305a	21 12 00	! . .
	add hl,de		;305d	19		.
	set 3,(hl)		;305e	cb de		. .
	ld a,002h		;3060	3e 02		> .
	push ix			;3062	dd e5		. .
	call sub_09fbh		;3064	cd fb 09	. . .
	pop ix			;3067	dd e1		. .
	call sub_30f6h		;3069	cd f6 30	. . 0
	ld (ix+000h),003h	;306c	dd 36 00 03	. 6 . .
	ld hl,04114h		;3070	21 14 41	! . A
	call sub_0db5h		;3073	cd b5 0d	. . .
	ld hl,3		;3076	21 03 00	! . .
	add hl,de		;3079	19		.
	ld (iy+007h),l		;307a	fd 75 07	. u .
	ld (iy+008h),h		;307d	fd 74 08	. t .
	ld de,00028h		;3080	11 28 00	. ( .
	add hl,de		;3083	19		.
	ld (iy+003h),h		;3084	fd 74 03	. t .
	ld (iy+002h),l		;3087	fd 75 02	. u .
	ld hl,(05b6bh)		;308a	2a 6b 5b	* k [
	inc hl			;308d	23		#
	inc hl			;308e	23		#
	ld a,(hl)		;308f	7e		~
	cp 010h			;3090	fe 10		. .
	jr nz,l3098h		;3092	20 04		  .
	ld a,003h		;3094	3e 03		> .
	jr l30a9h		;3096	18 11		. .
l3098h:
	jr nc,l309eh		;3098	30 04		0 .
	ld a,002h		;309a	3e 02		> .
	jr l30a9h		;309c	18 0b		. .
l309eh:
	ld a,(CFG8)		;309e	3a 3d 00	: = .
	bit 2,a			;30a1	cb 57		. W
	ld a,005h		;30a3	3e 05		> .
	jr z,l30a9h		;30a5	28 02		( .
	ld a,004h		;30a7	3e 04		> .
l30a9h:
	ld (iy+004h),a		;30a9	fd 77 04	. w .
	ld de,16		;30ac	11 10 00	. . .
	add hl,de		;30af	19		.
	ld a,(hl)		;30b0	7e		~
	ld (iy+015h),h		;30b1	fd 74 15	. t .
	ld (iy+014h),l		;30b4	fd 75 14	. u .
	and 007h		;30b7	e6 07		. .
	push af			;30b9	f5		.
	add a,a			;30ba	87		.
	ld e,a			;30bb	5f		_
	ld d,000h		;30bc	16 00		. .
	ld hl,l310eh		;30be	21 0e 31	! . 1
	add hl,de		;30c1	19		.
	ld a,(hl)		;30c2	7e		~
	ld (iy+005h),a		;30c3	fd 77 05	. w .
	inc hl			;30c6	23		#
	ld a,(hl)		;30c7	7e		~
	ld (iy+006h),a		;30c8	fd 77 06	. w .
	pop af			;30cb	f1		.
	di			;30cc	f3		.
	call sub_2c54h		;30cd	cd 54 2c	. T ,
	dec a			;30d0	3d		=
	ld (iy+009h),a		;30d1	fd 77 09	. w .
	ld a,(CUR_MAP)		;30d4	3a 22 41	: " A
	ld (iy+010h),a		;30d7	fd 77 10	. w .
	ld hl,(05b6bh)		;30da	2a 6b 5b	* k [
	ld de,0x30		;30dd	11 30 00	. 0 .
	add hl,de		;30e0	19		.
	ld (iy+00fh),h		;30e1	fd 74 0f	. t .
	ld (iy+00eh),l		;30e4	fd 75 0e	. u .
	ld a,001h		;30e7	3e 01		> .
	ld (iy+011h),a		;30e9	fd 77 11	. w .
	ld (iy+001h),000h	;30ec	fd 36 01 00	. 6 . .
	ld (iy+01dh),003h	;30f0	fd 36 1d 03	. 6 . .
	ei			;30f4	fb		.
	ret			;30f5	c9		.
sub_30f6h:
	ld a,(05754h)		;30f6	3a 54 57	: T W
	ld b,a			;30f9	47		G
	ld c,a			;30fa	4f		O
	ld hl,0566ah		;30fb	21 6a 56	! j V
	ld de,30		;30fe	11 1e 00	. . .
l3101h:
	add hl,de		;3101	19		.
	djnz l3101h		;3102	10 fd		. .
	ld (ix+002h),h		;3104	dd 74 02	. t .
	ld (ix+001h),l		;3107	dd 75 01	. u .
	push hl			;310a	e5		.
	pop iy			;310b	fd e1		. .
	ret			;310d	c9		.
l310eh:
	jr z,$+58		;310e	28 38		( 8
	inc h			;3110	24		$
	jr c,$+33		;3111	38 1f		8 .
	jr c,0x312d		;3113	38 18		8 .
	jr c,0x3127		;3115	38 10		8 .
	jr c,l311ch		;3117	38 03		8 .
	jr c,l311eh		;3119	38 03		8 .
	ld b,e			;311b	43		C
l311ch:
	inc bc			;311c	03		.
	ld d,e			;311d	53		S
l311eh:
	ret			;311e	c9		.
l311fh:
	; 40 spaces
	db "                                        "

; 0511dh has be initialized with sub_034eh
; Purpose unclear
TASK_4:
	ld sp,0511dh
	ld hl,TASK_4
	push hl			; We'll return here
	ld a,(v52bf)
	ld b,a
	ld a,(v52c0)
	cp b
	jr nz,l3185h		;3156	20 2d		  -
	xor a			;3158	af		.
	call SETMEMMAP	;3159	cd 1a 0f	. . .
	call HANDLE_SERIAL		; Something serial
	call HANDLE_KBD		; Something keyboard
	call HANDLE_FIFO4_1		; Something FIFO4 if CFG9!=0xaa
	call HANDLE_FIFO4_2		; Something FIFO4 if CFG9==0xaa
	call HANDLE_FIFO6		; Something FIFO6
	call HANDLE_PORT05			; Something PORT_05
	ld a,(05b7bh)
	and %00000001
	call nz,sub_9d2dh		; Something PORT_12 and FIFO3
	call sub_94b5h		; Do something if v5fa7==0xaa
	call sub_33dch		; Do something if CFG1==0x0aa
	call sub_33ffh		; Do something if CFG5!=0xaa
	call sub_3496h		; Do something depending on CFG11 and others
	jp sub_0334h		; A pretty unclear function, this one...
						; I suspect it jumps to the next task

l3185h:
	inc a			;3185	3c		<
	ld (v52c0),a		;3186	32 c0 52	2 . R
	ld b,032h		;3189	06 32		. 2
	ld a,(CFG2)		;318b	3a 07 00	: . .
	cp 0aah			;318e	fe aa		. .
	jr z,l31afh		;3190	28 1d		( .
	ld hl,(052c2h)		;3192	2a c2 52	* . R
	dec hl			;3195	2b		+
	ld a,l			;3196	7d		}
	or h			;3197	b4		.
	jr nz,l31aah		;3198	20 10		  .
	ld hl,003e7h		;319a	21 e7 03	! . .
	ld a,(052c1h)		;319d	3a c1 52	: . R
	dec a			;31a0	3d		=
	jr nz,l31a7h		;31a1	20 04		  .
	ld b,03bh		;31a3	06 3b		. ;
	jr l31ach		;31a5	18 05		. .
l31a7h:
	ld (052c1h),a		;31a7	32 c1 52	2 . R
l31aah:
	ld b,03ch		;31aa	06 3c		. <
l31ach:
	ld (052c2h),hl		;31ac	22 c2 52	" . R
l31afh:
	ld a,(052c1h)		;31af	3a c1 52	: . R
	dec a			;31b2	3d		=
	ld (052c1h),a		;31b3	32 c1 52	2 . R
	ld a,(CFG7)		;31b6	3a 3c 00	: < .
	cp 0bbh			;31b9	fe bb		. .
	jr nz,l31c1h		;31bb	20 04		  .
	in a,(PORT_30)		;31bd	db 30		. 0
	jr l31c3h		;31bf	18 02		. .
l31c1h:
	in a,(PORT_20)		;31c1	db 20		.  
l31c3h:
	ld a,(CFG6)		;31c3	3a 0d 00	: . .
	cp 0aah			;31c6	fe aa		. .
	jr nz,l31d5h		;31c8	20 0b		  .
	ld a,(05bafh)		;31ca	3a af 5b	: . [
l31cdh:
	and a			;31cd	a7		.
	ret z			;31ce	c8		.
	dec a			;31cf	3d		=
	ld (05bafh),a		;31d0	32 af 5b	2 . [
	jr l31dah		;31d3	18 05		. .
l31d5h:
	ld a,(052c1h)		;31d5	3a c1 52	: . R
	and a			;31d8	a7		.
	ret nz			;31d9	c0		.
l31dah:
	call sub_32d1h		;31da	cd d1 32	. . 2
	xor a			;31dd	af		.
	ld hl,05ea7h		;31de	21 a7 5e	! . ^
	cp (hl)			;31e1	be		.
	jr z,l31e5h		;31e2	28 01		( .
	dec (hl)		;31e4	35		5
l31e5h:
	ld hl,05ea8h		;31e5	21 a8 5e	! . ^
	cp (hl)			;31e8	be		.
	jr z,l31ech		;31e9	28 01		( .
	dec (hl)		;31eb	35		5
l31ech:
	ld hl,06029h		;31ec	21 29 60	! ) `
	cp (hl)			;31ef	be		.
	jr z,l31f3h		;31f0	28 01		( .
	dec (hl)		;31f2	35		5
l31f3h:
	ld a,(05b7bh)		;31f3	3a 7b 5b	: { [
	and 001h		;31f6	e6 01		. .
	jp z,l3248h		;31f8	ca 48 32	. H 2
	ld hl,06054h		;31fb	21 54 60	! T `
	ld a,(hl)		;31fe	7e		~
	cp 0ffh			;31ff	fe ff		. .
	jr z,l3204h		;3201	28 01		( .
	inc (hl)		;3203	34		4
l3204h:
	ld a,(060cch)		;3204	3a cc 60	: . `
	or a			;3207	b7		.
	jr z,l323fh		;3208	28 35		( 5
	cp 003h			;320a	fe 03		. .
	jr z,l3229h		;320c	28 1b		( .
	cp 002h			;320e	fe 02		. .
	jr z,l321ah		;3210	28 08		( .
	ld a,002h		;3212	3e 02		> .
	ld (060cch),a		;3214	32 cc 60	2 . `
	jp l3248h		;3217	c3 48 32	. H 2
l321ah:
	ld a,005h		;321a	3e 05		> .
	out (PORT_12),a		;321c	d3 12		. .
	ld a,0a0h		;321e	3e a0		> .
	out (PORT_12),a		;3220	d3 12		. .
	ld a,003h		;3222	3e 03		> .
	ld (060cch),a		;3224	32 cc 60	2 . `
	jr l3248h		;3227	18 1f		. .
l3229h:
	ld a,005h		;3229	3e 05		> .
	out (PORT_12),a		;322b	d3 12		. .
	ld a,020h		;322d	3e 20		>  
	out (PORT_12),a		;322f	d3 12		. .
	ld a,005h		;3231	3e 05		> .
	out (PORT_12),a		;3233	d3 12		. .
	ld a,0a0h		;3235	3e a0		> .
	out (PORT_12),a		;3237	d3 12		. .
	sub a			;3239	97		.
	ld (060cch),a		;323a	32 cc 60	2 . `
	jr l3248h		;323d	18 09		. .
l323fh:
	ld a,005h		;323f	3e 05		> .
	out (PORT_12),a		;3241	d3 12		. .
	ld a,(060ceh)		;3243	3a ce 60	: . `
	out (PORT_12),a		;3246	d3 12		. .
l3248h:
	ld hl,052c4h		;3248	21 c4 52	! . R
	inc (hl)		;324b	34		4
	ld a,b			;324c	78		x
	ld (052c1h),a		;324d	32 c1 52	2 . R
	call 0b2fbh		;3250	cd fb b2	. . .
	ld hl,(05b9bh)		;3253	2a 9b 5b	* . [
	ld a,l			;3256	7d		}
	or h			;3257	b4		.
	jp z,l328eh		;3258	ca 8e 32	. . 2
l325bh:
	push hl			;325b	e5		.
	call sub_07f9h		;325c	cd f9 07	. . .
	cp 0ffh			;325f	fe ff		. .
	jp z,l328dh		;3261	ca 8d 32	. . 2
	call SETMEMMAP	;3264	cd 1a 0f	. . .
	ld de,0x30		;3267	11 30 00	. 0 .
	add hl,de		;326a	19		.
	ld a,(CFG6)		;326b	3a 0d 00	: . .
	cp 0bbh			;326e	fe bb		. .
	jr nz,l3277h		;3270	20 05		  .
	call sub_3480h		;3272	cd 80 34	. . 4
	jr l3280h		;3275	18 09		. .
l3277h:
	ex de,hl		;3277	eb		.
	ld hl,055b7h		;3278	21 b7 55	! . U
	ld bc,32		;327b	01 20 00	.   .
	ldir			;327e	ed b0		. .
l3280h:
	pop de			;3280	d1		.
	inc de			;3281	13		.
	ld hl,(05b9dh)		;3282	2a 9d 5b	* . [
	or a			;3285	b7		.
	sbc hl,de		;3286	ed 52		. R
	ex de,hl		;3288	eb		.
	jr nc,l325bh		;3289	30 d0		0 .
	jr l328eh		;328b	18 01		. .
l328dh:
	pop hl			;328d	e1		.
l328eh:
	ld hl,(055e1h)		;328e	2a e1 55	* . U
	ld a,l			;3291	7d		}
	or h			;3292	b4		.
	jr z,l32bbh		;3293	28 26		( &
l3295h:
	push hl			;3295	e5		.
	call sub_07f9h		;3296	cd f9 07	. . .
	cp 0ffh			;3299	fe ff		. .
	jr z,l32bah		;329b	28 1d		( .
	call SETMEMMAP	;329d	cd 1a 0f	. . .
	ld de,0x30		;32a0	11 30 00	. 0 .
	add hl,de		;32a3	19		.
	ex de,hl		;32a4	eb		.
	ld hl,SCRN_WEATHER_START
	ld bc,SCRN_WEATHER_LEN
	ldir			;32ab	ed b0		. .
	pop de			;32ad	d1		.
	inc de			;32ae	13		.
l32afh:
	ld hl,(055e3h)		;32af	2a e3 55	* . U
	or a			;32b2	b7		.
	sbc hl,de		;32b3	ed 52		. R
	ex de,hl		;32b5	eb		.
	jr nc,l3295h		;32b6	30 dd		0 .
	jr l32bbh		;32b8	18 01		. .
l32bah:
	pop hl			;32ba	e1		.
l32bbh:
	ld hl,053b5h		;32bb	21 b5 53	! . S
	ld b,006h		;32be	06 06		. .
l32c0h:
	ld a,(hl)		;32c0	7e		~
	or a			;32c1	b7		.
	jr z,l32cdh		;32c2	28 09		( .
	cp 063h			;32c4	fe 63		. c
	jr z,l32cdh		;32c6	28 05		( .
	jr c,l32cch		;32c8	38 02		8 .
	ld (hl),010h		;32ca	36 10		6 .
l32cch:
	dec (hl)		;32cc	35		5
l32cdh:
	inc hl			;32cd	23		#
	djnz l32c0h		;32ce	10 f0		. .
	ret			;32d0	c9		.
sub_32d1h:
	ld a,(CFG7)		;32d1	3a 3c 00	: < .
	cp 0bbh			;32d4	fe bb		. .
	ret nz			;32d6	c0		.
	ld a,(FLAGS)		;32d7	3a 79 4f	: y O
	bit FLAG_DISP,a			;32da	cb 67		. g
	jr nz,l32f9h		;32dc	20 1b		  .
	ld a,(060cfh)		;32de	3a cf 60	: . `
	cp 000h			;32e1	fe 00		. .
	ret z			;32e3	c8		.
	xor a			;32e4	af		.
	ld (060cfh),a		;32e5	32 cf 60	2 . `
	in a,(PORT_16)		;32e8	db 16		. .
	and %00011000
	ret z			;32ec	c8		.
	ld hl,MSG_LOW_BAT		;32ed	21 fd 32	! . 2
	ld de,0415dh		;32f0	11 5d 41	. ] A
	ld bc,23		;32f3	01 17 00	. . .
	ldir			;32f6	ed b0		. .
	ret			;32f8	c9		.

l32f9h:
	ld (060cfh),a		;32f9	32 cf 60	2 . `
	ret			;32fc	c9		.
MSG_LOW_BAT:
	db " WARNING LOW BATTERIES "

FUN_9C:
	ld a,1
	ld b,6
_loop:
	call sub_332ah
	inc a
	djnz _loop
	ret

FUN_9D:
	ld a,1
	ld b,6
_loop:
	call sub_33a3h
	inc a
	djnz _loop
	ret

sub_332ah:
	push af			;332a	f5		.
	dec a			;332b	3d		=
	cp 006h			;332c	fe 06		. .
	jp nc,l337fh		;332e	d2 7f 33	. . 3
	push hl			;3331	e5		.
	push de			;3332	d5		.
	push bc			;3333	c5		.
	ld d,000h		;3334	16 00		. .
	ld e,a			;3336	5f		_
	ld hl,053b5h		;3337	21 b5 53	! . S
	add hl,de		;333a	19		.
	ld (hl),000h		;333b	36 00		6 .
	add a,a			;333d	87		.
	add a,a			;333e	87		.
	push af			;333f	f5		.
	add a,a			;3340	87		.
	add a,a			;3341	87		.
	add a,a			;3342	87		.
	sub e			;3343	93		.
	sub e			;3344	93		.
	ld e,a			;3345	5f		_
	ld hl,05688h		;3346	21 88 56	! . V
	add hl,de		;3349	19		.
	push hl			;334a	e5		.
	pop iy			;334b	fd e1		. .
l334dh:
	ld a,(iy+01dh)		;334d	fd 7e 1d	. ~ .
	cp 004h			;3350	fe 04		. .
	jr nz,l3366h		;3352	20 12		  .
	ld a,(FLAGS)		;3354	3a 79 4f	: y O
	bit FLAG_DISP,a			;3357	cb 67		. g
	jr z,l3366h		;3359	28 0b		( .
	ld (iy+008h),000h	;335b	fd 36 08 00	. 6 . .
	ld (iy+019h),00ah	;335f	fd 36 19 0a	. 6 . .
	pop af			;3363	f1		.
	jr l337ch		;3364	18 16		. .
l3366h:
	ld (hl),000h		;3366	36 00		6 .
	ld d,h			;3368	54		T
	ld e,l			;3369	5d		]
	inc de			;336a	13		.
	ld bc,29		;336b	01 1d 00	. . .
	di			;336e	f3		.
	ldir			;336f	ed b0		. .
	ei			;3371	fb		.
	pop af			;3372	f1		.
	ld d,000h		;3373	16 00		. .
	ld e,a			;3375	5f		_
	ld hl,0573ch		;3376	21 3c 57	! < W
	add hl,de		;3379	19		.
	ld (hl),000h		;337a	36 00		6 .
l337ch:
	pop bc			;337c	c1		.
	pop de			;337d	d1		.
	pop hl			;337e	e1		.
l337fh:
	pop af			;337f	f1		.
	ret			;3380	c9		.
sub_3381h:
	call sub_332ah		;3381	cd 2a 33	. * 3
	push af			;3384	f5		.
	or a			;3385	b7		.
	jr z,l33a1h		;3386	28 19		( .
	cp 007h			;3388	fe 07		. .
	jr nc,l33a1h		;338a	30 15		0 .
	push hl			;338c	e5		.
	push de			;338d	d5		.
	push bc			;338e	c5		.
	ld hl,052a6h		;338f	21 a6 52	! . R
	ld de,00027h		;3392	11 27 00	. ' .
	ld b,a			;3395	47		G
l3396h:
	add hl,de		;3396	19		.
	djnz l3396h		;3397	10 fd		. .
	ld (hl),000h		;3399	36 00		6 .
	inc hl			;339b	23		#
	ld (hl),000h		;339c	36 00		6 .
	pop bc			;339e	c1		.
	pop de			;339f	d1		.
	pop hl			;33a0	e1		.
l33a1h:
	pop af			;33a1	f1		.
	ret			;33a2	c9		.

sub_33a3h:
	push af			;33a3	f5		.
	or a			;33a4	b7		.
	jr z,l33d7h		;33a5	28 30		( 0
	cp 007h			;33a7	fe 07		. .
	jr nc,l33d7h		;33a9	30 2c		0 ,
	call sub_3381h		;33ab	cd 81 33	. . 3
l33aeh:
	push hl			;33ae	e5		.
	push de			;33af	d5		.
	push bc			;33b0	c5		.
	ld hl,052a8h		;33b1	21 a8 52	! . R
	ld de,00027h		;33b4	11 27 00	. ' .
	ld b,a			;33b7	47		G
l33b8h:
	add hl,de		;33b8	19		.
	djnz l33b8h		;33b9	10 fd		. .
	ld (hl),003h		;33bb	36 03		6 .
	inc hl			;33bd	23		#
	ld (hl),000h		;33be	36 00		6 .
	inc hl			;33c0	23		#
	ld (hl),000h		;33c1	36 00		6 .
	inc hl			;33c3	23		#
	ld b,004h		;33c4	06 04		. .
l33c6h:
	ld e,(hl)		;33c6	5e		^
	inc hl			;33c7	23		#
	ld d,(hl)		;33c8	56		V
	inc hl			;33c9	23		#
	inc hl			;33ca	23		#
	inc hl			;33cb	23		#
	inc hl			;33cc	23		#
	inc hl			;33cd	23		#
	ld (hl),e		;33ce	73		s
	inc hl			;33cf	23		#
	ld (hl),d		;33d0	72		r
	inc hl			;33d1	23		#
	djnz l33c6h		;33d2	10 f2		. .
	pop bc			;33d4	c1		.
	pop de			;33d5	d1		.
	pop hl			;33d6	e1		.
l33d7h:
	pop af			;33d7	f1		.
	ret			;33d8	c9		.
	push af			;33d9	f5		.
	jr l33aeh		;33da	18 d2		. .
sub_33dch:
	ld a,(CFG1)		;33dc	3a 06 00	: . .
	cp 0aah			;33df	fe aa		. .
	ret nz			;33e1	c0		.
	ld a,(FLAGS)		;33e2	3a 79 4f	: y O
	ld b,a			;33e5	47		G
	ld a,(053bdh)		;33e6	3a bd 53	: . S
	bit FLAG_DISP,b			;33e9	cb 60		. `
	jr nz,l33f4h		;33eb	20 07		  .
	bit 3,a			;33ed	cb 5f		. _
	ret z			;33ef	c8		.
	res 3,a			;33f0	cb 9f		. .
	jr l33f9h		;33f2	18 05		. .
l33f4h:
	bit 3,a			;33f4	cb 5f		. _
	ret nz			;33f6	c0		.
	set 3,a			;33f7	cb df		. .
l33f9h:
	ld (053bdh),a		;33f9	32 bd 53	2 . S
	out (PORT_05),a		;33fc	d3 05		. .
	ret			;33fe	c9		.
sub_33ffh:
	ld a,(CFG5)		;33ff	3a 0c 00	: . .
	cp 0aah			;3402	fe aa		. .
	ret z			;3404	c8		.
	ld a,(05fd6h)		;3405	3a d6 5f	: . _
	inc a			;3408	3c		<
	ld (05fd6h),a		;3409	32 d6 5f	2 . _
	cp 004h			;340c	fe 04		. .
	ret nz			;340e	c0		.
	ld a,000h		;340f	3e 00		> .
	ld (05fd6h),a		;3411	32 d6 5f	2 . _
	ld a,(05fd7h)		;3414	3a d7 5f	: . _
	ld b,a			;3417	47		G
	in a,(PORT_04)		;3418	db 04		. .
	and 030h		;341a	e6 30		. 0
	cp b			;341c	b8		.
	ret z			;341d	c8		.
	ld (05fd7h),a		;341e	32 d7 5f	2 . _
	cp 030h			;3421	fe 30		. 0
	ret z			;3423	c8		.
	ld a,(05fd8h)		;3424	3a d8 5f	: . _
	or a			;3427	b7		.
	jr nz,l3446h		;3428	20 1c		  .
	ld a,(05fd7h)		;342a	3a d7 5f	: . _
	bit 4,a			;342d	cb 67		. g
	ret nz			;342f	c0		.
	ld hl,FIFO_KBD		;3430	21 e4 40	! . @
	ld a,0f9h		;3433	3e f9		> .
	call DATA2FIFO		;3435	cd 09 0f	. . .
	ld hl,FIFO_KBD		;3438	21 e4 40	! . @
	ld a,09ah		;343b	3e 9a		> .
	call DATA2FIFO		;343d	cd 09 0f	. . .
	ld a,001h		;3440	3e 01		> .
	ld (05fd8h),a		;3442	32 d8 5f	2 . _
	ret			;3445	c9		.
l3446h:
	ld hl,FIFO_KBD		;3446	21 e4 40	! . @
	ld a,(05fd7h)		;3449	3a d7 5f	: . _
	bit 5,a			;344c	cb 6f		. o
	jr nz,l3456h		;344e	20 06		  .
	ld a,020h		;3450	3e 20		>  
	call DATA2FIFO		;3452	cd 09 0f	. . .
	ret			;3455	c9		.
l3456h:
	ld a,(05fd8h)		;3456	3a d8 5f	: . _
	inc a			;3459	3c		<
	ld (05fd8h),a		;345a	32 d8 5f	2 . _
	cp 009h			;345d	fe 09		. .
	jr z,l3467h		;345f	28 06		( .
	ld a,00ah		;3461	3e 0a		> .
	call DATA2FIFO		;3463	cd 09 0f	. . .
	ret			;3466	c9		.
l3467h:
	ld a,000h		;3467	3e 00		> .
	ld (05fd8h),a		;3469	32 d8 5f	2 . _
	ld b,003h		;346c	06 03		. .
l346eh:
	ld a,00ah		;346e	3e 0a		> .
	push bc			;3470	c5		.
	call DATA2FIFO		;3471	cd 09 0f	. . .
	pop bc			;3474	c1		.
	ld hl,FIFO_KBD		;3475	21 e4 40	! . @
	djnz l346eh		;3478	10 f4		. .
	ld a,0f8h		;347a	3e f8		> .
	call DATA2FIFO		;347c	cd 09 0f	. . .
	ret			;347f	c9		.
sub_3480h:
	ld de,24		;3480	11 18 00	. . .
	add hl,de		;3483	19		.
	ex de,hl		;3484	eb		.
	ld hl,055cch		;3485	21 cc 55	! . U
	ld bc,5		;3488	01 05 00	. . .
	ldir			;348b	ed b0		. .
	ld hl,055d4h		;348d	21 d4 55	! . U
	ld bc,3		;3490	01 03 00	. . .
	ldir			;3493	ed b0		. .
	ret			;3495	c9		.
sub_3496h:
	ld a,(CFG11)		;3496	3a 3e 00	: > .
	cp 0aah			;3499	fe aa		. .
	jr nz,l34bdh		;349b	20 20		   
	ld a,(05b98h)		;349d	3a 98 5b	: . [
	cp 01eh			;34a0	fe 1e		. .
	jr nz,l34b6h		;34a2	20 12		  .
	ld a,(05b99h)		;34a4	3a 99 5b	: . [
	cp 000h			;34a7	fe 00		. .
	jr nz,l34b6h		;34a9	20 0b		  .
	ld a,(053bdh)		;34ab	3a bd 53	: . S
	res 2,a			;34ae	cb 97		. .
l34b0h:
	ld (053bdh),a		;34b0	32 bd 53	2 . S
	out (PORT_05),a		;34b3	d3 05		. .
	ret			;34b5	c9		.
l34b6h:
	ld a,(053bdh)		;34b6	3a bd 53	: . S
	set 2,a			;34b9	cb d7		. .
	jr l34b0h		;34bb	18 f3		. .
l34bdh:
	cp 055h			;34bd	fe 55		. U
	ret nz			;34bf	c0		.
	ld a,(05baeh)		;34c0	3a ae 5b	: . [
	ld b,a			;34c3	47		G
	in a,(PORT_05)		;34c4	db 05		. .
	and 020h		;34c6	e6 20		.  
	cp b			;34c8	b8		.
	ret z			;34c9	c8		.
	ld (05baeh),a		;34ca	32 ae 5b	2 . [
	and a			;34cd	a7		.
	ret nz			;34ce	c0		.
	ld a,01eh		;34cf	3e 1e		> .
	ld (05b98h),a		;34d1	32 98 5b	2 . [
	ld a,000h		;34d4	3e 00		> .
	ld (05b99h),a		;34d6	32 99 5b	2 . [
	ld a,03ch		;34d9	3e 3c		> <
	ld (052c1h),a		;34db	32 c1 52	2 . R
	call 0c5cbh		;34de	cd cb c5	. . .
	ret			;34e1	c9		.

FUN_E4:
	ld hl,04a3eh		;34e2	21 3e 4a	! > J
	ld de,v53c2		;34e5	11 c2 53	. . S
	ld bc,16		;34e8	01 10 00	. . .
	ldir			;34eb	ed b0		. .
	ld a,(04a48h)		;34ed	3a 48 4a	: H J
	ld hl,053d6h		;34f0	21 d6 53	! . S
	call 0b845h		;34f3	cd 45 b8	. E .
	call sub_2a82h		;34f6	cd 82 2a	. . *
	M_OUT_MSG 0xd09b, 0xc6 ; 0F "DISPLAY TYPE" CRLF "DISPLAY SPEED" CRLF "DISPLAY TIME     SECONDS" CRLF "PAGE SKIP" CRLF "PAGE LINK" CRLF "PAGE WAIT" CRLF CRLF "      DISPLAY TIME WINDOW" CRLF CRLF "FIRST DAY" CRLF "      TIME" CRLF CRLF "            THROUGH" CRLF CRLF "LAST DAY" CRLF "     TIME" CRLF CRLF "LINE LEVELS   1  2  3  4"
	M_GOTO_YX 1,15
	ld ix,v53c2
	ld iy,0d161h
	ld c,00ah		;350c	0e 0a		. .
	ld b,(ix+003h)		;350e	dd 46 03	. F .
	dec b			;3511	05		.
	push bc			;3512	c5		.
	ld c,a			;3513	4f		O
	ld a,004h		;3514	3e 04		> .
	sub b			;3516	90		.
	ld a,c			;3517	79		y
	pop bc			;3518	c1		.
	jp nc,l3522h		;3519	d2 22 35	. " 5
	ld b,000h		;351c	06 00		. .
	ld (ix+003h),001h	;351e	dd 36 03 01	. 6 . .
l3522h:
	call sub_3b0ch		;3522	cd 0c 3b	. . ;
	M_GOTO_YX 2,15
	ld a,(ix+002h)		;352a	dd 7e 02	. ~ .
	ld iy,0d183h		;352d	fd 21 83 d1	. ! . .
	ld c,006h		;3531	0e 06		. .
	push bc			;3533	c5		.
	ld c,a			;3534	4f		O
	ld a,008h		;3535	3e 08		> .
	ld b,a			;3537	47		G
	ld a,c			;3538	79		y
	sub b			;3539	90		.
	ld a,c			;353a	79		y
	pop bc			;353b	c1		.
	jp nz,l3544h		;353c	c2 44 35	. D 5
	ld b,000h		;353f	06 00		. .
	jp l355ch		;3541	c3 5c 35	. \ 5
l3544h:
	push bc			;3544	c5		.
	ld c,a			;3545	4f		O
	ld a,020h		;3546	3e 20		>  
	ld b,a			;3548	47		G
	ld a,c			;3549	79		y
	sub b			;354a	90		.
	ld a,c			;354b	79		y
	pop bc			;354c	c1		.
	jp nz,l3555h		;354d	c2 55 35	. U 5
	ld b,002h		;3550	06 02		. .
	jp l355ch		;3552	c3 5c 35	. \ 5
l3555h:
	ld b,001h		;3555	06 01		. .
	ld a,010h		;3557	3e 10		> .
	ld (ix+002h),a		;3559	dd 77 02	. w .
l355ch:
	call sub_3b0ch		;355c	cd 0c 3b	. . ;
	M_GOTO_YX 3,15
	push bc			;3564	c5		.
	ld c,a			;3565	4f		O
	ld a,(ix+001h)		;3566	dd 7e 01	. ~ .
	ld b,a			;3569	47		G
	ld a,063h		;356a	3e 63		> c
	sub b			;356c	90		.
	ld a,c			;356d	79		y
	pop bc			;356e	c1		.
	jp nc,l3576h		;356f	d2 76 35	. v 5
	ld (ix+001h),010h	;3572	dd 36 01 10	. 6 . .
l3576h:
	M_OUT_VAR vUserCodes, 0x42
	M_GOTO_YX 4,15
	ld a,001h		;3581	3e 01		> .
	and (ix+000h)		;3583	dd a6 00	. . .
	call sub_3b79h		;3586	cd 79 3b	. y ;
	M_GOTO_YX 5,15
	ld a,002h		;358e	3e 02		> .
	and (ix+000h)		;3590	dd a6 00	. . .
	call sub_3b79h		;3593	cd 79 3b	. y ;
	M_GOTO_YX 6,15
	ld a,004h		;359b	3e 04		> .
	and (ix+000h)		;359d	dd a6 00	. . .
	call sub_3b79h		;35a0	cd 79 3b	. y ;
	push bc			;35a3	c5		.
	ld c,a			;35a4	4f		O
	ld a,008h		;35a5	3e 08		> .
	ld b,a			;35a7	47		G
	ld a,(ix+004h)		;35a8	dd 7e 04	. ~ .
	sub b			;35ab	90		.
	ld a,c			;35ac	79		y
	pop bc			;35ad	c1		.
	jp c,l35b9h		;35ae	da b9 35	. . 5
	ld (ix+004h),008h	;35b1	dd 36 04 08	. 6 . .
	ld (ix+007h),008h	;35b5	dd 36 07 08	. 6 . .
l35b9h:
	push bc			;35b9	c5		.
	ld c,a			;35ba	4f		O
	ld a,000h		;35bb	3e 00		> .
	ld b,a			;35bd	47		G
	ld a,(ix+004h)		;35be	dd 7e 04	. ~ .
	sub b			;35c1	90		.
	ld a,c			;35c2	79		y
	pop bc			;35c3	c1		.
	jp nz,l35ceh		;35c4	c2 ce 35	. . 5
	xor a			;35c7	af		.
	ld (ix+005h),a		;35c8	dd 77 05	. w .
	ld (ix+007h),a		;35cb	dd 77 07	. w .
l35ceh:
	ld a,(ix+005h)		;35ce	dd 7e 05	. ~ .
	and 07fh		;35d1	e6 7f		. .
	push bc			;35d3	c5		.
	ld c,a			;35d4	4f		O
	ld a,000h		;35d5	3e 00		> .
	ld b,a			;35d7	47		G
	ld a,c			;35d8	79		y
	sub b			;35d9	90		.
	ld a,c			;35da	79		y
	pop bc			;35db	c1		.
	jp nz,l35ebh		;35dc	c2 eb 35	. . 5
	ld (ix+008h),a		;35df	dd 77 08	. w .
	ld (ix+006h),a		;35e2	dd 77 06	. w .
	ld (ix+009h),a		;35e5	dd 77 09	. w .
	jp l3603h		;35e8	c3 03 36	. . 6
l35ebh:
	push bc			;35eb	c5		.
	ld c,a			;35ec	4f		O
	ld b,a			;35ed	47		G
	ld a,00ch		;35ee	3e 0c		> .
	sub b			;35f0	90		.
	ld a,c			;35f1	79		y
	pop bc			;35f2	c1		.
	jp nc,l3603h		;35f3	d2 03 36	. . 6
	xor a			;35f6	af		.
	ld (ix+005h),a		;35f7	dd 77 05	. w .
	ld (ix+008h),a		;35fa	dd 77 08	. w .
	ld (ix+006h),a		;35fd	dd 77 06	. w .
	ld (ix+009h),a		;3600	dd 77 09	. w .
l3603h:
	push bc			;3603	c5		.
	ld c,a			;3604	4f		O
	ld a,000h		;3605	3e 00		> .
	ld b,a			;3607	47		G
	ld a,(ix+007h)		;3608	dd 7e 07	. ~ .
	sub b			;360b	90		.
	ld a,c			;360c	79		y
	pop bc			;360d	c1		.
	jp nz,l361ah		;360e	c2 1a 36	. . 6
	ld a,(ix+004h)		;3611	dd 7e 04	. ~ .
	ld (ix+007h),a		;3614	dd 77 07	. w .
	jp l362eh		;3617	c3 2e 36	. . 6
l361ah:
	push bc			;361a	c5		.
	ld c,a			;361b	4f		O
	ld a,008h		;361c	3e 08		> .
	ld b,a			;361e	47		G
	ld a,(ix+007h)		;361f	dd 7e 07	. ~ .
	sub b			;3622	90		.
	ld a,c			;3623	79		y
	pop bc			;3624	c1		.
	jp c,l362eh		;3625	da 2e 36	. . 6
	ld a,(ix+004h)		;3628	dd 7e 04	. ~ .
	ld (ix+007h),a		;362b	dd 77 07	. w .
l362eh:
	ld a,(ix+008h)		;362e	dd 7e 08	. ~ .
	and 07fh		;3631	e6 7f		. .
	ld b,a			;3633	47		G
	push bc			;3634	c5		.
	ld c,a			;3635	4f		O
	ld a,000h		;3636	3e 00		> .
	push de			;3638	d5		.
	ld d,b			;3639	50		P
	ld b,a			;363a	47		G
	ld a,d			;363b	7a		z
	pop de			;363c	d1		.
	sub b			;363d	90		.
	ld a,c			;363e	79		y
	pop bc			;363f	c1		.
	jp nz,l364ch		;3640	c2 4c 36	. L 6
	ld a,(ix+005h)		;3643	dd 7e 05	. ~ .
	ld (ix+008h),a		;3646	dd 77 08	. w .
	jp l365ch		;3649	c3 5c 36	. \ 6
l364ch:
	push bc			;364c	c5		.
	ld c,a			;364d	4f		O
	ld a,00ch		;364e	3e 0c		> .
	sub b			;3650	90		.
	ld a,c			;3651	79		y
	pop bc			;3652	c1		.
	jp nc,l365ch		;3653	d2 5c 36	. \ 6
	ld a,(ix+005h)		;3656	dd 7e 05	. ~ .
	ld (ix+008h),a		;3659	dd 77 08	. w .
l365ch:
	M_GOTO_YX 10,15
	call sub_3879h		;3661	cd 79 38	. y 8
	ld b,006h		;3664	06 06		. .
	call sub_3866h		;3666	cd 66 38	. f 8
	M_GOTO_YX 19,15
	ld hl,053d6h		;366e	21 d6 53	! . S
	call 0b86dh		;3671	cd 6d b8	. m .
	M_GOTO_YX 22,1
	ld hl,053ceh		;3679	21 ce 53	! . S
	call sub_15b0h		;367c	cd b0 15	. . .
	ld b,000h		;367f	06 00		. .
	call sub_3866h		;3681	cd 66 38	. f 8
	M_GOTO_YX 1,15
	ld iy,0d161h		;368a	21 61 d1	! a .
	ld b,(ix+003h)		;368d	dd 46 03	. F .
	dec b			;3690	05		.
l3691h:
	call NEXT_MACRO_OR_KEY	;3691	cd a7 17	. . .
	push bc			;3694	c5		.
	ld c,a			;3695	4f		O
	ld a,020h		;3696	3e 20		>  
	ld b,a			;3698	47		G
	ld a,c			;3699	79		y
	sub b			;369a	90		.
	ld a,c			;369b	79		y
	pop bc			;369c	c1		.
	jp nz,l36b2h		;369d	c2 b2 36	. . 6
	inc b			;36a0	04		.
	push bc			;36a1	c5		.
	ld c,a			;36a2	4f		O
	ld a,004h		;36a3	3e 04		> .
	sub b			;36a5	90		.
	ld a,c			;36a6	79		y
	pop bc			;36a7	c1		.
	jp nc,l36adh		;36a8	d2 ad 36	. . 6
	ld b,000h		;36ab	06 00		. .
l36adh:
	ld c,00ah		;36ad	0e 0a		. .
	call sub_3b0ch		;36af	cd 0c 3b	. . ;
l36b2h:
	push bc			;36b2	c5		.
	ld c,a			;36b3	4f		O
	ld a,00ah		;36b4	3e 0a		> .
	ld b,a			;36b6	47		G
	ld a,c			;36b7	79		y
	sub b			;36b8	90		.
	ld a,c			;36b9	79		y
	pop bc			;36ba	c1		.
	jp nz,l3691h		;36bb	c2 91 36	. . 6
	inc b			;36be	04		.
	ld (ix+003h),b		;36bf	dd 70 03	. p .
	M_GOTO_YX 2,15
	ld iy,0d183h		;36c7	fd 21 83 d1	. ! . .
	ld d,(ix+002h)		;36cb	dd 56 02	. V .
l36ceh:
	call NEXT_MACRO_OR_KEY	;36ce	cd a7 17	. . .
	push bc			;36d1	c5		.
	ld c,a			;36d2	4f		O
	ld a,020h		;36d3	3e 20		>  
	ld b,a			;36d5	47		G
	ld a,c			;36d6	79		y
	sub b			;36d7	90		.
	ld a,c			;36d8	79		y
	pop bc			;36d9	c1		.
	jp nz,l370ah		;36da	c2 0a 37	. . 7
	rl d			;36dd	cb 12		. .
	push bc			;36df	c5		.
	ld c,a			;36e0	4f		O
	ld a,010h		;36e1	3e 10		> .
	ld b,a			;36e3	47		G
	ld a,d			;36e4	7a		z
	sub b			;36e5	90		.
	ld a,c			;36e6	79		y
	pop bc			;36e7	c1		.
	jp nz,l36f0h		;36e8	c2 f0 36	. . 6
	ld b,001h		;36eb	06 01		. .
	jp l3705h		;36ed	c3 05 37	. . 7
l36f0h:
	push bc			;36f0	c5		.
l36f1h:
	ld c,a			;36f1	4f		O
	ld a,020h		;36f2	3e 20		>  
	ld b,a			;36f4	47		G
	ld a,d			;36f5	7a		z
	sub b			;36f6	90		.
	ld a,c			;36f7	79		y
	pop bc			;36f8	c1		.
	jp nz,l3701h		;36f9	c2 01 37	. . 7
	ld b,002h		;36fc	06 02		. .
	jp l3705h		;36fe	c3 05 37	. . 7
l3701h:
	ld b,000h		;3701	06 00		. .
	ld d,008h		;3703	16 08		. .
l3705h:
	ld c,006h		;3705	0e 06		. .
	call sub_3b0ch		;3707	cd 0c 3b	. . ;
l370ah:
	push bc			;370a	c5		.
	ld c,a			;370b	4f		O
	ld a,00ah		;370c	3e 0a		> .
	ld b,a			;370e	47		G
	ld a,c			;370f	79		y
	sub b			;3710	90		.
	ld a,c			;3711	79		y
	pop bc			;3712	c1		.
	jp nz,l36ceh		;3713	c2 ce 36	. . 6
	ld (ix+002h),d		;3716	dd 72 02	. r .
	ld b,001h		;3719	06 01		. .
	call sub_3866h		;371b	cd 66 38	. f 8
	M_GOTO_YX 3,16
	M_SOMETHING1 vUserCodes, 0x42
	ld b,002h		;3729	06 02		. .
	call sub_3866h		;372b	cd 66 38	. f 8
	M_GOTO_YX 4,15
	ld hl,v53c2		;3733	21 c2 53	! . S
	ld b,001h		;3736	06 01		. .
	call sub_3ae0h		;3738	cd e0 3a	. . :
	M_GOTO_YX 5,15
	ld b,002h		;3740	06 02		. .
	call sub_3ae0h		;3742	cd e0 3a	. . :
	M_GOTO_YX 6,15
	ld b,004h		;374a	06 04		. .
	call sub_3ae0h		;374c	cd e0 3a	. . :
	ld b,000h		;374f	06 00		. .
	call sub_3866h		;3751	cd 66 38	. f 8
	M_GOTO_YX 10,15
	ld iy,0d27ah		;3759	fd 21 7a d2	. ! z .
	ld b,(ix+004h)		;375d	dd 46 04	. F .
l3760h:
	call NEXT_MACRO_OR_KEY	;3760	cd a7 17	. . .
	push bc			;3763	c5		.
	ld c,a			;3764	4f		O
	ld a,020h		;3765	3e 20		>  
	ld b,a			;3767	47		G
	ld a,c			;3768	79		y
	sub b			;3769	90		.
	ld a,c			;376a	79		y
	pop bc			;376b	c1		.
	jp nz,l3781h		;376c	c2 81 37	. . 7
	inc b			;376f	04		.
	push bc			;3770	c5		.
	ld c,a			;3771	4f		O
	ld a,008h		;3772	3e 08		> .
	sub b			;3774	90		.
	ld a,c			;3775	79		y
	pop bc			;3776	c1		.
	jp nc,l377ch		;3777	d2 7c 37	. | 7
	ld b,000h		;377a	06 00		. .
l377ch:
	ld c,00bh		;377c	0e 0b		. .
	call sub_3b0ch		;377e	cd 0c 3b	. . ;
l3781h:
	push bc			;3781	c5		.
	ld c,a			;3782	4f		O
	ld a,00ah		;3783	3e 0a		> .
	ld b,a			;3785	47		G
	ld a,c			;3786	79		y
	sub b			;3787	90		.
	ld a,c			;3788	79		y
	pop bc			;3789	c1		.
	jp nz,l3760h		;378a	c2 60 37	. ` 7
	ld a,b			;378d	78		x
	ld (053c6h),a		;378e	32 c6 53	2 . S
	push bc			;3791	c5		.
	ld c,a			;3792	4f		O
	ld a,000h		;3793	3e 00		> .
	push de			;3795	d5		.
	ld d,b			;3796	50		P
	ld b,a			;3797	47		G
	ld a,d			;3798	7a		z
	pop de			;3799	d1		.
	sub b			;379a	90		.
	ld a,c			;379b	79		y
	pop bc			;379c	c1		.
	jp nz,l37b5h		;379d	c2 b5 37	. . 7
	ld (053c7h),a		;37a0	32 c7 53	2 . S
	ld (053c8h),a		;37a3	32 c8 53	2 . S
	ld (053c9h),a		;37a6	32 c9 53	2 . S
	ld (053cah),a		;37a9	32 ca 53	2 . S
	ld (053cbh),a		;37ac	32 cb 53	2 . S
	call sub_3879h		;37af	cd 79 38	. y 8
	jp l383ah		;37b2	c3 3a 38	. : 8
l37b5h:
	push bc			;37b5	c5		.
	ld c,a			;37b6	4f		O
	ld a,008h		;37b7	3e 08		> .
	push de			;37b9	d5		.
	ld d,b			;37ba	50		P
	ld b,a			;37bb	47		G
	ld a,d			;37bc	7a		z
	pop de			;37bd	d1		.
	sub b			;37be	90		.
	ld a,c			;37bf	79		y
	pop bc			;37c0	c1		.
	jp nz,l37dah		;37c1	c2 da 37	. . 7
	ld (053c9h),a		;37c4	32 c9 53	2 . S
	M_GOTO_YX 15,15
	ld c,00bh		;37cc	0e 0b		. .
	call sub_3b0ch		;37ce	cd 0c 3b	. . ;
	call sub_38fbh		;37d1	cd fb 38	. . 8
	call sub_39c4h		;37d4	cd c4 39	. . 9
	jp l383ah		;37d7	c3 3a 38	. : 8
l37dah:
	ld a,(053c9h)		;37da	3a c9 53	: . S
	dec a			;37dd	3d		=
	cp 007h			;37de	fe 07		. .
	jp c,l37f1h		;37e0	da f1 37	. . 7
	ld a,b			;37e3	78		x
	ld (053c9h),a		;37e4	32 c9 53	2 . S
	M_GOTO_YX 15,15
	ld c,00bh		;37ec	0e 0b		. .
	call sub_3b0ch		;37ee	cd 0c 3b	. . ;
l37f1h:
	call sub_38fbh		;37f1	cd fb 38	. . 8
	ld b,000h		;37f4	06 00		. .
	call sub_3866h		;37f6	cd 66 38	. f 8
	M_GOTO_YX 15,15
	ld iy,0d27ah		;37fe	fd 21 7a d2	. ! z .
	ld a,(053c9h)		;3802	3a c9 53	: . S
	ld b,a			;3805	47		G
l3806h:
	call NEXT_MACRO_OR_KEY	;3806	cd a7 17	. . .
	push bc			;3809	c5		.
	ld c,a			;380a	4f		O
	ld a,020h		;380b	3e 20		>  
	ld b,a			;380d	47		G
	ld a,c			;380e	79		y
	sub b			;380f	90		.
	ld a,c			;3810	79		y
	pop bc			;3811	c1		.
	jp nz,l3827h		;3812	c2 27 38	. ' 8
	inc b			;3815	04		.
	push bc			;3816	c5		.
	ld c,a			;3817	4f		O
	ld a,007h		;3818	3e 07		> .
	sub b			;381a	90		.
	ld a,c			;381b	79		y
	pop bc			;381c	c1		.
	jp nc,l3822h		;381d	d2 22 38	. " 8
	ld b,001h		;3820	06 01		. .
l3822h:
	ld c,00bh		;3822	0e 0b		. .
	call sub_3b0ch		;3824	cd 0c 3b	. . ;
l3827h:
	push bc			;3827	c5		.
	ld c,a			;3828	4f		O
	ld a,00ah		;3829	3e 0a		> .
	ld b,a			;382b	47		G
	ld a,c			;382c	79		y
	sub b			;382d	90		.
	ld a,c			;382e	79		y
	pop bc			;382f	c1		.
	jp nz,l3806h		;3830	c2 06 38	. . 8
	ld a,b			;3833	78		x
	ld (053c9h),a		;3834	32 c9 53	2 . S
	call sub_39c4h		;3837	cd c4 39	. . 9
l383ah:
	ld b,006h		;383a	06 06		. .
	call sub_3866h		;383c	cd 66 38	. f 8
	M_GOTO_YX 19,15
	ld hl,053d6h		;3844	21 d6 53	! . S
	call 0b87bh		;3847	cd 7b b8	. { .
	ld (053cch),a		;384a	32 cc 53	2 . S
	M_GOTO_YX 22,1
	ld hl,053ceh		;3852	21 ce 53	! . S
	call sub_162bh		;3855	cd 2b 16	. + .
	ld de,04a3eh		;3858	11 3e 4a	. > J
	ld hl,v53c2		;385b	21 c2 53	! . S
	ld bc,16		;385e	01 10 00	. . .
	ldir			;3861	ed b0		. .
	jp l1925h		;3863	c3 25 19	. % .
sub_3866h:
	push iy			;3866	fd e5		. .
	ld iy,0d194h		;3868	fd 21 94 d1	. ! . .
	ld c,020h		;386c	0e 20		.  
	M_GOTO_YX 25,1
	call sub_3b0ch
	pop iy			;3876	fd e1		. .
	ret			;3878	c9		.
sub_3879h:
	ld d,002h		;3879	16 02		. .
	ld hl,053c6h		;387b	21 c6 53	! . S
l387eh:
	ld b,(hl)		;387e	46		F
	ld iy,0d27ah		;387f	fd 21 7a d2	. ! z .
	ld c,00bh		;3883	0e 0b		. .
	call sub_3b0ch		;3885	cd 0c 3b	. . ;
	M_DOWN 1
	inc hl
	ld a,(hl)
	and 07fh		;388e	e6 7f		. .
	ld (053d2h),a		;3890	32 d2 53	2 . S
	M_OUT_VAR 0x53d2, 0x42
	M_OUT_CH ':'
	inc hl
	ld a,(hl)
	push bc			;389f	c5		.
	ld c,a			;38a0	4f		O
	ld b,a			;38a1	47		G
	ld a,03bh		;38a2	3e 3b		> ;
	sub b			;38a4	90		.
	ld a,c			;38a5	79		y
	pop bc			;38a6	c1		.
	jp nc,l38adh		;38a7	d2 ad 38	. . 8
	ld a,000h		;38aa	3e 00		> .
	ld (hl),a		;38ac	77		w
l38adh:
	call sub_38c7h		;38ad	cd c7 38	. . 8
	M_DOWN 4
	M_LEFT 6
	inc hl
	dec d			;38b9	15		.
	push bc			;38ba	c5		.
	ld c,a			;38bb	4f		O
	ld a,000h		;38bc	3e 00		> .
	ld b,a			;38be	47		G
	ld a,d			;38bf	7a		z
	sub b			;38c0	90		.
	ld a,c			;38c1	79		y
	pop bc			;38c2	c1		.
	jp nz,l387eh		;38c3	c2 7e 38	. ~ 8
	ret			;38c6	c9		.
sub_38c7h:
	ld a,(hl)		;38c7	7e		~
	ld (053d3h),a		;38c8	32 d3 53	2 . S
	M_OUT_VAR 0x53d3, 0x42
	dec hl			;38d1	2b		+
	ld a,07fh		;38d2	3e 7f		> .
	and (hl)		;38d4	a6		.
	push bc			;38d5	c5		.
	ld c,a			;38d6	4f		O
	ld a,000h		;38d7	3e 00		> .
	ld b,a			;38d9	47		G
	ld a,c			;38da	79		y
	sub b			;38db	90		.
	ld a,c			;38dc	79		y
	pop bc			;38dd	c1		.
	jp nz,l38e6h		;38de	c2 e6 38	. . 8
	ld b,002h		;38e1	06 02		. .
	jp l38ech		;38e3	c3 ec 38	. . 8
l38e6h:
	ld a,080h		;38e6	3e 80		> .
	and (hl)		;38e8	a6		.
	ld b,a			;38e9	47		G
	rlc b			;38ea	cb 00		. .
l38ech:
	inc hl			;38ec	23		#
	ld c,009h		;38ed	0e 09		. .
	ld iy,0d2abh		;38ef	fd 21 ab d2	. ! . .
	M_RIGHT 1
	call 0x3b0c
	ret			;38fa	c9		.
sub_38fbh:
	ld b,003h		;38fb	06 03		. .
	call sub_3866h		;38fd	cd 66 38	. f 8
	M_GOTO_YX 11,16
	ld hl, 0x53c7
	ld a,(hl)		;3908	7e		~
	and 07fh		;3909	e6 7f		. .
	ld (053d2h),a		;390b	32 d2 53	2 . S
l390eh:
	M_SOMETHING1 v53d2, 0x52
	push de			;3914	d5		.
	push hl			;3915	e5		.
	ex de,hl		;3916	eb		.
	ld hl,12		;3917	21 0c 00	! . .
	or a			;391a	b7		.
	sbc hl,de		;391b	ed 52		. R
	pop hl			;391d	e1		.
	pop de			;391e	d1		.
	jp nc,l3926h		;391f	d2 26 39	. & 9
	xor a			;3922	af		.
	jp l3928h		;3923	c3 28 39	. ( 9
l3926h:
	ld a,0ffh		;3926	3e ff		> .
l3928h:
	push bc			;3928	c5		.
	ld c,a			;3929	4f		O
	ld a,000h		;392a	3e 00		> .
	ld b,a			;392c	47		G
	ld a,c			;392d	79		y
	sub b			;392e	90		.
	ld a,c			;392f	79		y
	pop bc			;3930	c1		.
	jp nz,_skip
	M_SOMETHING2 0x02
_skip:
	push bc			;3938	c5		.
	ld c,a			;3939	4f		O
	ld a,0ffh		;393a	3e ff		> .
	ld b,a			;393c	47		G
	ld a,c			;393d	79		y
	sub b			;393e	90		.
	ld a,c			;393f	79		y
	pop bc			;3940	c1		.
	jp nz,l390eh		;3941	c2 0e 39	. . 9
	M_OUT_MSG 0xd2bb, 0x03 ; RIGHT ":" RIGHT 
	ld a,l
	push bc			;394b	c5		.
	ld c,a			;394c	4f		O
	ld a,000h		;394d	3e 00		> .
	ld b,a			;394f	47		G
	ld a,c			;3950	79		y
	sub b			;3951	90		.
	ld a,c			;3952	79		y
	pop bc			;3953	c1		.
	jp z,l399ah		;3954	ca 9a 39	. . 9
	push bc			;3957	c5		.
	ld c,a			;3958	4f		O
l3959h:
	ld a,000h		;3959	3e 00		> .
	ld b,a			;395b	47		G
	ld a,(053c7h)		;395c	3a c7 53	: . S
	sub b			;395f	90		.
	ld a,c			;3960	79		y
	pop bc			;3961	c1		.
	jp nz,l3991h		;3962	c2 91 39	. . 9
	push af			;3965	f5		.
	ld (053c7h),a		;3966	32 c7 53	2 . S
	ld (053cah),a		;3969	32 ca 53	2 . S
	M_LEFT 1
	ld hl,053c8h
	call sub_38c7h		;3973	cd c7 38	. . 8
	M_GOTO_YX 16,15
	M_OUT_VAR 0x53d2, 0x42
	ld hl,053cbh		;3981	21 cb 53	! . S
	M_RIGHT 1
	call 0x38c7
	call 0x1527
	dec bc			;398e	0b		.
	inc de			;398f	13		.
	pop af			;3990	f1		.
l3991h:
	ld hl,053c8h		;3991	21 c8 53	! . S
	call sub_3a3dh		;3994	cd 3d 3a	. = :
	jp 039c3h		;3997	c3 c3 39	. . 9
l399ah:
	ld hl,053c7h		;399a	21 c7 53	! . S
	ld (hl),a		;399d	77		w
	inc hl			;399e	23		#
	ld (hl),a		;399f	77		w
	M_LEFT 1
	call sub_38c7h		;39a0	cd 6c 15	. l .
	inc hl			;39a8	23		#
	inc hl			;39a8	23		#
	xor a			;39a9	af		.
	ld (hl),a		;39aa	77		w
	M_GOTO_YX 16,15
	xor a			;39b0	af		.
	ld (053d2h),a		;39b1	32 d2 53	2 . S
	M_OUT_VAR 0x53d2, 0x42
	inc hl			;39ba	23		#
	ld (hl),a		;39bb	77		w
	M_RIGHT 1
	call sub_38c7h
	ret
sub_39c4h:
	ld a,(053c7h)		;39c4	3a c7 53	: . S
	and 07fh		;39c7	e6 7f		. .
	push bc			;39c9	c5		.
	ld c,a			;39ca	4f		O
l39cbh:
	ld a,000h		;39cb	3e 00		> .
	ld b,a			;39cd	47		G
	ld a,c			;39ce	79		y
	sub b			;39cf	90		.
	ld a,c			;39d0	79		y
	pop bc			;39d1	c1		.
	jp z,l3a3ch		;39d2	ca 3c 3a	. < :
	ld b,005h		;39d5	06 05		. .
	call sub_3866h		;39d7	cd 66 38	. f 8
	M_GOTO_YX 16,16
	ld hl,053cah		;39df	21 ca 53	! . S
	ld a,(hl)		;39e2	7e		~
	and 07fh		;39e3	e6 7f		. .
	ld (053d2h),a		;39e5	32 d2 53	2 . S
	push hl			;39e8	e5		.
l39e9h:
	M_SOMETHING1 v53d2, 0x52
l39efh:
	push de			;39ef	d5		.
	push hl			;39f0	e5		.
	ld de,1		;39f1	11 01 00	. . .
	or a			;39f4	b7		.
	sbc hl,de		;39f5	ed 52		. R
	pop hl			;39f7	e1		.
	pop de			;39f8	d1		.
	jp nc,l3a00h		;39f9	d2 00 3a	. . :
	xor a			;39fc	af		.
	jp l3a14h		;39fd	c3 14 3a	. . :
l3a00h:
	push de			;3a00	d5		.
	push hl			;3a01	e5		.
	ex de,hl		;3a02	eb		.
	ld hl,12		;3a03	21 0c 00	! . .
	or a			;3a06	b7		.
	sbc hl,de		;3a07	ed 52		. R
	pop hl			;3a09	e1		.
	pop de			;3a0a	d1		.
	jp nc,l3a12h		;3a0b	d2 12 3a	. . :
	xor a			;3a0e	af		.
	jp l3a14h		;3a0f	c3 14 3a	. . :
l3a12h:
	ld a,0ffh		;3a12	3e ff		> .
l3a14h:
	push bc			;3a14	c5		.
	ld c,a			;3a15	4f		O
	ld a,000h		;3a16	3e 00		> .
	ld b,a			;3a18	47		G
	ld a,c			;3a19	79		y
	sub b			;3a1a	90		.
	ld a,c			;3a1b	79		y
	pop bc			;3a1c	c1		.
	jp nz,_skip
	M_SOMETHING2 0x02
_skip:
	push bc			;3a24	c5		.
	ld c,a			;3a25	4f		O
	ld a,0ffh		;3a26	3e ff		> .
	ld b,a			;3a28	47		G
	ld a,c			;3a29	79		y
	sub b			;3a2a	90		.
	ld a,c			;3a2b	79		y
	pop bc			;3a2c	c1		.
	jp nz,l39e9h		;3a2d	c2 e9 39	. . 9
	M_OUT_MSG 0xd2bb, 0x03 ; RIGHT ":" RIGHT 
	ld a,l
	pop hl			;3a37	e1		.
	inc hl			;3a38	23		#
	call sub_3a3dh		;3a39	cd 3d 3a	. = :
l3a3ch:
	ret			;3a3c	c9		.
sub_3a3dh:
	call sub_3b86h		;3a3d	cd 86 3b	. . ;
	push bc			;3a40	c5		.
	ld b,004h		;3a41	06 04		. .
	call sub_3866h		;3a43	cd 66 38	. f 8
	pop bc			;3a46	c1		.
	call U_OUT_0F040B_09_0E		;3a47	cd 48 15	. H .
	ld a,(hl)		;3a4a	7e		~
	ld (053d3h),a		;3a4b	32 d3 53	2 . S
	push hl			;3a4e	e5		.
l3a4fh:
	M_SOMETHING1 v53d3, 0x52
	push de			;3a55	d5		.
	push hl			;3a56	e5		.
	ex de,hl		;3a57	eb		.
	ld hl,0003bh		;3a58	21 3b 00	! ; .
	or a			;3a5b	b7		.
	sbc hl,de		;3a5c	ed 52		. R
	pop hl			;3a5e	e1		.
	pop de			;3a5f	d1		.
	jp nc,l3a67h		;3a60	d2 67 3a	. g :
	xor a			;3a63	af		.
	jp l3a69h		;3a64	c3 69 3a	. i :
l3a67h:
	ld a,0ffh		;3a67	3e ff		> .
l3a69h:
	push bc			;3a69	c5		.
	ld c,a			;3a6a	4f		O
	ld a,000h		;3a6b	3e 00		> .
	ld b,a			;3a6d	47		G
	ld a,c			;3a6e	79		y
	sub b			;3a6f	90		.
	ld a,c			;3a70	79		y
	pop bc			;3a71	c1		.
	jp nz,_skip
	M_SOMETHING2 0x02
_skip:
	push bc			;3a79	c5		.
	ld c,a			;3a7a	4f		O
	ld a,0ffh		;3a7b	3e ff		> .
	ld b,a			;3a7d	47		G
	ld a,c			;3a7e	79		y
	sub b			;3a7f	90		.
	ld a,c			;3a80	79		y
	pop bc			;3a81	c1		.
	jp nz,l3a4fh		;3a82	c2 4f 3a	. O :
	ld a,l			;3a85	7d		}
	pop hl			;3a86	e1		.
	ld (hl),a		;3a87	77		w
	M_LEFT 2
	M_OUT_CH ':'
	M_RIGHT 3
	dec hl			;3a94	2b		+
	call sub_3b86h		;3a95	cd 86 3b	. . ;
	push bc			;3a98	c5		.
	ld b,000h		;3a99	06 00		. .
	call sub_3866h		;3a9b	cd 66 38	. f 8
	pop bc			;3a9e	c1		.
	call U_OUT_0F040B_09_0E		;3a9f	cd 48 15	. H .
	ld a,080h		;3aa2	3e 80		> .
	and (hl)		;3aa4	a6		.
	ld e,a			;3aa5	5f		_
	ld iy,0d2abh		;3aa6	fd 21 ab d2	. ! . .
	ld c,009h		;3aaa	0e 09		. .
l3aach:
	call NEXT_MACRO_OR_KEY	;3aac	cd a7 17	. . .
	push bc			;3aaf	c5		.
	ld c,a			;3ab0	4f		O
	ld a,020h		;3ab1	3e 20		>  
	ld b,a			;3ab3	47		G
	ld a,c			;3ab4	79		y
	sub b			;3ab5	90		.
	ld a,c			;3ab6	79		y
	pop bc			;3ab7	c1		.
	jp nz,l3aceh		;3ab8	c2 ce 3a	. . :
	bit 7,e			;3abb	cb 7b		. {
	jp z,l3ac7h		;3abd	ca c7 3a	. . :
	res 7,e			;3ac0	cb bb		. .
	ld b,000h		;3ac2	06 00		. .
	jp l3acbh		;3ac4	c3 cb 3a	. . :
l3ac7h:
	set 7,e			;3ac7	cb fb		. .
	ld b,001h		;3ac9	06 01		. .
l3acbh:
	call sub_3b0ch		;3acb	cd 0c 3b	. . ;
l3aceh:
	push bc			;3ace	c5		.
	ld c,a			;3acf	4f		O
	ld a,00ah		;3ad0	3e 0a		> .
	ld b,a			;3ad2	47		G
	ld a,c			;3ad3	79		y
	sub b			;3ad4	90		.
	ld a,c			;3ad5	79		y
	pop bc			;3ad6	c1		.
	jp nz,l3aach		;3ad7	c2 ac 3a	. . :
	ld a,(053d2h)		;3ada	3a d2 53	: . S
	or e			;3add	b3		.
	ld (hl),a		;3ade	77		w
	ret			;3adf	c9		.
sub_3ae0h:
	call NEXT_MACRO_OR_KEY	;3ae0	cd a7 17	. . .
	and 05fh		;3ae3	e6 5f		. _
	cp 00ah			;3ae5	fe 0a		. .
	ret z			;3ae7	c8		.
	cp 059h			;3ae8	fe 59		. Y
	jr z,l3af6h		;3aea	28 0a		( .
	cp 04eh			;3aec	fe 4e		. N
	jr nz,sub_3ae0h		;3aee	20 f0		  .
	call OUT_CH		;3af0	cd 84 10	. . .
	xor a			;3af3	af		.
	jr l3afbh		;3af4	18 05		. .
l3af6h:
	call OUT_CH		;3af6	cd 84 10	. . .
	ld a,0ffh		;3af9	3e ff		> .
l3afbh:
	push bc			;3afb	c5		.
	and b			;3afc	a0		.
	push af			;3afd	f5		.
	ld a,b			;3afe	78		x
	cpl			;3aff	2f		/
	and (hl)		;3b00	a6		.
	ld b,a			;3b01	47		G
	pop af			;3b02	f1		.
	or b			;3b03	b0		.
	ld (hl),a		;3b04	77		w
	M_LEFT 1
	pop bc
	jr sub_3ae0h

sub_3b0ch:
	M_CALL_WITH_MMAP0 l3b12h
	ret
l3b12h:
	push iy			;3b12	fd e5		. .
	push de			;3b14	d5		.
	push af			;3b15	f5		.
	push bc			;3b16	c5		.
	ld d,000h		;3b17	16 00		. .
l3b19h:
	push bc			;3b19	c5		.
	ld c,a			;3b1a	4f		O
	ld a,000h		;3b1b	3e 00		> .
	sub b			;3b1d	90		.
	ld a,c			;3b1e	79		y
	pop bc			;3b1f	c1		.
	jp nc,l3b2dh		;3b20	d2 2d 3b	. - ;
	ld e,(iy+000h)		;3b23	fd 5e 00	. ^ .
	inc e			;3b26	1c		.
	add iy,de		;3b27	fd 19		. .
	dec b			;3b29	05		.
	jp l3b19h		;3b2a	c3 19 3b	. . ;
l3b2dh:
	ld b,(iy+000h)		;3b2d	fd 46 00	. F .
	ld d,c			;3b30	51		Q
	push bc			;3b31	c5		.
	push de			;3b32	d5		.
	ld d,a			;3b33	57		W
	ld a,c			;3b34	79		y
	ld c,d			;3b35	4a		J
	pop de			;3b36	d1		.
	sub b			;3b37	90		.
	ld a,c			;3b38	79		y
	pop bc			;3b39	c1		.
	jp nc,l3b3eh		;3b3a	d2 3e 3b	. > ;
	ld b,c			;3b3d	41		A
l3b3eh:
	ld a,c			;3b3e	79		y
	sub b			;3b3f	90		.
	ld c,a			;3b40	4f		O
	inc iy			;3b41	fd 23		. #
l3b43h:
	push bc			;3b43	c5		.
	ld c,a			;3b44	4f		O
	ld a,000h		;3b45	3e 00		> .
	sub b			;3b47	90		.
	ld a,c			;3b48	79		y
	pop bc			;3b49	c1		.
	jp nc,l3b59h		;3b4a	d2 59 3b	. Y ;
	ld a,(iy+000h)		;3b4d	fd 7e 00	. ~ .
	call OUT_CH		;3b50	cd 84 10	. . .
	inc iy			;3b53	fd 23		. #
	dec b			;3b55	05		.
	jp l3b43h		;3b56	c3 43 3b	. C ;
l3b59h:
	ld a,020h		;3b59	3e 20		>  
l3b5bh:
	push bc			;3b5b	c5		.
	ld b,c			;3b5c	41		A
	ld c,a			;3b5d	4f		O
	ld a,000h		;3b5e	3e 00		> .
	sub b			;3b60	90		.
	ld a,c			;3b61	79		y
	pop bc			;3b62	c1		.
	jp nc,l3b6dh		;3b63	d2 6d 3b	. m ;
	call OUT_CH		;3b66	cd 84 10	. . .
	dec c			;3b69	0d		.
	jp l3b5bh		;3b6a	c3 5b 3b	. [ ;
l3b6dh:
	ld b,d			;3b6d	42		B
	ld a,008h		;3b6e	3e 08		> .
	call OUT_CH_REPEAT		;3b70	cd 7c 15	. | .
	pop bc			;3b73	c1		.
	pop af			;3b74	f1		.
	pop de			;3b75	d1		.
	pop iy			;3b76	fd e1		. .
	ret			;3b78	c9		.
sub_3b79h:
	or a			;3b79	b7		.
	jr z,l3b80h		;3b7a	28 04		( .
	ld a,059h		;3b7c	3e 59		> Y
	jr l3b82h		;3b7e	18 02		. .
l3b80h:
	ld a,04eh		;3b80	3e 4e		> N
l3b82h:
	call OUT_CH		;3b82	cd 84 10	. . .
	ret			;3b85	c9		.
sub_3b86h:
	push hl			;3b86	e5		.
	push de			;3b87	d5		.
	push af			;3b88	f5		.
	ld a,001h		;3b89	3e 01		> .
	ld de,(p4f84)		;3b8b	ed 5b 84 4f	. [ . O
	ld hl,04186h		;3b8f	21 86 41	! . A
	ld bc,00043h		;3b92	01 43 00	. C .
l3b95h:
	call CMP_HLDE		;3b95	cd 20 0f	.   .
	jr z,l3ba0h		;3b98	28 06		( .
	add hl,bc		;3b9a	09		.
	inc a			;3b9b	3c		<
	cp 01ah			;3b9c	fe 1a		. .
	jr c,l3b95h		;3b9e	38 f5		8 .
l3ba0h:
	ld b,a			;3ba0	47		G
	ld a,(CURSORX)		;3ba1	3a 86 4f	: . O
	inc a			;3ba4	3c		<
	ld c,a			;3ba5	4f		O
	pop af			;3ba6	f1		.
	pop de			;3ba7	d1		.
	pop hl			;3ba8	e1		.
	ret			;3ba9	c9		.

FUN_F1:
	call sub_2a82h		;3baa	cd 82 2a	. . *
	M_OUT_MSG 0xd2be, 0x17 ; 0F "SEQUENCE FOR REGION  " 0E 
	ld iy,-3
	add iy,sp		;3bb7	fd 39		. 9
	ld sp,iy		;3bb9	fd f9		. .
	ld h,006h		;3bbb	26 06		& .
	call INPUT_NUM		;3bbd	cd 48 3d	. H =
	ld a,(05cbah)		;3bc0	3a ba 5c	: . \
	cp 005h			;3bc3	fe 05		. .
	jr nz,l3bcfh		;3bc5	20 08		  .
	inc hl			;3bc7	23		#
	ld a,053h		;3bc8	3e 53		> S
	call 088dch		;3bca	cd dc 88	. . .
	jr l3be4h		;3bcd	18 15		. .
l3bcfh:
	call sub_3d8ah		;3bcf	cd 8a 3d	. . =
	ld de,052cbh		;3bd2	11 cb 52	. . R
	add hl,de		;3bd5	19		.
	ld (iy+001h),l		;3bd6	fd 75 01	. u .
	ld (iy+002h),h		;3bd9	fd 74 02	. t .
	ld de,v53c2		;3bdc	11 c2 53	. . S
	ld bc,00027h		;3bdf	01 27 00	. ' .
	ldir			;3be2	ed b0		. .
l3be4h:
	M_OUT_MSG 0xd2d5, 0x37 ; 0F CRLF CRLF "FILE  START  STOP  CHANGE" CRLF "      PAGE   PAGE   FILE" CRLF CRLF 
	ld hl, v53c9
	push hl			;3bed	e5		.
	ld (iy+000h),001h	;3bee	fd 36 00 01	. 6 . .
l3bf2h:
	push bc			;3bf2	c5		.
	ld c,a			;3bf3	4f		O
	ld a,(iy+000h)		;3bf4	fd 7e 00	. ~ .
	ld b,a			;3bf7	47		G
	ld a,004h		;3bf8	3e 04		> .
	sub b			;3bfa	90		.
	ld a,c			;3bfb	79		y
	pop bc			;3bfc	c1		.
	jp c,l3c3bh		;3bfd	da 3b 3c	. ; <
	M_RIGHT 2
	M_OUT_VAR 0x0000, 0x41
	M_RIGHT 3
	ex (sp),iy		;3c0e	fd e3		. .
	M_OUT_VAR 0x0000, 0x04
	M_RIGHT 3
	M_OUT_VAR 0x0002, 0x04
	M_RIGHT 3
	M_OUT_VAR 0x0004, 0x04
	ld de,8		;3c2a	11 08 00	. . .
	add iy,de		;3c2d	fd 19		. .
	ex (sp),iy		;3c2f	fd e3		. .
	inc (iy+000h)		;3c31	fd 34 00	. 4 .
	M_OUT_CH CRLF
	jp l3bf2h		;3c38	c3 f2 3b	. . ;
l3c3bh:
	pop hl			;3c3b	e1		.
	ld hl,0	;3c3c	21 00 00	! . .
	ld (053c7h),hl		;3c3f	22 c7 53	" . S
	M_GOTO_YX 6,1
	push iy			;3c47	fd e5		. .
	ld iy,053c9h		;3c49	fd 21 c9 53	. ! . S
	ld a,000h		;3c4d	3e 00		> .
l3c4fh:
	push bc			;3c4f	c5		.
	ld c,a			;3c50	4f		O
	ld b,a			;3c51	47		G
	ld a,003h		;3c52	3e 03		> .
	sub b			;3c54	90		.
	ld a,c			;3c55	79		y
	pop bc			;3c56	c1		.
	jp c,l3cadh		;3c57	da ad 3c	. . <
	push af			;3c5a	f5		.
	M_RIGHT 9
	call sub_3cdfh		;3c5f	cd df 3c	. . <
	ld (iy+006h),l		;3c62	fd 75 06	. u .
	ld (iy+007h),h		;3c65	fd 74 07	. t .
	ex de,hl		;3c68	eb		.
	M_RIGHT 7
	call sub_3d11h		;3c6d	cd 11 3d	. . =
	M_RIGHT 7
	; Adrs is IY+4
	M_SOMETHING1 0x0004, 0x04
	push de			;3c7a	d5		.
	push hl			;3c7b	e5		.
	ld hl,(053c7h)		;3c7c	2a c7 53	* . S
	ld de,0	;3c7f	11 00 00	. . .
	or a			;3c82	b7		.
	sbc hl,de		;3c83	ed 52		. R
	pop hl			;3c85	e1		.
	pop de			;3c86	d1		.
	jp nz,l3c9fh		;3c87	c2 9f 3c	. . <
	push de			;3c8a	d5		.
	push hl			;3c8b	e5		.
	ld de,0	;3c8c	11 00 00	. . .
	or a			;3c8f	b7		.
	sbc hl,de		;3c90	ed 52		. R
	pop hl			;3c92	e1		.
	pop de			;3c93	d1		.
	jp z,l3c9fh		;3c94	ca 9f 3c	. . <
	ld (053c7h),hl		;3c97	22 c7 53	" . S
	pop af			;3c9a	f1		.
	push af			;3c9b	f5		.
	ld (053c6h),a		;3c9c	32 c6 53	2 . S
l3c9fh:
	M_OUT_CH CRLF
	ld de,8		;3ca3	11 08 00	. . .
	add iy,de		;3ca6	fd 19		. .
	pop af			;3ca8	f1		.
	inc a			;3ca9	3c		<
	jp l3c4fh		;3caa	c3 4f 3c	. O <
l3cadh:
	pop iy			;3cad	fd e1		. .
	ld a,(05cbah)		;3caf	3a ba 5c	: . \
	cp 005h			;3cb2	fe 05		. .
	jr nz,l3cc6h		;3cb4	20 10		  .
	ld hl,v53c2		;3cb6	21 c2 53	! . S
	ld de,05cc6h		;3cb9	11 c6 5c	. . \
	ld bc,00027h		;3cbc	01 27 00	. ' .
	ldir			;3cbf	ed b0		. .
	call 0893fh		;3cc1	cd 3f 89	. ? .
	jr l3cd4h		;3cc4	18 0e		. .
l3cc6h:
	ld e,(iy+001h)		;3cc6	fd 5e 01	. ^ .
	ld d,(iy+002h)		;3cc9	fd 56 02	. V .
	ld hl,v53c2		;3ccc	21 c2 53	! . S
	ld bc,00027h		;3ccf	01 27 00	. ' .
	ldir			;3cd2	ed b0		. .
l3cd4h:
	ld iy,3		;3cd4	fd 21 03 00	. ! . .
	add iy,sp		;3cd8	fd 39		. 9
	ld sp,iy		;3cda	fd f9		. .
	jp l1925h		;3cdc	c3 25 19	. % .
sub_3cdfh:
	; Adrs = IY
	M_SOMETHING1 0x0000, 0x14
	ld de,(05b77h)		;3ce5	ed 5b 77 5b	. [ w [
	ex de,hl		;3ce9	eb		.
	call CMP_HLDE		;3cea	cd 20 0f	.   .
	jr nc,l3d0fh		;3ced	30 20		0  
	ld a,(05b84h)		;3cef	3a 84 5b	: . [
	cp 04eh			;3cf2	fe 4e		. N
	jr z,l3cfeh		;3cf4	28 08		( .
	call sub_09e4h		;3cf6	cd e4 09	. . .
	call CMP_HLDE		;3cf9	cd 20 0f	.   .
	jr c,l3d0fh		;3cfc	38 11		8 .
l3cfeh:
	ld hl,(0548ah)		;3cfe	2a 8a 54	* . T
	ex de,hl		;3d01	eb		.
	ld (0548ah),hl		;3d02	22 8a 54	" . T
	call CMP_HLDE		;3d05	cd 20 0f	.   .
	ret z			;3d08	c8		.
	M_SOMETHING2 0x04
	jr sub_3cdfh		;3d0d	18 d0		. .
l3d0fh:
	ex de,hl		;3d0f	eb		.
	ret			;3d10	c9		.
sub_3d11h:
	; Adrs is IY+2
	M_SOMETHING1 0x0002, 0x14
	call CMP_HLDE		;3d17	cd 20 0f	.   .
	jr c,l3d3fh		;3d1a	38 23		8 #
	push hl			;3d1c	e5		.
	push de			;3d1d	d5		.
	ex de,hl		;3d1e	eb		.
	ld hl,(05b77h)		;3d1f	2a 77 5b	* w [
	call CMP_HLDE		;3d22	cd 20 0f	.   .
	jr nc,l3d45h		;3d25	30 1e		0 .
	ld hl,(0548ah)		;3d27	2a 8a 54	* . T
	ex de,hl		;3d2a	eb		.
	ld (0548ah),hl		;3d2b	22 8a 54	" . T
	call CMP_HLDE		;3d2e	cd 20 0f	.   .
	jr z,l3d45h		;3d31	28 12		( .
	ld hl,(05b77h)		;3d33	2a 77 5b	* w [
	pop de			;3d36	d1		.
	push de			;3d37	d5		.
	call CMP_HLDE		;3d38	cd 20 0f	.   .
	jr c,l3d45h		;3d3b	38 08		8 .
	pop de			;3d3d	d1		.
	pop hl			;3d3e	e1		.
l3d3fh:
	M_SOMETHING2 0x04
	jr sub_3d11h		;3d43	18 cc		. .
l3d45h:
	pop de			;3d45	d1		.
	pop hl			;3d46	e1		.
	ret			;3d47	c9		.

; Input number 1 to H
; OUPUT: L, from 0 to H-1
INPUT_NUM:
	ld l,0ffh		;3d48	2e ff		. .
l3d4ah:
	call NEXT_MACRO_OR_KEY	;3d4a	cd a7 17	. . .
	push bc
	ld c,a
	ld a,"\n"
	ld b,a
	ld a,c
	sub b
	ld a,c
	pop bc
	jp nz,l3d6ah
	ld a,l			; Return pressed
	cp h
	jp nc,l3d65h		;3d5b	d2 65 3d	. e =
	ld a,10
	ld h,0
	jp l3d67h		;3d62	c3 67 3d	. g =
l3d65h:
	ld a,00bh		;3d65	3e 0b		> .
l3d67h:
	jp l3d7dh		;3d67	c3 7d 3d	. } =
l3d6ah:
	sub '1'
	cp h
	jp nc,l3d7bh		; Entry too large
	ld l,a				; Result
	inc a			;3d71	3c		<
	or 030h			;3d72	f6 30		. 0
	call OUT_CH		;3d74	cd 84 10	. . .
	M_LEFT 1
l3d7bh:
	ld a,0x0b
l3d7dh:
	push bc
	ld c,a
	ld a,10
	ld b,a
	ld a,c
	sub b
	ld a,c
	pop bc
	jp nz,l3d4ah		; Try again
	ret

sub_3d8ah:
	push de			;3d8a	d5		.
	ld d,h			;3d8b	54		T
	ld e,l			;3d8c	5d		]
	add hl,hl		;3d8d	29		)
	add hl,hl		;3d8e	29		)
	add hl,hl		;3d8f	29		)
	add hl,de		;3d90	19		.
	add hl,hl		;3d91	29		)
	add hl,de		;3d92	19		.
	add hl,hl		;3d93	29		)
	add hl,de		;3d94	19		.
	pop de			;3d95	d1		.
	ret			;3d96	c9		.

FUN_98:
	ld a,(05cbah)		;3d97	3a ba 5c	: . \
	cp 005h			;3d9a	fe 05		. .
	jr nz,l3dbbh		;3d9c	20 1d		  .
	ld a,048h		;3d9e	3e 48		> H
	ld hl,0	;3da0	21 00 00	! . .
	call 088dch		;3da3	cd dc 88	. . .
	ld hl,053d9h		;3da6	21 d9 53	! . S
	ld de,053e5h		;3da9	11 e5 53	. . S
	ld bc,24		;3dac	01 18 00	. . .
	lddr			;3daf	ed b8		. .
	ld a,052h		;3db1	3e 52		> R
	ld hl,0	;3db3	21 00 00	! . .
	call 088dch		;3db6	cd dc 88	. . .
	jr l3dc6h		;3db9	18 0b		. .
l3dbbh:
	ld hl,05b6fh		;3dbb	21 6f 5b	! o [
	ld de,v53c2		;3dbe	11 c2 53	. . S
	ld bc,36		;3dc1	01 24 00	. $ .
	ldir			;3dc4	ed b0		. .
l3dc6h:
	call sub_2a82h		;3dc6	cd 82 2a	. . *
	M_CALL_WITH_MMAP0 sub_c21dh
	call sub_978dh
	M_GOTO_YX 1,1
	call sub_9a27h
	jr z,l3de1h		;3dd9	28 06		( .
	call 097d9h		;3ddb	cd d9 97	. . .
	jp l3e88h		;3dde	c3 88 3e	. . >
l3de1h:
	M_GOTO_YX 3,16
	M_INPUT v53c2, 0x42
	M_GOTO_YX 7,16
	ld b,1
	ld de,26
	ld iy,053c4h		;3df6	fd 21 c4 53	. ! . S
l3dfah:
	push de			;3dfa	d5		.
	push hl			;3dfb	e5		.
	ld hl,0	;3dfc	21 00 00	! . .
	or a			;3dff	b7		.
	sbc hl,de		;3e00	ed 52		. R
	pop hl			;3e02	e1		.
	pop de			;3e03	d1		.
	jp nc,l3e5ah		;3e04	d2 5a 3e	. Z >
l3e07h:
	; Adrs is IY
	M_SOMETHING1 0x0000, 0x52
	push de			;3e0d	d5		.
	push hl			;3e0e	e5		.
	ex de,hl		;3e0f	eb		.
	or a			;3e10	b7		.
	sbc hl,de		;3e11	ed 52		. R
	pop hl			;3e13	e1		.
	pop de			;3e14	d1		.
	jp nc,l3e1ch		;3e15	d2 1c 3e	. . >
	xor a			;3e18	af		.
	jp l3e1eh		;3e19	c3 1e 3e	. . >
l3e1ch:
	ld a,0ffh		;3e1c	3e ff		> .
l3e1eh:
	push bc			;3e1e	c5		.
	ld c,a			;3e1f	4f		O
	ld a,000h		;3e20	3e 00		> .
	ld b,a			;3e22	47		G
	ld a,c			;3e23	79		y
	sub b			;3e24	90		.
	ld a,c			;3e25	79		y
	pop bc			;3e26	c1		.
	jp nz,l3e2eh		;3e27	c2 2e 3e	. . >
	M_SOMETHING2 0x02
l3e2eh:
	push bc			;3e2e	c5		.
	ld c,a			;3e2f	4f		O
	ld a,0ffh		;3e30	3e ff		> .
	ld b,a			;3e32	47		G
	ld a,c			;3e33	79		y
	sub b			;3e34	90		.
	ld a,c			;3e35	79		y
	pop bc			;3e36	c1		.
	jp nz,l3e07h		;3e37	c2 07 3e	. . >
	ex de,hl		;3e3a	eb		.
	xor a			;3e3b	af		.
	sbc hl,de		;3e3c	ed 52		. R
	ex de,hl		;3e3e	eb		.
	inc b			;3e3f	04		.
	push bc			;3e40	c5		.
	ld c,a			;3e41	4f		O
	ld a,006h		;3e42	3e 06		> .
	sub b			;3e44	90		.
	ld a,c			;3e45	79		y
	pop bc			;3e46	c1		.
	jp nc,l3e51h		;3e47	d2 51 3e	. Q >
	add hl,de		;3e4a	19		.
	ld (iy+000h),l		;3e4b	fd 75 00	. u .
	ld de,0	;3e4e	11 00 00	. . .
l3e51h:
	inc iy			;3e51	fd 23		. #
	M_DOWN 1
	jp l3dfah
l3e5ah:
	push bc			;3e5a	c5		.
	ld c,a			;3e5b	4f		O
	ld a,006h		;3e5c	3e 06		> .
	sub b			;3e5e	90		.
	ld a,c			;3e5f	79		y
	pop bc			;3e60	c1		.
	jp c,l3e80h		;3e61	da 80 3e	. . >
	ld (iy+000h),000h	;3e64	fd 36 00 00	. 6 . .
	M_LEFT 1
	M_OUT_VAR 0x0000, 0x42
	M_DOWN 1
	M_LEFT 1
	inc b
	inc iy
	jp l3e5ah		;3e7d	c3 5a 3e	. Z >
l3e80h:
	M_CALL_WITH_MMAP0 sub_c2c1h
	call sub_97afh
l3e88h:
	ld a,(05cbah)		;3e88	3a ba 5c	: . \
	cp 005h			;3e8b	fe 05		. .
	jr nz,l3eb3h		;3e8d	20 24		  $
	ld hl,v53c2		;3e8f	21 c2 53	! . S
	ld de,05cc6h		;3e92	11 c6 5c	. . \
	ld bc,12		;3e95	01 0c 00	. . .
	ldir			;3e98	ed b0		. .
	call 0893fh		;3e9a	cd 3f 89	. ? .
	ld hl,053ceh		;3e9d	21 ce 53	! . S
	ld de,05cc6h		;3ea0	11 c6 5c	. . \
	ld bc,24		;3ea3	01 18 00	. . .
	ldir			;3ea6	ed b0		. .
	ld a,048h		;3ea8	3e 48		> H
	ld (05cc2h),a		;3eaa	32 c2 5c	2 . \
	call 0893fh		;3ead	cd 3f 89	. ? .
	jp l1925h		;3eb0	c3 25 19	. % .
l3eb3h:
	ld de,05b6fh		;3eb3	11 6f 5b	. o [
	ld hl,v53c2		;3eb6	21 c2 53	! . S
	ld bc,36		;3eb9	01 24 00	. $ .
	ldir			;3ebc	ed b0		. .
	call 099cah		;3ebe	cd ca 99	. . .
	call sub_0849h		;3ec1	cd 49 08	. I .
	jp l1925h		;3ec4	c3 25 19	. % .

IF HACK_ROM
FRED_HACK:
	exx
	push af
	ld c,PORT_SERIAL_DATA
	ld hl,FIFO_KBD
	call PORT2FIFO	; Read port 0x00 into FIFO_SERIAL
	jp ACK_IF_NEEDED
ENDIF

	ds 0x4000-$, 0x00

	; ---------------------------------------
	;	16K RAM
	;   ORG : 4000
	; ---------------------------------------

	ds 16384, 0x00

	; ---------------------------------------
	;	16K ROM U21
	;   ORG : 8000
	; ---------------------------------------

	; Code to be executed by each key (while in edit mode?)
TABLE_FUN_KEY:
    dw FUN_00,FUN_00,FUN_03,FUN_04,FUN_05,FUN_06,FUN_07,FUN_00	;00
    dw FUN_08,FUN_09,FUN_00,FUN_0B,FUN_0C,FUN_00,FUN_00,FUN_0F	;08
    dw FUN_10,FUN_11,FUN_11,FUN_11,FUN_11,FUN_11,FUN_11,FUN_11	;10
    dw FUN_11,FUN_19,FUN_1A,FUN_00,FUN_1C,FUN_1D,FUN_1E,FUN_1F	;18
    dw FUN_20,FUN_20,FUN_20,FUN_20,FUN_20,FUN_20,FUN_20,FUN_20	;20
    dw FUN_20,FUN_20,FUN_20,FUN_20,FUN_20,FUN_20,FUN_20,FUN_20	;28
    dw FUN_20,FUN_20,FUN_20,FUN_20,FUN_20,FUN_20,FUN_20,FUN_20	;30
    dw FUN_20,FUN_20,FUN_20,FUN_20,FUN_20,FUN_20,FUN_20,FUN_20	;38
    dw FUN_20,FUN_20,FUN_20,FUN_20,FUN_20,FUN_20,FUN_20,FUN_20	;40
    dw FUN_20,FUN_20,FUN_20,FUN_20,FUN_20,FUN_20,FUN_20,FUN_20	;48
    dw FUN_20,FUN_20,FUN_20,FUN_20,FUN_20,FUN_20,FUN_20,FUN_20	;50
    dw FUN_20,FUN_20,FUN_20,FUN_20,FUN_20,FUN_20,FUN_20,FUN_20	;58
    dw FUN_20,FUN_20,FUN_20,FUN_20,FUN_20,FUN_20,FUN_20,FUN_20	;60
    dw FUN_20,FUN_20,FUN_20,FUN_20,FUN_20,FUN_20,FUN_20,FUN_20	;68
    dw FUN_20,FUN_20,FUN_20,FUN_20,FUN_20,FUN_20,FUN_20,FUN_20	;70
    dw FUN_20,FUN_20,FUN_20,FUN_20,FUN_20,FUN_20,FUN_20,FUN_7F	;78
    dw FUN_00,FUN_81,FUN_82,FUN_83,FUN_84,FUN_00,FUN_86,FUN_87	;80
    dw FUN_88,FUN_89,FUN_00,FUN_8B,FUN_8C,FUN_00,FUN_8E,FUN_8F	;88
    dw FUN_00,FUN_00,FUN_92,FUN_93,FUN_94,FUN_95,FUN_96,FUN_00	;90
    dw FUN_98,FUN_99,FUN_9A,FUN_00,FUN_9C,FUN_9D,FUN_9E,FUN_00	;98
    dw FUN_00,FUN_00,FUN_00,FUN_00,FUN_A4,FUN_A5,FUN_00,FUN_00	;A0
    dw FUN_00,FUN_00,FUN_00,FUN_00,FUN_00,FUN_00,FUN_00,FUN_00	;A8
    dw FUN_00,FUN_00,FUN_00,FUN_00,FUN_00,FUN_00,FUN_00,FUN_00	;B0
    dw FUN_00,FUN_00,FUN_00,FUN_00,FUN_00,FUN_00,FUN_00,FUN_00	;B8
    dw FUN_00,FUN_C1,FUN_C2,FUN_C3,FUN_00,FUN_00,FUN_00,FUN_00	;C0
    dw FUN_00,FUN_00,FUN_00,FUN_00,FUN_00,FUN_00,FUN_00,FUN_00	;C8
    dw FUN_00,FUN_00,FUN_D2,FUN_D3,FUN_D4,FUN_D5,FUN_00,FUN_00	;D0
    dw FUN_00,FUN_D9,FUN_00,FUN_00,FUN_DC,FUN_DD,FUN_DE,FUN_00	;D8
    dw FUN_E0,FUN_E1,FUN_E2,FUN_E3,FUN_E4,FUN_00,FUN_00,FUN_00	;E0
    dw FUN_00,FUN_00,FUN_00,FUN_00,FUN_00,FUN_00,FUN_00,FUN_00	;E8
    dw FUN_00,FUN_F1,FUN_F2,FUN_00,FUN_F4,FUN_00,FUN_00,FUN_F7	;F0
    dw FUN_F8,FUN_F9,FUN_FA,FUN_FB,FUN_FC,FUN_FD,FUN_FE,FUN_FF	;F8

FUN_A4:
MENU_8200:
	ld a,091h		;8200	3e 91 	> . 
	ld (05fd3h),a		;8202	32 d3 5f 	2 . _ 
	ld hl,FLAGS		;8205	21 79 4f 	! y O 
	bit 4,(hl)		;8208	cb 66 	. f 
	call nz,sub_2326h		;820a	c4 26 23 	. & # 
	call sub_2a82h		;820d	cd 82 2a 	. . * 
	M_OUT_MSG 0xd488, 0xd9 ; "SELECT" CRLF CRLF "E-EDIT" CRLF "F-FORMATED EDIT" CRLF "D-DISPLAY RESUME" CRLF "R-RECALL PAGE" CRLF "S-STORE PAGE" CRLF "N-NEXT PAGE" CRLF "L-LAST PAGE" CRLF "C-CLOCK SET" CRLF "P-PAGE COPY" CRLF "M-MEMORY SET" CRLF "X-EXTERNAL LINE LEVELS" CRLF "B-BLOCK EDIT" CRLF "H-HELP MENU FOR CONTROL CODES" CRLF "SETUP-NEXT MENU"
	M_GOTO_YX 1,9
	ld hl,MENU_TABLE1
	call HANDLE_MENU		;821e	cd 37 82 	. 7 . 
	jp (hl)			;8221	e9 	. 

FUN_A5:
MENU_8222:
	call sub_2a82h		;8222	cd 82 2a 	. . * 
	M_OUT_MSG 0xd561, 0xba ; "SELECT" CRLF CRLF "C-CHANNEL REGION SETUP" CRLF "S-SEQUENCE" CRLF "E-EVENTS" CRLF "N-NEXT EVENT" CRLF "L-LAST EVENT" CRLF "D-DATA EXTERNAL SOURCE" CRLF "W-WEATHER SETUP" CRLF "B-BATCH TRANSFER" CRLF "R-REMOTE EDIT" CRLF "K-KEYBOARD DIRECT" CRLF "A-AUTHORIZATION CODES"
	M_GOTO_YX 1,9
	ld hl,MENU_TABLE2
	call HANDLE_MENU		;8233	cd 37 82 	. 7 . 
	jp (hl)			;8236	e9 	. 

; Get a key and returns the routine from the menu routines
HANDLE_MENU:
	call NEXT_MACRO_OR_KEY		; Get key
	and 0dfh					; Poor's man uppercase
	ld b,00eh					; # entries
_loop:
	cp (hl)						; Right key?
	jr z,_found
	inc hl						; Next entry 
	inc hl
	inc hl 
	djnz _loop 
_found:							; or end of table
	inc hl						; Get pointer
	ld e,(hl)			
	inc hl
	ld d,(hl) 
	ex de,hl 
	ret 

MENU_TABLE1:
	db 'E'
	dw 0x23d2
	db 'F'
	dw 0x8412
	db 'D'
	dw 0x235c
	db 'R'
	dw 0x2922
	db 'S'
	dw 0x2776
	db 'N'
	dw 0x2a3a
	db 'L'
	dw 0x2a5e
	db 'C'
	dw 0xb1c5
	db 'P'
	dw 0xb0c7
	db 'M'
	dw 0xafd5
	db 'X'
	dw 0xb61b
	db 'H'
	dw 0x82a6
	db 0x84 ; ?
	dw MENU_8222
	db 'B'
	dw 0xb8e1
	db ' '
	dw MENU_8200
MENU_TABLE2:
	db 'C'
	dw 0x3d97
	db 'S'
	dw 0x3baa
	db 'E'
	dw 0xb961
	db 'N'
	dw 0xbf3b
	db 'L'
	dw 0xbf45
	db 'D'
	dw 0xac17
	db 'W'
	dw FUN_F7
	db 'B'
	dw 0x8505
	db 'R'
	dw 0x844d
	db 'K'
	dw 0x8413
	db 'A'
	dw 0x904e
	db ' '
	dw MENU_8222
	db ' '
	dw MENU_8222
	db ' '
	dw MENU_8222
	db ' '
	dw MENU_8222
	call sub_2a82h		;82a6	cd 82 2a 	. . * 
	M_OUT_MSG 0xd30c, 0xf6 ; "CONTROL KEY FUNCTIONS" CRLF CRLF "LINE SEPARATOR" CRLF " C-COLOR" CRLF " T-TOP ON/OFF" CRLF " B-BOTTOM ON/OFF" CRLF "WORD CONTROL CHARACTERS" CRLF " F-ALTERNATE FONT" CRLF " X-EXTERNAL VIDEO" CRLF "EDIT FUNCTIONS" CRLF " L-ERASE TO END OF LINE" CRLF " P-ERASE TO END OF PAGE" CRLF " A-ERASE PAGE ATTRIBUTES" CRLF " S-CHARACTER INSERT" CRLF 
	M_OUT_MSG 0xd402, 0x86 ; " D-CHARACTER DELETE" CRLF " V-LINE INSERT" CRLF " K-LINE DELETE" CRLF " R-BORDER" CRLF "SYSTEM FUNCTIONS" CRLF " E-SELECT CHANNEL FOR EDITING" CRLF " O-OFF LINE BATCH TRANSFER" 0F 
	ret

sub_82b6h:
	ld a,(05cbah)		;82b6	3a ba 5c 	: . \ 
	cp 002h		;82b9	fe 02 	. . 
	ret z			;82bb	c8 	. 
	ld a,(05fd3h)		;82bc	3a d3 5f 	: . _ 
	cp 091h		;82bf	fe 91 	. . 
l82c1h:
	ld a,b			;82c1	78 	x 
	jr z,l82cdh		;82c2	28 09 	( . 
l82c4h:
	cp 0a4h		;82c4	fe a4 	. . 
	ret nz			;82c6	c0 	. 
l82c7h:
	ld a,091h		;82c7	3e 91 	> . 
	ld (05fd3h),a		;82c9	32 d3 5f 	2 . _ 
	ret			;82cc	c9 	. 
l82cdh:
	ld de,WEIRD_TABLE		; Weird table
	cp 0x90		; If KEY that would be KEY_CTRL_RESET 
	jr nz,l82d8h 
	ld (05fd3h),a 
	ret 
l82d8h:
	ld l,a
	ld h,0
	add hl,de
	ld a,(hl)		; Lookup into WEIRD_TABLE
	ld b,a
	cp 0xb0
	jr nz,l82f1h
	ld a,(04f76h)
	cp 0xb0 
	jr z,l82eeh
	ld a,b
	ld (04f76h),a
	ret
l82eeh:
	ld b,0xa0
	ret
l82f1h:
	cp 0xb1
	jr nz,l8304h
	ld a,(04f76h)
	cp 0xb1
	jr z,l8301h
l82fch:
	ld a,b
	ld (04f76h),a
	ret
l8301h:
	ld b,0xa1
	ret
l8304h:
	cp 0xa4
	ret nz
	ld a,(04f76h)
	cp 0xa4
	jr nz,l82fch
	ld b,0xa5
	jr l82fch

	; Almost sorted sometimes, then strange
	; Stats with a 'jp' to a non existent address
	; Sounds to me like some sort of kbd mapping table (german?)
WEIRD_TABLE:
	db 0xc3, 0x87, 0xfe, 0x9e, 0x86, 0x9b, 0xe0, 0xd9
	db 0x7f, 0x90, 0xe4, 0x8e, 0x03, 0x05, 0x0e, 0x99
	db 0x02, 0x11, 0x1f, 0x8f, 0xde, 0x15, 0x81, 0x17
	db 0xc1, 0x19, 0x1a, 0x1b, 0xa0, 0x1d, 0x1e, 0x1f
	db 0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27
	db 0x28, 0x29, 0x2a, 0x2b, 0x2c, 0x2d, 0x2e, 0x2f
	db 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37
	db 0x38, 0x39, 0x3a, 0x3b, 0x3c, 0x3d, 0x3e, 0x3f
	db 0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47
	db 0x48, 0x49, 0x4a, 0x4b, 0x4c, 0x4d, 0x4e, 0x4f
	db 0x50, 0x51, 0x52, 0x53, 0x54, 0x55, 0x56, 0x57
	db 0x58, 0x59, 0x5a, 0x5b, 0xb0, 0x5d, 0x5e, 0x5f
	db 0x20, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67
	db 0x68, 0x69, 0x6a, 0x6b, 0x6c, 0x6d, 0x6e, 0x6f
	db 0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77
	db 0x78, 0x79, 0x7a, 0x7b, 0xa0, 0x20, 0x60, 0xb1
	db 0xe3, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87
	db 0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x8f
	db 0x90, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97
	db 0x98, 0x99, 0x9a, 0x9b, 0x9c, 0x9d, 0x9e, 0x9f
	db 0xa0, 0xa1, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0x9b
	db 0xa8, 0xa9, 0xaa, 0xab, 0x04, 0xad, 0x84, 0xaf
	db 0xb0, 0xb1, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6, 0xb7
	db 0xb8, 0xb9, 0xba, 0xbb, 0xbc, 0xbd, 0xbe, 0xbf
	db 0xc0, 0x0c, 0x0b, 0x09, 0x08, 0xc5, 0xc6, 0xc7
	db 0xc8, 0xc9, 0xca, 0xcb, 0xcc, 0xc2, 0xce, 0xcf
	db 0x11, 0x12, 0x13, 0x14, 0xe1, 0xd5, 0xd6, 0xd7
	db 0xec, 0xc2, 0xda, 0xdb, 0xdc, 0xdd, 0xde, 0xdf
	db 0xe0, 0xe1, 0xe2, 0xe3, 0xe4, 0xe5, 0xe6, 0xe7
	db 0xe8, 0xe9, 0xd9, 0xeb, 0x1a, 0x18, 0xe2, 0xef
	db 0x0a, 0x1e, 0x1d, 0x1c, 0x10, 0xff, 0x19, 0x15
	db 0x16, 0x17, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff

	ret			;8412	c9 	. 

FUN_94:
	call sub_8441h		;8413	cd 41 84 	. A . 
	call sub_2a82h		;8416	cd 82 2a 	. . * 
	M_OUT_MSG 0xd61b, 0x1f ; "KEYBOARD DIRECT  SYSTEM NAME   "
	M_INPUT v53c2, 0x42
	ld hl,(v53c2)		;8425	2a c2 53 	* . S 
	ld (05e9dh),hl		;8428	22 9d 5e 	" . ^ 
	ld a,04bh		;842b	3e 4b 	> K 
	ld (05cc1h),a		;842d	32 c1 5c 	2 . \ 
	call sub_848eh		;8430	cd 8e 84 	. . . 
	M_OUT_MSG 0xd63a, 0x09 ; CRLF "ON LINE "
	ld a,001h		;8439	3e 01 	> . 
	ld (05cbah),a		;843b	32 ba 5c 	2 . \ 
	jp l1934h		;843e	c3 34 19 	. 4 . 

sub_8441h:
	ld a,(05cbah)		;8441	3a ba 5c 	: . \ 
	or a			;8444	b7 	. 
	ret z			;8445	c8 	. 
	call sub_8fa5h		;8446	cd a5 8f 	. . . 
	pop hl			;8449	e1 	. 
	jp l1934h		;844a	c3 34 19 	. 4 . 

FUN_D4:
	call sub_8441h		;844d	cd 41 84 	. A . 
	call sub_2a82h		;8450	cd 82 2a 	. . * 
	M_OUT_MSG 0xd643, 0x1b ; "REMOTE EDIT  SYSTEM NAME   "
	M_INPUT v53c2, 0x42
	ld hl,(v53c2)		;845f	2a c2 53 	* . S 
	ld (05e9dh),hl		;8462	22 9d 5e 	" . ^ 
	ld a,045h		;8465	3e 45 	> E 
	ld (05cc1h),a		;8467	32 c1 5c 	2 . \ 
	call sub_848eh		;846a	cd 8e 84 	. . . 
	ld a,005h		;846d	3e 05 	> . 
	ld (05cbah),a		;846f	32 ba 5c 	2 . \ 
	ld a,042h		;8472	3e 42 	> B 
	ld hl,0		;8474	21 00 00 	! . . 
	call sub_88dch		;8477	cd dc 88 	. . . 
	ld hl,v53c2		;847a	21 c2 53 	! . S 
	ld de,05fb2h		;847d	11 b2 5f 	. . _ 
	ld bc,4
	ldir 
	M_OUT_MSG 0xd63a, 0x09 ; CRLF "ON LINE "
	jp l1934h		;848b	c3 34 19 	. 4 . 
sub_848eh:
	ld a,(0000fh)		;848e	3a 0f 00 	: . . 
	cp 0aah		;8491	fe aa 	. . 
	jr nz,l849fh		;8493	20 0a 	  . 
	call sub_9382h		;8495	cd 82 93 	. . . 
	jr z,l84ddh		;8498	28 43 	( C 
	ld a,0aah		;849a	3e aa 	> . 
	ld (06038h),a		;849c	32 38 60 	2 8 ` 
l849fh:
	call sub_8b30h		;849f	cd 30 8b 	. 0 . 
l84a2h:
	ld a,003h		;84a2	3e 03 	> . 
	ld (05cbbh),a		;84a4	32 bb 5c 	2 . \ 
	call sub_890ah		;84a7	cd 0a 89 	. . . 
l84aah:
	or a			;84aa	b7 	. 
	ret z			;84ab	c8 	. 
	cp 055h		;84ac	fe 55 	. U 
	jr z,l84b7h		;84ae	28 07 	( . 
	call sub_8b41h		;84b0	cd 41 8b 	. A . 
	jr z,l84ddh		;84b3	28 28 	( ( 
	jr l84a2h		;84b5	18 eb 	. . 
l84b7h:
	M_OUT_MSG 0xd70b, 0x11 ; CRLF "LOGON ID        "
	M_INPUT v5cbf, 0x46
l84c3h:
	call sub_0334h		;84c3	cd 34 03 	. 4 . 
	ld a,(06029h)		;84c6	3a 29 60 	: ) ` 
	or a			;84c9	b7 	. 
	jr nz,l84c3h		;84ca	20 f7 	  . 
	ld hl,la5a5h		;84cc	21 a5 a5 	! . . 
	ld (05cbdh),hl		;84cf	22 bd 5c 	" . \ 
	call sub_898ah		;84d2	cd 8a 89 	. . . 
	ld hl,00009h		;84d5	21 09 00 	! . . 
	call sub_8913h		;84d8	cd 13 89 	. . . 
	jr l84aah		;84db	18 cd 	. . 
l84ddh:
	call sub_84e4h		;84dd	cd e4 84 	. . . 
	pop hl			;84e0	e1 	. 
	jp l1934h		;84e1	c3 34 19 	. 4 . 
sub_84e4h:
	M_OUT_MSG 0xd71c, 0x14 ; CRLF "NO ACCESS          "
	ld a,(0000fh)		;84ea	3a 0f 00 	: . . 
	cp 0aah		;84ed	fe aa 	. . 
	call z,sub_93dah		;84ef	cc da 93 	. . . 
	xor a			;84f2	af 	. 
	ld (05cbbh),a		;84f3	32 bb 5c 	2 . \ 
	ld (05cbch),a		;84f6	32 bc 5c 	2 . \ 
sub_84f9h:
	push hl			;84f9	e5 	. 
	ld hl,0		;84fa	21 00 00 	! . . 
	ld (05eaeh),hl		;84fd	22 ae 5e 	" . ^ 
	ld (05eb0h),hl		;8500	22 b0 5e 	" . ^ 
	pop hl			;8503	e1 	. 
	ret			;8504	c9 	. 

FUN_F4:
	call sub_8441h		;8505	cd 41 84 	. A . 
	call sub_2a82h		;8508	cd 82 2a 	. . * 
	M_OUT_MSG 0xd66d, 0x1e ; "BATCH TRANSFER  SYSTEM NAME   "
	M_INPUT v53c2, 0x42
	ld hl,(v53c2)		;8517	2a c2 53 	* . S 
	ld (05e9dh),hl		;851a	22 9d 5e 	" . ^ 
	ld a,042h		;851d	3e 42 	> B 
	ld (05cc1h),a		;851f	32 c1 5c 	2 . \ 
	call sub_848eh		;8522	cd 8e 84 	. . . 
	M_OUT_MSG 0xd63a, 0x09 ; CRLF "ON LINE "
	ld a,003h		;852b	3e 03 	> . 
	ld (05cbah),a		;852d	32 ba 5c 	2 . \ 
	M_GOTO_YX 5,1
	M_OUT_MSG 0xd68d, 0x7e ; "DIRECTION     (S=SEND F=FETCH)" CRLF CRLF "SOURCE  SOURCE  DESTIN  PRESENT" CRLF " FIRST   LAST    FIRST  TRANSFER" CRLF " 0000    0000    0000    0000"
	M_GOTO_YX 5,12
l8540h:
	call NEXT_MACRO_OR_KEY		;8540	cd a7 17 	. . . 
	and 0dfh		;8543	e6 df 	. . 
	cp 053h		;8545	fe 53 	. S 
	jr z,l854dh		;8547	28 04 	( . 
	cp 046h		;8549	fe 46 	. F 
	jr nz,l8540h		;854b	20 f3 	  . 
l854dh:
	ld (053c4h),a		;854d	32 c4 53 	2 . S 
	call OUT_CH		;8550	cd 84 10 	. . . 
	M_GOTO_YX 9,5
	ld hl,053c6h		;8558	21 c6 53 	! . S 
	ld b,006h		;855b	06 06 	. . 
l855dh:
	ld (hl),000h		;855d	36 00 	6 . 
	inc hl			;855f	23 	# 
	djnz l855dh		;8560	10 fb 	. . 
	M_SOMETHING1 v53c6, 0x04
	ex de,hl			;8568	eb 	. 
	M_RIGHT 8
l856dh:
	M_SOMETHING1 v53c8, 0x14
	call CMP_HLDE		;8573	cd 20 0f 	.   . 
	jr nc,l857eh		;8576	30 06 	0 . 
	M_SOMETHING2 0x04
	jr l856dh		;857c	18 ef 	. . 
l857eh:
	M_RIGHT 8
	M_SOMETHING1 v53ca, 0x04
	M_RIGHT 8
	ld a,(053c4h)		;858c	3a c4 53 	: . S 
	cp 'S'
	jp z,l8690h		;8591	ca 90 86 	. . . 
l8594h:
	ld hl,(053c6h)		;8594	2a c6 53 	* . S 
	ld de,(053c8h)		;8597	ed 5b c8 53 	. [ . S 
	call CMP_HLDE		;859b	cd 20 0f 	.   . 
	jp nz,l8637h		;859e	c2 37 86 	. 7 . 
	push hl			;85a1	e5 	. 
	ld hl,0270fh		;85a2	21 0f 27 	! . ' 
	call CMP_HLDE		;85a5	cd 20 0f 	.   . 
	pop hl			;85a8	e1 	. 
	jp nz,l8637h		;85a9	c2 37 86 	. 7 . 
	M_LEFT 3
	ld a,'Q'
	call sub_87fch
	ld a,'X'
	call sub_87fch
	ld a,'W'
	call sub_87fch
	ld a,'R'
	call sub_87fch
	ld a,'T'
	call sub_87fch
	ld a,'L'
	call sub_87fch
	ld a,'O'
	call sub_87fch
	ld a,'H'
	call sub_87fch
	call sub_8edeh
	ld a,'E'
	call OUT_CH
	M_RIGHT 2
	ld bc,(05b79h)		;85e4	ed 4b 79 5b 	. K y [ 
	ld a,b			;85e8	78 	x 
	or c			;85e9	b1 	. 
	jp z,l88d0h		;85ea	ca d0 88 	. . . 
	ld hl,0		;85ed	21 00 00 	! . . 
l85f0h:
	call sub_8b30h		;85f0	cd 30 8b 	. 0 . 
l85f3h:
	call sub_8b36h		;85f3	cd 36 8b 	. 6 . 
	push bc			;85f6	c5 	. 
	push hl			;85f7	e5 	. 
	call sub_889bh		;85f8	cd 9b 88 	. . . 
	cp 0ffh		;85fb	fe ff 	. . 
	jr nz,l8609h		;85fd	20 0a 	  . 
	pop hl			;85ff	e1 	. 
	pop bc			;8600	c1 	. 
	call sub_8b41h		;8601	cd 41 8b 	. A . 
	jr nz,l85f3h		;8604	20 ed 	  . 
	jp sub_88c4h		;8606	c3 c4 88 	. . . 
l8609h:
	pop hl			;8609	e1 	. 
	push hl			;860a	e5 	. 
	call sub_8625h		;860b	cd 25 86 	. % . 
	call sub_8d1fh		;860e	cd 1f 8d 	. . . 
	ex de,hl			;8611	eb 	. 
	ld hl,05cc6h		;8612	21 c6 5c 	! . \ 
	ld bc,00020h		;8615	01 20 00 	.   . 
	ldir		;8618	ed b0 	. . 
	pop hl			;861a	e1 	. 
	pop bc			;861b	c1 	. 
	inc hl			;861c	23 	# 
	call sub_88adh		;861d	cd ad 88 	. . . 
	jr nz,l85f0h		;8620	20 ce 	  . 
	jp l88d0h		;8622	c3 d0 88 	. . . 
sub_8625h:
	M_LEFT 2
	ld (053cch),hl		;8629	22 cc 53 	" . S 
	M_OUT_VAR 0x53cc, 0x03
	M_LEFT 1
	ret
l8637h:
	ld de,(v53c2)
	call sub_88b5h
	call sub_8b30h		;863e	cd 30 8b 	. 0 . 
l8641h:
	call sub_8b36h		;8641	cd 36 8b 	. 6 . 
	push hl			;8644	e5 	. 
	push de			;8645	d5 	. 
	call sub_8879h		;8646	cd 79 88 	. y . 
	pop de			;8649	d1 	. 
	pop hl			;864a	e1 	. 
	cp 0ffh		;864b	fe ff 	. . 
	jr nz,l8657h		;864d	20 08 	  . 
	call sub_8b41h		;864f	cd 41 8b 	. A . 
	jr nz,l8641h		;8652	20 ed 	  . 
	jp sub_88c4h		;8654	c3 c4 88 	. . . 
l8657h:
	ld hl,(053cah)		;8657	2a ca 53 	* . S 
	call sub_07f9h		;865a	cd f9 07 	. . . 
	cp 0ffh		;865d	fe ff 	. . 
	jp z,sub_88c4h		;865f	ca c4 88 	. . . 
	call SETMEMMAP		;8662	cd 1a 0f 	. . . 
	ex de,hl			;8665	eb 	. 
	ld hl,05cc6h		;8666	21 c6 5c 	! . \ 
	ld bc,l0170h		;8669	01 70 01 	. p . 
	ldir		;866c	ed b0 	. . 
	ld hl,(053c6h)		;866e	2a c6 53 	* . S 
	inc hl			;8671	23 	# 
	ld (053c6h),hl		;8672	22 c6 53 	" . S 
	ex de,hl			;8675	eb 	. 
	ld hl,(053c8h)		;8676	2a c8 53 	* . S 
	call CMP_HLDE		;8679	cd 20 0f 	.   . 
	jr nc,l8686h		;867c	30 08 	0 . 
	ld a,(05e36h)		;867e	3a 36 5e 	: 6 ^ 
	bit 1,a		;8681	cb 4f 	. O 
	jp z,l88d0h		;8683	ca d0 88 	. . . 
l8686h:
	ld hl,(053cah)		;8686	2a ca 53 	* . S 
	inc hl			;8689	23 	# 
	ld (053cah),hl		;868a	22 ca 53 	" . S 
	jp l8594h		;868d	c3 94 85 	. . . 
l8690h:
	ld hl,(053c6h)		;8690	2a c6 53 	* . S 
	ld de,(053c8h)		;8693	ed 5b c8 53 	. [ . S 
	ld bc,(053cah)		;8697	ed 4b ca 53 	. K . S 
	call CMP_HLDE		;869b	cd 20 0f 	.   . 
	jr nz,l871eh		;869e	20 7e 	  ~ 
	push hl			;86a0	e5 	. 
	ld hl,0270fh		;86a1	21 0f 27 	! . ' 
	call CMP_HLDE		;86a4	cd 20 0f 	.   . 
	pop hl			;86a7	e1 	. 
	jr nz,l871eh		;86a8	20 74 	  t 
	M_LEFT 3
	ld a,'Q'
	call sub_884ah		;86b0	cd 4a 88 	. J . 
	ld a,'X'
	call sub_884ah		;86b5	cd 4a 88 	. J . 
	ld a,'W'
	call sub_884ah		;86ba	cd 4a 88 	. J . 
	ld a,'R'
	call sub_884ah		;86bf	cd 4a 88 	. J . 
	ld a,'T'
	call sub_884ah		;86c4	cd 4a 88 	. J . 
	ld a,'L'
	call sub_884ah		;86c9	cd 4a 88 	. J . 
	ld a,'O'
	call sub_884ah		;86ce	cd 4a 88 	. J . 
	ld a,'H'
	call sub_884ah		;86d3	cd 4a 88 	. J . 
	ld a,'E'
	call OUT_CH		;86d8	cd 84 10 	. . . 
	M_RIGHT 2
	ld bc,(05b79h)		;86df	ed 4b 79 5b 	. K y [ 
	ld a,b			;86e3	78 	x 
	or c			;86e4	b1 	. 
	jp z,l88d0h		;86e5	ca d0 88 	. . . 
	ld hl,0		;86e8	21 00 00 	! . . 
l86ebh:
	call sub_8b30h		;86eb	cd 30 8b 	. 0 . 
l86eeh:
	call sub_8b36h		;86ee	cd 36 8b 	. 6 . 
	push bc			;86f1	c5 	. 
	push hl			;86f2	e5 	. 
	call sub_8625h		;86f3	cd 25 86 	. % . 
	ld (05cc3h),hl		;86f6	22 c3 5c 	" . \ 
	call sub_8d1fh		;86f9	cd 1f 8d 	. . . 
	ld de,05cc6h		;86fc	11 c6 5c 	. . \ 
	ld bc,00020h		;86ff	01 20 00 	.   . 
	ldir		;8702	ed b0 	. . 
	call sub_87d0h		;8704	cd d0 87 	. . . 
	cp 0ffh		;8707	fe ff 	. . 
	pop hl			;8709	e1 	. 
	pop bc			;870a	c1 	. 
	jr nz,l8715h		;870b	20 08 	  . 
	call sub_8b41h		;870d	cd 41 8b 	. A . 
	jp z,sub_88c4h		;8710	ca c4 88 	. . . 
	jr l86eeh		;8713	18 d9 	. . 
l8715h:
	inc hl			;8715	23 	# 
	call sub_88adh		;8716	cd ad 88 	. . . 
	jr nz,l86ebh		;8719	20 d0 	  . 
	jp l88d0h		;871b	c3 d0 88 	. . . 
l871eh:
	call sub_8b30h		;871e	cd 30 8b 	. 0 . 
	ld de,(v53c2)		;8721	ed 5b c2 53 	. [ . S 
	call sub_88b5h		;8725	cd b5 88 	. . . 
l8728h:
	call sub_8b36h		;8728	cd 36 8b 	. 6 . 
	push bc			;872b	c5 	. 
	push de			;872c	d5 	. 
	push hl			;872d	e5 	. 
	call sub_876ch		;872e	cd 6c 87 	. l . 
	pop hl			;8731	e1 	. 
	pop de			;8732	d1 	. 
	pop bc			;8733	c1 	. 
	cp 0ffh		;8734	fe ff 	. . 
	jr nz,l8740h		;8736	20 08 	  . 
	call sub_8b41h		;8738	cd 41 8b 	. A . 
	jp z,sub_88c4h		;873b	ca c4 88 	. . . 
	jr l8728h		;873e	18 e8 	. . 
l8740h:
	ld hl,(053c6h)		;8740	2a c6 53 	* . S 
	inc hl			;8743	23 	# 
	ld (053c6h),hl		;8744	22 c6 53 	" . S 
	ex de,hl			;8747	eb 	. 
	ld hl,(053c8h)		;8748	2a c8 53 	* . S 
	call CMP_HLDE		;874b	cd 20 0f 	.   . 
	jr nc,l8762h		;874e	30 12 	0 . 
	ex de,hl			;8750	eb 	. 
	call sub_07f9h		;8751	cd f9 07 	. . . 
	cp 0ffh		;8754	fe ff 	. . 
	jp z,l88d0h		;8756	ca d0 88 	. . . 
	call SETMEMMAP		;8759	cd 1a 0f 	. . . 
	ld a,(hl)			;875c	7e 	~ 
	bit 1,a		;875d	cb 4f 	. O 
	jp z,l88d0h		;875f	ca d0 88 	. . . 
l8762h:
	ld hl,(053cah)		;8762	2a ca 53 	* . S 
	inc hl			;8765	23 	# 
	ld (053cah),hl		;8766	22 ca 53 	" . S 
	jp l8690h		;8769	c3 90 86 	. . . 
sub_876ch:
	ld (05cbfh),de		;876c	ed 53 bf 5c 	. S . \ 
	ld (05cc3h),bc		;8770	ed 43 c3 5c 	. C . \ 
	ld a,053h		;8774	3e 53 	> S 
	ld (05cc1h),a		;8776	32 c1 5c 	2 . \ 
	ld a,050h		;8779	3e 50 	> P 
	ld (05cc2h),a		;877b	32 c2 5c 	2 . \ 
	call sub_07f9h		;877e	cd f9 07 	. . . 
	cp 0ffh		;8781	fe ff 	. . 
	ret z			;8783	c8 	. 
	call SETMEMMAP		;8784	cd 1a 0f 	. . . 
	ld de,05cc6h		;8787	11 c6 5c 	. . \ 
	ld bc,l0170h		;878a	01 70 01 	. p . 
	ldir		;878d	ed b0 	. . 
	call sub_8984h		;878f	cd 84 89 	. . . 
	ld bc,00171h		;8792	01 71 01 	. q . 
	call sub_8a1ah		;8795	cd 1a 8a 	. . . 
	ld hl,05cbdh		;8798	21 bd 5c 	! . \ 
	ld (05e9fh),hl		;879b	22 9f 5e 	" . ^ 
	ld hl,0017bh		;879e	21 7b 01 	! { . 
	ld (05ea1h),hl		;87a1	22 a1 5e 	" . ^ 
	ld a,001h		;87a4	3e 01 	> . 
	ld (05cbch),a		;87a6	32 bc 5c 	2 . \ 
l87a9h:
	call sub_0334h		;87a9	cd 34 03 	. 4 . 
	ld a,(05cbch)		;87ac	3a bc 5c 	: . \ 
	or a			;87af	b7 	. 
	ret z			;87b0	c8 	. 
	cp 0ffh		;87b1	fe ff 	. . 
	ret z			;87b3	c8 	. 
	cp 055h		;87b4	fe 55 	. U 
	jr nz,l87bbh		;87b6	20 03 	  . 
	ld a,0ffh		;87b8	3e ff 	> . 
	ret			;87ba	c9 	. 
l87bbh:
	ld a,(06029h)		;87bb	3a 29 60 	: ) ` 
	and a			;87be	a7 	. 
	jr nz,l87a9h		;87bf	20 e8 	  . 
	ld a,(05cbah)		;87c1	3a ba 5c 	: . \ 
	cp 007h		;87c4	fe 07 	. . 
	ld a,0ffh		;87c6	3e ff 	> . 
	ret nz			;87c8	c0 	. 
	xor a			;87c9	af 	. 
	ld (05fe0h),a		;87ca	32 e0 5f 	2 . _ 
	ld a,0feh		;87cd	3e fe 	> . 
	ret			;87cf	c9 	. 
sub_87d0h:
	ld hl,(05e9dh)		;87d0	2a 9d 5e 	* . ^ 
	ld (05cbfh),hl		;87d3	22 bf 5c 	" . \ 
	ld a,053h		;87d6	3e 53 	> S 
	ld (05cc1h),a		;87d8	32 c1 5c 	2 . \ 
	ld a,045h		;87db	3e 45 	> E 
	ld (05cc2h),a		;87dd	32 c2 5c 	2 . \ 
	call sub_8984h		;87e0	cd 84 89 	. . . 
	ld bc,00020h		;87e3	01 20 00 	.   . 
	call sub_8a1ah		;87e6	cd 1a 8a 	. . . 
	ld hl,05cbdh		;87e9	21 bd 5c 	! . \ 
	ld (05e9fh),hl		;87ec	22 9f 5e 	" . ^ 
	ld hl,0002ah		;87ef	21 2a 00 	! * . 
	ld (05ea1h),hl		;87f2	22 a1 5e 	" . ^ 
	ld a,001h		;87f5	3e 01 	> . 
	ld (05cbch),a		;87f7	32 bc 5c 	2 . \ 
	jr l87a9h		;87fa	18 ad 	. . 
sub_87fch:
	push af			;87fc	f5 	. 
	call OUT_CH		;87fd	cd 84 10 	. . . 
	M_LEFT 1
	pop af
	ld hl,0
	call sub_88dch		;8808	cd dc 88 	. . . 
	or a			;880b	b7 	. 
	ret nz			;880c	c0 	. 
	ld a,(05cc2h)		;880d	3a c2 5c 	: . \ 
	cp 052h		;8810	fe 52 	. R 
	jr z,l886dh		;8812	28 59 	( Y 
	call sub_8ca2h		;8814	cd a2 8c 	. . . 
	ex de,hl			;8817	eb 	. 
	ld hl,05cc6h		;8818	21 c6 5c 	! . \ 
	ld a,(05cc2h)		;881b	3a c2 5c 	: . \ 
	cp 048h		;881e	fe 48 	. H 
	jr nz,l8825h		;8820	20 03 	  . 
	ld bc,10		;8822	01 0a 00 	. . . 
l8825h:
	ldir		;8825	ed b0 	. . 
	ld a,(05cc2h)		;8827	3a c2 5c 	: . \ 
	cp 054h		;882a	fe 54 	. T 
	jr z,l883bh		;882c	28 0d 	( . 
	cp 04ch		;882e	fe 4c 	. L 
	jr z,l8844h		;8830	28 12 	( . 
	cp 058h		;8832	fe 58 	. X 
	ret nz			;8834	c0 	. 
	M_CALL_WITH_MMAP0 INIT
	ret			;883a	c9 	. 
l883bh:
	ld a,0ffh		;883b	3e ff 	> . 
	ld (055b6h),a		;883d	32 b6 55 	2 . U 
	call sub_b2a0h		;8840	cd a0 b2 	. . . 
	ret			;8843	c9 	. 
l8844h:
	ld a,(05cc6h)		;8844	3a c6 5c 	: . \ 
	out (PORT_05),a		;8847	d3 05 	. . 
	ret			;8849	c9 	. 
sub_884ah:
	push af			;884a	f5 	. 
	ld (05cc2h),a		;884b	32 c2 5c 	2 . \ 
	call OUT_CH		;884e	cd 84 10 	. . . 
	M_LEFT 1
	pop af
	ld hl,(05e9dh)
	ld (05cbfh),hl		;8859	22 bf 5c 	" . \ 
	ld hl,0		;885c	21 00 00 	! . . 
	ld (05cc3h),hl		;885f	22 c3 5c 	" . \ 
	call sub_8ca2h		;8862	cd a2 8c 	. . . 
	ld de,05cc6h		;8865	11 c6 5c 	. . \ 
	ldir		;8868	ed b0 	. . 
	jp l893fh		;886a	c3 3f 89 	. ? . 
l886dh:
	ld hl,05cc8h		;886d	21 c8 5c 	! . \ 
	ld bc,10		;8870	01 0a 00 	. . . 
	ld de,05b71h		;8873	11 71 5b 	. q [ 
	ldir		;8876	ed b0 	. . 
	ret			;8878	c9 	. 
sub_8879h:
	ld (05cbfh),de		;8879	ed 53 bf 5c 	. S . \ 
	ld (05cc3h),hl		;887d	22 c3 5c 	" . \ 
	ld a,046h		;8880	3e 46 	> F 
	ld (05cc1h),a		;8882	32 c1 5c 	2 . \ 
	ld a,050h		;8885	3e 50 	> P 
l8887h:
	ld (05cc2h),a		;8887	32 c2 5c 	2 . \ 
	call sub_8984h		;888a	cd 84 89 	. . . 
	ld hl,00009h		;888d	21 09 00 	! . . 
	ld (05ea1h),hl		;8890	22 a1 5e 	" . ^ 
	ld a,001h		;8893	3e 01 	> . 
	ld (05cbch),a		;8895	32 bc 5c 	2 . \ 
	jp l87a9h		;8898	c3 a9 87 	. . . 
sub_889bh:
	ld (05cc3h),hl		;889b	22 c3 5c 	" . \ 
	ld hl,(05e9dh)		;889e	2a 9d 5e 	* . ^ 
	ld (05cbfh),hl		;88a1	22 bf 5c 	" . \ 
	ld a,046h		;88a4	3e 46 	> F 
	ld (05cc1h),a		;88a6	32 c1 5c 	2 . \ 
	ld a,045h		;88a9	3e 45 	> E 
	jr l8887h		;88ab	18 da 	. . 
sub_88adh:
	push hl			;88ad	e5 	. 
	ld l,a			;88ae	6f 	o 
	dec bc			;88af	0b 	. 
	ld a,b			;88b0	78 	x 
	or c			;88b1	b1 	. 
	ld a,l			;88b2	7d 	} 
	pop hl			;88b3	e1 	. 
	ret			;88b4	c9 	. 
sub_88b5h:
	M_LEFT 3
	M_OUT_VAR 0x53c6, 0x04
	M_LEFT 1
	ret
sub_88c4h:
	M_OUT_MSG 0xd65e, 0x0f ; CRLF "ERROR" CRLF "COMPLETE"
	call sub_8fa5h		;88ca	cd a5 8f 	. . . 
	jp l1934h		;88cd	c3 34 19 	. 4 . 
l88d0h:
	M_OUT_MSG 0xd664, 0x09 ; CRLF "COMPLETE"
	call sub_8fa5h		;88d6	cd a5 8f 	. . . 
	jp l1934h		;88d9	c3 34 19 	. 4 . 
sub_88dch:
	ld (05cc2h),a		;88dc	32 c2 5c 	2 . \ 
	call sub_8b30h		;88df	cd 30 8b 	. 0 . 
l88e2h:
	ld a,046h		;88e2	3e 46 	> F 
	ld (05cc1h),a		;88e4	32 c1 5c 	2 . \ 
	ld (05cc3h),hl		;88e7	22 c3 5c 	" . \ 
	push hl			;88ea	e5 	. 
	call sub_890ah		;88eb	cd 0a 89 	. . . 
	pop hl			;88ee	e1 	. 
	or a			;88ef	b7 	. 
	jr z,l88fah		;88f0	28 08 	( . 
	call sub_8b41h		;88f2	cd 41 8b 	. A . 
	jr nz,l88e2h		;88f5	20 eb 	  . 
	ld a,0ffh		;88f7	3e ff 	> . 
	ret			;88f9	c9 	. 
l88fah:
	ld a,(05cc2h)		;88fa	3a c2 5c 	: . \ 
	call sub_8999h		;88fd	cd 99 89 	. . . 
	ld hl,05cc6h		;8900	21 c6 5c 	! . \ 
	ld de,v53c2		;8903	11 c2 53 	. . S 
	ldir		;8906	ed b0 	. . 
	xor a			;8908	af 	. 
	ret			;8909	c9 	. 
sub_890ah:
	ld hl,(05e9dh)		;890a	2a 9d 5e 	* . ^ 
	ld (05cbfh),hl		;890d	22 bf 5c 	" . \ 
	call sub_8984h		;8910	cd 84 89 	. . . 
sub_8913h:
	ld hl,00009h		;8913	21 09 00 	! . . 
	ld (05ea1h),hl		;8916	22 a1 5e 	" . ^ 
	ld a,001h		;8919	3e 01 	> . 
	ld (05cbch),a		;891b	32 bc 5c 	2 . \ 
	xor a			;891e	af 	. 
	ld (05eadh),a		;891f	32 ad 5e 	2 . ^ 
	call sub_8b36h		;8922	cd 36 8b 	. 6 . 
l8925h:
	ld a,(05cbch)		;8925	3a bc 5c 	: . \ 
	or a			;8928	b7 	. 
	ret z			;8929	c8 	. 
	cp 055h		;892a	fe 55 	. U 
	ret z			;892c	c8 	. 
	cp 04eh		;892d	fe 4e 	. N 
	ret z			;892f	c8 	. 
	cp 0ffh		;8930	fe ff 	. . 
	ret z			;8932	c8 	. 
	call sub_0334h		;8933	cd 34 03 	. 4 . 
	ld a,(06029h)		;8936	3a 29 60 	: ) ` 
	and a			;8939	a7 	. 
	jr nz,l8925h		;893a	20 e9 	  . 
	ld a,0ffh		;893c	3e ff 	> . 
	ret			;893e	c9 	. 
l893fh:
	call sub_8b30h		;893f	cd 30 8b 	. 0 . 
l8942h:
	ld a,053h		;8942	3e 53 	> S 
	ld (05cc1h),a		;8944	32 c1 5c 	2 . \ 
	call sub_8984h		;8947	cd 84 89 	. . . 
	ld a,(05cc2h)		;894a	3a c2 5c 	: . \ 
	call sub_8999h		;894d	cd 99 89 	. . . 
	push bc			;8950	c5 	. 
	call sub_8a1ah		;8951	cd 1a 8a 	. . . 
	pop bc			;8954	c1 	. 
	ld hl,05cbdh		;8955	21 bd 5c 	! . \ 
	ld (05e9fh),hl		;8958	22 9f 5e 	" . ^ 
	ld hl,10		;895b	21 0a 00 	! . . 
	add hl,bc			;895e	09 	. 
	ld (05ea1h),hl		;895f	22 a1 5e 	" . ^ 
	ld a,001h		;8962	3e 01 	> . 
	ld (05cbch),a		;8964	32 bc 5c 	2 . \ 
	call sub_8b36h		;8967	cd 36 8b 	. 6 . 
l896ah:
	ld a,(05cbch)		;896a	3a bc 5c 	: . \ 
	or a			;896d	b7 	. 
	ret z			;896e	c8 	. 
	cp 0ffh		;896f	fe ff 	. . 
	jr z,l897ch		;8971	28 09 	( . 
	call sub_0334h		;8973	cd 34 03 	. 4 . 
	ld a,(06029h)		;8976	3a 29 60 	: ) ` 
	and a			;8979	a7 	. 
	jr nz,l896ah		;897a	20 ee 	  . 
l897ch:
	call sub_8b41h		;897c	cd 41 8b 	. A . 
	jr nz,l8942h		;897f	20 c1 	  . 
	ld a,0ffh		;8981	3e ff 	> . 
	ret			;8983	c9 	. 
sub_8984h:
	ld hl,0aa55h		;8984	21 55 aa 	! U . 
	ld (05cbdh),hl		;8987	22 bd 5c 	" . \ 
sub_898ah:
	ld b,008h		;898a	06 08 	. . 
	xor a			;898c	af 	. 
	ld hl,05cbdh		;898d	21 bd 5c 	! . \ 
	ld (05e9fh),hl		;8990	22 9f 5e 	" . ^ 
l8993h:
	xor (hl)			;8993	ae 	. 
	inc hl			;8994	23 	# 
	djnz l8993h		;8995	10 fc 	. . 
	ld (hl),a			;8997	77 	w 
	ret			;8998	c9 	. 
sub_8999h:
	ld hl,l89b6h		;8999	21 b6 89 	! . . 
	ld de,5		;899c	11 05 00 	. . . 
	ld b,013h		;899f	06 13 	. . 
l89a1h:
	cp (hl)			;89a1	be 	. 
	jr z,l89adh		;89a2	28 09 	( . 
	add hl,de			;89a4	19 	. 
	djnz l89a1h		;89a5	10 fa 	. . 
	ld bc,00001h		;89a7	01 01 00 	. . . 
	ld h,0ffh		;89aa	26 ff 	& . 
	ret			;89ac	c9 	. 
l89adh:
	inc hl			;89ad	23 	# 
	ld c,(hl)			;89ae	4e 	N 
	inc hl			;89af	23 	# 
	ld b,(hl)			;89b0	46 	F 
	inc hl			;89b1	23 	# 
	ld e,(hl)			;89b2	5e 	^ 
	inc hl			;89b3	23 	# 
	ld d,(hl)			;89b4	56 	V 
	ret			;89b5	c9 	. 


; fred xxx looks like some sort of table of 5 bytes elements
l89b6h:
	db 'X', 0xc8, 0x00, 0xee, 0x54
	db 'P', 0x71, 0x01, 0x00, 0x00
	db 'S', 0x27, 0x00, 0xcb, 0x52
	db 'C', 0x06, 0x00, 0xc2, 0x53
	db 'M', 0xcc, 0x01, 0x00, 0x00
	db 'W', 0xa5, 0x00, 0xe1, 0x55
	ld d,d			;89d4	52 	R 
	inc c			;89d5	0c 	. 
	nop			;89d6	00 	. 
	ld l,a			;89d7	6f 	o 
	ld e,e			;89d8	5b 	[ 
	ld c,b			;89d9	48 	H 
	jr l89dch		;89da	18 00 	. . 
l89dch:
	ld a,e			;89dc	7b 	{ 
	ld e,e			;89dd	5b 	[ 
	ld d,h			;89de	54 	T 
	inc c			;89df	0c 	. 
	nop			;89e0	00 	. 
	sub e			;89e1	93 	. 
	ld e,e			;89e2	5b 	[ 
	ld b,l			;89e3	45 	E 
	jr nz,l89e6h		;89e4	20 00 	  . 
l89e6h:
	nop			;89e6	00 	. 
	nop			;89e7	00 	. 
	ld c,h			;89e8	4c 	L 
	dec b			;89e9	05 	. 
	nop			;89ea	00 	. 
	cp l			;89eb	bd 	. 
	ld d,e			;89ec	53 	S 
	ld d,(hl)			;89ed	56 	V 
	ld bc,00400h		;89ee	01 00 04 	. . . 
	nop			;89f1	00 	. 
	ld b,c			;89f2	41 	A 
	ld bc,0		;89f3	01 00 00 	. . . 
	nop			;89f6	00 	. 
	ld d,c			;89f7	51 	Q 
	jp pe,0cb00h		;89f8	ea 00 cb 	. . . 
	ld d,d			;89fb	52 	R 
	ld c,a			;89fc	4f 	O 
	pop af			;89fd	f1 	. 
	nop			;89fe	00 	. 
	or d			;89ff	b2 	. 
	ld e,(hl)			;8a00	5e 	^ 
	ld b,d			;8a01	42 	B 
	inc b			;8a02	04 	. 
	nop			;8a03	00 	. 
	xor (hl)			;8a04	ae 	. 
	ld e,a			;8a05	5f 	_ 
	ld c,c			;8a06	49 	I 
	inc l			;8a07	2c 	, 
	nop			;8a08	00 	. 
	nop			;8a09	00 	. 
	nop			;8a0a	00 	. 
	ld b,h			;8a0b	44 	D 
	dec b			;8a0c	05 	. 
	nop			;8a0d	00 	. 
	nop			;8a0e	00 	. 
	nop			;8a0f	00 	. 
	ld b,a			;8a10	47 	G 
	ld c,000h		;8a11	0e 00 	. . 
	ret nc			;8a13	d0 	. 
	ld h,b			;8a14	60 	` 
	rst 38h			;8a15	ff 	. 
	rst 38h			;8a16	ff 	. 
	rst 38h			;8a17	ff 	. 
	rst 38h			;8a18	ff 	. 
	rst 38h			;8a19	ff 	. 
sub_8a1ah:
	ld hl,05cc6h		;8a1a	21 c6 5c 	! . \ 
	xor a			;8a1d	af 	. 
l8a1eh:
	xor (hl)			;8a1e	ae 	. 
	inc hl			;8a1f	23 	# 
	dec bc			;8a20	0b 	. 
	ld d,a			;8a21	57 	W 
	ld a,b			;8a22	78 	x 
	or c			;8a23	b1 	. 
	ld a,d			;8a24	7a 	z 
	jr nz,l8a1eh		;8a25	20 f7 	  . 
	ld (hl),a			;8a27	77 	w 
	ret			;8a28	c9 	. 
sub_8a29h:
	call sub_8999h		;8a29	cd 99 89 	. . . 
	ld hl,05cc6h		;8a2c	21 c6 5c 	! . \ 
	xor a			;8a2f	af 	. 
l8a30h:
	xor (hl)			;8a30	ae 	. 
	inc hl			;8a31	23 	# 
	dec bc			;8a32	0b 	. 
	ld d,a			;8a33	57 	W 
	ld a,b			;8a34	78 	x 
	or c			;8a35	b1 	. 
	ld a,d			;8a36	7a 	z 
	jr nz,l8a30h		;8a37	20 f7 	  . 
	cp (hl)			;8a39	be 	. 
l8a3ah:
	ret nz			;8a3a	c0 	. 
	xor a			;8a3b	af 	. 
	ld (05eabh),a		;8a3c	32 ab 5e 	2 . ^ 
	ret			;8a3f	c9 	. 
sub_8a40h:
	ld a,(05cbah)		;8a40	3a ba 5c 	: . \ 
	and 001h		;8a43	e6 01 	. . 
	jr nz,l8a5dh		;8a45	20 16 	  . 
	ld hl,(05cbfh)		;8a47	2a bf 5c 	* . \ 
	ld a,l			;8a4a	7d 	} 
	cp 020h		;8a4b	fe 20 	.   
	jr nz,l8a53h		;8a4d	20 04 	  . 
	in a,(PORT_FF)		;8a4f	db ff 	. . 
	cp h			;8a51	bc 	. 
	ret z			;8a52	c8 	. 
l8a53h:
	ld a,(05b6fh)		;8a53	3a 6f 5b 	: o [ 
	cp l			;8a56	bd 	. 
	ret nz			;8a57	c0 	. 
	ld a,(05b70h)		;8a58	3a 70 5b 	: p [ 
	cp h			;8a5b	bc 	. 
	ret			;8a5c	c9 	. 
l8a5dh:
	xor a			;8a5d	af 	. 
	ret			;8a5e	c9 	. 
sub_8a5fh:
	ld hl,05cbdh		;8a5f	21 bd 5c 	! . \ 
sub_8a62h:
	ld b,008h		;8a62	06 08 	. . 
	xor a			;8a64	af 	. 
l8a65h:
	xor (hl)			;8a65	ae 	. 
	inc hl			;8a66	23 	# 
	djnz l8a65h		;8a67	10 fc 	. . 
	cp (hl)			;8a69	be 	. 
	ret nz			;8a6a	c0 	. 
	xor a			;8a6b	af 	. 
	ld (05eabh),a		;8a6c	32 ab 5e 	2 . ^ 
	ret			;8a6f	c9 	. 
sub_8a70h:
	push bc			;8a70	c5 	. 
	ld hl,05e94h		;8a71	21 94 5e 	! . ^ 
	ld de,05e93h		;8a74	11 93 5e 	. . ^ 
	ld bc,00008h		;8a77	01 08 00 	. . . 
	ldir		;8a7a	ed b0 	. . 
	dec hl			;8a7c	2b 	+ 
	pop bc			;8a7d	c1 	. 
	ld (hl),b			;8a7e	70 	p 
	ld hl,(05e93h)		;8a7f	2a 93 5e 	* . ^ 
	ld de,0aa55h		;8a82	11 55 aa 	. U . 
	call CMP_HLDE		;8a85	cd 20 0f 	.   . 
	jr nz,l8abch		;8a88	20 32 	  2 
	ld hl,05e93h		;8a8a	21 93 5e 	! . ^ 
	call sub_8a62h		;8a8d	cd 62 8a 	. b . 
	ret nz			;8a90	c0 	. 
	ld hl,05e93h		;8a91	21 93 5e 	! . ^ 
	ld de,05cbdh		;8a94	11 bd 5c 	. . \ 
	ld bc,00009h		;8a97	01 09 00 	. . . 
	ldir		;8a9a	ed b0 	. . 
	ld hl,(05e95h)		;8a9c	2a 95 5e 	* . ^ 
	ld de,lbbbbh		;8a9f	11 bb bb 	. . . 
	call CMP_HLDE		;8aa2	cd 20 0f 	.   . 
	call z,sub_8fa5h		;8aa5	cc a5 8f 	. . . 
	call sub_8a40h		;8aa8	cd 40 8a 	. @ . 
	ret z			;8aab	c8 	. 
	call sub_91e4h		;8aac	cd e4 91 	. . . 
	xor a			;8aaf	af 	. 
	ld (05cbah),a		;8ab0	32 ba 5c 	2 . \ 
	ld (05each),a		;8ab3	32 ac 5e 	2 . ^ 
	call sub_84f9h		;8ab6	cd f9 84 	. . . 
	cp 001h		;8ab9	fe 01 	. . 
	ret			;8abb	c9 	. 
l8abch:
	ld de,la5a5h		;8abc	11 a5 a5 	. . . 
	call CMP_HLDE		;8abf	cd 20 0f 	.   . 
	ret nz			;8ac2	c0 	. 
	ld hl,05e93h		;8ac3	21 93 5e 	! . ^ 
	ld de,05cbdh		;8ac6	11 bd 5c 	. . \ 
	ld bc,00009h		;8ac9	01 09 00 	. . . 
	ldir		;8acc	ed b0 	. . 
	call sub_8a5fh		;8ace	cd 5f 8a 	. _ . 
	ret nz			;8ad1	c0 	. 
	ld a,(05cbah)		;8ad2	3a ba 5c 	: . \ 
	cp 000h		;8ad5	fe 00 	. . 
	ret z			;8ad7	c8 	. 
	ld hl,05eb3h		;8ad8	21 b3 5e 	! . ^ 
	ld b,018h		;8adb	06 18 	. . 
l8addh:
	push hl			;8add	e5 	. 
	ld de,05cbfh		;8ade	11 bf 5c 	. . \ 
	call sub_8af4h		;8ae1	cd f4 8a 	. . . 
	pop hl			;8ae4	e1 	. 
	jr z,l8af0h		;8ae5	28 09 	( . 
	ld de,10		;8ae7	11 0a 00 	. . . 
	add hl,de			;8aea	19 	. 
	djnz l8addh		;8aeb	10 f0 	. . 
	call sub_8d63h		;8aed	cd 63 8d 	. c . 
l8af0h:
	xor a			;8af0	af 	. 
	cp 001h		;8af1	fe 01 	. . 
	ret			;8af3	c9 	. 
sub_8af4h:
	ld c,006h		;8af4	0e 06 	. . 
l8af6h:
	ld a,(de)			;8af6	1a 	. 
	cp (hl)			;8af7	be 	. 
	ret nz			;8af8	c0 	. 
	inc hl			;8af9	23 	# 
	inc de			;8afa	13 	. 
	dec c			;8afb	0d 	. 
	jr nz,l8af6h		;8afc	20 f8 	  . 
	ld de,05eaeh		;8afe	11 ae 5e 	. . ^ 
	ld bc,FLAG_DISP		;8b01	01 04 00 	. . . 
	ldir		;8b04	ed b0 	. . 
	ld a,(05cbah)		;8b06	3a ba 5c 	: . \ 
	cp 084h		;8b09	fe 84 	. . 
	jr z,l8b23h		;8b0b	28 16 	( . 
	ld hl,(05eaeh)		;8b0d	2a ae 5e 	* . ^ 
	ld de,0270fh		;8b10	11 0f 27 	. . ' 
	call CMP_HLDE		;8b13	cd 20 0f 	.   . 
	jr z,l8b23h		;8b16	28 0b 	( . 
	call sub_8d63h		;8b18	cd 63 8d 	. c . 
	xor a			;8b1b	af 	. 
	ld (05cbah),a		;8b1c	32 ba 5c 	2 . \ 
	ld (05each),a		;8b1f	32 ac 5e 	2 . ^ 
	ret			;8b22	c9 	. 
l8b23h:
	call sub_8d67h		;8b23	cd 67 8d 	. g . 
	ld a,0aah		;8b26	3e aa 	> . 
	ld (05each),a		;8b28	32 ac 5e 	2 . ^ 
	cp 0aah		;8b2b	fe aa 	. . 
	ret			;8b2d	c9 	. 
	xor a			;8b2e	af 	. 
	ret			;8b2f	c9 	. 
sub_8b30h:
	ld a,004h		;8b30	3e 04 	> . 
	ld (05ea9h),a		;8b32	32 a9 5e 	2 . ^ 
	ret			;8b35	c9 	. 
sub_8b36h:
	ld a,003h		;8b36	3e 03 	> . 
	ld (06029h),a		;8b38	32 29 60 	2 ) ` 
	ld a,03ch		;8b3b	3e 3c 	> < 
	ld (05ea7h),a		;8b3d	32 a7 5e 	2 . ^ 
	ret			;8b40	c9 	. 
sub_8b41h:
	ld a,(05ea9h)		;8b41	3a a9 5e 	: . ^ 
	dec a			;8b44	3d 	= 
	ld (05ea9h),a		;8b45	32 a9 5e 	2 . ^ 
	ret			;8b48	c9 	. 
	ld a,038h		;8b49	3e 38 	> 8 
	out (PORT_16),a		;8b4b	d3 16 	. . 
	ld hl,l8b5ah		;8b4d	21 5a 8b 	! Z . 
	push hl			;8b50	e5 	. 
	ld a,001h		;8b51	3e 01 	> . 
	ld (05eaah),a		;8b53	32 aa 5e 	2 . ^ 
	exx			;8b56	d9 	. 
	ei			;8b57	fb 	. 
	reti		;8b58	ed 4d 	. M 
l8b5ah:
	push bc			;8b5a	c5 	. 
	push de			;8b5b	d5 	. 
	push hl			;8b5c	e5 	. 
	push ix		;8b5d	dd e5 	. . 
	push iy		;8b5f	fd e5 	. . 
	call sub_8b78h		;8b61	cd 78 8b 	. x . 
	pop iy		;8b64	fd e1 	. . 
	pop ix		;8b66	dd e1 	. . 
	pop hl			;8b68	e1 	. 
	pop de			;8b69	d1 	. 
	pop bc			;8b6a	c1 	. 
	xor a			;8b6b	af 	. 
	ld (05eaah),a		;8b6c	32 aa 5e 	2 . ^ 
	pop af			;8b6f	f1 	. 
	ret			;8b70	c9 	. 

TASK_6:
	ld sp,051e5h		;8b71	31 e5 51 	1 . Q 
	ld hl,l8c21h		;8b74	21 21 8c 	! ! . 
	push hl			;8b77	e5 	. 
sub_8b78h:
	ld a,001h		;8b78	3e 01 	> . 
	ld (05eaah),a		;8b7a	32 aa 5e 	2 . ^ 
	ld a,(0558ch)		;8b7d	3a 8c 55 	: . U 
	cp 001h		;8b80	fe 01 	. . 
	ret z			;8b82	c8 	. 
l8b83h:
	ld de,FIFO5		;8b83	11 f0 40 	. . @ 
	call FIFO_READ		;8b86	cd e1 0e 	. . . 
	jr nc,l8b9ah		;8b89	30 0f 	0 . 
	ld a,(05cbbh)		;8b8b	3a bb 5c 	: . \ 
	cp 002h		;8b8e	fe 02 	. . 
	ret nz			;8b90	c0 	. 
	ld a,(06029h)		;8b91	3a 29 60 	: ) ` 
	or a			;8b94	b7 	. 
	ret nz			;8b95	c0 	. 
	ld (05cbbh),a		;8b96	32 bb 5c 	2 . \ 
	ret			;8b99	c9 	. 
l8b9ah:
	ld b,004h		;8b9a	06 04 	. . 
	call LOG_CHAR		;8b9c	cd e6 1a 	. . . 
	ld b,a			;8b9f	47 	G 
	call sub_8b36h		;8ba0	cd 36 8b 	. 6 . 
	cp 0aah		;8ba3	fe aa 	. . 
	jr nz,l8bach		;8ba5	20 05 	  . 
	ld a,(05eadh)		;8ba7	3a ad 5e 	: . ^ 
	and a			;8baa	a7 	. 
	ret nz			;8bab	c0 	. 
l8bach:
	xor a			;8bac	af 	. 
	ld (05eadh),a		;8bad	32 ad 5e 	2 . ^ 
	ld a,(05ea1h)		;8bb0	3a a1 5e 	: . ^ 
	or a			;8bb3	b7 	. 
	jr z,l8bbch		;8bb4	28 06 	( . 
	ld a,(05cbah)		;8bb6	3a ba 5c 	: . \ 
	cp 005h		;8bb9	fe 05 	. . 
	ret z			;8bbb	c8 	. 
l8bbch:
	ld a,(05eb2h)		;8bbc	3a b2 5e 	: . ^ 
	or a			;8bbf	b7 	. 
	jr z,l8bc8h		;8bc0	28 06 	( . 
	ld a,(05each)		;8bc2	3a ac 5e 	: . ^ 
	or a			;8bc5	b7 	. 
	jr z,l8bd0h		;8bc6	28 08 	( . 
l8bc8h:
	ld a,(05cbah)		;8bc8	3a ba 5c 	: . \ 
	cp 002h		;8bcb	fe 02 	. . 
	jp z,l8f90h		;8bcd	ca 90 8f 	. . . 
l8bd0h:
	ld a,(05cbbh)		;8bd0	3a bb 5c 	: . \ 
	cp 003h		;8bd3	fe 03 	. . 
	jp z,l8fe6h		;8bd5	ca e6 8f 	. . . 
	cp 002h		;8bd8	fe 02 	. . 
	jp z,l8d9dh		;8bda	ca 9d 8d 	. . . 
	call sub_8a70h		;8bdd	cd 70 8a 	. p . 
	jr nz,l8b83h		;8be0	20 a1 	  . 
	ld a,(05cc1h)		;8be2	3a c1 5c 	: . \ 
	cp 04bh		;8be5	fe 4b 	. K 
	jr z,l8c2bh		;8be7	28 42 	( B 
	cp 045h		;8be9	fe 45 	. E 
	jr z,l8c32h		;8beb	28 45 	( E 
	cp 042h		;8bed	fe 42 	. B 
	jr z,l8c39h		;8bef	28 48 	( H 
	cp 043h		;8bf1	fe 43 	. C 
	jr z,l8c49h		;8bf3	28 54 	( T 
	cp 05ah		;8bf5	fe 5a 	. Z 
	jp z,sub_84e4h		;8bf7	ca e4 84 	. . . 
	ld a,(05cbah)		;8bfa	3a ba 5c 	: . \ 
	bit 0,a		;8bfd	cb 47 	. G 
	jr nz,l8c0eh		;8bff	20 0d 	  . 
	ld a,(05eb2h)		;8c01	3a b2 5e 	: . ^ 
	or a			;8c04	b7 	. 
	jr z,l8c0eh		;8c05	28 07 	( . 
	ld a,(05each)		;8c07	3a ac 5e 	: . ^ 
	or a			;8c0a	b7 	. 
	jp z,l8b83h		;8c0b	ca 83 8b 	. . . 
l8c0eh:
	ld a,(05cc1h)		;8c0e	3a c1 5c 	: . \ 
	cp 046h		;8c11	fe 46 	. F 
	jr z,l8c63h		;8c13	28 4e 	( N 
	cp 053h		;8c15	fe 53 	. S 
	jp z,l8d84h		;8c17	ca 84 8d 	. . . 
	xor a			;8c1a	af 	. 
	ld (05cbbh),a		;8c1b	32 bb 5c 	2 . \ 
	jp l8b83h		;8c1e	c3 83 8b 	. . . 
l8c21h:
	xor a			;8c21	af 	. 
	ld (05eaah),a		;8c22	32 aa 5e 	2 . ^ 
	call sub_0334h		;8c25	cd 34 03 	. 4 . 
	jp TASK_6		;8c28	c3 71 8b 	. q . 

l8c2bh:
	ld a,082h		;8c2b	3e 82 	> . 
	ld (05cbah),a		;8c2d	32 ba 5c 	2 . \ 
	jr l8c3eh		;8c30	18 0c 	. . 
l8c32h:
	ld a,086h		;8c32	3e 86 	> . 
	ld (05cbah),a		;8c34	32 ba 5c 	2 . \ 
	jr l8c3eh		;8c37	18 05 	. . 
l8c39h:
	ld a,084h		;8c39	3e 84 	> . 
	ld (05cbah),a		;8c3b	32 ba 5c 	2 . \ 
l8c3eh:
	ld a,(05eb2h)		;8c3e	3a b2 5e 	: . ^ 
	cp 059h		;8c41	fe 59 	. Y 
	jp nz,sub_8d67h		;8c43	c2 67 8d 	. g . 
	jp l8d5fh		;8c46	c3 5f 8d 	. _ . 
l8c49h:
	ld a,(05cc2h)		;8c49	3a c2 5c 	: . \ 
	cp 047h		;8c4c	fe 47 	. G 
	jr nz,l8c55h		;8c4e	20 05 	  . 
	xor a			;8c50	af 	. 
	ld (05cbch),a		;8c51	32 bc 5c 	2 . \ 
	ret			;8c54	c9 	. 
l8c55h:
	cp 042h		;8c55	fe 42 	. B 
	jr z,l8c5dh		;8c57	28 04 	( . 
	ld a,055h		;8c59	3e 55 	> U 
	jr nz,l8c5fh		;8c5b	20 02 	  . 
l8c5dh:
	ld a,0ffh		;8c5d	3e ff 	> . 
l8c5fh:
	ld (05cbch),a		;8c5f	32 bc 5c 	2 . \ 
	ret			;8c62	c9 	. 
l8c63h:
	ld a,(05cc2h)		;8c63	3a c2 5c 	: . \ 
	cp 050h		;8c66	fe 50 	. P 
	jr z,l8cbbh		;8c68	28 51 	( Q 
	cp 041h		;8c6a	fe 41 	. A 
	jr z,l8cbbh		;8c6c	28 4d 	( M 
	cp 049h		;8c6e	fe 49 	. I 
	jp z,l8cfdh		;8c70	ca fd 8c 	. . . 
	call sub_9007h		;8c73	cd 07 90 	. . . 
	jp nz,l901eh		;8c76	c2 1e 90 	. . . 
	cp 045h		;8c79	fe 45 	. E 
	jp z,l8d33h		;8c7b	ca 33 8d 	. 3 . 
	call sub_8ca2h		;8c7e	cd a2 8c 	. . . 
	cp 0ffh		;8c81	fe ff 	. . 
	jp z,l901eh		;8c83	ca 1e 90 	. . . 
	push bc			;8c86	c5 	. 
	ld de,05cc6h		;8c87	11 c6 5c 	. . \ 
	ldir		;8c8a	ed b0 	. . 
	pop bc			;8c8c	c1 	. 
l8c8dh:
	push bc			;8c8d	c5 	. 
	call sub_8a1ah		;8c8e	cd 1a 8a 	. . . 
	ld a,053h		;8c91	3e 53 	> S 
	ld (05cc1h),a		;8c93	32 c1 5c 	2 . \ 
	call sub_8984h		;8c96	cd 84 89 	. . . 
	pop hl			;8c99	e1 	. 
	ld bc,10		;8c9a	01 0a 00 	. . . 
	add hl,bc			;8c9d	09 	. 
	ld (05ea1h),hl		;8c9e	22 a1 5e 	" . ^ 
	ret			;8ca1	c9 	. 
sub_8ca2h:
	call sub_8999h		;8ca2	cd 99 89 	. . . 
	ex de,hl			;8ca5	eb 	. 
	ld a,h			;8ca6	7c 	| 
	cp 0ffh		;8ca7	fe ff 	. . 
	ret z			;8ca9	c8 	. 
	ld de,(05cc3h)		;8caa	ed 5b c3 5c 	. [ . \ 
	ld a,d			;8cae	7a 	z 
	or e			;8caf	b3 	. 
	ret z			;8cb0	c8 	. 
l8cb1h:
	dec de			;8cb1	1b 	. 
	ld a,d			;8cb2	7a 	z 
	or e			;8cb3	b3 	. 
	ret z			;8cb4	c8 	. 
	add hl,bc			;8cb5	09 	. 
	jr l8cb1h		;8cb6	18 f9 	. . 
	add hl,bc			;8cb8	09 	. 
	jr l8cb1h		;8cb9	18 f6 	. . 
l8cbbh:
	ld hl,(05cc3h)		;8cbb	2a c3 5c 	* . \ 
	call sub_902dh		;8cbe	cd 2d 90 	. - . 
	jp nz,l901eh		;8cc1	c2 1e 90 	. . . 
	call sub_07f9h		;8cc4	cd f9 07 	. . . 
	cp 0ffh		;8cc7	fe ff 	. . 
	jp z,l8d4bh		;8cc9	ca 4b 8d 	. K . 
	call SETMEMMAP		;8ccc	cd 1a 0f 	. . . 
	ld bc,l0170h		;8ccf	01 70 01 	. p . 
	ld de,05cc6h		;8cd2	11 c6 5c 	. . \ 
	ldir		;8cd5	ed b0 	. . 
	ld hl,(05cc3h)		;8cd7	2a c3 5c 	* . \ 
	inc hl			;8cda	23 	# 
	call sub_07f9h		;8cdb	cd f9 07 	. . . 
	cp 0ffh		;8cde	fe ff 	. . 
	jr z,l8cfah		;8ce0	28 18 	( . 
	call SETMEMMAP		;8ce2	cd 1a 0f 	. . . 
	ld a,(hl)			;8ce5	7e 	~ 
l8ce6h:
	ld (05e36h),a		;8ce6	32 36 5e 	2 6 ^ 
	ld hl,00171h		;8ce9	21 71 01 	! q . 
	ld a,(05cc2h)		;8cec	3a c2 5c 	: . \ 
	cp 041h		;8cef	fe 41 	. A 
	jr nz,l8cf6h		;8cf1	20 03 	  . 
	ld hl,00001h		;8cf3	21 01 00 	! . . 
l8cf6h:
	push hl			;8cf6	e5 	. 
	pop bc			;8cf7	c1 	. 
	jr l8c8dh		;8cf8	18 93 	. . 
l8cfah:
	xor a			;8cfa	af 	. 
	jr l8ce6h		;8cfb	18 e9 	. . 
l8cfdh:
	ld hl,(v4f89)		;8cfd	2a 89 4f 	* . O 
	push hl			;8d00	e5 	. 
	ld hl,(05cc3h)		;8d01	2a c3 5c 	* . \ 
	ld (v4f89),hl		;8d04	22 89 4f 	" . O 
	call l1fe5h		;8d07	cd e5 1f 	. . . 
	ld de,05cc6h		;8d0a	11 c6 5c 	. . \ 
	ld hl,v53c2		;8d0d	21 c2 53 	! . S 
	ld bc,0002ch		;8d10	01 2c 00 	. , . 
	push bc			;8d13	c5 	. 
	ldir		;8d14	ed b0 	. . 
	pop bc			;8d16	c1 	. 
	call l8c8dh		;8d17	cd 8d 8c 	. . . 
	pop hl			;8d1a	e1 	. 
	ld (v4f89),hl		;8d1b	22 89 4f 	" . O 
	ret			;8d1e	c9 	. 
sub_8d1fh:
	ld a,003h		;8d1f	3e 03 	> . 
	call SETMEMMAP		;8d21	cd 1a 0f 	. . . 
	ld de,(05b79h)		;8d24	ed 5b 79 5b 	. [ y [ 
	call CMP_HLDE		;8d28	cd 20 0f 	.   . 
	ld a,0ffh		;8d2b	3e ff 	> . 
	ret nc			;8d2d	d0 	. 
	call sub_bf2fh		;8d2e	cd 2f bf 	. / . 
	xor a			;8d31	af 	. 
	ret			;8d32	c9 	. 
l8d33h:
	ld hl,(05cc3h)		;8d33	2a c3 5c 	* . \ 
	call sub_8d1fh		;8d36	cd 1f 8d 	. . . 
	cp 0ffh		;8d39	fe ff 	. . 
	jr z,l8d4bh		;8d3b	28 0e 	( . 
	ld bc,00020h		;8d3d	01 20 00 	.   . 
	ld de,05cc6h		;8d40	11 c6 5c 	. . \ 
	ldir		;8d43	ed b0 	. . 
	ld bc,00020h		;8d45	01 20 00 	.   . 
	jp l8c8dh		;8d48	c3 8d 8c 	. . . 
l8d4bh:
	ld a,049h		;8d4b	3e 49 	> I 
l8d4dh:
	ld (05cc2h),a		;8d4d	32 c2 5c 	2 . \ 
	ld a,043h		;8d50	3e 43 	> C 
	ld (05cc1h),a		;8d52	32 c1 5c 	2 . \ 
	call sub_8984h		;8d55	cd 84 89 	. . . 
	ld hl,00009h		;8d58	21 09 00 	! . . 
	ld (05ea1h),hl		;8d5b	22 a1 5e 	" . ^ 
	ret			;8d5e	c9 	. 
l8d5fh:
	ld a,055h		;8d5f	3e 55 	> U 
	jr l8d71h		;8d61	18 0e 	. . 
sub_8d63h:
	ld a,04eh		;8d63	3e 4e 	> N 
	jr l8d71h		;8d65	18 0a 	. . 
sub_8d67h:
	ld a,(05cbah)		;8d67	3a ba 5c 	: . \ 
	res 7,a		;8d6a	cb bf 	. . 
	ld (05cbah),a		;8d6c	32 ba 5c 	2 . \ 
	ld a,0aah		;8d6f	3e aa 	> . 
l8d71h:
	ld b,005h		;8d71	06 05 	. . 
	ld hl,05cbdh		;8d73	21 bd 5c 	! . \ 
	ld (05e9fh),hl		;8d76	22 9f 5e 	" . ^ 
l8d79h:
	ld (hl),a			;8d79	77 	w 
	inc hl			;8d7a	23 	# 
	djnz l8d79h		;8d7b	10 fc 	. . 
	ld hl,5		;8d7d	21 05 00 	! . . 
	ld (05ea1h),hl		;8d80	22 a1 5e 	" . ^ 
	ret			;8d83	c9 	. 
l8d84h:
	ld a,(05cc2h)		;8d84	3a c2 5c 	: . \ 
	call sub_8999h		;8d87	cd 99 89 	. . . 
	ld hl,05cc6h		;8d8a	21 c6 5c 	! . \ 
	ld (05ea3h),hl		;8d8d	22 a3 5e 	" . ^ 
	inc bc			;8d90	03 	. 
	ld (05ea5h),bc		;8d91	ed 43 a5 5e 	. C . ^ 
	ld a,002h		;8d95	3e 02 	> . 
	ld (05cbbh),a		;8d97	32 bb 5c 	2 . \ 
	jp l8b83h		;8d9a	c3 83 8b 	. . . 
l8d9dh:
	ld hl,(05ea3h)		;8d9d	2a a3 5e 	* . ^ 
	ld (hl),b			;8da0	70 	p 
	inc hl			;8da1	23 	# 
	ld (05ea3h),hl		;8da2	22 a3 5e 	" . ^ 
	ld hl,(05ea5h)		;8da5	2a a5 5e 	* . ^ 
	dec hl			;8da8	2b 	+ 
	ld (05ea5h),hl		;8da9	22 a5 5e 	" . ^ 
	ld a,l			;8dac	7d 	} 
	or h			;8dad	b4 	. 
	jp nz,l8b83h		;8dae	c2 83 8b 	. . . 
	xor a			;8db1	af 	. 
	ld (05cbbh),a		;8db2	32 bb 5c 	2 . \ 
	ld a,(05cc2h)		;8db5	3a c2 5c 	: . \ 
	call sub_8a29h		;8db8	cd 29 8a 	. ) . 
	jr z,l8dc1h		;8dbb	28 04 	( . 
	ld a,042h		;8dbd	3e 42 	> B 
	jr l8d4dh		;8dbf	18 8c 	. . 
l8dc1h:
	ld a,(05cbah)		;8dc1	3a ba 5c 	: . \ 
	cp 004h		;8dc4	fe 04 	. . 
	jr z,l8dd1h		;8dc6	28 09 	( . 
	cp 006h		;8dc8	fe 06 	. . 
	jr z,l8dd1h		;8dca	28 05 	( . 
	xor a			;8dcc	af 	. 
	ld (05cbch),a		;8dcd	32 bc 5c 	2 . \ 
	ret			;8dd0	c9 	. 
l8dd1h:
	ld a,(05cc2h)		;8dd1	3a c2 5c 	: . \ 
	cp 050h		;8dd4	fe 50 	. P 
	jp z,l8f4ah		;8dd6	ca 4a 8f 	. J . 
	call sub_9007h		;8dd9	cd 07 90 	. . . 
	jp nz,l901eh		;8ddc	c2 1e 90 	. . . 
	cp 045h		;8ddf	fe 45 	. E 
	jp z,l8ec7h		;8de1	ca c7 8e 	. . . 
	cp 049h		;8de4	fe 49 	. I 
	jp z,l8f2ch		;8de6	ca 2c 8f 	. , . 
	cp 052h		;8de9	fe 52 	. R 
	jr nz,l8e26h		;8deb	20 39 	  9 
	ld a,(05cbah)		;8ded	3a ba 5c 	: . \ 
	cp 004h		;8df0	fe 04 	. . 
	ld a,052h		;8df2	3e 52 	> R 
	jr nz,l8dfch		;8df4	20 06 	  . 
	ld hl,(05b6fh)		;8df6	2a 6f 5b 	* o [ 
	ld (05cc6h),hl		;8df9	22 c6 5c 	" . \ 
l8dfch:
	ld hl,FLAGS		;8dfc	21 79 4f 	! y O 
	bit 4,(hl)		;8dff	cb 66 	. f 
	jr z,l8e26h		;8e01	28 23 	( # 
	ld hl,05cc8h		;8e03	21 c8 5c 	! . \ 
	ld de,05b71h		;8e06	11 71 5b 	. q [ 
	ld b,006h		;8e09	06 06 	. . 
l8e0bh:
	ld a,(de)			;8e0b	1a 	. 
	cp (hl)			;8e0c	be 	. 
	jr nz,l8e17h		;8e0d	20 08 	  . 
	inc hl			;8e0f	23 	# 
	inc de			;8e10	13 	. 
	djnz l8e0bh		;8e11	10 f8 	. . 
	ld a,052h		;8e13	3e 52 	> R 
	jr l8e26h		;8e15	18 0f 	. . 
l8e17h:
	ld a,0f9h		;8e17	3e f9 	> . 
	ld hl,FIFO_KBD		;8e19	21 e4 40 	! . @ 
	call DATA2FIFO		;8e1c	cd 09 0f 	. . . 
	ld a,0f8h		;8e1f	3e f8 	> . 
	call DATA2FIFO		;8e21	cd 09 0f 	. . . 
	ld a,052h		;8e24	3e 52 	> R 
l8e26h:
	call sub_8ca2h		;8e26	cd a2 8c 	. . . 
	ex de,hl			;8e29	eb 	. 
	ld hl,05cc6h		;8e2a	21 c6 5c 	! . \ 
	ldir		;8e2d	ed b0 	. . 
	ld a,(05cc2h)		;8e2f	3a c2 5c 	: . \ 
	cp 058h		;8e32	fe 58 	. X 
	jr z,l8e5ch		;8e34	28 26 	( & 
	cp 056h		;8e36	fe 56 	. V 
	jr z,l8e61h		;8e38	28 27 	( ' 
	cp 043h		;8e3a	fe 43 	. C 
	jr z,l8e64h		;8e3c	28 26 	( & 
	cp 04dh		;8e3e	fe 4d 	. M 
	jr z,l8e7bh		;8e40	28 39 	( 9 
	cp 054h		;8e42	fe 54 	. T 
	jr z,l8eb4h		;8e44	28 6e 	( n 
	cp 04ch		;8e46	fe 4c 	. L 
	jr z,l8ebfh		;8e48	28 75 	( u 
	cp 052h		;8e4a	fe 52 	. R 
	jp z,l8f1fh		;8e4c	ca 1f 8f 	. . . 
	cp 048h		;8e4f	fe 48 	. H 
	jp z,l8f1ah		;8e51	ca 1a 8f 	. . . 
	cp 044h		;8e54	fe 44 	. D 
	jp z,l8f24h		;8e56	ca 24 8f 	. $ . 
	jp l8f7fh		;8e59	c3 7f 8f 	.  . 
l8e5ch:
	M_CALL_WITH_MMAP0 INIT
l8e61h:
	jp l8f7fh		;8e61	c3 7f 8f 	.  . 
l8e64h:
	ld hl,(05cc6h)		;8e64	2a c6 5c 	* . \ 
	ld de,(05cc8h)		;8e67	ed 5b c8 5c 	. [ . \ 
	ld bc,(05ccah)		;8e6b	ed 4b ca 5c 	. K . \ 
	call sub_b139h		;8e6f	cd 39 b1 	. 9 . 
	call sub_22f0h		;8e72	cd f0 22 	. . " 
	call sub_2318h		;8e75	cd 18 23 	. . # 
	jp l8f7fh		;8e78	c3 7f 8f 	.  . 
l8e7bh:
	ld hl,(05e8eh)		;8e7b	2a 8e 5e 	* . ^ 
	ld de,(05e90h)		;8e7e	ed 5b 90 5e 	. [ . ^ 
l8e82h:
	ex de,hl			;8e82	eb 	. 
	call CMP_HLDE		;8e83	cd 20 0f 	.   . 
	ex de,hl			;8e86	eb 	. 
	jp c,l8f7fh		;8e87	da 7f 8f 	.  . 
	call sub_0334h		;8e8a	cd 34 03 	. 4 . 
	push hl			;8e8d	e5 	. 
	push de			;8e8e	d5 	. 
	call sub_07f9h		;8e8f	cd f9 07 	. . . 
	cp 0ffh		;8e92	fe ff 	. . 
	jr z,l8eafh		;8e94	28 19 	( . 
	call SETMEMMAP		;8e96	cd 1a 0f 	. . . 
	ex de,hl			;8e99	eb 	. 
	ld hl,05cc6h		;8e9a	21 c6 5c 	! . \ 
	ld bc,00030h		;8e9d	01 30 00 	. 0 . 
	ldir		;8ea0	ed b0 	. . 
	ld bc,l0140h		;8ea2	01 40 01 	. @ . 
	ld hl,05d4eh		;8ea5	21 4e 5d 	! N ] 
	ldir		;8ea8	ed b0 	. . 
	pop de			;8eaa	d1 	. 
	pop hl			;8eab	e1 	. 
	inc hl			;8eac	23 	# 
	jr l8e82h		;8ead	18 d3 	. . 
l8eafh:
	pop hl			;8eaf	e1 	. 
	pop hl			;8eb0	e1 	. 
	jp l8f7fh		;8eb1	c3 7f 8f 	.  . 
l8eb4h:
	ld a,0ffh		;8eb4	3e ff 	> . 
	ld (055b6h),a		;8eb6	32 b6 55 	2 . U 
	call sub_b2a0h		;8eb9	cd a0 b2 	. . . 
	jp l8f7fh		;8ebc	c3 7f 8f 	.  . 
l8ebfh:
	ld a,(05cc6h)		;8ebf	3a c6 5c 	: . \ 
	out (PORT_05),a		;8ec2	d3 05 	. . 
	jp l8f7fh		;8ec4	c3 7f 8f 	.  . 
l8ec7h:
	ld hl,(05cc3h)		;8ec7	2a c3 5c 	* . \ 
	call sub_8d1fh		;8eca	cd 1f 8d 	. . . 
	cp 0ffh		;8ecd	fe ff 	. . 
	jp z,l8d4bh		;8ecf	ca 4b 8d 	. K . 
	ex de,hl			;8ed2	eb 	. 
	ld hl,05cc6h		;8ed3	21 c6 5c 	! . \ 
	ld bc,00020h		;8ed6	01 20 00 	.   . 
	ldir		;8ed9	ed b0 	. . 
	jp l8f7fh		;8edb	c3 7f 8f 	.  . 
sub_8edeh:
	ld a,(CFG3)		;8ede	3a 0a 00 	: . . 
	ld (05b88h),a		;8ee1	32 88 5b 	2 . [ 
	cp 0aah		;8ee4	fe aa 	. . 
	jr z,l8eeeh		;8ee6	28 06 	( . 
	xor a			;8ee8	af 	. 
	ld (05b7bh),a		;8ee9	32 7b 5b 	2 { [ 
	jr l8efeh		;8eec	18 10 	. . 
l8eeeh:
	nop			;8eee	00 	. 
	nop			;8eef	00 	. 
	nop			;8ef0	00 	. 
	ld a,(05b7bh)		;8ef1	3a 7b 5b 	: { [ 
	bit 3,a		;8ef4	cb 5f 	. _ 
	call nz,sub_9bfch		;8ef6	c4 fc 9b 	. . . 
	bit 5,a		;8ef9	cb 6f 	. o 
	call nz,sub_9c4ah		;8efb	c4 4a 9c 	. J . 
l8efeh:
	ld de,(05b79h)		;8efe	ed 5b 79 5b 	. [ y [ 
	call sub_0968h		;8f02	cd 68 09 	. h . 
	ld a,(05b84h)		;8f05	3a 84 5b 	: . [ 
	M_CALL_WITH_MMAP0 sub_c36ah
	ld (05b77h),hl
	ld (05b85h),hl		;8f10	22 85 5b 	" . [ 
	ld (05b79h),de		;8f13	ed 53 79 5b 	. S y [ 
	jp sub_0849h		;8f17	c3 49 08 	. I . 
l8f1ah:
	call sub_8edeh		;8f1a	cd de 8e 	. . . 
	jr l8f7fh		;8f1d	18 60 	. ` 
l8f1fh:
	call l8efeh		;8f1f	cd fe 8e 	. . . 
	jr l8f7fh		;8f22	18 5b 	. [ 
l8f24h:
	ld a,(05cc6h)		;8f24	3a c6 5c 	: . \ 
	call sub_16eeh		;8f27	cd ee 16 	. . . 
	jr l8f7fh		;8f2a	18 53 	. S 
l8f2ch:
	ld hl,(v4f89)		;8f2c	2a 89 4f 	* . O 
	push hl			;8f2f	e5 	. 
	ld hl,(05cc3h)		;8f30	2a c3 5c 	* . \ 
	ld (v4f89),hl		;8f33	22 89 4f 	" . O 
	ld hl,05cc6h		;8f36	21 c6 5c 	! . \ 
	ld de,v53c2		;8f39	11 c2 53 	. . S 
	ld bc,0002ch		;8f3c	01 2c 00 	. , . 
	ldir		;8f3f	ed b0 	. . 
	call l1f44h		;8f41	cd 44 1f 	. D . 
	pop hl			;8f44	e1 	. 
	ld (v4f89),hl		;8f45	22 89 4f 	" . O 
	jr l8f7fh		;8f48	18 35 	. 5 
l8f4ah:
	ld hl,(05cc3h)		;8f4a	2a c3 5c 	* . \ 
	call sub_902dh		;8f4d	cd 2d 90 	. - . 
	jp nz,l901eh		;8f50	c2 1e 90 	. . . 
	call sub_07f9h		;8f53	cd f9 07 	. . . 
	cp 0ffh		;8f56	fe ff 	. . 
	jp z,l8d4bh		;8f58	ca 4b 8d 	. K . 
	call SETMEMMAP		;8f5b	cd 1a 0f 	. . . 
	ex de,hl			;8f5e	eb 	. 
	ld hl,05cc6h		;8f5f	21 c6 5c 	! . \ 
	ld bc,l0170h		;8f62	01 70 01 	. p . 
	ld a,(hl)			;8f65	7e 	~ 
	cp 0ffh		;8f66	fe ff 	. . 
	call z,sub_8f87h		;8f68	cc 87 8f 	. . . 
	ldir		;8f6b	ed b0 	. . 
	ld hl,(05cc3h)		;8f6d	2a c3 5c 	* . \ 
	inc hl			;8f70	23 	# 
	call sub_07f9h		;8f71	cd f9 07 	. . . 
	cp 0ffh		;8f74	fe ff 	. . 
	jr z,l8f84h		;8f76	28 0c 	( . 
	call SETMEMMAP		;8f78	cd 1a 0f 	. . . 
	ld a,(hl)			;8f7b	7e 	~ 
l8f7ch:
	ld (05cc3h),a		;8f7c	32 c3 5c 	2 . \ 
l8f7fh:
	ld a,047h		;8f7f	3e 47 	> G 
	jp l8d4dh		;8f81	c3 4d 8d 	. M . 
l8f84h:
	xor a			;8f84	af 	. 
	jr l8f7ch		;8f85	18 f5 	. . 
sub_8f87h:
	ld a,010h		;8f87	3e 10 	> . 
l8f89h:
	inc hl			;8f89	23 	# 
	inc de			;8f8a	13 	. 
	dec bc			;8f8b	0b 	. 
	dec a			;8f8c	3d 	= 
	jr nz,l8f89h		;8f8d	20 fa 	  . 
	ret			;8f8f	c9 	. 
l8f90h:
	ld a,b			;8f90	78 	x 
	cp 0d0h		;8f91	fe d0 	. . 
	jp z,0		;8f93	ca 00 00 	. . . 
	cp 099h		;8f96	fe 99 	. . 
	jr z,sub_8fa5h		;8f98	28 0b 	( . 
	ld hl,FIFO_KBD		;8f9a	21 e4 40 	! . @ 
	jp DATA2FIFO		;8f9d	c3 09 0f 	. . . 

FUN_99:
	ld a,003h		;8fa0	3e 03 	> . 
	ld (05cbah),a		;8fa2	32 ba 5c 	2 . \ 
sub_8fa5h:
	push af			;8fa5	f5 	. 
	push bc			;8fa6	c5 	. 
	ld a,(05cbah)		;8fa7	3a ba 5c 	: . \ 
	ld b,a			;8faa	47 	G 
	xor a			;8fab	af 	. 
	ld (05cbah),a		;8fac	32 ba 5c 	2 . \ 
	ld (05cbbh),a		;8faf	32 bb 5c 	2 . \ 
	ld (05each),a		;8fb2	32 ac 5e 	2 . ^ 
	ld (05eadh),a		;8fb5	32 ad 5e 	2 . ^ 
	call sub_84f9h		;8fb8	cd f9 84 	. . . 
	ld a,b			;8fbb	78 	x 
	bit 0,a		;8fbc	cb 47 	. G 
	jr z,l8fe0h		;8fbe	28 20 	(   
	ld (06039h),a		;8fc0	32 39 60 	2 9 ` 
	ld bc,lbbbbh		;8fc3	01 bb bb 	. . . 
	ld (05cbfh),bc		;8fc6	ed 43 bf 5c 	. C . \ 
	call sub_8984h		;8fca	cd 84 89 	. . . 
	ld bc,00009h		;8fcd	01 09 00 	. . . 
	ld (05ea1h),bc		;8fd0	ed 43 a1 5e 	. C . ^ 
	ld a,099h		;8fd4	3e 99 	> . 
	out (PORT_14),a		;8fd6	d3 14 	. . 
	M_OUT_MSG 0xd730, 0x0a ; CRLF "OFF LINE "
	jr l8fe3h		;8fde	18 03 	. . 
l8fe0h:
	call sub_91e4h		;8fe0	cd e4 91 	. . . 
l8fe3h:
	pop bc			;8fe3	c1 	. 
	pop af			;8fe4	f1 	. 
	ret			;8fe5	c9 	. 
l8fe6h:
	ld a,b			;8fe6	78 	x 
	cp 0aah		;8fe7	fe aa 	. . 
	jr nz,l8ff8h		;8fe9	20 0d 	  . 
	ld a,001h		;8feb	3e 01 	> . 
	ld (05eadh),a		;8fed	32 ad 5e 	2 . ^ 
	xor a			;8ff0	af 	. 
	ld (05cbbh),a		;8ff1	32 bb 5c 	2 . \ 
	ld (05cbch),a		;8ff4	32 bc 5c 	2 . \ 
	ret			;8ff7	c9 	. 
l8ff8h:
	cp 055h		;8ff8	fe 55 	. U 
	jr nz,l9000h		;8ffa	20 04 	  . 
	ld (05cbch),a		;8ffc	32 bc 5c 	2 . \ 
	ret			;8fff	c9 	. 
l9000h:
	cp 04eh		;9000	fe 4e 	. N 
	ret nz			;9002	c0 	. 
	ld (05cbch),a		;9003	32 bc 5c 	2 . \ 
	ret			;9006	c9 	. 
sub_9007h:
	push hl			;9007	e5 	. 
	push de			;9008	d5 	. 
	push af			;9009	f5 	. 
	ld a,(05eb2h)		;900a	3a b2 5e 	: . ^ 
	or a			;900d	b7 	. 
	jr z,l9019h		;900e	28 09 	( . 
	ld hl,(05eaeh)		;9010	2a ae 5e 	* . ^ 
	ld de,0270fh		;9013	11 0f 27 	. . ' 
	call CMP_HLDE		;9016	cd 20 0f 	.   . 
l9019h:
	pop de			;9019	d1 	. 
	ld a,d			;901a	7a 	z 
	pop de			;901b	d1 	. 
	pop hl			;901c	e1 	. 
	ret			;901d	c9 	. 
l901eh:
	ld a,05ah		;901e	3e 5a 	> Z 
	ld (05cc1h),a		;9020	32 c1 5c 	2 . \ 
	call sub_8984h		;9023	cd 84 89 	. . . 
	ld hl,00009h		;9026	21 09 00 	! . . 
	ld (05ea1h),hl		;9029	22 a1 5e 	" . ^ 
	ret			;902c	c9 	. 
sub_902dh:
	call sub_9007h		;902d	cd 07 90 	. . . 
	ret z			;9030	c8 	. 
	push hl			;9031	e5 	. 
	push de			;9032	d5 	. 
	push af			;9033	f5 	. 
	xor a			;9034	af 	. 
	ld de,(05eaeh)		;9035	ed 5b ae 5e 	. [ . ^ 
	call CMP_HLDE		;9039	cd 20 0f 	.   . 
	jr c,l904ah		;903c	38 0c 	8 . 
	ex de,hl			;903e	eb 	. 
	ld hl,(05eb0h)		;903f	2a b0 5e 	* . ^ 
	call CMP_HLDE		;9042	cd 20 0f 	.   . 
	jr c,l904ah		;9045	38 03 	8 . 
	or a			;9047	b7 	. 
	jr l9019h		;9048	18 cf 	. . 
l904ah:
	cp 001h		;904a	fe 01 	. . 
	jr l9019h		;904c	18 cb 	. . 

FUN_D5:
	call sub_2a82h		;904e	cd 82 2a 	. . * 
	ld bc,000f1h		;9051	01 f1 00 	. . . 
	ld de,v53c2		;9054	11 c2 53 	. . S 
	ld hl,05eb2h		;9057	21 b2 5e 	! . ^ 
l905ah:
	ldir		;905a	ed b0 	. . 
	ld a,(05cbah)		;905c	3a ba 5c 	: . \ 
	cp 005h		;905f	fe 05 	. . 
	jr nz,l906bh		;9061	20 08 	  . 
	ld a,04fh		;9063	3e 4f 	> O 
	ld hl,0		;9065	21 00 00 	! . . 
	call sub_88dch		;9068	cd dc 88 	. . . 
l906bh:
	M_OUT_MSG 0xd73a, 0x16 ; "LIMIT REMOTE ACCESS?  "
	ld a,(v53c2)				; #### Strange, v53c2 is used for other things too
	or a
	jr nz,_yes					; non-zero, remote access is limited
	ld a,'N'
	jr _print_current
_yes:
	ld a,'Y'
_print_current:
	call OUT_CH

	; Implements "CODES Key Operation."
	; Manual page 3-51
	M_OUT_MSG 0xd750, 0x2a ; "  (Y / N)" CRLF "USER CODE  START PAGE  STOP PAGE"

	ld iy,vUserCodes			; The start of user code info
	ld b,24						; 24 lines

_line_loop:
	M_OUT_CH CRLF			; Next line
	M_RIGHT 1
	M_OUT_MSG 0x0000, 0x06 ; F3 C3 8E 01 "W" FF 
	M_RIGHT 7
	M_OUT_VAR 0x0006, 0x04		; Start page is at offset 6, printed with 4 digits
	M_RIGHT 7
	M_OUT_VAR 0x0008, 0x04		; Stop page is at offset 8, printed with 4 digits

	ld de,10
	add iy,de					; Move to next entry
	djnz _line_loop

	M_GOTO_YX 01,23				; Cursor on 'Y' or 'N'

_key_again:
	call NEXT_MACRO_OR_KEY
	and %11011111 				; Uppercase 
	cp 'N'
	jr nz,_check_yes
	xor a
	ld (v53c2),a		;90c4	32 c2 53 	2 . S 
	ld a,'N'
	jr _l90d2h		;90c9	18 07 	. . 
_check_yes:
	cp 'Y'
	jr nz,_check_done		;90cd	20 0c 	  . 
	ld (v53c2),a		;90cf	32 c2 53 	2 . S 
_l90d2h:
	call OUT_CH		;90d2	cd 84 10 	. . . 
	M_LEFT 1
	jr _key_again
_check_done:
	cp "\n"
	jr nz,_key_again
	M_GOTO_YX 3,7
	ld b,018h		;90e4	06 18 	. . 
	ld iy,vUserCodes		;90e6	fd 21 c3 53 	. ! . S 
l90eah:
	; Stores in IY
	M_INPUT 0x0000, 0x46
	M_RIGHT 11
	; Adrs is IY+6
	M_SOMETHING1 0x0006, 0x14
	M_RIGHT 11
_loop:
	; Adrs is IY+8
	M_SOMETHING1 0x0008, 0x14
	ld d,(iy+007h)		;9104	fd 56 07 	. V . 
	ld e,(iy+006h)		;9107	fd 5e 06 	. ^ . 
	ld h,(iy+009h)		;910a	fd 66 09 	. f . 
	ld l,(iy+008h)		;910d	fd 6e 08 	. n . 
	call CMP_HLDE		;9110	cd 20 0f 	.   . 
	jr nc,l911bh		;9113	30 06 	0 . 
	M_SOMETHING2 0x04
	jr _loop
l911bh:
	M_OUT_CH CRLF
	M_RIGHT 6
	ld de,10
	add iy,de		;9126	fd 19 	. . 
	djnz l90eah		;9128	10 c0 	. . 
	ld bc,000f1h		;912a	01 f1 00 	. . . 
	ld de,05eb2h		;912d	11 b2 5e 	. . ^ 
	ld hl,v53c2		;9130	21 c2 53 	! . S 
	ld a,(05cbah)		;9133	3a ba 5c 	: . \ 
	cp 005h		;9136	fe 05 	. . 
	jr nz,l9145h		;9138	20 0b 	  . 
	ld de,05cc6h		;913a	11 c6 5c 	. . \ 
	ldir		;913d	ed b0 	. . 
	call l893fh		;913f	cd 3f 89 	. ? . 
	jp l1925h		;9142	c3 25 19 	. % . 
l9145h:
	ldir		;9145	ed b0 	. . 
	jp l1925h		;9147	c3 25 19 	. % . 

TASK_5:
	ld sp,05181h		;914a	31 81 51 	1 . Q 
	call sub_0334h		;914d	cd 34 03 	. 4 . 
	ld hl,TASK_5		;9150	21 4a 91 	! J . 
	push hl			;9153	e5 	. 
	ld a,(0000fh)		;9154	3a 0f 00 	: . . 
	cp 0aah		;9157	fe aa 	. . 
	jr nz,l916ch		;9159	20 11 	  . 
	ld a,(05ea8h)		;915b	3a a8 5e 	: . ^ 
	cp 000h		;915e	fe 00 	. . 
	jr nz,l9185h		;9160	20 23 	  # 
	ld a,005h		;9162	3e 05 	> . 
	ld (05ea8h),a		;9164	32 a8 5e 	2 . ^ 
	call sub_91d5h		;9167	cd d5 91 	. . . 
	jr l9185h		;916a	18 19 	. . 
l916ch:
	ld a,(05ea7h)		;916c	3a a7 5e 	: . ^ 
	cp 000h		;916f	fe 00 	. . 
	jr nz,l9185h		;9171	20 12 	  . 
	ld a,(05cbah)		;9173	3a ba 5c 	: . \ 
	and 004h		;9176	e6 04 	. . 
	jr nz,l9185h		;9178	20 0b 	  . 
	ld a,010h		;917a	3e 10 	> . 
	out (PORT_16),a		;917c	d3 16 	. . 
	in a,(PORT_16)		;917e	db 16 	. . 
	bit 5,a		;9180	cb 6f 	. o 
	call nz,sub_91e4h		;9182	c4 e4 91 	. . . 
l9185h:
	ld bc,(05ea1h)		;9185	ed 4b a1 5e 	. K . ^ 
	ld a,b			;9189	78 	x 
	or c			;918a	b1 	. 
	jr z,l91fch		;918b	28 6f 	( o 
	call sub_91d5h		;918d	cd d5 91 	. . . 
l9190h:
	ld a,(05eabh)		;9190	3a ab 5e 	: . ^ 
	or a			;9193	b7 	. 
	jr nz,l91cbh		;9194	20 35 	  5 
	ld a,010h		;9196	3e 10 	> . 
	out (PORT_16),a		;9198	d3 16 	. . 
	ld a,(0000fh)		;919a	3a 0f 00 	: . . 
	cp 0aah		;919d	fe aa 	. . 
	jr nz,l91a9h		;919f	20 08 	  . 
	in a,(PORT_16)		;91a1	db 16 	. . 
	and 004h		;91a3	e6 04 	. . 
	cp 004h		;91a5	fe 04 	. . 
	jr l91afh		;91a7	18 06 	. . 
l91a9h:
	in a,(PORT_16)		;91a9	db 16 	. . 
	and 024h		;91ab	e6 24 	. $ 
	cp 024h		;91ad	fe 24 	. $ 
l91afh:
	jr nz,l91cbh		;91af	20 1a 	  . 
	ld bc,(05ea1h)		;91b1	ed 4b a1 5e 	. K . ^ 
	ld a,b			;91b5	78 	x 
	or c			;91b6	b1 	. 
	jr z,l91deh		;91b7	28 25 	( % 
	dec bc			;91b9	0b 	. 
	ld (05ea1h),bc		;91ba	ed 43 a1 5e 	. C . ^ 
	ld hl,(05e9fh)		;91be	2a 9f 5e 	* . ^ 
	ld a,(hl)			;91c1	7e 	~ 
	inc hl			;91c2	23 	# 
	ld (05e9fh),hl		;91c3	22 9f 5e 	" . ^ 
	out (PORT_14),a		;91c6	d3 14 	. . 
	call sub_8b36h		;91c8	cd 36 8b 	. 6 . 
l91cbh:
	call sub_0334h		;91cb	cd 34 03 	. 4 . 
	ld a,(06029h)		;91ce	3a 29 60 	: ) ` 
	or a			;91d1	b7 	. 
	ret z			;91d2	c8 	. 
	jr l9190h		;91d3	18 bb 	. . 
sub_91d5h:
	ld a,005h		;91d5	3e 05 	> . 
	out (PORT_16),a		;91d7	d3 16 	. . 
	ld a,0eah		;91d9	3e ea 	> . 
	out (PORT_16),a		;91db	d3 16 	. . 
	ret			;91dd	c9 	. 
l91deh:
	ld a,(06039h)		;91de	3a 39 60 	: 9 ` 
	cp 000h		;91e1	fe 00 	. . 
	ret z			;91e3	c8 	. 
sub_91e4h:
	ld a,(0000fh)		;91e4	3a 0f 00 	: . . 
	cp 0aah		;91e7	fe aa 	. . 
	jr nz,l91efh		;91e9	20 04 	  . 
	call sub_93dah		;91eb	cd da 93 	. . . 
	ret			;91ee	c9 	. 
l91efh:
	ld a,005h		;91ef	3e 05 	> . 
	out (PORT_16),a		;91f1	d3 16 	. . 
	ld a,0e8h		;91f3	3e e8 	> . 
	out (PORT_16),a		;91f5	d3 16 	. . 
	xor a			;91f7	af 	. 
	ld (06039h),a		;91f8	32 39 60 	2 9 ` 
	ret			;91fb	c9 	. 
l91fch:
	ld a,(0000eh)		;91fc	3a 0e 00 	: . . 
	cp 0aah		;91ff	fe aa 	. . 
	ret nz			;9201	c0 	. 
	ld a,003h		;9202	3e 03 	> . 
	call SETMEMMAP		;9204	cd 1a 0f 	. . . 
	ld hl,(06034h)		;9207	2a 34 60 	* 4 ` 
	ld de,(05b79h)		;920a	ed 5b 79 5b 	. [ y [ 
	ld ix,(06036h)		;920e	dd 2a 36 60 	. * 6 ` 
	call CMP_HLDE		;9212	cd 20 0f 	.   . 
	jr c,l9224h		;9215	38 0d 	8 . 
	ld hl,0ffe0h		;9217	21 e0 ff 	! . . 
	ld (06036h),hl		;921a	22 36 60 	" 6 ` 
	ld hl,0		;921d	21 00 00 	! . . 
	ld (06034h),hl		;9220	22 34 60 	" 4 ` 
	ret			;9223	c9 	. 
l9224h:
	ld a,(ix+01fh)		;9224	dd 7e 1f 	. ~ . 
	cp 0aah		;9227	fe aa 	. . 
	jp nz,l9299h		;9229	c2 99 92 	. . . 
	ld a,(ix+004h)		;922c	dd 7e 04 	. ~ . 
	cp 042h		;922f	fe 42 	. B 
	jp nz,l9299h		;9231	c2 99 92 	. . . 
	ld hl,(FIFO_KBD)		;9234	2a e4 40 	* . @ 
	ld de,(040e6h)		;9237	ed 5b e6 40 	. [ . @ 
	call CMP_HLDE		;923b	cd 20 0f 	.   . 
	ret nz			;923e	c0 	. 
	ld a,0f4h		;923f	3e f4 	> . 
	ld hl,FIFO_KBD		;9241	21 e4 40 	! . @ 
	call DATA2FIFO		;9244	cd 09 0f 	. . . 
	ld a,0f4h		;9247	3e f4 	> . 
	call DATA2FIFO		;9249	cd 09 0f 	. . . 
	ld a,(ix+005h)		;924c	dd 7e 05 	. ~ . 
	call DATA2FIFO		;924f	cd 09 0f 	. . . 
	ld a,(ix+006h)		;9252	dd 7e 06 	. ~ . 
	call DATA2FIFO		;9255	cd 09 0f 	. . . 
	ld a,00ah		;9258	3e 0a 	> . 
	call DATA2FIFO		;925a	cd 09 0f 	. . . 
	push ix		;925d	dd e5 	. . 
	ld b,006h		;925f	06 06 	. . 
l9261h:
	ld a,(ix+007h)		;9261	dd 7e 07 	. ~ . 
	push bc			;9264	c5 	. 
	call DATA2FIFO		;9265	cd 09 0f 	. . . 
	pop bc			;9268	c1 	. 
	inc ix		;9269	dd 23 	. # 
	djnz l9261h		;926b	10 f4 	. . 
	pop ix		;926d	dd e1 	. . 
	ld a,00ah		;926f	3e 0a 	> . 
	call DATA2FIFO		;9271	cd 09 0f 	. . . 
	ld a,(ix+00dh)		;9274	dd 7e 0d 	. ~ . 
	call DATA2FIFO		;9277	cd 09 0f 	. . . 
	ld l,(ix+00eh)		;927a	dd 6e 0e 	. n . 
	ld h,(ix+00fh)		;927d	dd 66 0f 	. f . 
	call sub_92abh		;9280	cd ab 92 	. . . 
	ld l,(ix+010h)		;9283	dd 6e 10 	. n . 
	ld h,(ix+011h)		;9286	dd 66 11 	. f . 
	call sub_92abh		;9289	cd ab 92 	. . . 
	ld l,(ix+012h)		;928c	dd 6e 12 	. n . 
	ld h,(ix+013h)		;928f	dd 66 13 	. f . 
	call sub_92abh		;9292	cd ab 92 	. . . 
	xor a			;9295	af 	. 
	ld (ix+01fh),a		;9296	dd 77 1f 	. w . 
l9299h:
	ld hl,(06034h)		;9299	2a 34 60 	* 4 ` 
	inc hl			;929c	23 	# 
	ld (06034h),hl		;929d	22 34 60 	" 4 ` 
	ld hl,(06036h)		;92a0	2a 36 60 	* 6 ` 
	ld de,0ffe0h		;92a3	11 e0 ff 	. . . 
	add hl,de			;92a6	19 	. 
	ld (06036h),hl		;92a7	22 36 60 	" 6 ` 
	ret			;92aa	c9 	. 
sub_92abh:
	ld de,SCRATCH4		;92ab	11 7a 4f 	. z O 
	ld c,004h		;92ae	0e 04 	. . 
	call NUM2STR		;92b0	cd 9e 0f 	. . . 
	ld hl,FIFO_KBD		;92b3	21 e4 40 	! . @ 
	ld de,SCRATCH4		;92b6	11 7a 4f 	. z O 
	ld b,004h		;92b9	06 04 	. . 
l92bbh:
	ld a,(de)			;92bb	1a 	. 
	push de			;92bc	d5 	. 
	push bc			;92bd	c5 	. 
	call DATA2FIFO		;92be	cd 09 0f 	. . . 
	pop bc			;92c1	c1 	. 
	pop de			;92c2	d1 	. 
	inc de			;92c3	13 	. 
	djnz l92bbh		;92c4	10 f5 	. . 
	ld a,00ah		;92c6	3e 0a 	> . 
	call DATA2FIFO		;92c8	cd 09 0f 	. . . 
	ret			;92cb	c9 	. 
sub_92cch:
	M_OUT_MSG 0xd66d, 0x1d ; "BATCH TRANSFER  SYSTEM NAME  "
	M_OUT_MSG 0x53c7, 0x02 ; *** RAM data ***
	M_OUT_MSG 0xd70b, 0x0b ; CRLF "LOGON ID  "
	M_OUT_MSG v53c9, 0x06 ; *** RAM data ***
	M_OUT_MSG 0xd68c, 0x0c ; CRLF "DIRECTION  "
	ld a,(053cfh)		;92ea	3a cf 53 	: . S 
	cp 046h		;92ed	fe 46 	. F 
	jr z,l92f3h		;92ef	28 02 	( . 
	ld a,053h		;92f1	3e 53 	> S 
l92f3h:
	ld (053cfh),a		;92f3	32 cf 53 	2 . S 
	call OUT_CH		;92f6	cd 84 10 	. . . 
	M_OUT_MSG 0xd699, 0x2b ; "  (S=SEND F=FETCH)" CRLF CRLF "SOURCE  SOURCE  DESTIN "
	M_OUT_MSG 0xd6cc, 0x18 ; CRLF " FIRST   LAST    FIRST "
	M_GOTO_YX 16,2
l930ah:
	M_OUT_VAR 0x53d0, 0x04
	M_GOTO_YX 16,10
	M_OUT_VAR 0x53d2, 0x04
	M_GOTO_YX 16,18
	M_OUT_VAR 0x53d4, 0x04
	M_GOTO_YX 10,31
	ret
sub_932ch:
	M_GOTO_YX 10,31
	M_INPUT v53c7, 0x42
	M_GOTO_YX 11,16
	M_INPUT v53c9, 0x46
l9342h:
	M_GOTO_YX 12,12
l9347h:
	call NEXT_MACRO_OR_KEY		;9347	cd a7 17 	. . . 
	and 0dfh		;934a	e6 df 	. . 
	cp 00ah		;934c	fe 0a 	. . 
	jr z,l9360h		;934e	28 10 	( . 
	cp 053h		;9350	fe 53 	. S 
	jr z,l9358h		;9352	28 04 	( . 
	cp 046h		;9354	fe 46 	. F 
	jr nz,l9347h		;9356	20 ef 	  . 
l9358h:
	ld (053cfh),a		;9358	32 cf 53 	2 . S 
	call OUT_CH		;935b	cd 84 10 	. . . 
	jr l9342h		;935e	18 e2 	. . 
l9360h:
	; FReD ####
	M_GOTO_YX 16,5
	M_SOMETHING1 v53d0, 0x04
	M_GOTO_YX 16,13
	M_SOMETHING1 v53d2, 0x04
	M_GOTO_YX 16,21
	M_SOMETHING1 v53d4, 0x04
	ret			;9381	c9 	. 
sub_9382h:
	ld a,014h		;9382	3e 14 	> . 
	ld (05ea8h),a		;9384	32 a8 5e 	2 . ^ 
l9387h:
	call sub_0334h		;9387	cd 34 03 	. 4 . 
	ld a,(05ea8h)		;938a	3a a8 5e 	: . ^ 
	cp 005h		;938d	fe 05 	. . 
	ret z			;938f	c8 	. 
l9390h:
	ld a,(06038h)		;9390	3a 38 60 	: 8 ` 
	or a			;9393	b7 	. 
	jr nz,l9387h		;9394	20 f1 	  . 
	call sub_8b30h		;9396	cd 30 8b 	. 0 . 
l9399h:
	ld a,(05e9eh)		;9399	3a 9e 5e 	: . ^ 
	ld (05cbdh),a		;939c	32 bd 5c 	2 . \ 
	ld a,00dh		;939f	3e 0d 	> . 
	ld (05cbeh),a		;93a1	32 be 5c 	2 . \ 
	ld hl,00002h		;93a4	21 02 00 	! . . 
	ld (05ea1h),hl		;93a7	22 a1 5e 	" . ^ 
	ld hl,05cbdh		;93aa	21 bd 5c 	! . \ 
	ld (05e9fh),hl		;93ad	22 9f 5e 	" . ^ 
l93b0h:
	call sub_0334h		;93b0	cd 34 03 	. 4 . 
	ld hl,(05ea1h)		;93b3	2a a1 5e 	* . ^ 
	ld a,h			;93b6	7c 	| 
	or l			;93b7	b5 	. 
	jr nz,l93b0h		;93b8	20 f6 	  . 
	ld a,010h		;93ba	3e 10 	> . 
	ld (05ea7h),a		;93bc	32 a7 5e 	2 . ^ 
l93bfh:
	call sub_0334h		;93bf	cd 34 03 	. 4 . 
	ld a,010h		;93c2	3e 10 	> . 
	out (PORT_16),a		;93c4	d3 16 	. . 
	in a,(PORT_16)		;93c6	db 16 	. . 
	and 020h		;93c8	e6 20 	.   
	ret nz			;93ca	c0 	. 
	ld a,(05ea7h)		;93cb	3a a7 5e 	: . ^ 
	or a			;93ce	b7 	. 
	jr nz,l93bfh		;93cf	20 ee 	  . 
	call sub_93e0h		;93d1	cd e0 93 	. . . 
	call sub_8b41h		;93d4	cd 41 8b 	. A . 
	ret z			;93d7	c8 	. 
	jr l9399h		;93d8	18 bf 	. . 
sub_93dah:
	ld a,(06038h)		;93da	3a 38 60 	: 8 ` 
	cp 0aah		;93dd	fe aa 	. . 
	ret nz			;93df	c0 	. 
sub_93e0h:
	ld a,03ch		;93e0	3e 3c 	> < 
	ld (05ea7h),a		;93e2	32 a7 5e 	2 . ^ 
l93e5h:
	call l91efh		;93e5	cd ef 91 	. . . 
	call sub_0334h		;93e8	cd 34 03 	. 4 . 
	ld a,(05ea7h)		;93eb	3a a7 5e 	: . ^ 
	cp 000h		;93ee	fe 00 	. . 
	jr z,l93fch		;93f0	28 0a 	( . 
	ld a,010h		;93f2	3e 10 	> . 
	out (PORT_16),a		;93f4	d3 16 	. . 
	in a,(PORT_16)		;93f6	db 16 	. . 
	and %00100000   
	jr nz,l93e5h		;93fa	20 e9 	  . 
l93fch:
	ld a,005h		;93fc	3e 05 	> . 
	ld (05ea7h),a		;93fe	32 a7 5e 	2 . ^ 
l9401h:
	call sub_0334h		;9401	cd 34 03 	. 4 . 
	ld a,(05ea7h)		;9404	3a a7 5e 	: . ^ 
	cp 000h		;9407	fe 00 	. . 
	jr nz,l9401h		;9409	20 f6 	  . 
	call sub_91d5h		;940b	cd d5 91 	. . . 
	xor a			;940e	af 	. 
	ld (06038h),a		;940f	32 38 60 	2 8 ` 
	ret			;9412	c9 	. 
HANDLE_PORT05:
	call sub_949bh		;9413	cd 9b 94 	. . . 
	ld a,(053bch)		;9416	3a bc 53 	: . S 
	ld b,a			;9419	47 	G 
	in a,(PORT_05)		;941a	db 05 	. . 
	and 030h		;941c	e6 30 	. 0 
	cp b			;941e	b8 	. 
	ret z			;941f	c8 	. 
	ld (053bch),a		;9420	32 bc 53 	2 . S 
	ld c,a			;9423	4f 	O 
	xor b			;9424	a8 	. 
	ld b,a			;9425	47 	G 
	ld ix,053beh		;9426	dd 21 be 53 	. ! . S 
	push bc			;942a	c5 	. 
	bit 4,b		;942b	cb 60 	. ` 
	call nz,sub_9438h		;942d	c4 38 94 	. 8 . 
	pop bc			;9430	c1 	. 
	srl c		;9431	cb 39 	. 9 
	inc ix		;9433	dd 23 	. # 
	bit 5,b		;9435	cb 68 	. h 
	ret z			;9437	c8 	. 
sub_9438h:
	bit 4,c		;9438	cb 61 	. a 
	ret nz			;943a	c0 	. 
	ld a,(ix+000h)		;943b	dd 7e 00 	. ~ . 
	cp 04eh		;943e	fe 4e 	. N 
	ret z			;9440	c8 	. 
	cp 053h		;9441	fe 53 	. S 
	jr z,l945eh		;9443	28 19 	( . 
	cp 050h		;9445	fe 50 	. P 
	ret nz			;9447	c0 	. 
	ld b,001h		;9448	06 01 	. . 
	ld a,(ix+002h)		;944a	dd 7e 02 	. ~ . 
	and 047h		;944d	e6 47 	. G 
	cp 041h		;944f	fe 41 	. A 
	jr nz,l9457h		;9451	20 04 	  . 
	ld a,001h		;9453	3e 01 	> . 
	ld b,006h		;9455	06 06 	. . 
l9457h:
	call sub_332ah		;9457	cd 2a 33 	. * 3 
	inc a			;945a	3c 	< 
	djnz l9457h		;945b	10 fa 	. . 
	ret			;945d	c9 	. 
l945eh:
	ld b,001h		;945e	06 01 	. . 
	ld a,(ix+002h)		;9460	dd 7e 02 	. ~ . 
	and 047h		;9463	e6 47 	. G 
	cp 041h		;9465	fe 41 	. A 
	jr nz,l946dh		;9467	20 04 	  . 
	ld a,001h		;9469	3e 01 	> . 
	ld b,006h		;946b	06 06 	. . 
l946dh:
	call sub_33a3h		;946d	cd a3 33 	. . 3 
	inc a			;9470	3c 	< 
	djnz l946dh		;9471	10 fa 	. . 
	ret			;9473	c9 	. 
l9474h:
	or a			;9474	b7 	. 
	ret z			;9475	c8 	. 
	ld l,a			;9476	6f 	o 
	srl a		;9477	cb 3f 	. ? 
	srl a		;9479	cb 3f 	. ? 
	srl a		;947b	cb 3f 	. ? 
	srl a		;947d	cb 3f 	. ? 
	ld h,a			;947f	67 	g 
	cpl			;9480	2f 	/ 
	ld c,a			;9481	4f 	O 
	or l			;9482	b5 	. 
	ld b,a			;9483	47 	G 
	ld a,(053bdh)		;9484	3a bd 53 	: . S 
	and b			;9487	a0 	. 
	ld b,a			;9488	47 	G 
	ld a,l			;9489	7d 	} 
	and c			;948a	a1 	. 
	or b			;948b	b0 	. 
	ld b,a			;948c	47 	G 
	ld a,h			;948d	7c 	| 
	and l			;948e	a5 	. 
	xor b			;948f	a8 	. 
	out (PORT_05),a		;9490	d3 05 	. . 
	ld a,b			;9492	78 	x 
	and 00fh		;9493	e6 0f 	. . 
	ld (053bdh),a		;9495	32 bd 53 	2 . S 
	out (PORT_05),a		;9498	d3 05 	. . 
	ret			;949a	c9 	. 
sub_949bh:
	ld a,(CFG6)		;949b	3a 0d 00 	: . . 
	cp 0aah		;949e	fe aa 	. . 
	ret nz			;94a0	c0 	. 
	ld a,(05baeh)		;94a1	3a ae 5b 	: . [ 
	ld b,a			;94a4	47 	G 
	in a,(PORT_05)		;94a5	db 05 	. . 
	and 020h		;94a7	e6 20 	.   
	cp b			;94a9	b8 	. 
	ret z			;94aa	c8 	. 
	ld (05baeh),a		;94ab	32 ae 5b 	2 . [ 
	and a			;94ae	a7 	. 
	ret z			;94af	c8 	. 
	ld hl,05bafh		;94b0	21 af 5b 	! . [ 
	inc (hl)			;94b3	34 	4 
	ret			;94b4	c9 	. 
sub_94b5h:
	ld a,(v5fa7)
	cp 0xaa
	ret nz			;94ba	c0 	. 
	ld a,003h		;94bb	3e 03 	> . 
	call SETMEMMAP		;94bd	cd 1a 0f 	. . . 
	ld hl,(05fa8h)		;94c0	2a a8 5f 	* . _ 
	ld de,(05b79h)		;94c3	ed 5b 79 5b 	. [ y [ 
	ld ix,(05faah)		;94c7	dd 2a aa 5f 	. * . _ 
	ld iy,05b93h		;94cb	fd 21 93 5b 	. ! . [ 
	ld b,01eh		;94cf	06 1e 	. . 
l94d1h:
	call CMP_HLDE		;94d1	cd 20 0f 	.   . 
	jr c,l94e7h		;94d4	38 11 	8 . 
	ld hl,0ffe0h		;94d6	21 e0 ff 	! . . 
	ld (05faah),hl		;94d9	22 aa 5f 	" . _ 
	ld hl,0		;94dc	21 00 00 	! . . 
	ld (05fa8h),hl		;94df	22 a8 5f 	" . _ 
	xor a			;94e2	af 	. 
	ld (v5fa7),a		;94e3	32 a7 5f 	2 . _ 
	ret			;94e6	c9 	. 
l94e7h:
	call sub_950fh		;94e7	cd 0f 95 	. . . 
	jr z,l94feh		;94ea	28 12 	( . 
	inc hl			;94ec	23 	# 
	push de			;94ed	d5 	. 
	ld de,0ffe0h		;94ee	11 e0 ff 	. . . 
	add ix,de		;94f1	dd 19 	. . 
	pop de			;94f3	d1 	. 
	djnz l94d1h		;94f4	10 db 	. . 
	ld (05fa8h),hl		;94f6	22 a8 5f 	" . _ 
	ld (05faah),ix		;94f9	dd 22 aa 5f 	. " . _ 
	ret			;94fd	c9 	. 
l94feh:
	call sub_9543h		;94fe	cd 43 95 	. C . 
	inc hl			;9501	23 	# 
	ld (05fa8h),hl		;9502	22 a8 5f 	" . _ 
	ld de,0ffe0h		;9505	11 e0 ff 	. . . 
	add ix,de		;9508	dd 19 	. . 
	ld (05faah),ix		;950a	dd 22 aa 5f 	. " . _ 
	ret			;950e	c9 	. 
sub_950fh:
	ld a,(ix+000h)		;950f	dd 7e 00 	. ~ . 
	cp 059h		;9512	fe 59 	. Y 
	ret nz			;9514	c0 	. 
	ld a,(ix+001h)		;9515	dd 7e 01 	. ~ . 
	cp (iy+005h)		;9518	fd be 05 	. . . 
	ret nz			;951b	c0 	. 
	ld a,(ix+002h)		;951c	dd 7e 02 	. ~ . 
	res 7,a		;951f	cb bf 	. . 
	cp 041h		;9521	fe 41 	. A 
	jr z,l9539h		;9523	28 14 	( . 
	cp 00ch		;9525	fe 0c 	. . 
	jr nz,l952ah		;9527	20 01 	  . 
	xor a			;9529	af 	. 
l952ah:
	cp (iy+004h)		;952a	fd be 04 	. . . 
	ret nz			;952d	c0 	. 
	ld a,(ix+002h)		;952e	dd 7e 02 	. ~ . 
	rla			;9531	17 	. 
	rla			;9532	17 	. 
	and 001h		;9533	e6 01 	. . 
	cp (iy+007h)		;9535	fd be 07 	. . . 
	ret nz			;9538	c0 	. 
l9539h:
	ld a,(ix+003h)		;9539	dd 7e 03 	. ~ . 
	cp 041h		;953c	fe 41 	. A 
	ret z			;953e	c8 	. 
	cp (iy+000h)		;953f	fd be 00 	. . . 
	ret			;9542	c9 	. 
sub_9543h:
	ld a,(ix+004h)		;9543	dd 7e 04 	. ~ . 
	cp 04ch		;9546	fe 4c 	. L 
	jr nz,l9550h		;9548	20 06 	  . 
	ld a,(ix+005h)		;954a	dd 7e 05 	. ~ . 
	jp l9474h		;954d	c3 74 94 	. t . 
l9550h:
	cp 053h		;9550	fe 53 	. S 
	jr nz,l955ah		;9552	20 06 	  . 
	push hl			;9554	e5 	. 
	call sub_956dh		;9555	cd 6d 95 	. m . 
	pop hl			;9558	e1 	. 
	ret			;9559	c9 	. 
l955ah:
	cp 054h		;955a	fe 54 	. T 
	jr nz,l9564h		;955c	20 06 	  . 
	ld a,(ix+007h)		;955e	dd 7e 07 	. ~ . 
	jp sub_16eeh		;9561	c3 ee 16 	. . . 
l9564h:
	cp 042h		;9564	fe 42 	. B 
	ret nz			;9566	c0 	. 
	ld a,0aah		;9567	3e aa 	> . 
	ld (ix+01fh),a		;9569	dd 77 1f 	. w . 
	ret			;956c	c9 	. 
sub_956dh:
	ld a,(ix+005h)		;956d	dd 7e 05 	. ~ . 
	cp 046h		;9570	fe 46 	. F 
	jr z,l95adh		;9572	28 39 	( 9 
	cp 049h		;9574	fe 49 	. I 
	ret nz			;9576	c0 	. 
	ld e,(ix+007h)		;9577	dd 5e 07 	. ^ . 
	ld d,000h		;957a	16 00 	. . 
	ld hl,05fb3h		;957c	21 b3 5f 	! . _ 
	add hl,de			;957f	19 	. 
	add hl,de			;9580	19 	. 
	add hl,de			;9581	19 	. 
	add hl,de			;9582	19 	. 
	ex de,hl			;9583	eb 	. 
	push ix		;9584	dd e5 	. . 
	pop hl			;9586	e1 	. 
	ld bc,00008h		;9587	01 08 00 	. . . 
	add hl,bc			;958a	09 	. 
	ld bc,FLAG_DISP		;958b	01 04 00 	. . . 
	ldir		;958e	ed b0 	. . 
	ld a,(ix+006h)		;9590	dd 7e 06 	. ~ . 
	cp 049h		;9593	fe 49 	. I 
	ret nz			;9595	c0 	. 
	ld b,(ix+007h)		;9596	dd 46 07 	. F . 
	ld de,00027h		;9599	11 27 00 	. ' . 
	ld hl,052a6h		;959c	21 a6 52 	! . R 
l959fh:
	add hl,de			;959f	19 	. 
	djnz l959fh		;95a0	10 fd 	. . 
	ld (hl),000h		;95a2	36 00 	6 . 
	inc hl			;95a4	23 	# 
	ld (hl),000h		;95a5	36 00 	6 . 
	ld a,(ix+007h)		;95a7	dd 7e 07 	. ~ . 
	jp sub_332ah		;95aa	c3 2a 33 	. * 3 
l95adh:
	ld b,(ix+007h)		;95ad	dd 46 07 	. F . 
	ld a,(05b7bh)		;95b0	3a 7b 5b 	: { [ 
	and 001h		;95b3	e6 01 	. . 
	jr z,l95c8h		;95b5	28 11 	( . 
	ld a,(05b81h)		;95b7	3a 81 5b 	: . [ 
	cp b			;95ba	b8 	. 
	jr nz,l95c8h		;95bb	20 0b 	  . 
	ld a,(0609dh)		;95bd	3a 9d 60 	: . ` 
	and a			;95c0	a7 	. 
	jr z,l95c8h		;95c1	28 05 	( . 
	ld de,060a5h		;95c3	11 a5 60 	. . ` 
	jr l95d2h		;95c6	18 0a 	. . 
l95c8h:
	ld de,00027h		;95c8	11 27 00 	. ' . 
	ld hl,052abh		;95cb	21 ab 52 	! . R 
l95ceh:
	add hl,de			;95ce	19 	. 
	djnz l95ceh		;95cf	10 fd 	. . 
	ex de,hl			;95d1	eb 	. 
l95d2h:
	push ix		;95d2	dd e5 	. . 
	pop hl			;95d4	e1 	. 
	ld bc,00008h		;95d5	01 08 00 	. . . 
	add hl,bc			;95d8	09 	. 
	ld b,004h		;95d9	06 04 	. . 
l95dbh:
	push bc			;95db	c5 	. 
	ld bc,6		;95dc	01 06 00 	. . . 
	ldir		;95df	ed b0 	. . 
	inc de			;95e1	13 	. 
	inc de			;95e2	13 	. 
	pop bc			;95e3	c1 	. 
	djnz l95dbh		;95e4	10 f5 	. . 
	ld a,(ix+007h)		;95e6	dd 7e 07 	. ~ . 
	call 033d9h		;95e9	cd d9 33 	. . 3 
	ld a,(ix+006h)		;95ec	dd 7e 06 	. ~ . 
	cp 049h		;95ef	fe 49 	. I 
	ret nz			;95f1	c0 	. 
	ld a,(ix+007h)		;95f2	dd 7e 07 	. ~ . 
	jp sub_33a3h		;95f5	c3 a3 33 	. . 3 

; message at 95f8
	db "ENABLE PUBLIC ACCESS "
	db 0x45 ;	  E 
	ld b,h			;960e	44 	D 
	ld c,c			;960f	49 	I 
	ld d,h			;9610	54 	T 
	jr nz,l9656h		;9611	20 43 	  C 
	ld b,c			;9613	41 	A 
	ld d,h			;9614	54 	T 
	jr nz,$+70		;9615	20 44 	  D 
	ld b,l			;9617	45 	E 
	ld b,(hl)			;9618	46 	F 
	jr nz,l966fh		;9619	20 54 	  T 
	ld b,c			;961b	41 	A 
	ld b,d			;961c	42 	B 
	ld c,h			;961d	4c 	L 
	ld b,l			;961e	45 	E 
	jr nz,l9626h		;961f	20 05 	  . 
	dec b			;9621	05 	. 
	ld d,d			;9622	52 	R 
	ld b,l			;9623	45 	E 
	ld d,b			;9624	50 	P 
	ld b,l			;9625	45 	E 
l9626h:
	ld b,c			;9626	41 	A 
	ld d,h			;9627	54 	T 
	jr nz,l966dh		;9628	20 43 	  C 
	ld b,c			;962a	41 	A 
	ld d,h			;962b	54 	T 
	ld b,l			;962c	45 	E 
	ld b,a			;962d	47 	G 
	ld c,a			;962e	4f 	O 
	ld d,d			;962f	52 	R 
	ld c,c			;9630	49 	I 
	ld b,l			;9631	45 	E 
	ld d,e			;9632	53 	S 
	jr nz,l963ah		;9633	20 05 	  . 
	dec b			;9635	05 	. 
	ld d,d			;9636	52 	R 
	ld b,l			;9637	45 	E 
	ld b,a			;9638	47 	G 
	ld c,c			;9639	49 	I 
l963ah:
	ld c,a			;963a	4f 	O 
	ld c,(hl)			;963b	4e 	N 
	jr nz,l9661h		;963c	20 23 	  # 
	jr nz,l9686h		;963e	20 46 	  F 
	ld c,a			;9640	4f 	O 
	ld d,d			;9641	52 	R 
	jr nz,l9687h		;9642	20 43 	  C 
	ld b,c			;9644	41 	A 
	ld d,h			;9645	54 	T 
	ld b,l			;9646	45 	E 
	ld b,a			;9647	47 	G 
l9648h:
	ld c,a			;9648	4f 	O 
	ld d,d			;9649	52 	R 
	ld e,c			;964a	59 	Y 
	jr nz,l96a1h		;964b	20 54 	  T 
	ld b,l			;964d	45 	E 
	ld e,b			;964e	58 	X 
	ld d,h			;964f	54 	T 
l9650h:
	jr nz,l9657h		;9650	20 05 	  . 
	ld b,e			;9652	43 	C 
l9653h:
	ld b,c			;9653	41 	A 
	ld d,h			;9654	54 	T 
	ld b,l			;9655	45 	E 
l9656h:
	ld b,a			;9656	47 	G 
l9657h:
	ld c,a			;9657	4f 	O 
	ld d,d			;9658	52 	R 
	ld e,c			;9659	59 	Y 
	jr nz,l96a0h		;965a	20 44 	  D 
	ld b,l			;965c	45 	E 
	ld b,(hl)			;965d	46 	F 
	jr nz,$+85		;965e	20 53 	  S 
	ld d,h			;9660	54 	T 
l9661h:
	ld b,c			;9661	41 	A 
	ld d,d			;9662	52 	R 
	ld d,h			;9663	54 	T 
	jr nz,l96b6h		;9664	20 50 	  P 
	ld b,c			;9666	41 	A 
	ld b,a			;9667	47 	G 
	ld b,l			;9668	45 	E 
	jr nz,l9670h		;9669	20 05 	  . 
	ld b,e			;966b	43 	C 
	ld b,c			;966c	41 	A 
l966dh:
	ld d,h			;966d	54 	T 
	ld b,l			;966e	45 	E 
l966fh:
	ld b,a			;966f	47 	G 
l9670h:
	ld c,a			;9670	4f 	O 
	ld d,d			;9671	52 	R 
	ld e,c			;9672	59 	Y 
	jr nz,l96b9h		;9673	20 44 	  D 
	ld b,l			;9675	45 	E 
	ld b,(hl)			;9676	46 	F 
	jr nz,l96cch		;9677	20 53 	  S 
	ld d,h			;9679	54 	T 
	ld c,a			;967a	4f 	O 
	ld d,b			;967b	50 	P 
	jr nz,l96ceh		;967c	20 50 	  P 
	ld b,c			;967e	41 	A 
	ld b,a			;967f	47 	G 
	ld b,l			;9680	45 	E 
	jr nz,l9688h		;9681	20 05 	  . 
	dec b			;9683	05 	. 
	ld d,d			;9684	52 	R 
	ld b,l			;9685	45 	E 
l9686h:
	ld b,a			;9686	47 	G 
l9687h:
	ld c,c			;9687	49 	I 
l9688h:
	ld c,a			;9688	4f 	O 
	ld c,(hl)			;9689	4e 	N 
	jr nz,l96afh		;968a	20 23 	  # 
	jr nz,l96d4h		;968c	20 46 	  F 
	ld c,a			;968e	4f 	O 
	ld d,d			;968f	52 	R 
	jr nz,l96e4h		;9690	20 52 	  R 
	ld b,l			;9692	45 	E 
	ld d,c			;9693	51 	Q 
	ld d,l			;9694	55 	U 
	ld b,l			;9695	45 	E 
	ld d,e			;9696	53 	S 
	ld d,h			;9697	54 	T 
	jr nz,l96ebh		;9698	20 51 	  Q 
	ld d,l			;969a	55 	U 
	ld b,l			;969b	45 	E 
	ld d,l			;969c	55 	U 
	ld b,l			;969d	45 	E 
	jr nz,l96a5h		;969e	20 05 	  . 
l96a0h:
	ld d,d			;96a0	52 	R 
l96a1h:
	ld b,l			;96a1	45 	E 
	ld d,c			;96a2	51 	Q 
	ld d,l			;96a3	55 	U 
	ld b,l			;96a4	45 	E 
l96a5h:
	ld d,e			;96a5	53 	S 
	ld d,h			;96a6	54 	T 
	jr nz,l96fah		;96a7	20 51 	  Q 
	ld d,l			;96a9	55 	U 
	ld b,l			;96aa	45 	E 
	ld d,l			;96ab	55 	U 
	ld b,l			;96ac	45 	E 
	jr nz,$+82		;96ad	20 50 	  P 
l96afh:
	ld b,c			;96af	41 	A 
	ld b,a			;96b0	47 	G 
	ld b,l			;96b1	45 	E 
	jr nz,l96d7h		;96b2	20 23 	  # 
	jr nz,l96bbh		;96b4	20 05 	  . 
l96b6h:
	dec b			;96b6	05 	. 
	ld b,l			;96b7	45 	E 
	ld b,h			;96b8	44 	D 
l96b9h:
	ld c,c			;96b9	49 	I 
	ld d,h			;96ba	54 	T 
l96bbh:
	jr nz,l970dh		;96bb	20 50 	  P 
	ld d,d			;96bd	52 	R 
	ld c,a			;96be	4f 	O 
	ld d,h			;96bf	54 	T 
	ld b,l			;96c0	45 	E 
	ld b,e			;96c1	43 	C 
	ld d,h			;96c2	54 	T 
	ld b,l			;96c3	45 	E 
	ld b,h			;96c4	44 	D 
	jr nz,l970dh		;96c5	20 46 	  F 
	ld d,l			;96c7	55 	U 
	ld c,(hl)			;96c8	4e 	N 
	ld b,e			;96c9	43 	C 
	ld d,h			;96ca	54 	T 
	ld c,c			;96cb	49 	I 
l96cch:
	ld c,a			;96cc	4f 	O 
	ld c,(hl)			;96cd	4e 	N 
l96ceh:
	ld d,e			;96ce	53 	S 
	jr nz,l971fh		;96cf	20 4e 	  N 
	dec b			;96d1	05 	. 
	dec b			;96d2	05 	. 
	dec b			;96d3	05 	. 
l96d4h:
	ld c,c			;96d4	49 	I 
	ld c,(hl)			;96d5	4e 	N 
	ld c,c			;96d6	49 	I 
l96d7h:
	ld d,h			;96d7	54 	T 
	jr nz,l971dh		;96d8	20 43 	  C 
	ld b,c			;96da	41 	A 
	ld d,h			;96db	54 	T 
	jr nz,$+70		;96dc	20 44 	  D 
	ld b,l			;96de	45 	E 
	ld b,(hl)			;96df	46 	F 
	jr nz,l9736h		;96e0	20 54 	  T 
	ld b,c			;96e2	41 	A 
	ld b,d			;96e3	42 	B 
l96e4h:
	ld c,h			;96e4	4c 	L 
	ld b,l			;96e5	45 	E 
	jr nz,l96edh		;96e6	20 05 	  . 
	dec b			;96e8	05 	. 
	ld b,e			;96e9	43 	C 
	ld c,h			;96ea	4c 	L 
l96ebh:
	ld b,l			;96eb	45 	E 
	ld b,c			;96ec	41 	A 
l96edh:
	ld d,d			;96ed	52 	R 
	jr nz,l9733h		;96ee	20 43 	  C 
	ld b,c			;96f0	41 	A 
	ld d,h			;96f1	54 	T 
	ld b,l			;96f2	45 	E 
	ld b,a			;96f3	47 	G 
	ld c,a			;96f4	4f 	O 
	ld d,d			;96f5	52 	R 
	ld e,c			;96f6	59 	Y 
	jr nz,l973ch		;96f7	20 43 	  C 
	ld c,a			;96f9	4f 	O 
l96fah:
	ld d,l			;96fa	55 	U 
	ld c,(hl)			;96fb	4e 	N 
	ld d,h			;96fc	54 	T 
	ld d,e			;96fd	53 	S 
	jr nz,l9745h		;96fe	20 45 	  E 
	ld c,(hl)			;9700	4e 	N 
	ld d,h			;9701	54 	T 
	ld b,l			;9702	45 	E 
	ld d,d			;9703	52 	R 
	jr nz,l9749h		;9704	20 43 	  C 
	ld b,c			;9706	41 	A 
	ld d,h			;9707	54 	T 
	ld b,l			;9708	45 	E 
	ld b,a			;9709	47 	G 
	ld c,a			;970a	4f 	O 
	ld d,d			;970b	52 	R 
	ld e,c			;970c	59 	Y 
l970dh:
	jr nz,$+80		;970d	20 4e 	  N 
	ld d,l			;970f	55 	U 
	ld c,l			;9710	4d 	M 
	ld b,d			;9711	42 	B 
	ld b,l			;9712	45 	E 
	ld d,d			;9713	52 	R 
	jr nz,l9740h		;9714	20 2a 	  * 
	ld hl,(0202ah)		;9716	2a 2a 20 	* *   
	ld b,e			;9719	43 	C 
	ld b,c			;971a	41 	A 
	ld d,h			;971b	54 	T 
	ld b,l			;971c	45 	E 
l971dh:
	ld b,a			;971d	47 	G 
	ld c,a			;971e	4f 	O 
l971fh:
	ld d,d			;971f	52 	R 
	ld e,c			;9720	59 	Y 
	jr nz,l9771h		;9721	20 4e 	  N 
	ld c,a			;9723	4f 	O 
	ld d,h			;9724	54 	T 
	jr nz,l976dh		;9725	20 46 	  F 
	ld c,a			;9727	4f 	O 
	ld d,l			;9728	55 	U 
	ld c,(hl)			;9729	4e 	N 
	ld b,h			;972a	44 	D 
	jr nz,l9757h		;972b	20 2a 	  * 
	ld hl,(0452ah)		;972d	2a 2a 45 	* * E 
	ld c,(hl)			;9730	4e 	N 
	ld d,h			;9731	54 	T 
	ld b,l			;9732	45 	E 
l9733h:
	ld d,d			;9733	52 	R 
	jr nz,l9786h		;9734	20 50 	  P 
l9736h:
	ld b,c			;9736	41 	A 
	ld d,e			;9737	53 	S 
	ld d,e			;9738	53 	S 
	ld d,a			;9739	57 	W 
	ld c,a			;973a	4f 	O 
	ld d,d			;973b	52 	R 
l973ch:
	ld b,h			;973c	44 	D 
	jr nz,l9784h		;973d	20 45 	  E 
	ld c,(hl)			;973f	4e 	N 
l9740h:
	ld d,h			;9740	54 	T 
	ld b,l			;9741	45 	E 
	ld d,d			;9742	52 	R 
	jr nz,$+85		;9743	20 53 	  S 
l9745h:
	ld d,h			;9745	54 	T 
	ld b,c			;9746	41 	A 
	ld d,d			;9747	52 	R 
	ld d,h			;9748	54 	T 
l9749h:
	jr nz,$+80		;9749	20 4e 	  N 
	ld d,l			;974b	55 	U 
	ld c,l			;974c	4d 	M 
	ld b,d			;974d	42 	B 
	ld b,l			;974e	45 	E 
	ld d,d			;974f	52 	R 
	jr nz,l9757h		;9750	20 05 	  . 
	ld b,l			;9752	45 	E 
	ld c,(hl)			;9753	4e 	N 
	ld d,h			;9754	54 	T 
	ld b,l			;9755	45 	E 
	ld d,d			;9756	52 	R 
l9757h:
	jr nz,l97ach		;9757	20 53 	  S 
	ld d,h			;9759	54 	T 
	ld c,a			;975a	4f 	O 
	ld d,b			;975b	50 	P 
	jr nz,l97ach		;975c	20 4e 	  N 
	ld d,l			;975e	55 	U 
	ld c,l			;975f	4d 	M 
	ld b,d			;9760	42 	B 
	ld b,l			;9761	45 	E 
	ld d,d			;9762	52 	R 
	jr nz,l97bah		;9763	20 55 	  U 
	ld d,e			;9765	53 	S 
	ld c,c			;9766	49 	I 
	ld c,(hl)			;9767	4e 	N 
	ld b,a			;9768	47 	G 
	jr nz,$+68		;9769	20 42 	  B 
	ld b,c			;976b	41 	A 
	ld d,h			;976c	54 	T 
l976dh:
	ld b,e			;976d	43 	C 
	ld c,b			;976e	48 	H 
	ld b,l			;976f	45 	E 
	ld b,h			;9770	44 	D 
l9771h:
	ld c,c			;9771	49 	I 
	ld d,h			;9772	54 	T 
	jr nz,$+82		;9773	20 50 	  P 
	ld d,l			;9775	55 	U 
	ld b,d			;9776	42 	B 
	ld c,h			;9777	4c 	L 
	ld c,c			;9778	49 	I 
	ld b,e			;9779	43 	C 
	jr nz,l97bdh		;977a	20 41 	  A 
	ld b,e			;977c	43 	C 
	ld b,e			;977d	43 	C 
	ld b,l			;977e	45 	E 
	ld d,e			;977f	53 	S 
	ld d,e			;9780	53 	S 
	jr nz,l97d9h		;9781	20 56 	  V 
	ld b,c			;9783	41 	A 
l9784h:
	ld d,d			;9784	52 	R 
	ld c,c			;9785	49 	I 
l9786h:
	ld b,c			;9786	41 	A 
	ld b,d			;9787	42 	B 
	ld c,h			;9788	4c 	L 
	ld b,l			;9789	45 	E 
	ld d,e			;978a	53 	S 
	jr nz,$+80		;978b	20 4e 	  N 
sub_978dh:
	ld a,(053dbh)		;978d	3a db 53 	: . S 
	cp 0aah		;9790	fe aa 	. . 
	ret nz			;9792	c0 	. 
	M_GOTO_YX 21,1
	M_OUT_MSG 0x95f8, 0x15 ; "ENABLE PUBLIC ACCESS "
	ld ix,053ceh		;979e	dd 21 ce 53 	. ! . S 
	M_GOTO_YX 21, 22
	ld a,(ix+0)
	and 001h		;97aa	e6 01 	. . 
l97ach:
	jp sub_3b79h		;97ac	c3 79 3b 	. y ; 
sub_97afh:
	ld a,(053ceh)		;97af	3a ce 53 	: . S 
	and 0c7h		;97b2	e6 c7 	. . 
	ld (053ceh),a		;97b4	32 ce 53 	2 . S 
	ld a,(053dbh)		;97b7	3a db 53 	: . S 
l97bah:
	cp 0aah		;97ba	fe aa 	. . 
	ret nz			;97bc	c0 	. 
l97bdh:
	M_GOTO_YX 21,22
	ld b,1
	ld hl,053ceh
	call sub_3ae0h		;97c7	cd e0 3a 	. . : 
	ld a,(053ceh)		;97ca	3a ce 53 	: . S 
	and 001h		;97cd	e6 01 	. . 
	ret z			;97cf	c8 	. 
	ld a,005h		;97d0	3e 05 	> . 
	call OUT_CH		;97d2	cd 84 10 	. . . 
	call sub_9a27h		;97d5	cd 27 9a 	. ' . 
	ret z			;97d8	c8 	. 
l97d9h:
	ld a,(05cbah)		;97d9	3a ba 5c 	: . \ 
	cp 005h		;97dc	fe 05 	. . 
	call nz,sub_99a7h		;97de	c4 a7 99 	. . . 
	ld hl,0		;97e1	21 00 00 	! . . 
	ld (053e0h),hl		;97e4	22 e0 53 	" . S 
	ld (053e2h),hl		;97e7	22 e2 53 	" . S 
	ld a,(053ceh)		;97ea	3a ce 53 	: . S 
	and 0c7h		;97ed	e6 c7 	. . 
	ld (053ceh),a		;97ef	32 ce 53 	2 . S 
	call sub_2a82h		;97f2	cd 82 2a 	. . * 
	M_GOTO_YX 1,1
	; FReD : fix data at 960d
	M_OUT_MSG 0x960d, 0xf2 ; "EDIT CAT DEF TABLE " CRLF CRLF "REPEAT CATEGORIES " CRLF CRLF "REGION # FOR CATEGORY TEXT " CRLF "CATEGORY DEF START PAGE " CRLF "CATEGORY DEF STOP PAGE " CRLF CRLF "REGION # FOR REQUEST QUEUE " CRLF "REQUEST QUEUE PAGE # " CRLF CRLF "EDIT PROTECTED FUNCTIONS N" CRLF CRLF CRLF "INIT CAT DEF TABLE " CRLF CRLF "CLEAR CATEGORY COUNTS "
	ld a,(05cbah)
	cp 005h		;9803	fe 05 	. . 
	jr nz,l9814h		;9805	20 0d 	  . 
	M_GOTO_YX 1,20
	M_OUT_MSG 0x9764, 0x0b ; "USING BATCH"
	jr l9829h		;9812	18 15 	. . 
l9814h:
	ld a,(053ceh)		;9814	3a ce 53 	: . S 
	or 010h		;9817	f6 10 	. . 
	ld (053ceh),a		;9819	32 ce 53 	2 . S 
	M_GOTO_YX 1,20
	ld a,(053ceh)
	and 010h		;9824	e6 10 	. . 
	call sub_3b79h		;9826	cd 79 3b 	. y ; 
l9829h:
	M_GOTO_YX 3,19
	ld a,(053ceh)		;982e	3a ce 53 	: . S 
	and 002h		;9831	e6 02 	. . 
	call sub_3b79h		;9833	cd 79 3b 	. y ; 
	M_GOTO_YX 5,28
	M_OUT_VAR 0x53cf, 0x41
	M_GOTO_YX 6,25
	M_OUT_VAR 0x53d0, 0x04
	M_GOTO_YX 7,25
	M_OUT_VAR 0x53d2, 0x04
	M_GOTO_YX 9,28
	M_OUT_VAR 0x53d4, 0x41
	M_GOTO_YX 10,22
	M_OUT_VAR 0x53d5, 0x04
	M_GOTO_YX 15,20
	ld a,(053ceh)		;9872	3a ce 53 	: . S 
	and 008h		;9875	e6 08 	. . 
	call sub_3b79h		;9877	cd 79 3b 	. y ; 
	M_GOTO_YX 17,23
	ld a,(053ceh)
	and 020h		;9882	e6 20 	.   
	call sub_3b79h		;9884	cd 79 3b 	. y ; 
l9887h:
	ld a,(05cbah)		;9887	3a ba 5c 	: . \ 
	cp 005h		;988a	fe 05 	. . 
	jr z,l98a1h		;988c	28 13 	( . 
	M_GOTO_YX 1,20
	ld b,0x10
	ld hl,053ceh
	call sub_3ae0h		;9898	cd e0 3a 	. . : 
	ld a,(053ceh)		;989b	3a ce 53 	: . S 
	and 010h		;989e	e6 10 	. . 
	ret nz			;98a0	c0 	. 
l98a1h:
	M_GOTO_YX 3,19
	ld b,002h		;98a6	06 02 	. . 
	ld hl,053ceh		;98a8	21 ce 53 	! . S 
	call sub_3ae0h		;98ab	cd e0 3a 	. . : 
	M_GOTO_YX 5,28
	M_SOMETHING1 v53cf, 0x41
l98b9h:
	M_GOTO_YX 6,28
	M_SOMETHING1 v53d0, 0x04
	M_GOTO_YX 7,28
	M_SOMETHING1 v53d2, 0x04
	ld hl,(053d2h)		;98cf	2a d2 53 	* . S 
	ld de,(053d0h)		;98d2	ed 5b d0 53 	. [ . S 
	call CMP_HLDE		;98d6	cd 20 0f 	.   . 
	jr c,l98b9h		;98d9	38 de 	8 . 
	M_GOTO_YX 9,28
	M_SOMETHING1 v53d4, 0x41
	M_GOTO_YX 10,25
	M_SOMETHING1 v53d5, 0x04
	M_GOTO_YX 12,26
	ld hl,053ceh		;98f6	21 ce 53 	! . S 
	res 2,(hl)		;98f9	cb 96 	. . 
	ld b,004h		;98fb	06 04 	. . 
	call sub_3ae0h		;98fd	cd e0 3a 	. . : 
	bit 2,(hl)		;9900	cb 56 	. V 
	ret z			;9902	c8 	. 
	M_GOTO_YX 13,1
	M_OUT_MSG 0x972f, 0x0f ; "ENTER PASSWORD "
	M_GOTO_YX 13,16
	ld hl,0
	ld (053dch),hl		;9916	22 dc 53 	" . S 
	M_OUT_VAR 0x53dc, 0x03
	M_GOTO_YX 13,18
	M_SOMETHING1 v53dc, 0x03
	ld a,(053ceh)		;992a	3a ce 53 	: . S 
	and 040h		;992d	e6 40 	. @ 
	jr nz,l9941h		;992f	20 10 	  . 
	ld hl,(053dch)		;9931	2a dc 53 	* . S 
	ld (053deh),hl		;9934	22 de 53 	" . S 
	ld a,(053ceh)		;9937	3a ce 53 	: . S 
	or 040h		;993a	f6 40 	. @ 
	ld (053ceh),a		;993c	32 ce 53 	2 . S 
	jr l994ch		;993f	18 0b 	. . 
l9941h:
	ld hl,(053dch)		;9941	2a dc 53 	* . S 
	ld de,(053deh)		;9944	ed 5b de 53 	. [ . S 
	call CMP_HLDE		;9948	cd 20 0f 	.   . 
	ret nz			;994b	c0 	. 
l994ch:
	M_GOTO_YX 15,20
	ld b,008h		;9951	06 08 	. . 
	ld hl,053ceh		;9953	21 ce 53 	! . S 
	call sub_3ae0h		;9956	cd e0 3a 	. . : 
	bit 3,(hl)		;9959	cb 5e 	. ^ 
	ret nz			;995b	c0 	. 
	M_GOTO_YX 17,23
	ld b,0x20
	ld hl,053ceh
	call sub_3ae0h		;9966	cd e0 3a 	. . : 
	ld a,(053ceh)		;9969	3a ce 53 	: . S 
	and 020h		;996c	e6 20 	.   
	ret z			;996e	c8 	. 
	M_GOTO_YX 19,1
	M_OUT_MSG 0x973e, 0x26 ; "ENTER START NUMBER " CRLF "ENTER STOP NUMBER "
	M_GOTO_YX 19,20
	M_OUT_VAR 0x53e0, 0x03
l9985h:
	M_GOTO_YX 20,19
	M_OUT_VAR 0x53e2, 0x03
	M_GOTO_YX 19,22
	M_SOMETHING1 v53e0, 0x03
	M_GOTO_YX 20,21
	M_SOMETHING1 v53e2, 0x03
	ret			;99a6	c9 	. 
sub_99a7h:
	sub a			;99a7	97 	. 
	ld (06056h),a		;99a8	32 56 60 	2 V ` 
	ld (06070h),a		;99ab	32 70 60 	2 p ` 
	ld (06071h),a		;99ae	32 71 60 	2 q ` 
	ld ix,06057h		;99b1	dd 21 57 60 	. ! W ` 
	ld a,020h		;99b5	3e 20 	>   
	ld (ix+000h),a		;99b7	dd 77 00 	. w . 
	ld (ix+001h),a		;99ba	dd 77 01 	. w . 
	ld (ix+002h),a		;99bd	dd 77 02 	. w . 
	ld hl,0		;99c0	21 00 00 	! . . 
	ld (05b8dh),hl		;99c3	22 8d 5b 	" . [ 
	ld (05b8fh),hl		;99c6	22 8f 5b 	" . [ 
	ret			;99c9	c9 	. 
	ld a,(05b7bh)		;99ca	3a 7b 5b 	: { [ 
	bit 4,a		;99cd	cb 67 	. g 
	jr nz,l99dch		;99cf	20 0b 	  . 
	bit 3,a		;99d1	cb 5f 	. _ 
	jp nz,sub_9bfch		;99d3	c2 fc 9b 	. . . 
	bit 5,a		;99d6	cb 6f 	. o 
	jp nz,sub_9c4ah		;99d8	c2 4a 9c 	. J . 
	ret			;99db	c9 	. 
l99dch:
	M_GOTO_YX 2,1
	M_OUT_MSG 0x96ff, 0x16 ; "ENTER CATEGORY NUMBER "
	M_GOTO_YX 2,23
	M_OUT_VAR 0x60c7, 0x03
	M_GOTO_YX 2,25
	M_SOMETHING1 v60c7, 0x03
	ld hl,(060c7h)		;99fd	2a c7 60 	* . ` 
	call sub_9b71h		;9a00	cd 71 9b 	. q . 
	ld a,c			;9a03	79 	y 
	cp 0ffh		;9a04	fe ff 	. . 
	jr nz,l9a16h		;9a06	20 0e 	  . 
	M_GOTO_YX 3,1
	M_OUT_MSG 0x9715,0x1a
	jp l9887h		;9a13	c3 87 98 	. . . 
l9a16h:
	ld b,000h		;9a16	06 00 	. . 
	push bc			;9a18	c5 	. 
	push hl			;9a19	e5 	. 
	call sub_9a89h		;9a1a	cd 89 9a 	. . . 
	call sub_9aa9h		;9a1d	cd a9 9a 	. . . 
	pop hl			;9a20	e1 	. 
	pop bc			;9a21	c1 	. 
	ld b,001h		;9a22	06 01 	. . 
	jp sub_9a89h		;9a24	c3 89 9a 	. . . 
sub_9a27h:
	ld a,(053dbh)		;9a27	3a db 53 	: . S 
	cp 0aah		;9a2a	fe aa 	. . 
	jr z,l9a30h		;9a2c	28 02 	( . 
	cp a			;9a2e	bf 	. 
	ret			;9a2f	c9 	. 
l9a30h:
	ld a,(053ceh)		;9a30	3a ce 53 	: . S 
	and 001h		;9a33	e6 01 	. . 
	ret z			;9a35	c8 	. 
	M_OUT_MSG 0x976f, 0x1e ; "EDIT PUBLIC ACCESS VARIABLES N"
	M_LEFT 1
	ld hl,v53ce
	res 2,(hl)		;9a43	cb 96 	. . 
	ld b,004h		;9a45	06 04 	. . 
	call sub_3ae0h		;9a47	cd e0 3a 	. . : 
	bit 2,(hl)		;9a4a	cb 56 	. V 
	ret			;9a4c	c9 	. 
	jr nz,l9a6fh		;9a4d	20 20 	    
	ld b,e			;9a4f	43 	C 
	ld b,c			;9a50	41 	A 
	ld d,h			;9a51	54 	T 
	ld b,l			;9a52	45 	E 
	ld b,a			;9a53	47 	G 
	ld c,a			;9a54	4f 	O 
	ld d,d			;9a55	52 	R 
	ld e,c			;9a56	59 	Y 
	jr nz,l9a9dh		;9a57	20 44 	  D 
	ld b,l			;9a59	45 	E 
	ld b,(hl)			;9a5a	46 	F 
	ld c,c			;9a5b	49 	I 
	ld c,(hl)			;9a5c	4e 	N 
	ld c,c			;9a5d	49 	I 
	ld d,h			;9a5e	54 	T 
	ld c,c			;9a5f	49 	I 
	ld c,a			;9a60	4f 	O 
	ld c,(hl)			;9a61	4e 	N 
	jr nz,l9ab8h		;9a62	20 54 	  T 
	ld b,c			;9a64	41 	A 
	ld b,d			;9a65	42 	B 
	ld c,h			;9a66	4c 	L 
	ld b,l			;9a67	45 	E 
	dec b			;9a68	05 	. 
	jr nz,$+34		;9a69	20 20 	    
	ld b,e			;9a6b	43 	C 
	ld b,c			;9a6c	41 	A 
	ld d,h			;9a6d	54 	T 
	ld b,l			;9a6e	45 	E 
l9a6fh:
	ld b,a			;9a6f	47 	G 
	ld c,a			;9a70	4f 	O 
	ld d,d			;9a71	52 	R 
	ld e,c			;9a72	59 	Y 
	jr nz,$+34		;9a73	20 20 	    
	ld d,e			;9a75	53 	S 
	ld d,h			;9a76	54 	T 
	ld b,c			;9a77	41 	A 
	ld d,d			;9a78	52 	R 
	ld d,h			;9a79	54 	T 
	jr nz,$+34		;9a7a	20 20 	    
	ld d,e			;9a7c	53 	S 
	ld d,h			;9a7d	54 	T 
	ld c,a			;9a7e	4f 	O 
	ld d,b			;9a7f	50 	P 
	jr nz,l9aa2h		;9a80	20 20 	    
	jr nz,$+34		;9a82	20 20 	    
	ld b,e			;9a84	43 	C 
	ld c,a			;9a85	4f 	O 
	ld d,l			;9a86	55 	U 
	ld c,(hl)			;9a87	4e 	N 
	ld d,h			;9a88	54 	T 
sub_9a89h:
	push hl			;9a89	e5 	. 
	ld a,(05b7ch)		;9a8a	3a 7c 5b 	: | [ 
	call sub_07f9h		;9a8d	cd f9 07 	. . . 
	call SETMEMMAP		;9a90	cd 1a 0f 	. . . 
	ld de,000b8h		;9a93	11 b8 00 	. . . 
	dec c			;9a96	0d 	. 
	jr z,l9a9ah		;9a97	28 01 	( . 
	add hl,de			;9a99	19 	. 
l9a9ah:
	ld de,v53c2		;9a9a	11 c2 53 	. . S 
l9a9dh:
	ld a,b			;9a9d	78 	x 
	and a			;9a9e	a7 	. 
	jr z,l9aa2h		;9a9f	28 01 	( . 
	ex de,hl			;9aa1	eb 	. 
l9aa2h:
	ld bc,000b8h		;9aa2	01 b8 00 	. . . 
	ldir		;9aa5	ed b0 	. . 
	pop hl			;9aa7	e1 	. 
	ret			;9aa8	c9 	. 
sub_9aa9h:
	call sub_2a82h		;9aa9	cd 82 2a 	. . * 
	ld bc,00101h		;9aac	01 01 01 	. . . 
	call U_OUT_0F040B_09_0E		;9aaf	cd 48 15 	. H . 
	M_OUT_MSG 0x9a4d,0x3c
l9ab8h:
	ld hl,00201h		;9ab8	21 01 02 	! . . 
	ld a,017h		;9abb	3e 17 	> . 
	ld iy,v53c2		;9abd	fd 21 c2 53 	. ! . S 
l9ac1h:
	push hl			;9ac1	e5 	. 
	ld de,003e8h		;9ac2	11 e8 03 	. . . 
	ld l,(iy+000h)		;9ac5	fd 6e 00 	. n . 
	ld h,(iy+001h)		;9ac8	fd 66 01 	. f . 
	call CMP_HLDE		;9acb	cd 20 0f 	.   . 
	pop hl			;9ace	e1 	. 
	jr nc,l9b0eh		;9acf	30 3d 	0 = 
	ld bc,00100h		;9ad1	01 00 01 	. . . 
	add hl,bc			;9ad4	09 	. 
	push hl			;9ad5	e5 	. 
	pop bc			;9ad6	c1 	. 
	call U_OUT_0F040B_09_0E		;9ad7	cd 48 15 	. H . 
	push af			;9ada	f5 	. 
	push hl			;9adb	e5 	. 
	call RIGHT_INLINE		;9adc	cd 70 15 	. p . 
	inc bc			;9adf	03 	. 
	M_OUT_VAR 0x0000, 0x03
	call RIGHT_INLINE		;9ae6	cd 70 15 	. p . 
	ld b,0cdh		;9ae9	06 cd 	. . 
	ld sp,00214h		;9aeb	31 14 02 	1 . . 
	nop			;9aee	00 	. 
	inc b			;9aef	04 	. 
	call RIGHT_INLINE		;9af0	cd 70 15 	. p . 
	inc bc			;9af3	03 	. 
	M_OUT_VAR 0x0004, 0x04
	call RIGHT_INLINE		;9afa	cd 70 15 	. p . 
	inc b			;9afd	04 	. 
	M_OUT_VAR 0x0006, 0x04
	pop hl			;9b04	e1 	. 
	pop af			;9b05	f1 	. 
	ld bc,00008h		;9b06	01 08 00 	. . . 
	add iy,bc		;9b09	fd 09 	. . 
	dec a			;9b0b	3d 	= 
	jr nz,l9ac1h		;9b0c	20 b3 	  . 
l9b0eh:
	ld hl,00201h		;9b0e	21 01 02 	! . . 
	ld a,017h		;9b11	3e 17 	> . 
	ld iy,v53c2		;9b13	fd 21 c2 53 	. ! . S 
l9b17h:
	push hl			;9b17	e5 	. 
	ld de,003e8h		;9b18	11 e8 03 	. . . 
	ld l,(iy+000h)		;9b1b	fd 6e 00 	. n . 
	ld h,(iy+001h)		;9b1e	fd 66 01 	. f . 
	call CMP_HLDE		;9b21	cd 20 0f 	.   . 
	pop hl			;9b24	e1 	. 
	ret nc			;9b25	d0 	. 
	ld bc,00100h		;9b26	01 00 01 	. . . 
	add hl,bc			;9b29	09 	. 
	push hl			;9b2a	e5 	. 
	pop bc			;9b2b	c1 	. 
	call U_OUT_0F040B_09_0E		;9b2c	cd 48 15 	. H . 
	push af			;9b2f	f5 	. 
	push hl			;9b30	e5 	. 
	call RIGHT_INLINE		;9b31	cd 70 15 	. p . 
	dec b			;9b34	05 	. 
	; Adrs is IY
	M_SOMETHING1 0x0000, 0x03
	call RIGHT_INLINE		;9b3b	cd 70 15 	. p . 
	ld a,(bc)			;9b3e	0a 	. 
l9b3fh:
	; Adrs is IY+4
	M_SOMETHING1 0x0002, 0x04
	call RIGHT_INLINE		;9b45	cd 70 15 	. p . 
	rlca			;9b48	07 	. 
	; Adrs is IY+4
	M_SOMETHING1 0x0004, 0x04
	ld l,(iy+004h)		;9b4f	fd 6e 04 	. n . 
	ld h,(iy+005h)		;9b52	fd 66 05 	. f . 
	ld e,(iy+002h)		;9b55	fd 5e 02 	. ^ . 
	ld d,(iy+003h)		;9b58	fd 56 03 	. V . 
	call CMP_HLDE		;9b5b	cd 20 0f 	.   . 
	jr nc,l9b66h		;9b5e	30 06 	0 . 
	call LEFT_INLINE		;9b60	cd 6c 15 	. l . 
	rlca			;9b63	07 	. 
	jr l9b3fh		;9b64	18 d9 	. . 
l9b66h:
	pop hl			;9b66	e1 	. 
	pop af			;9b67	f1 	. 
	ld bc,00008h		;9b68	01 08 00 	. . . 
	add iy,bc		;9b6b	fd 09 	. . 
	dec a			;9b6d	3d 	= 
	jr nz,l9b17h		;9b6e	20 a7 	  . 
	ret			;9b70	c9 	. 
sub_9b71h:
	ex de,hl			;9b71	eb 	. 
	ld hl,(05b7dh)		;9b72	2a 7d 5b 	* } [ 
l9b75h:
	push hl			;9b75	e5 	. 
	ld a,(05b7ch)		;9b76	3a 7c 5b 	: | [ 
	call sub_07f9h		;9b79	cd f9 07 	. . . 
	call SETMEMMAP		;9b7c	cd 1a 0f 	. . . 
	push hl			;9b7f	e5 	. 
	pop ix		;9b80	dd e1 	. . 
	ld b,002h		;9b82	06 02 	. . 
l9b84h:
	push bc			;9b84	c5 	. 
	ld b,017h		;9b85	06 17 	. . 
l9b87h:
	push bc			;9b87	c5 	. 
	ld l,(ix+000h)		;9b88	dd 6e 00 	. n . 
	ld h,(ix+001h)		;9b8b	dd 66 01 	. f . 
	call CMP_HLDE		;9b8e	cd 20 0f 	.   . 
	jr z,l9badh		;9b91	28 1a 	( . 
	ld bc,00008h		;9b93	01 08 00 	. . . 
	add ix,bc		;9b96	dd 09 	. . 
	pop bc			;9b98	c1 	. 
	djnz l9b87h		;9b99	10 ec 	. . 
	pop bc			;9b9b	c1 	. 
	djnz l9b84h		;9b9c	10 e6 	. . 
	pop hl			;9b9e	e1 	. 
	push de			;9b9f	d5 	. 
	ld de,(05b7fh)		;9ba0	ed 5b 7f 5b 	. [  [ 
	call CMP_HLDE		;9ba4	cd 20 0f 	.   . 
	pop de			;9ba7	d1 	. 
	jr z,l9bb5h		;9ba8	28 0b 	( . 
	inc hl			;9baa	23 	# 
	jr l9b75h		;9bab	18 c8 	. . 
l9badh:
	pop bc			;9bad	c1 	. 
	pop bc			;9bae	c1 	. 
	ld a,003h		;9baf	3e 03 	> . 
	sub b			;9bb1	90 	. 
	ld c,a			;9bb2	4f 	O 
	pop hl			;9bb3	e1 	. 
	ret			;9bb4	c9 	. 
l9bb5h:
	ld c,0ffh		;9bb5	0e ff 	. . 
	ret			;9bb7	c9 	. 
sub_9bb8h:
	call sub_9b71h		;9bb8	cd 71 9b 	. q . 
	ld a,c			;9bbb	79 	y 
	cp 0ffh		;9bbc	fe ff 	. . 
	ret z			;9bbe	c8 	. 
	inc (ix+006h)		;9bbf	dd 34 06 	. 4 . 
	ret nz			;9bc2	c0 	. 
	inc (ix+007h)		;9bc3	dd 34 07 	. 4 . 
	ret			;9bc6	c9 	. 
	ld hl,(05b7dh)		;9bc7	2a 7d 5b 	* } [ 
l9bcah:
	push hl			;9bca	e5 	. 
	ld a,(05b7ch)		;9bcb	3a 7c 5b 	: | [ 
	call sub_07f9h		;9bce	cd f9 07 	. . . 
	call SETMEMMAP		;9bd1	cd 1a 0f 	. . . 
	push hl			;9bd4	e5 	. 
	pop ix		;9bd5	dd e1 	. . 
	ld b,002h		;9bd7	06 02 	. . 
l9bd9h:
	push bc			;9bd9	c5 	. 
	ld b,017h		;9bda	06 17 	. . 
l9bdch:
	push bc			;9bdc	c5 	. 
	ld (ix+006h),000h		;9bdd	dd 36 06 00 	. 6 . . 
	ld (ix+007h),000h		;9be1	dd 36 07 00 	. 6 . . 
	ld bc,00008h		;9be5	01 08 00 	. . . 
	add ix,bc		;9be8	dd 09 	. . 
	pop bc			;9bea	c1 	. 
	djnz l9bdch		;9beb	10 ef 	. . 
	pop bc			;9bed	c1 	. 
	djnz l9bd9h		;9bee	10 e9 	. . 
	pop hl			;9bf0	e1 	. 
	ld de,(05b7fh)		;9bf1	ed 5b 7f 5b 	. [  [ 
	call CMP_HLDE		;9bf5	cd 20 0f 	.   . 
	ret z			;9bf8	c8 	. 
	inc hl			;9bf9	23 	# 
	jr l9bcah		;9bfa	18 ce 	. . 
sub_9bfch:
	ld de,0		;9bfc	11 00 00 	. . . 
	ld hl,(05b7dh)		;9bff	2a 7d 5b 	* } [ 
l9c02h:
	push hl			;9c02	e5 	. 
	push de			;9c03	d5 	. 
	ld a,(05b7ch)		;9c04	3a 7c 5b 	: | [ 
	call sub_07f9h		;9c07	cd f9 07 	. . . 
	call SETMEMMAP		;9c0a	cd 1a 0f 	. . . 
	pop de			;9c0d	d1 	. 
	push hl			;9c0e	e5 	. 
	pop ix		;9c0f	dd e1 	. . 
	ld b,002h		;9c11	06 02 	. . 
l9c13h:
	push bc			;9c13	c5 	. 
	ld b,017h		;9c14	06 17 	. . 
l9c16h:
	push bc			;9c16	c5 	. 
	ld (ix+000h),e		;9c17	dd 73 00 	. s . 
	ld (ix+001h),d		;9c1a	dd 72 01 	. r . 
	inc de			;9c1d	13 	. 
	xor a			;9c1e	af 	. 
	ld (ix+002h),a		;9c1f	dd 77 02 	. w . 
	ld (ix+003h),a		;9c22	dd 77 03 	. w . 
	ld (ix+004h),a		;9c25	dd 77 04 	. w . 
	ld (ix+005h),a		;9c28	dd 77 05 	. w . 
	ld (ix+006h),a		;9c2b	dd 77 06 	. w . 
	ld (ix+007h),a		;9c2e	dd 77 07 	. w . 
	ld bc,00008h		;9c31	01 08 00 	. . . 
	add ix,bc		;9c34	dd 09 	. . 
	pop bc			;9c36	c1 	. 
	djnz l9c16h		;9c37	10 dd 	. . 
	pop bc			;9c39	c1 	. 
	djnz l9c13h		;9c3a	10 d7 	. . 
	pop hl			;9c3c	e1 	. 
	push de			;9c3d	d5 	. 
	ld de,(05b7fh)		;9c3e	ed 5b 7f 5b 	. [  [ 
	call CMP_HLDE		;9c42	cd 20 0f 	.   . 
	pop de			;9c45	d1 	. 
	ret z			;9c46	c8 	. 
	inc hl			;9c47	23 	# 
	jr l9c02h		;9c48	18 b8 	. . 
sub_9c4ah:
	ld hl,0		;9c4a	21 00 00 	! . . 
	ld (060c9h),hl		;9c4d	22 c9 60 	" . ` 
	ld de,(05b8dh)		;9c50	ed 5b 8d 5b 	. [ . [ 
l9c54h:
	call sub_0334h		;9c54	cd 34 03 	. 4 . 
	ld hl,(05b8fh)		;9c57	2a 8f 5b 	* . [ 
	call CMP_HLDE		;9c5a	cd 20 0f 	.   . 
	jr c,l9c8ch		;9c5d	38 2d 	8 - 
	push de			;9c5f	d5 	. 
	ex de,hl			;9c60	eb 	. 
	call sub_9b71h		;9c61	cd 71 9b 	. q . 
	ld a,c			;9c64	79 	y 
	cp 0ffh		;9c65	fe ff 	. . 
	jr z,l9c88h		;9c67	28 1f 	( . 
	pop de			;9c69	d1 	. 
	push de			;9c6a	d5 	. 
	ld hl,0		;9c6b	21 00 00 	! . . 
	call CMP_HLDE		;9c6e	cd 20 0f 	.   . 
	jr z,l9c80h		;9c71	28 0d 	( . 
	ld e,(ix+006h)		;9c73	dd 5e 06 	. ^ . 
	ld d,(ix+007h)		;9c76	dd 56 07 	. V . 
	ld hl,(060c9h)		;9c79	2a c9 60 	* . ` 
	add hl,de			;9c7c	19 	. 
	ld (060c9h),hl		;9c7d	22 c9 60 	" . ` 
l9c80h:
	ld (ix+006h),000h		;9c80	dd 36 06 00 	. 6 . . 
	ld (ix+007h),000h		;9c84	dd 36 07 00 	. 6 . . 
l9c88h:
	pop de			;9c88	d1 	. 
	inc de			;9c89	13 	. 
	jr l9c54h		;9c8a	18 c8 	. . 
l9c8ch:
	ld hl,0		;9c8c	21 00 00 	! . . 
	call sub_9b71h		;9c8f	cd 71 9b 	. q . 
	ld l,(ix+006h)		;9c92	dd 6e 06 	. n . 
	ld h,(ix+007h)		;9c95	dd 66 07 	. f . 
	ld de,(060c9h)		;9c98	ed 5b c9 60 	. [ . ` 
	and a			;9c9c	a7 	. 
	sbc hl,de		;9c9d	ed 52 	. R 
	ret c			;9c9f	d8 	. 
	ld (ix+006h),l		;9ca0	dd 75 06 	. u . 
	ld (ix+007h),h		;9ca3	dd 74 07 	. t . 
	ret			;9ca6	c9 	. 
sub_9ca7h:
	ld a,(0609dh)		;9ca7	3a 9d 60 	: . ` 
	or a			;9caa	b7 	. 
	ret nz			;9cab	c0 	. 
	call sub_9d1ch		;9cac	cd 1c 9d 	. . . 
	push ix		;9caf	dd e5 	. . 
	xor a			;9cb1	af 	. 
	ld (ix+000h),a		;9cb2	dd 77 00 	. w . 
	ld (ix+001h),a		;9cb5	dd 77 01 	. w . 
	ld (ix+002h),a		;9cb8	dd 77 02 	. w . 
	ld (ix+003h),a		;9cbb	dd 77 03 	. w . 
	pop hl			;9cbe	e1 	. 
	ld de,0609eh		;9cbf	11 9e 60 	. . ` 
	ld bc,00027h		;9cc2	01 27 00 	. ' . 
	ldir		;9cc5	ed b0 	. . 
	ld a,001h		;9cc7	3e 01 	> . 
	ld (0609dh),a		;9cc9	32 9d 60 	2 . ` 
	push ix		;9ccc	dd e5 	. . 
	ld b,027h		;9cce	06 27 	. ' 
	xor a			;9cd0	af 	. 
l9cd1h:
	ld (ix+000h),a		;9cd1	dd 77 00 	. w . 
	inc ix		;9cd4	dd 23 	. # 
	djnz l9cd1h		;9cd6	10 f9 	. . 
	pop ix		;9cd8	dd e1 	. . 
	ld (ix+005h),001h		;9cda	dd 36 05 01 	. 6 . . 
	ld (ix+006h),a		;9cde	dd 77 06 	. w . 
	ld hl,(05b82h)		;9ce1	2a 82 5b 	* . [ 
	ld (ix+007h),l		;9ce4	dd 75 07 	. u . 
	ld (ix+008h),h		;9ce7	dd 74 08 	. t . 
	ld (ix+009h),l		;9cea	dd 75 09 	. u . 
	ld (ix+00ah),h		;9ced	dd 74 0a 	. t . 
	ld (ix+00bh),001h		;9cf0	dd 36 0b 01 	. 6 . . 
	ld (ix+00ch),a		;9cf4	dd 77 0c 	. w . 
	ld (ix+00dh),l		;9cf7	dd 75 0d 	. u . 
	ld (ix+00eh),h		;9cfa	dd 74 0e 	. t . 
	ld a,(05b81h)		;9cfd	3a 81 5b 	: . [ 
	call sub_33a3h		;9d00	cd a3 33 	. . 3 
	ret			;9d03	c9 	. 
sub_9d04h:
	ld a,(0609dh)		;9d04	3a 9d 60 	: . ` 
	or a			;9d07	b7 	. 
	ret z			;9d08	c8 	. 
	call sub_9d1ch		;9d09	cd 1c 9d 	. . . 
	push ix		;9d0c	dd e5 	. . 
	pop de			;9d0e	d1 	. 
	ld hl,0609eh		;9d0f	21 9e 60 	! . ` 
	ld bc,00027h		;9d12	01 27 00 	. ' . 
	ldir		;9d15	ed b0 	. . 
	sub a			;9d17	97 	. 
	ld (0609dh),a		;9d18	32 9d 60 	2 . ` 
	ret			;9d1b	c9 	. 
sub_9d1ch:
	ld a,(05b81h)		;9d1c	3a 81 5b 	: . [ 
	ld b,a			;9d1f	47 	G 
	ld e,027h		;9d20	1e 27 	. ' 
	ld d,000h		;9d22	16 00 	. . 
	ld ix,052a4h		;9d24	dd 21 a4 52 	. ! . R 
l9d28h:
	add ix,de		;9d28	dd 19 	. . 
	djnz l9d28h		;9d2a	10 fc 	. . 
	ret			;9d2c	c9 	. 
sub_9d2dh:
	ld a,(06054h)		;9d2d	3a 54 60 	: T ` 
	cp 0ffh		;9d30	fe ff 	. . 
	jr nz,l9d50h		;9d32	20 1c 	  . 
	ld a,(060cch)		;9d34	3a cc 60 	: . ` 
	or a			;9d37	b7 	. 
	jp nz,l9e27h		;9d38	c2 27 9e 	. ' . 
	ld a,010h		;9d3b	3e 10 	> . 
	out (PORT_12),a		;9d3d	d3 12 	. . 
	in a,(PORT_12)		;9d3f	db 12 	. . 
	and 008h		;9d41	e6 08 	. . 
	jp z,l9e0dh		;9d43	ca 0d 9e 	. . . 
	sub a			;9d46	97 	. 
	ld (06054h),a		;9d47	32 54 60 	2 T ` 
	ld (060cch),a		;9d4a	32 cc 60 	2 . ` 
	call sub_9ca7h		;9d4d	cd a7 9c 	. . . 
l9d50h:
	ld de,FIFO3
	call FIFO_READ		;9d53	cd e1 0e 	. . . 
	jp c,l9debh		;9d56	da eb 9d 	. . . 
	and 03fh		;9d59	e6 3f 	. ? 
	cp 03ah		;9d5b	fe 3a 	. : 
	jr nz,l9d61h		;9d5d	20 02 	  . 
	ld a,030h		;9d5f	3e 30 	> 0 
l9d61h:
	ld (06055h),a		;9d61	32 55 60 	2 U ` 
	sub 030h		;9d64	d6 30 	. 0 
	ret c			;9d66	d8 	. 
	ld a,(06055h)		;9d67	3a 55 60 	: U ` 
	sub 03ah		;9d6a	d6 3a 	. : 
	jp nc,l9e27h		;9d6c	d2 27 9e 	. ' . 
	ld hl,06057h		;9d6f	21 57 60 	! W ` 
	ld a,(06056h)		;9d72	3a 56 60 	: V ` 
	ld c,a			;9d75	4f 	O 
	ld b,000h		;9d76	06 00 	. . 
	add hl,bc			;9d78	09 	. 
	ld a,(06055h)		;9d79	3a 55 60 	: U ` 
	ld (hl),a			;9d7c	77 	w 
	ld a,c			;9d7d	79 	y 
	inc a			;9d7e	3c 	< 
	ld (06056h),a		;9d7f	32 56 60 	2 V ` 
	call sub_9f11h		;9d82	cd 11 9f 	. . . 
	ld a,(06056h)		;9d85	3a 56 60 	: V ` 
	cp 003h		;9d88	fe 03 	. . 
	jr c,l9de8h		;9d8a	38 5c 	8 \ 
	ld c,003h		;9d8c	0e 03 	. . 
	ld de,06057h		;9d8e	11 57 60 	. W ` 
	call STR2NUM		;9d91	cd 54 0f 	. T . 
	ld (0605ah),hl		;9d94	22 5a 60 	" Z ` 
	call sub_9eb4h		;9d97	cd b4 9e 	. . . 
	ld hl,(0605ah)		;9d9a	2a 5a 60 	* Z ` 
	call sub_9bb8h		;9d9d	cd b8 9b 	. . . 
	ld a,c			;9da0	79 	y 
	cp 0ffh		;9da1	fe ff 	. . 
	jp z,l9e1bh		;9da3	ca 1b 9e 	. . . 
	ld hl,0		;9da6	21 00 00 	! . . 
	call sub_9bb8h		;9da9	cd b8 9b 	. . . 
	ld hl,(0605ah)		;9dac	2a 5a 60 	* Z ` 
	call sub_9b71h		;9daf	cd 71 9b 	. q . 
	ld de,0		;9db2	11 00 00 	. . . 
	ld l,(ix+002h)		;9db5	dd 6e 02 	. n . 
	ld h,(ix+003h)		;9db8	dd 66 03 	. f . 
	call CMP_HLDE		;9dbb	cd 20 0f 	.   . 
	jr nz,l9dcbh		;9dbe	20 0b 	  . 
	ld l,(ix+004h)		;9dc0	dd 6e 04 	. n . 
	ld h,(ix+005h)		;9dc3	dd 66 05 	. f . 
	call CMP_HLDE		;9dc6	cd 20 0f 	.   . 
	jr z,l9e1bh		;9dc9	28 50 	( P 
l9dcbh:
	ld hl,(0605ah)		;9dcb	2a 5a 60 	* Z ` 
	call sub_9f76h		;9dce	cd 76 9f 	. v . 
	ld a,(06070h)		;9dd1	3a 70 60 	: p ` 
	cp 001h		;9dd4	fe 01 	. . 
	jr nz,l9ddch		;9dd6	20 04 	  . 
	sub a			;9dd8	97 	. 
	ld (06071h),a		;9dd9	32 71 60 	2 q ` 
l9ddch:
	ld a,(06070h)		;9ddc	3a 70 60 	: p ` 
	cp 00ah		;9ddf	fe 0a 	. . 
	jr c,l9de8h		;9de1	38 05 	8 . 
	ld a,0a2h		;9de3	3e a2 	> . 
	ld (060ceh),a		;9de5	32 ce 60 	2 . ` 
l9de8h:
	call sub_9f11h		;9de8	cd 11 9f 	. . . 
l9debh:
	ld a,(060cdh)		;9deb	3a cd 60 	: . ` 
	or a			;9dee	b7 	. 
	jr nz,l9e0dh		;9def	20 1c 	  . 
	ld a,(060cch)		;9df1	3a cc 60 	: . ` 
	or a			;9df4	b7 	. 
	jr nz,l9e0dh		;9df5	20 16 	  . 
	ld a,010h		;9df7	3e 10 	> . 
	out (PORT_12),a		;9df9	d3 12 	. . 
	in a,(PORT_12)		;9dfb	db 12 	. . 
	and %00001000
	jr nz,l9e0dh		;9dff	20 0c 	  . 
	call sub_9eb4h		;9e01	cd b4 9e 	. . . 
	ld a,(06070h)		;9e04	3a 70 60 	: p ` 
	or a			;9e07	b7 	. 
	jr nz,l9e0dh		;9e08	20 03 	  . 
	call sub_9d04h		;9e0a	cd 04 9d 	. . . 
l9e0dh:
	ld a,(06054h)		;9e0d	3a 54 60 	: T ` 
	cp 0ffh		;9e10	fe ff 	. . 
	jr z,l9e27h		;9e12	28 13 	( . 
	cp 00bh		;9e14	fe 0b 	. . 
	jr c,l9e27h		;9e16	38 0f 	8 . 
	call sub_9eb4h		;9e18	cd b4 9e 	. . . 
l9e1bh:
	call sub_9f11h		;9e1b	cd 11 9f 	. . . 
	ld a,(06070h)		;9e1e	3a 70 60 	: p ` 
	or a			;9e21	b7 	. 
	jr nz,l9e27h		;9e22	20 03 	  . 
	call sub_9d04h		;9e24	cd 04 9d 	. . . 
l9e27h:
	ld a,(06072h)		;9e27	3a 72 60 	: r ` 
	or a			;9e2a	b7 	. 
	jr z,l9e75h		;9e2b	28 48 	( H 
	call sub_9fb8h		;9e2d	cd b8 9f 	. . . 
	call sub_9f11h		;9e30	cd 11 9f 	. . . 
	ld a,0a0h		;9e33	3e a0 	> . 
	ld (060ceh),a		;9e35	32 ce 60 	2 . ` 
	sub a			;9e38	97 	. 
	ld (06072h),a		;9e39	32 72 60 	2 r ` 
	ld a,(06070h)		;9e3c	3a 70 60 	: p ` 
	or a			;9e3f	b7 	. 
	jr z,l9e67h		;9e40	28 25 	( % 
	ld iy,06073h		;9e42	fd 21 73 60 	. ! s ` 
	ld a,(iy+002h)		;9e46	fd 7e 02 	. ~ . 
	ld (iy+000h),a		;9e49	fd 77 00 	. w . 
	ld a,(iy+003h)		;9e4c	fd 7e 03 	. ~ . 
	ld (iy+001h),a		;9e4f	fd 77 01 	. w . 
	ld a,(iy+004h)		;9e52	fd 7e 04 	. ~ . 
	ld (iy+002h),a		;9e55	fd 77 02 	. w . 
	ld a,(iy+005h)		;9e58	fd 7e 05 	. ~ . 
	ld (iy+003h),a		;9e5b	fd 77 03 	. w . 
	sub a			;9e5e	97 	. 
	ld (iy+004h),a		;9e5f	fd 77 04 	. w . 
	ld (iy+005h),a		;9e62	fd 77 05 	. w . 
	jr l9e75h		;9e65	18 0e 	. . 
l9e67h:
	call sub_9d04h		;9e67	cd 04 9d 	. . . 
	ld b,006h		;9e6a	06 06 	. . 
	sub a			;9e6c	97 	. 
	ld hl,06073h		;9e6d	21 73 60 	! s ` 
l9e70h:
	ld (hl),a			;9e70	77 	w 
	inc hl			;9e71	23 	# 
	djnz l9e70h		;9e72	10 fc 	. . 
	ret			;9e74	c9 	. 
l9e75h:
	ld a,(06070h)		;9e75	3a 70 60 	: p ` 
	ld b,a			;9e78	47 	G 
	ld a,(06071h)		;9e79	3a 71 60 	: q ` 
	sub b			;9e7c	90 	. 
	ret nc			;9e7d	d0 	. 
	ld ix,05fb7h		;9e7e	dd 21 b7 5f 	. ! . _ 
	ld a,(05b7ch)		;9e82	3a 7c 5b 	: | [ 
	dec a			;9e85	3d 	= 
	ld c,a			;9e86	4f 	O 
	sla c		;9e87	cb 21 	. ! 
	sla c		;9e89	cb 21 	. ! 
	ld b,000h		;9e8b	06 00 	. . 
	add ix,bc		;9e8d	dd 09 	. . 
	ld de,0		;9e8f	11 00 00 	. . . 
	ld l,(ix+000h)		;9e92	dd 6e 00 	. n . 
	ld h,(ix+001h)		;9e95	dd 66 01 	. f . 
	call CMP_HLDE		;9e98	cd 20 0f 	.   . 
	ret nz			;9e9b	c0 	. 
	ld l,(ix+002h)		;9e9c	dd 6e 02 	. n . 
	ld h,(ix+003h)		;9e9f	dd 66 03 	. f . 
	call CMP_HLDE		;9ea2	cd 20 0f 	.   . 
	ret nz			;9ea5	c0 	. 
	call sub_9fe4h		;9ea6	cd e4 9f 	. . . 
	call sub_9f11h		;9ea9	cd 11 9f 	. . . 
	ld a,(06071h)		;9eac	3a 71 60 	: q ` 
	inc a			;9eaf	3c 	< 
	ld (06071h),a		;9eb0	32 71 60 	2 q ` 
	ret			;9eb3	c9 	. 
sub_9eb4h:
	ld a,005h		;9eb4	3e 05 	> . 
	out (PORT_12),a		;9eb6	d3 12 	. . 
	ld a,020h		;9eb8	3e 20 	>   
	out (PORT_12),a		;9eba	d3 12 	. . 
	ld a,001h		;9ebc	3e 01 	> . 
	ld (060cch),a		;9ebe	32 cc 60 	2 . ` 
	ld a,0ffh		;9ec1	3e ff 	> . 
	ld (06054h),a		;9ec3	32 54 60 	2 T ` 
	sub a			;9ec6	97 	. 
	ld (060cdh),a		;9ec7	32 cd 60 	2 . ` 
	ld (06056h),a		;9eca	32 56 60 	2 V ` 
	ld ix,06057h		;9ecd	dd 21 57 60 	. ! W ` 
	ld a,020h		;9ed1	3e 20 	>   
	ld (ix+000h),a		;9ed3	dd 77 00 	. w . 
	ld (ix+001h),a		;9ed6	dd 77 01 	. w . 
	ld (ix+002h),a		;9ed9	dd 77 02 	. w . 
	ret			;9edc	c9 	. 
	rlca			;9edd	07 	. 
	ld hl,05b7bh		;9ede	21 7b 5b 	! { [ 
	ld b,009h		;9ee1	06 09 	. . 
	sub a			;9ee3	97 	. 
l9ee4h:
	ld (hl),a			;9ee4	77 	w 
	inc hl			;9ee5	23 	# 
	djnz l9ee4h		;9ee6	10 fc 	. . 
	ld hl,06054h		;9ee8	21 54 60 	! T ` 
	ld b,07bh		;9eeb	06 7b 	. { 
l9eedh:
	ld (hl),a			;9eed	77 	w 
	inc hl			;9eee	23 	# 
	djnz l9eedh		;9eef	10 fc 	. . 
	ld a,(CFG3)		;9ef1	3a 0a 00 	: . . 
	ld (05b88h),a		;9ef4	32 88 5b 	2 . [ 
	ld hl,0605ch		;9ef7	21 5c 60 	! \ ` 
	ld b,014h		;9efa	06 14 	. . 
	ld a,0ffh		;9efc	3e ff 	> . 
l9efeh:
	ld (hl),a			;9efe	77 	w 
	inc hl			;9eff	23 	# 
	djnz l9efeh		;9f00	10 fc 	. . 
	ld (06054h),a		;9f02	32 54 60 	2 T ` 
	ld a,0a0h		;9f05	3e a0 	> . 
	ld (060ceh),a		;9f07	32 ce 60 	2 . ` 
	ld hl,0		;9f0a	21 00 00 	! . . 
	ld (05b8bh),hl		;9f0d	22 8b 5b 	" . [ 
	ret			;9f10	c9 	. 
sub_9f11h:
	ld hl,(05b82h)		;9f11	2a 82 5b 	* . [ 
	push hl			;9f14	e5 	. 
	ld a,(05b81h)		;9f15	3a 81 5b 	: . [ 
l9f18h:
	call sub_07f9h		;9f18	cd f9 07 	. . . 
	cp 0feh		;9f1b	fe fe 	. . 
	jr nz,l9f24h		;9f1d	20 05 	  . 
	call sub_0334h		;9f1f	cd 34 03 	. 4 . 
	jr l9f18h		;9f22	18 f4 	. . 
l9f24h:
	call SETMEMMAP		;9f24	cd 1a 0f 	. . . 
	ld de,00030h		;9f27	11 30 00 	. 0 . 
	add hl,de			;9f2a	19 	. 
	push hl			;9f2b	e5 	. 
	pop de			;9f2c	d1 	. 
	ld b,028h		;9f2d	06 28 	. ( 
	ld a,020h		;9f2f	3e 20 	>   
l9f31h:
	ld (hl),a			;9f31	77 	w 
	inc hl			;9f32	23 	# 
	djnz l9f31h		;9f33	10 fc 	. . 
	ld ix,0605ch		;9f35	dd 21 5c 60 	. ! \ ` 
	ld a,(06070h)		;9f39	3a 70 60 	: p ` 
	or a			;9f3c	b7 	. 
	jr z,l9f59h		;9f3d	28 1a 	( . 
	ld b,a			;9f3f	47 	G 
	ld c,003h		;9f40	0e 03 	. . 
l9f42h:
	ld l,(ix+000h)		;9f42	dd 6e 00 	. n . 
	inc ix		;9f45	dd 23 	. # 
	ld h,(ix+000h)		;9f47	dd 66 00 	. f . 
	inc ix		;9f4a	dd 23 	. # 
	push bc			;9f4c	c5 	. 
	push de			;9f4d	d5 	. 
	call NUM2STR		;9f4e	cd 9e 0f 	. . . 
	pop de			;9f51	d1 	. 
	pop bc			;9f52	c1 	. 
	inc de			;9f53	13 	. 
	inc de			;9f54	13 	. 
	inc de			;9f55	13 	. 
	inc de			;9f56	13 	. 
	djnz l9f42h		;9f57	10 e9 	. . 
l9f59h:
	ld a,(06070h)		;9f59	3a 70 60 	: p ` 
	cp 00ah		;9f5c	fe 0a 	. . 
	jr z,l9f6fh		;9f5e	28 0f 	( . 
	ex de,hl			;9f60	eb 	. 
	ld a,(06057h)		;9f61	3a 57 60 	: W ` 
	ld (hl),a			;9f64	77 	w 
	inc hl			;9f65	23 	# 
	ld a,(06058h)		;9f66	3a 58 60 	: X ` 
	ld (hl),a			;9f69	77 	w 
	inc hl			;9f6a	23 	# 
	ld a,(06059h)		;9f6b	3a 59 60 	: Y ` 
	ld (hl),a			;9f6e	77 	w 
l9f6fh:
	ld a,(05b81h)		;9f6f	3a 81 5b 	: . [ 
	pop hl			;9f72	e1 	. 
	jp sub_087ch		;9f73	c3 7c 08 	. | . 
sub_9f76h:
	ld ix,0605ch		;9f76	dd 21 5c 60 	. ! \ ` 
	ld a,(06070h)		;9f7a	3a 70 60 	: p ` 
	cp 00ah		;9f7d	fe 0a 	. . 
	ret nc			;9f7f	d0 	. 
	or a			;9f80	b7 	. 
	jr z,l9f8ah		;9f81	28 07 	( . 
	ld a,(05b7bh)		;9f83	3a 7b 5b 	: { [ 
	and 002h		;9f86	e6 02 	. . 
	jr z,l9f96h		;9f88	28 0c 	( . 
l9f8ah:
	ld a,(06070h)		;9f8a	3a 70 60 	: p ` 
	ld c,a			;9f8d	4f 	O 
	ld b,000h		;9f8e	06 00 	. . 
	add ix,bc		;9f90	dd 09 	. . 
	add ix,bc		;9f92	dd 09 	. . 
	jr l9faah		;9f94	18 14 	. . 
l9f96h:
	ld a,(06070h)		;9f96	3a 70 60 	: p ` 
	ld b,a			;9f99	47 	G 
l9f9ah:
	ld e,(ix+000h)		;9f9a	dd 5e 00 	. ^ . 
	ld d,(ix+001h)		;9f9d	dd 56 01 	. V . 
	call CMP_HLDE		;9fa0	cd 20 0f 	.   . 
	ret z			;9fa3	c8 	. 
	inc ix		;9fa4	dd 23 	. # 
	inc ix		;9fa6	dd 23 	. # 
	djnz l9f9ah		;9fa8	10 f0 	. . 
l9faah:
	ld a,(06070h)		;9faa	3a 70 60 	: p ` 
	inc a			;9fad	3c 	< 
	ld (06070h),a		;9fae	32 70 60 	2 p ` 
	ld (ix+000h),l		;9fb1	dd 75 00 	. u . 
	ld (ix+001h),h		;9fb4	dd 74 01 	. t . 
	ret			;9fb7	c9 	. 
sub_9fb8h:
	ld ix,0605ch		;9fb8	dd 21 5c 60 	. ! \ ` 
	ld b,012h		;9fbc	06 12 	. . 
l9fbeh:
	ld a,(ix+002h)		;9fbe	dd 7e 02 	. ~ . 
	ld (ix+000h),a		;9fc1	dd 77 00 	. w . 
	inc ix		;9fc4	dd 23 	. # 
	djnz l9fbeh		;9fc6	10 f6 	. . 
	ld a,0ffh		;9fc8	3e ff 	> . 
	ld (ix+000h),a		;9fca	dd 77 00 	. w . 
	ld (ix+001h),a		;9fcd	dd 77 01 	. w . 
	ld a,(06070h)		;9fd0	3a 70 60 	: p ` 
	or a			;9fd3	b7 	. 
	jr z,l9fdah		;9fd4	28 04 	( . 
	dec a			;9fd6	3d 	= 
	ld (06070h),a		;9fd7	32 70 60 	2 p ` 
l9fdah:
	ld a,(06071h)		;9fda	3a 71 60 	: q ` 
	or a			;9fdd	b7 	. 
	ret z			;9fde	c8 	. 
	dec a			;9fdf	3d 	= 
	ld (06071h),a		;9fe0	32 71 60 	2 q ` 
	ret			;9fe3	c9 	. 
sub_9fe4h:
	ld ix,0605ch		;9fe4	dd 21 5c 60 	. ! \ ` 
	ld a,(06071h)		;9fe8	3a 71 60 	: q ` 
	or a			;9feb	b7 	. 
	jr z,l9ff5h		;9fec	28 07 	( . 
	call sub_9fb8h		;9fee	cd b8 9f 	. . . 
	jr sub_9fe4h		;9ff1	18 f1 	. . 
	nop			;9ff3	00 	. 
	nop			;9ff4	00 	. 
l9ff5h:
	ld l,(ix+000h)		;9ff5	dd 6e 00 	. n . 
	ld h,(ix+001h)		;9ff8	dd 66 01 	. f . 
	call sub_9b71h		;9ffb	cd 71 9b 	. q . 
	push hl			;9ffe	e5 	. 
	ld iy,06073h		;9fff	fd 21 73 60 	. ! s ` 
	ld a,(iy+000h)		;a003	fd 7e 00 	. ~ . 
	ld b,(iy+001h)		;a006	fd 46 01 	. F . 
	or b			;a009	b0 	. 
	jr z,la01dh		;a00a	28 11 	( . 
	inc iy		;a00c	fd 23 	. # 
	inc iy		;a00e	fd 23 	. # 
	ld a,(iy+000h)		;a010	fd 7e 00 	. ~ . 
	ld b,(iy+001h)		;a013	fd 46 01 	. F . 
	or b			;a016	b0 	. 
	jr z,la01dh		;a017	28 04 	( . 
	inc iy		;a019	fd 23 	. # 
	inc iy		;a01b	fd 23 	. # 
la01dh:
	ld a,(ix+004h)		;a01d	dd 7e 04 	. ~ . 
	ld (iy+000h),a		;a020	fd 77 00 	. w . 
	ld a,(ix+005h)		;a023	dd 7e 05 	. ~ . 
	ld (iy+001h),a		;a026	fd 77 01 	. w . 
	push ix		;a029	dd e5 	. . 
	pop de			;a02b	d1 	. 
	inc de			;a02c	13 	. 
	inc de			;a02d	13 	. 
	ld b,000h		;a02e	06 00 	. . 
	ld a,(05b7ch)		;a030	3a 7c 5b 	: | [ 
	dec a			;a033	3d 	= 
	ld c,a			;a034	4f 	O 
	sla c		;a035	cb 21 	. ! 
	sla c		;a037	cb 21 	. ! 
	ld hl,05fb7h		;a039	21 b7 5f 	! . _ 
	add hl,bc			;a03c	09 	. 
	ex de,hl			;a03d	eb 	. 
	ld bc,FLAG_DISP		;a03e	01 04 00 	. . . 
	ldir		;a041	ed b0 	. . 
	pop hl			;a043	e1 	. 
	ld a,(05b7ch)		;a044	3a 7c 5b 	: | [ 
	jp sub_087ch		;a047	c3 7c 08 	. | . 
	push af			;a04a	f5 	. 
	push bc			;a04b	c5 	. 
	push de			;a04c	d5 	. 
	push hl			;a04d	e5 	. 
	push ix		;a04e	dd e5 	. . 
	ld de,6		;a050	11 06 00 	. . . 
	ld ix,06073h		;a053	dd 21 73 60 	. ! s ` 
	ld a,(060cbh)		;a057	3a cb 60 	: . ` 
	ld b,a			;a05a	47 	G 
la05bh:
	add ix,de		;a05b	dd 19 	. . 
	djnz la05bh		;a05d	10 fc 	. . 
	ld e,(ix+000h)		;a05f	dd 5e 00 	. ^ . 
	ld d,(ix+001h)		;a062	dd 56 01 	. V . 
	ld a,(ix+002h)		;a065	dd 7e 02 	. ~ . 
	push af			;a068	f5 	. 
	ld c,(ix+003h)		;a069	dd 4e 03 	. N . 
	ld (ix+000h),c		;a06c	dd 71 00 	. q . 
	ld b,(ix+004h)		;a06f	dd 46 04 	. F . 
	ld (ix+001h),b		;a072	dd 70 01 	. p . 
	ld a,(ix+005h)		;a075	dd 7e 05 	. ~ . 
	ld (ix+002h),a		;a078	dd 77 02 	. w . 
	ld (ix+003h),l		;a07b	dd 75 03 	. u . 
	ld (ix+004h),h		;a07e	dd 74 04 	. t . 
	ld a,(0602ah)		;a081	3a 2a 60 	: * ` 
	ld (ix+005h),a		;a084	dd 77 05 	. w . 
	call CMP_HLDE		;a087	cd 20 0f 	.   . 
	jr z,la09bh		;a08a	28 0f 	( . 
	ld l,c			;a08c	69 	i 
	ld h,b			;a08d	60 	` 
	call CMP_HLDE		;a08e	cd 20 0f 	.   . 
	jr z,la09bh		;a091	28 08 	( . 
	ld a,(060cbh)		;a093	3a cb 60 	: . ` 
	ld l,e			;a096	6b 	k 
	ld h,d			;a097	62 	b 
	call sub_087ch		;a098	cd 7c 08 	. | . 
la09bh:
	ld a,(060cbh)		;a09b	3a cb 60 	: . ` 
	ld b,a			;a09e	47 	G 
	ld a,(05b7ch)		;a09f	3a 7c 5b 	: | [ 
	cp b			;a0a2	b8 	. 
	pop bc			;a0a3	c1 	. 
	jr nz,la0bfh		;a0a4	20 19 	  . 
	ld hl,(06073h)		;a0a6	2a 73 60 	* s ` 
	ld a,h			;a0a9	7c 	| 
	or l			;a0aa	b5 	. 
	jr z,la0bfh		;a0ab	28 12 	( . 
	ex de,hl			;a0ad	eb 	. 
	ld b,a			;a0ae	47 	G 
	dec a			;a0af	3d 	= 
	add a,l			;a0b0	85 	. 
	ld l,a			;a0b1	6f 	o 
	jr nc,la0b5h		;a0b2	30 01 	0 . 
	inc h			;a0b4	24 	$ 
la0b5h:
	call CMP_HLDE		;a0b5	cd 20 0f 	.   . 
	jr c,la0bfh		;a0b8	38 05 	8 . 
	ld a,001h		;a0ba	3e 01 	> . 
	ld (06072h),a		;a0bc	32 72 60 	2 r ` 
la0bfh:
	pop ix		;a0bf	dd e1 	. . 
	pop hl			;a0c1	e1 	. 
	pop de			;a0c2	d1 	. 
	pop bc			;a0c3	c1 	. 
	pop af			;a0c4	f1 	. 
	ret			;a0c5	c9 	. 

HANDLE_KBD:
	ld a,(05b7bh)		;a0c6	3a 7b 5b 	: { [ 
	and 001h		;a0c9	e6 01 	. . 
	ret nz			;a0cb	c0 	. 
	ld de,FIFO3 
	call FIFO_READ		;a0cf	cd e1 0e 	. . . 
	ret c			;a0d2	d8 	. 
	ld c,a			;a0d3	4f 	O 
	ld a,(CFG12)		;a0d4	3a 14 00 	: . . 
	cp 0aah		;a0d7	fe aa 	. . 
	ld a,c			;a0d9	79 	y 
	jp z,la2afh		;a0da	ca af a2 	. . . 
	ld hl,05bb8h		;a0dd	21 b8 5b 	! . [ 
	M_CALL_WITH_MMAP0 sub_c103h
	ld b,002h		;a0e5	06 02 	. . 
	call LOG_CHAR		;a0e7	cd e6 1a 	. . . 
	push af			;a0ea	f5 	. 
	ld b,a			;a0eb	47 	G 
	ld a,(05bb9h)		;a0ec	3a b9 5b 	: . [ 
	cp 001h		;a0ef	fe 01 	. . 
	jr nz,la145h		;a0f1	20 52 	  R 
	ld a,b			;a0f3	78 	x 
	cp 020h		;a0f4	fe 20 	.   
	jr nc,la123h		;a0f6	30 2b 	0 + 
	cp 00dh		;a0f8	fe 0d 	. . 
	jr z,la10bh		;a0fa	28 0f 	( . 
	cp 007h		;a0fc	fe 07 	. . 
	jp nz,la182h		;a0fe	c2 82 a1 	. . . 
	ld a,(05bbah)		;a101	3a ba 5b 	: . [ 
	cp 007h		;a104	fe 07 	. . 
	jp nz,la182h		;a106	c2 82 a1 	. . . 
	jr la155h		;a109	18 4a 	. J 
la10bh:
	ld hl,(05bbbh)		;a10b	2a bb 5b 	* . [ 
	ld de,00028h		;a10e	11 28 00 	. ( . 
	add hl,de			;a111	19 	. 
	ld de,(05bbfh)		;a112	ed 5b bf 5b 	. [ . [ 
	call CMP_HLDE		;a116	cd 20 0f 	.   . 
	jr nc,la13eh		;a119	30 23 	0 # 
	ld (05bbbh),hl		;a11b	22 bb 5b 	" . [ 
	ld (05bc1h),hl		;a11e	22 c1 5b 	" . [ 
	jr la182h		;a121	18 5f 	. _ 
la123h:
	push af			;a123	f5 	. 
	ld a,(05bc3h)		;a124	3a c3 5b 	: . [ 
	call SETMEMMAP		;a127	cd 1a 0f 	. . . 
	pop af			;a12a	f1 	. 
	ld hl,(05bc1h)		;a12b	2a c1 5b 	* . [ 
	ld (hl),a			;a12e	77 	w 
	inc hl			;a12f	23 	# 
	ld (05bc1h),hl		;a130	22 c1 5b 	" . [ 
	ld de,(05bbfh)		;a133	ed 5b bf 5b 	. [ . [ 
	call CMP_HLDE		;a137	cd 20 0f 	.   . 
	jr c,la182h		;a13a	38 46 	8 F 
	jr z,la182h		;a13c	28 44 	( D 
la13eh:
	ld hl,05bb9h		;a13e	21 b9 5b 	! . [ 
	ld (hl),000h		;a141	36 00 	6 . 
	jr la182h		;a143	18 3d 	. = 
la145h:
	bit 1,a		;a145	cb 4f 	. O 
	jr nz,la16dh		;a147	20 24 	  $ 
	ld a,b			;a149	78 	x 
	cp 007h		;a14a	fe 07 	. . 
	jr nz,la182h		;a14c	20 34 	  4 
	ld a,(05bbah)		;a14e	3a ba 5b 	: . [ 
	cp 007h		;a151	fe 07 	. . 
	jr nz,la182h		;a153	20 2d 	  - 
la155h:
	ld hl,05bb9h		;a155	21 b9 5b 	! . [ 
	ld (hl),002h		;a158	36 02 	6 . 
	ld a,(05bc3h)		;a15a	3a c3 5b 	: . [ 
	call SETMEMMAP		;a15d	cd 1a 0f 	. . . 
	ld hl,(05bbdh)		;a160	2a bd 5b 	* . [ 
	ld a,l			;a163	7d 	} 
	or h			;a164	b4 	. 
	jr z,la182h		;a165	28 1b 	( . 
	res 0,(hl)		;a167	cb 86 	. . 
	set 3,(hl)		;a169	cb de 	. . 
	jr la182h		;a16b	18 15 	. . 
la16dh:
	ld a,b			;a16d	78 	x 
	cp 00dh		;a16e	fe 0d 	. . 
	jr z,la177h		;a170	28 05 	( . 
	call sub_a238h		;a172	cd 38 a2 	. 8 . 
	jr la182h		;a175	18 0b 	. . 
la177h:
	xor a			;a177	af 	. 
	ld (05bddh),a		;a178	32 dd 5b 	2 . [ 
	ld a,001h		;a17b	3e 01 	> . 
	ld (05bb9h),a		;a17d	32 b9 5b 	2 . [ 
	jr la192h		;a180	18 10 	. . 
la182h:
	pop af			;a182	f1 	. 
	ld (05bbah),a		;a183	32 ba 5b 	2 . [ 
	ret			;a186	c9 	. 
sub_a187h:
	ld (hl),020h		;a187	36 20 	6   
	ld d,h			;a189	54 	T 
	ld e,l			;a18a	5d 	] 
	inc de			;a18b	13 	. 
	ld bc,0013fh		;a18c	01 3f 01 	. ? . 
	ldir		;a18f	ed b0 	. . 
	ret			;a191	c9 	. 
la192h:
	ld a,(05bc4h)		;a192	3a c4 5b 	: . [ 
	or a			;a195	b7 	. 
	jr z,la13eh		;a196	28 a6 	( . 
	cp 009h		;a198	fe 09 	. . 
	jr nc,la13eh		;a19a	30 a2 	0 . 
	dec a			;a19c	3d 	= 
	ld hl,0550eh		;a19d	21 0e 55 	! . U 
	ld e,a			;a1a0	5f 	_ 
	ld d,000h		;a1a1	16 00 	. . 
	add hl,de			;a1a3	19 	. 
	ld a,(hl)			;a1a4	7e 	~ 
	or a			;a1a5	b7 	. 
	jr z,la13eh		;a1a6	28 96 	( . 
	cp 009h		;a1a8	fe 09 	. . 
	jr nc,la13eh		;a1aa	30 92 	0 . 
	dec a			;a1ac	3d 	= 
	add a,a			;a1ad	87 	. 
	ld hl,05bc5h		;a1ae	21 c5 5b 	! . [ 
	ld e,a			;a1b1	5f 	_ 
	ld d,000h		;a1b2	16 00 	. . 
	add hl,de			;a1b4	19 	. 
	ld (05bd5h),hl		;a1b5	22 d5 5b 	" . [ 
	ld c,(hl)			;a1b8	4e 	N 
	inc hl			;a1b9	23 	# 
	ld b,(hl)			;a1ba	46 	F 
	add a,a			;a1bb	87 	. 
	ld e,a			;a1bc	5f 	_ 
	ld hl,054eeh		;a1bd	21 ee 54 	! . T 
	add hl,de			;a1c0	19 	. 
	ld e,(hl)			;a1c1	5e 	^ 
	inc hl			;a1c2	23 	# 
	ld d,(hl)			;a1c3	56 	V 
	inc hl			;a1c4	23 	# 
	push hl			;a1c5	e5 	. 
	push bc			;a1c6	c5 	. 
	pop hl			;a1c7	e1 	. 
	call CMP_HLDE		;a1c8	cd 20 0f 	.   . 
	call c,sub_a225h		;a1cb	dc 25 a2 	. % . 
	pop hl			;a1ce	e1 	. 
	ld e,(hl)			;a1cf	5e 	^ 
	inc hl			;a1d0	23 	# 
	ld d,(hl)			;a1d1	56 	V 
	push bc			;a1d2	c5 	. 
	pop hl			;a1d3	e1 	. 
	ex de,hl			;a1d4	eb 	. 
	call CMP_HLDE		;a1d5	cd 20 0f 	.   . 
	ex de,hl			;a1d8	eb 	. 
	call c,sub_a225h		;a1d9	dc 25 a2 	. % . 
	ld de,0		;a1dc	11 00 00 	. . . 
	call CMP_HLDE		;a1df	cd 20 0f 	.   . 
	jp z,la13eh		;a1e2	ca 3e a1 	. > . 
	call sub_07f9h		;a1e5	cd f9 07 	. . . 
	cp 0ffh		;a1e8	fe ff 	. . 
	jr z,la21fh		;a1ea	28 33 	( 3 
	ld (05bc3h),a		;a1ec	32 c3 5b 	2 . [ 
	ld (05bbdh),hl		;a1ef	22 bd 5b 	" . [ 
	call SETMEMMAP		;a1f2	cd 1a 0f 	. . . 
	set 0,(hl)		;a1f5	cb c6 	. . 
	ld de,00030h		;a1f7	11 30 00 	. 0 . 
	add hl,de			;a1fa	19 	. 
	ld (05bc1h),hl		;a1fb	22 c1 5b 	" . [ 
	ld (05bbbh),hl		;a1fe	22 bb 5b 	" . [ 
	call sub_a187h		;a201	cd 87 a1 	. . . 
	ld (05bbfh),hl		;a204	22 bf 5b 	" . [ 
	call sub_a20dh		;a207	cd 0d a2 	. . . 
	jp la182h		;a20a	c3 82 a1 	. . . 
sub_a20dh:
	ld ix,(05bd5h)		;a20d	dd 2a d5 5b 	. * . [ 
	ld l,(ix+000h)		;a211	dd 6e 00 	. n . 
	ld h,(ix+001h)		;a214	dd 66 01 	. f . 
	inc hl			;a217	23 	# 
	ld (ix+000h),l		;a218	dd 75 00 	. u . 
	ld (ix+001h),h		;a21b	dd 74 01 	. t . 
	ret			;a21e	c9 	. 
la21fh:
	call sub_a20dh		;a21f	cd 0d a2 	. . . 
	jp la13eh		;a222	c3 3e a1 	. > . 
sub_a225h:
	ld hl,054eeh		;a225	21 ee 54 	! . T 
la228h:
	ld e,a			;a228	5f 	_ 
	ld d,000h		;a229	16 00 	. . 
	add hl,de			;a22b	19 	. 
	ld c,(hl)			;a22c	4e 	N 
	inc hl			;a22d	23 	# 
	ld b,(hl)			;a22e	46 	F 
	ld hl,(05bd5h)		;a22f	2a d5 5b 	* . [ 
	ld (hl),c			;a232	71 	q 
	inc hl			;a233	23 	# 
	ld (hl),b			;a234	70 	p 
	push bc			;a235	c5 	. 
	pop hl			;a236	e1 	. 
	ret			;a237	c9 	. 
sub_a238h:
	ld hl,05bd7h		;a238	21 d7 5b 	! . [ 
	call sub_a2a4h		;a23b	cd a4 a2 	. . . 
	ld a,b			;a23e	78 	x 
	ld (de),a			;a23f	12 	. 
	ld a,(05bddh)		;a240	3a dd 5b 	: . [ 
	inc a			;a243	3c 	< 
	ld (05bddh),a		;a244	32 dd 5b 	2 . [ 
	cp 007h		;a247	fe 07 	. . 
	ret c			;a249	d8 	. 
	jr nz,la29ch		;a24a	20 50 	  P 
	ld a,(05bdch)		;a24c	3a dc 5b 	: . [ 
	cp 01fh		;a24f	fe 1f 	. . 
	jr nz,la29ch		;a251	20 49 	  I 
	ld a,01ch		;a253	3e 1c 	> . 
	ld hl,05bd7h		;a255	21 d7 5b 	! . [ 
	cp (hl)			;a258	be 	. 
	jr nz,la29ch		;a259	20 41 	  A 
	inc hl			;a25b	23 	# 
	cp (hl)			;a25c	be 	. 
	jr nz,la298h		;a25d	20 39 	  9 
	inc hl			;a25f	23 	# 
	cp (hl)			;a260	be 	. 
	jr nz,la27ch		;a261	20 19 	  . 
	inc hl			;a263	23 	# 
	cp (hl)			;a264	be 	. 
	jr nz,la270h		;a265	20 09 	  . 
	inc hl			;a267	23 	# 
	cp (hl)			;a268	be 	. 
	ret z			;a269	c8 	. 
	ld a,006h		;a26a	3e 06 	> . 
la26ch:
	ld (05bc4h),a		;a26c	32 c4 5b 	2 . [ 
	ret			;a26f	c9 	. 
la270h:
	inc hl			;a270	23 	# 
	cp (hl)			;a271	be 	. 
	jr nz,la278h		;a272	20 04 	  . 
	ld a,002h		;a274	3e 02 	> . 
	jr la26ch		;a276	18 f4 	. . 
la278h:
	ld a,001h		;a278	3e 01 	> . 
	jr la26ch		;a27a	18 f0 	. . 
la27ch:
	inc hl			;a27c	23 	# 
	cp (hl)			;a27d	be 	. 
	jr nz,la28ch		;a27e	20 0c 	  . 
	inc hl			;a280	23 	# 
	cp (hl)			;a281	be 	. 
	jr nz,la288h		;a282	20 04 	  . 
	ld a,004h		;a284	3e 04 	> . 
	jr la26ch		;a286	18 e4 	. . 
la288h:
	ld a,005h		;a288	3e 05 	> . 
	jr la26ch		;a28a	18 e0 	. . 
la28ch:
	inc hl			;a28c	23 	# 
	cp (hl)			;a28d	be 	. 
	jr nz,la294h		;a28e	20 04 	  . 
	ld a,003h		;a290	3e 03 	> . 
	jr la26ch		;a292	18 d8 	. . 
la294h:
	ld a,008h		;a294	3e 08 	> . 
	jr la26ch		;a296	18 d4 	. . 
la298h:
	ld a,007h		;a298	3e 07 	> . 
	jr la26ch		;a29a	18 d0 	. . 
la29ch:
	xor a			;a29c	af 	. 
	ld (05bddh),a		;a29d	32 dd 5b 	2 . [ 
	ret			;a2a0	c9 	. 
sub_a2a1h:
	ld hl,05bf9h		;a2a1	21 f9 5b 	! . [ 
sub_a2a4h:
	push hl			;a2a4	e5 	. 
	pop de			;a2a5	d1 	. 
	push bc			;a2a6	c5 	. 
	inc hl			;a2a7	23 	# 
	ld bc,5		;a2a8	01 05 00 	. . . 
	ldir		;a2ab	ed b0 	. . 
	pop bc			;a2ad	c1 	. 
	ret			;a2ae	c9 	. 
la2afh:
	ld hl,05bb8h		;a2af	21 b8 5b 	! . [ 
	ld a,c			;a2b2	79 	y 
	M_CALL_WITH_MMAP0 sub_c103h
	ld b,002h		;a2b8	06 02 	. . 
	call LOG_CHAR		;a2ba	cd e6 1a 	. . . 
	cp 01fh		;a2bd	fe 1f 	. . 
	ret z			;a2bf	c8 	. 
	cp 01ch		;a2c0	fe 1c 	. . 
	ret z			;a2c2	c8 	. 
	cp 007h		;a2c3	fe 07 	. . 
	ret z			;a2c5	c8 	. 
	ld iy,CFG8		;a2c6	fd 21 3d 00 	. ! = . 
	bit 0,(iy+000h)		;a2ca	fd cb 00 46 	. . . F 
	jr z,la2d6h		;a2ce	28 06 	( . 
	cp 00ah		;a2d0	fe 0a 	. . 
	ret z			;a2d2	c8 	. 
	cp 000h		;a2d3	fe 00 	. . 
	ret z			;a2d5	c8 	. 
la2d6h:
	ld c,a			;a2d6	4f 	O 
	ld a,(05bbdh)		;a2d7	3a bd 5b 	: . [ 
	ld e,a			;a2da	5f 	_ 
	ld a,(05bbch)		;a2db	3a bc 5b 	: . [ 
	ld (05bbdh),a		;a2de	32 bd 5b 	2 . [ 
	ld b,a			;a2e1	47 	G 
	ld a,c			;a2e2	79 	y 
	ld (05bbch),a		;a2e3	32 bc 5b 	2 . [ 
	bit 0,(iy+000h)		;a2e6	fd cb 00 46 	. . . F 
	jr z,la30eh		;a2ea	28 22 	( " 
	xor a			;a2ec	af 	. 
	or c			;a2ed	b1 	. 
	or b			;a2ee	b0 	. 
	or e			;a2ef	b3 	. 
	cp 020h		;a2f0	fe 20 	.   
	jr nz,la31eh		;a2f2	20 2a 	  * 
	ld a,(05bbbh)		;a2f4	3a bb 5b 	: . [ 
	cp 002h		;a2f7	fe 02 	. . 
	jr nz,la31eh		;a2f9	20 23 	  # 
	ld a,020h		;a2fb	3e 20 	>   
	ld hl,05bc4h		;a2fd	21 c4 5b 	! . [ 
	ld (hl),a			;a300	77 	w 
	inc hl			;a301	23 	# 
	ld (hl),a			;a302	77 	w 
	ld a,002h		;a303	3e 02 	> . 
	ld (05bc3h),a		;a305	32 c3 5b 	2 . [ 
	call sub_a468h		;a308	cd 68 a4 	. h . 
	jp la3fah		;a30b	c3 fa a3 	. . . 
la30eh:
	cp 00ah		;a30e	fe 0a 	. . 
	jr nz,la31eh		;a310	20 0c 	  . 
	cp b			;a312	b8 	. 
	ret nz			;a313	c0 	. 
	ld a,e			;a314	7b 	{ 
	ld (05bbdh),a		;a315	32 bd 5b 	2 . [ 
	ld a,00dh		;a318	3e 0d 	> . 
	ld c,a			;a31a	4f 	O 
	ld (05bbch),a		;a31b	32 bc 5b 	2 . [ 
la31eh:
	ld a,(05bb9h)		;a31e	3a b9 5b 	: . [ 
	or a			;a321	b7 	. 
	jp z,la3fah		;a322	ca fa a3 	. . . 
la325h:
	ld a,(05bbch)		;a325	3a bc 5b 	: . [ 
	ld c,a			;a328	4f 	O 
	cp 00dh		;a329	fe 0d 	. . 
	jr nz,la367h		;a32b	20 3a 	  : 
	bit 0,(iy+000h)		;a32d	fd cb 00 46 	. . . F 
	jr nz,la33ch		;a331	20 09 	  . 
	ld c,020h		;a333	0e 20 	.   
	ld a,(05bbdh)		;a335	3a bd 5b 	: . [ 
	cp 00dh		;a338	fe 0d 	. . 
	jr nz,la367h		;a33a	20 2b 	  + 
la33ch:
	ld a,(05bbah)		;a33c	3a ba 5b 	: . [ 
	cp 008h		;a33f	fe 08 	. . 
	jr c,la346h		;a341	38 03 	8 . 
	jp sub_a468h		;a343	c3 68 a4 	. h . 
la346h:
	ld a,(05bbbh)		;a346	3a bb 5b 	: . [ 
	ld e,a			;a349	5f 	_ 
	ld a,028h		;a34a	3e 28 	> ( 
	sub e			;a34c	93 	. 
	ld e,a			;a34d	5f 	_ 
	ld d,000h		;a34e	16 00 	. . 
	ld hl,(05bc0h)		;a350	2a c0 5b 	* . [ 
	add hl,de			;a353	19 	. 
	ld (05bc0h),hl		;a354	22 c0 5b 	" . [ 
	ld a,(05bbah)		;a357	3a ba 5b 	: . [ 
	inc a			;a35a	3c 	< 
	ld (05bbah),a		;a35b	32 ba 5b 	2 . [ 
	ld a,000h		;a35e	3e 00 	> . 
	ld (05bbbh),a		;a360	32 bb 5b 	2 . [ 
	ld (05bc3h),a		;a363	32 c3 5b 	2 . [ 
	ret			;a366	c9 	. 
la367h:
	ld a,(05bc2h)		;a367	3a c2 5b 	: . [ 
	call SETMEMMAP		;a36a	cd 1a 0f 	. . . 
	ld a,(05bbbh)		;a36d	3a bb 5b 	: . [ 
	ld b,a			;a370	47 	G 
	bit 0,(iy+000h)		;a371	fd cb 00 46 	. . . F 
	jr nz,la389h		;a375	20 12 	  . 
	or a			;a377	b7 	. 
	ld a,c			;a378	79 	y 
	jr nz,la389h		;a379	20 0e 	  . 
	cp 020h		;a37b	fe 20 	.   
	jr nz,la389h		;a37d	20 0a 	  . 
	ld a,(05bbdh)		;a37f	3a bd 5b 	: . [ 
	cp 020h		;a382	fe 20 	.   
	jr z,la389h		;a384	28 03 	( . 
	cp 00dh		;a386	fe 0d 	. . 
	ret nz			;a388	c0 	. 
la389h:
	ld hl,(05bc0h)		;a389	2a c0 5b 	* . [ 
	ld a,c			;a38c	79 	y 
	ld (hl),a			;a38d	77 	w 
	ld a,b			;a38e	78 	x 
	inc a			;a38f	3c 	< 
	inc hl			;a390	23 	# 
	ld (05bc0h),hl		;a391	22 c0 5b 	" . [ 
	ld (05bbbh),a		;a394	32 bb 5b 	2 . [ 
	bit 0,(iy+000h)		;a397	fd cb 00 46 	. . . F 
	jr z,la3a1h		;a39b	28 04 	( . 
	cp 021h		;a39d	fe 21 	. ! 
	jr la3a3h		;a39f	18 02 	. . 
la3a1h:
	cp 020h		;a3a1	fe 20 	.   
la3a3h:
	ret c			;a3a3	d8 	. 
	ld a,020h		;a3a4	3e 20 	>   
	ld c,000h		;a3a6	0e 00 	. . 
	ld b,014h		;a3a8	06 14 	. . 
la3aah:
	dec hl			;a3aa	2b 	+ 
	inc c			;a3ab	0c 	. 
	cp (hl)			;a3ac	be 	. 
	jr z,la3b1h		;a3ad	28 02 	( . 
	djnz la3aah		;a3af	10 f9 	. . 
la3b1h:
	ld b,c			;a3b1	41 	A 
	inc hl			;a3b2	23 	# 
	ld de,05bc4h		;a3b3	11 c4 5b 	. . [ 
	dec b			;a3b6	05 	. 
	ld a,b			;a3b7	78 	x 
	ld (05bc3h),a		;a3b8	32 c3 5b 	2 . [ 
	jr z,la3c5h		;a3bb	28 08 	( . 
la3bdh:
	ld a,(hl)			;a3bd	7e 	~ 
	ld (hl),020h		;a3be	36 20 	6   
	ld (de),a			;a3c0	12 	. 
	inc hl			;a3c1	23 	# 
	inc de			;a3c2	13 	. 
	djnz la3bdh		;a3c3	10 f8 	. . 
la3c5h:
	ld a,(05bbah)		;a3c5	3a ba 5b 	: . [ 
	cp 008h		;a3c8	fe 08 	. . 
	jr c,la3cfh		;a3ca	38 03 	8 . 
	jp sub_a468h		;a3cc	c3 68 a4 	. h . 
la3cfh:
	inc a			;a3cf	3c 	< 
	ld (05bbah),a		;a3d0	32 ba 5b 	2 . [ 
	ld hl,(05bc0h)		;a3d3	2a c0 5b 	* . [ 
	ld de,00008h		;a3d6	11 08 00 	. . . 
	bit 0,(iy+000h)		;a3d9	fd cb 00 46 	. . . F 
	jr z,la3e2h		;a3dd	28 03 	( . 
	ld de,7		;a3df	11 07 00 	. . . 
la3e2h:
	add hl,de			;a3e2	19 	. 
	ex de,hl			;a3e3	eb 	. 
	ld hl,05bc4h		;a3e4	21 c4 5b 	! . [ 
	ld a,(05bc3h)		;a3e7	3a c3 5b 	: . [ 
	or a			;a3ea	b7 	. 
	jr z,la3f2h		;a3eb	28 05 	( . 
	ld b,000h		;a3ed	06 00 	. . 
	ld c,a			;a3ef	4f 	O 
	ldir		;a3f0	ed b0 	. . 
la3f2h:
	ex de,hl			;a3f2	eb 	. 
	ld (05bc0h),hl		;a3f3	22 c0 5b 	" . [ 
	ld (05bbbh),a		;a3f6	32 bb 5b 	2 . [ 
	ret			;a3f9	c9 	. 
la3fah:
	ld hl,(054eeh)		;a3fa	2a ee 54 	* . T 
	ld a,l			;a3fd	7d 	} 
	or h			;a3fe	b4 	. 
	ret z			;a3ff	c8 	. 
	ex de,hl			;a400	eb 	. 
	ld hl,(05bbeh)		;a401	2a be 5b 	* . [ 
	inc hl			;a404	23 	# 
	ld (05bbeh),hl		;a405	22 be 5b 	" . [ 
	call CMP_HLDE		;a408	cd 20 0f 	.   . 
	jr c,la416h		;a40b	38 09 	8 . 
	ex de,hl			;a40d	eb 	. 
	ld hl,(054f0h)		;a40e	2a f0 54 	* . T 
	call CMP_HLDE		;a411	cd 20 0f 	.   . 
la414h:
	jr nc,la41ch		;a414	30 06 	0 . 
la416h:
	ld hl,(054eeh)		;a416	2a ee 54 	* . T 
	ld (05bbeh),hl		;a419	22 be 5b 	" . [ 
la41ch:
	ld hl,(05bbeh)		;a41c	2a be 5b 	* . [ 
	call sub_07f9h		;a41f	cd f9 07 	. . . 
	ld (05bc2h),a		;a422	32 c2 5b 	2 . [ 
	call SETMEMMAP		;a425	cd 1a 0f 	. . . 
	set 0,(hl)		;a428	cb c6 	. . 
	ld de,00030h		;a42a	11 30 00 	. 0 . 
	add hl,de			;a42d	19 	. 
	ld (05bc0h),hl		;a42e	22 c0 5b 	" . [ 
	ld a,001h		;a431	3e 01 	> . 
	ld (05bb9h),a		;a433	32 b9 5b 	2 . [ 
	ld (05bbah),a		;a436	32 ba 5b 	2 . [ 
	xor a			;a439	af 	. 
	ld (05bbbh),a		;a43a	32 bb 5b 	2 . [ 
	ld d,h			;a43d	54 	T 
	ld e,l			;a43e	5d 	] 
	ld bc,0013fh		;a43f	01 3f 01 	. ? . 
	inc de			;a442	13 	. 
	ld (hl),020h		;a443	36 20 	6   
	ldir		;a445	ed b0 	. . 
	ld a,(05bc3h)		;a447	3a c3 5b 	: . [ 
	or a			;a44a	b7 	. 
	jp z,la325h		;a44b	ca 25 a3 	. % . 
	ld b,000h		;a44e	06 00 	. . 
	ld c,a			;a450	4f 	O 
	ld hl,05bc4h		;a451	21 c4 5b 	! . [ 
	ld de,(05bc0h)		;a454	ed 5b c0 5b 	. [ . [ 
	ldir		;a458	ed b0 	. . 
	ld (05bbbh),a		;a45a	32 bb 5b 	2 . [ 
	xor a			;a45d	af 	. 
	ld (05bc3h),a		;a45e	32 c3 5b 	2 . [ 
	ld (05bc0h),de		;a461	ed 53 c0 5b 	. S . [ 
	jp la325h		;a465	c3 25 a3 	. % . 
sub_a468h:
	ld hl,(05bbeh)		;a468	2a be 5b 	* . [ 
	call sub_07f9h		;a46b	cd f9 07 	. . . 
	call SETMEMMAP		;a46e	cd 1a 0f 	. . . 
	res 0,(hl)		;a471	cb 86 	. . 
	set 3,(hl)		;a473	cb de 	. . 
	ld a,000h		;a475	3e 00 	> . 
	ld (05bb9h),a		;a477	32 b9 5b 	2 . [ 
	ret			;a47a	c9 	. 
HANDLE_FIFO4_1:
	ld a,(CFG9)		;a47b	3a 15 00 	: . . 
	cp 0aah		;a47e	fe aa 	. . 
	ret z			;a480	c8 	. 
	ld de,FIFO4		;a481	11 ec 40 	. . @ 
	call FIFO_READ		;a484	cd e1 0e 	. . . 
	ret c			;a487	d8 	. 
	ld c,a			;a488	4f 	O 
	ld a,(CFG9)		;a489	3a 15 00 	: . . 
	cp 055h		;a48c	fe 55 	. U 
	jp z,laaa0h		;a48e	ca a0 aa 	. . . 
	ld a,c			;a491	79 	y 
	ld hl,05bdeh		;a492	21 de 5b 	! . [ 
	M_CALL_WITH_MMAP0 sub_c103h
	ld b,003h		;a49a	06 03 	. . 
	call LOG_CHAR		;a49c	cd e6 1a 	. . . 
	push af			;a49f	f5 	. 
	ld b,a			;a4a0	47 	G 
	cp 01ch		;a4a1	fe 1c 	. . 
	jr z,la4e3h		;a4a3	28 3e 	( > 
	cp 01fh		;a4a5	fe 1f 	. . 
	jr z,la4e3h		;a4a7	28 3a 	( : 
	cp 007h		;a4a9	fe 07 	. . 
	jp z,la54fh		;a4ab	ca 4f a5 	. O . 
	cp 021h		;a4ae	fe 21 	. ! 
	jp z,la54fh		;a4b0	ca 4f a5 	. O . 
	cp 026h		;a4b3	fe 26 	. & 
	jp z,la54fh		;a4b5	ca 4f a5 	. O . 
	cp 00dh		;a4b8	fe 0d 	. . 
	jr z,la4e3h		;a4ba	28 27 	( ' 
	ld a,(05bdfh)		;a4bc	3a df 5b 	: . [ 
	cp 001h		;a4bf	fe 01 	. . 
	jr nz,la514h		;a4c1	20 51 	  Q 
	ld a,b			;a4c3	78 	x 
	cp 00ah		;a4c4	fe 0a 	. . 
	jr z,la4efh		;a4c6	28 27 	( ' 
la4c8h:
	push af			;a4c8	f5 	. 
	ld a,(05be9h)		;a4c9	3a e9 5b 	: . [ 
	call SETMEMMAP		;a4cc	cd 1a 0f 	. . . 
	pop af			;a4cf	f1 	. 
	ld hl,(05be7h)		;a4d0	2a e7 5b 	* . [ 
	ld (hl),a			;a4d3	77 	w 
	ld de,(05be5h)		;a4d4	ed 5b e5 5b 	. [ . [ 
	call CMP_HLDE		;a4d8	cd 20 0f 	.   . 
	jr nc,la4e8h		;a4db	30 0b 	0 . 
	inc hl			;a4dd	23 	# 
	ld (05be7h),hl		;a4de	22 e7 5b 	" . [ 
	jr la54ah		;a4e1	18 67 	. g 
la4e3h:
	call z,sub_a5f3h		;a4e3	cc f3 a5 	. . . 
	jr la54fh		;a4e6	18 67 	. g 
la4e8h:
	ld hl,05bdfh		;a4e8	21 df 5b 	! . [ 
	ld (hl),080h		;a4eb	36 80 	6 . 
	jr la54ah		;a4ed	18 5b 	. [ 
la4efh:
	ld a,(05be0h)		;a4ef	3a e0 5b 	: . [ 
	cp 00ah		;a4f2	fe 0a 	. . 
	jr nz,la4fbh		;a4f4	20 05 	  . 
	call sub_a551h		;a4f6	cd 51 a5 	. Q . 
	jr la54ah		;a4f9	18 4f 	. O 
la4fbh:
	ld hl,(05be1h)		;a4fb	2a e1 5b 	* . [ 
	ld de,00028h		;a4fe	11 28 00 	. ( . 
	add hl,de			;a501	19 	. 
	ld (05be1h),hl		;a502	22 e1 5b 	" . [ 
	ld (05be7h),hl		;a505	22 e7 5b 	" . [ 
	ld de,(05be5h)		;a508	ed 5b e5 5b 	. [ . [ 
	call CMP_HLDE		;a50c	cd 20 0f 	.   . 
	call nc,sub_a551h		;a50f	d4 51 a5 	. Q . 
	jr la54ah		;a512	18 36 	. 6 
la514h:
	bit 7,a		;a514	cb 7f 	.  
	jr z,la520h		;a516	28 08 	( . 
	ld a,b			;a518	78 	x 
	cp 00ah		;a519	fe 0a 	. . 
	call z,sub_a551h		;a51b	cc 51 a5 	. Q . 
	jr la54ah		;a51e	18 2a 	. * 
la520h:
	bit 6,a		;a520	cb 77 	. w 
	jr z,la539h		;a522	28 15 	( . 
	ld a,b			;a524	78 	x 
	cp 00ah		;a525	fe 0a 	. . 
	jr z,la54ah		;a527	28 21 	( ! 
	ld (05be0h),a		;a529	32 e0 5b 	2 . [ 
	jr la564h		;a52c	18 36 	. 6 
la52eh:
	ld a,001h		;a52e	3e 01 	> . 
	ld (05bdfh),a		;a530	32 df 5b 	2 . [ 
	ld a,(05be0h)		;a533	3a e0 5b 	: . [ 
	jp la4c8h		;a536	c3 c8 a4 	. . . 
la539h:
	ld a,b			;a539	78 	x 
	cp 00ah		;a53a	fe 0a 	. . 
	jr nz,la54ah		;a53c	20 0c 	  . 
	ld a,(05be0h)		;a53e	3a e0 5b 	: . [ 
	cp 00ah		;a541	fe 0a 	. . 
	jr nz,la54ah		;a543	20 05 	  . 
	ld a,040h		;a545	3e 40 	> @ 
	ld (05bdfh),a		;a547	32 df 5b 	2 . [ 
la54ah:
	pop af			;a54a	f1 	. 
	ld (05be0h),a		;a54b	32 e0 5b 	2 . [ 
	ret			;a54e	c9 	. 
la54fh:
	pop af			;a54f	f1 	. 
	ret			;a550	c9 	. 
sub_a551h:
	ld a,(05be9h)		;a551	3a e9 5b 	: . [ 
	call SETMEMMAP		;a554	cd 1a 0f 	. . . 
	ld hl,(05be3h)		;a557	2a e3 5b 	* . [ 
	res 0,(hl)		;a55a	cb 86 	. . 
	set 3,(hl)		;a55c	cb de 	. . 
	ld hl,05bdfh		;a55e	21 df 5b 	! . [ 
	ld (hl),040h		;a561	36 40 	6 @ 
	ret			;a563	c9 	. 
la564h:
	ld a,(05beah)		;a564	3a ea 5b 	: . [ 
	or a			;a567	b7 	. 
	jp z,la5e6h		;a568	ca e6 a5 	. . . 
	cp 008h		;a56b	fe 08 	. . 
	jp nc,la5e6h		;a56d	d2 e6 a5 	. . . 
	dec a			;a570	3d 	= 
	ld hl,05532h		;a571	21 32 55 	! 2 U 
	ld e,a			;a574	5f 	_ 
	ld d,000h		;a575	16 00 	. . 
	add hl,de			;a577	19 	. 
	ld a,(hl)			;a578	7e 	~ 
	or a			;a579	b7 	. 
	jr z,la5e6h		;a57a	28 6a 	( j 
	cp 008h		;a57c	fe 08 	. . 
	jr nc,la5e6h		;a57e	30 66 	0 f 
	dec a			;a580	3d 	= 
	add a,a			;a581	87 	. 
	ld hl,05bebh		;a582	21 eb 5b 	! . [ 
	ld e,a			;a585	5f 	_ 
	ld d,000h		;a586	16 00 	. . 
	add hl,de			;a588	19 	. 
	ld (05bd5h),hl		;a589	22 d5 5b 	" . [ 
	ld c,(hl)			;a58c	4e 	N 
	inc hl			;a58d	23 	# 
	ld b,(hl)			;a58e	46 	F 
	add a,a			;a58f	87 	. 
	ld e,a			;a590	5f 	_ 
	ld hl,05516h		;a591	21 16 55 	! . U 
	add hl,de			;a594	19 	. 
	ld e,(hl)			;a595	5e 	^ 
	inc hl			;a596	23 	# 
	ld d,(hl)			;a597	56 	V 
	inc hl			;a598	23 	# 
	push hl			;a599	e5 	. 
	push bc			;a59a	c5 	. 
	pop hl			;a59b	e1 	. 
	call CMP_HLDE		;a59c	cd 20 0f 	.   . 
	call c,sub_a5e0h		;a59f	dc e0 a5 	. . . 
	pop hl			;a5a2	e1 	. 
	ld e,(hl)			;a5a3	5e 	^ 
	inc hl			;a5a4	23 	# 
la5a5h:
	ld d,(hl)			;a5a5	56 	V 
	push bc			;a5a6	c5 	. 
	pop hl			;a5a7	e1 	. 
	ex de,hl			;a5a8	eb 	. 
	call CMP_HLDE		;a5a9	cd 20 0f 	.   . 
	ex de,hl			;a5ac	eb 	. 
	call c,sub_a5e0h		;a5ad	dc e0 a5 	. . . 
	ld de,0		;a5b0	11 00 00 	. . . 
	call CMP_HLDE		;a5b3	cd 20 0f 	.   . 
	jr z,la5e6h		;a5b6	28 2e 	( . 
	call sub_07f9h		;a5b8	cd f9 07 	. . . 
	cp 0ffh		;a5bb	fe ff 	. . 
	jr z,la5eeh		;a5bd	28 2f 	( / 
	ld (05be9h),a		;a5bf	32 e9 5b 	2 . [ 
	ld (05be3h),hl		;a5c2	22 e3 5b 	" . [ 
	call SETMEMMAP		;a5c5	cd 1a 0f 	. . . 
	set 0,(hl)		;a5c8	cb c6 	. . 
	ld de,00030h		;a5ca	11 30 00 	. 0 . 
	add hl,de			;a5cd	19 	. 
	ld (05be7h),hl		;a5ce	22 e7 5b 	" . [ 
	ld (05be1h),hl		;a5d1	22 e1 5b 	" . [ 
	call sub_a187h		;a5d4	cd 87 a1 	. . . 
	ld (05be5h),hl		;a5d7	22 e5 5b 	" . [ 
	call sub_a20dh		;a5da	cd 0d a2 	. . . 
	jp la52eh		;a5dd	c3 2e a5 	. . . 
sub_a5e0h:
	ld hl,05516h		;a5e0	21 16 55 	! . U 
	jp la228h		;a5e3	c3 28 a2 	. ( . 
la5e6h:
	ld a,000h		;a5e6	3e 00 	> . 
	ld (05bdfh),a		;a5e8	32 df 5b 	2 . [ 
	jp la54ah		;a5eb	c3 4a a5 	. J . 
la5eeh:
	call sub_a20dh		;a5ee	cd 0d a2 	. . . 
	jr la5e6h		;a5f1	18 f3 	. . 
sub_a5f3h:
	ld a,(05bffh)		;a5f3	3a ff 5b 	: . [ 
	or a			;a5f6	b7 	. 
	jr nz,la61fh		;a5f7	20 26 	  & 
	call sub_a2a1h		;a5f9	cd a1 a2 	. . . 
	ld a,b			;a5fc	78 	x 
	ld (05bfeh),a		;a5fd	32 fe 5b 	2 . [ 
	ld hl,05bfah		;a600	21 fa 5b 	! . [ 
	ld a,00dh		;a603	3e 0d 	> . 
	cp (hl)			;a605	be 	. 
	ret nz			;a606	c0 	. 
	inc hl			;a607	23 	# 
	inc hl			;a608	23 	# 
	cp (hl)			;a609	be 	. 
	ret nz			;a60a	c0 	. 
	ld a,01fh		;a60b	3e 1f 	> . 
	dec hl			;a60d	2b 	+ 
	cp (hl)			;a60e	be 	. 
	ret nz			;a60f	c0 	. 
	inc hl			;a610	23 	# 
	inc hl			;a611	23 	# 
	cp (hl)			;a612	be 	. 
	ret nz			;a613	c0 	. 
	ld a,01ch		;a614	3e 1c 	> . 
	inc hl			;a616	23 	# 
	cp (hl)			;a617	be 	. 
la618h:
	ret nz			;a618	c0 	. 
	ld a,001h		;a619	3e 01 	> . 
	ld (05bffh),a		;a61b	32 ff 5b 	2 . [ 
	ret			;a61e	c9 	. 
la61fh:
	call sub_a2a1h		;a61f	cd a1 a2 	. . . 
	ld a,b			;a622	78 	x 
	ld (de),a			;a623	12 	. 
	cp 00dh		;a624	fe 0d 	. . 
	jr z,la67eh		;a626	28 56 	( V 
	ld a,(05bffh)		;a628	3a ff 5b 	: . [ 
	inc a			;a62b	3c 	< 
	ld (05bffh),a		;a62c	32 ff 5b 	2 . [ 
	cp 007h		;a62f	fe 07 	. . 
	ret c			;a631	d8 	. 
	xor a			;a632	af 	. 
	ld (05bffh),a		;a633	32 ff 5b 	2 . [ 
	ld hl,05bf9h		;a636	21 f9 5b 	! . [ 
	ld a,01fh		;a639	3e 1f 	> . 
	cp (hl)			;a63b	be 	. 
	jr nz,la67eh		;a63c	20 40 	  @ 
	inc hl			;a63e	23 	# 
	cp (hl)			;a63f	be 	. 
	jr nz,la67eh		;a640	20 3c 	  < 
	inc hl			;a642	23 	# 
	cp (hl)			;a643	be 	. 
	jr nz,la67eh		;a644	20 38 	  8 
	inc hl			;a646	23 	# 
	cp (hl)			;a647	be 	. 
	jr nz,la662h		;a648	20 18 	  . 
	inc hl			;a64a	23 	# 
	cp (hl)			;a64b	be 	. 
	jr nz,la654h		;a64c	20 06 	  . 
	ld a,003h		;a64e	3e 03 	> . 
	ld (05beah),a		;a650	32 ea 5b 	2 . [ 
	ret			;a653	c9 	. 
la654h:
	inc hl			;a654	23 	# 
	cp (hl)			;a655	be 	. 
	jr z,la65eh		;a656	28 06 	( . 
	ld a,001h		;a658	3e 01 	> . 
la65ah:
	ld (05beah),a		;a65a	32 ea 5b 	2 . [ 
	ret			;a65d	c9 	. 
la65eh:
	ld a,002h		;a65e	3e 02 	> . 
	jr la65ah		;a660	18 f8 	. . 
la662h:
	inc hl			;a662	23 	# 
	cp (hl)			;a663	be 	. 
	jr z,la672h		;a664	28 0c 	( . 
	inc hl			;a666	23 	# 
	cp (hl)			;a667	be 	. 
	jr z,la66eh		;a668	28 04 	( . 
	ld a,006h		;a66a	3e 06 	> . 
	jr la65ah		;a66c	18 ec 	. . 
la66eh:
	ld a,007h		;a66e	3e 07 	> . 
	jr la65ah		;a670	18 e8 	. . 
la672h:
	inc hl			;a672	23 	# 
	cp (hl)			;a673	be 	. 
	jr nz,la67ah		;a674	20 04 	  . 
	ld a,005h		;a676	3e 05 	> . 
	jr la65ah		;a678	18 e0 	. . 
la67ah:
	ld a,004h		;a67a	3e 04 	> . 
	jr la65ah		;a67c	18 dc 	. . 
la67eh:
	xor a			;a67e	af 	. 
	ld (05bffh),a		;a67f	32 ff 5b 	2 . [ 
la682h:
	ret			;a682	c9 	. 
HANDLE_FIFO4_2:
	ld a,(CFG9)		;a683	3a 15 00 	: . . 
	cp 0aah		;a686	fe aa 	. . 
	ret nz			;a688	c0 	. 
	ld de,FIFO4		;a689	11 ec 40 	. . @ 
	call FIFO_READ		;a68c	cd e1 0e 	. . . 
	ret c			;a68f	d8 	. 
	res 7,a		;a690	cb bf 	. . 
	ld b,003h		;a692	06 03 	. . 
	call LOG_CHAR		;a694	cd e6 1a 	. . . 
	call sub_a818h		;a697	cd 18 a8 	. . . 
	ld c,a			;a69a	4f 	O 
	ld ix,05541h		;a69b	dd 21 41 55 	. ! A U 
	ld iy,05c00h		;a69f	fd 21 00 5c 	. ! . \ 
	ld b,041h		;a6a3	06 41 	. A 
	call sub_a6b2h		;a6a5	cd b2 a6 	. . . 
	ld ix,05542h		;a6a8	dd 21 42 55 	. ! B U 
	ld iy,05c0ch		;a6ac	fd 21 0c 5c 	. ! . \ 
	ld b,042h		;a6b0	06 42 	. B 
sub_a6b2h:
	ld a,(iy+000h)		;a6b2	fd 7e 00 	. ~ . 
	cp 004h		;a6b5	fe 04 	. . 
	jr z,la70fh		;a6b7	28 56 	( V 
	cp 001h		;a6b9	fe 01 	. . 
	jr z,la6cch		;a6bb	28 0f 	( . 
	cp 002h		;a6bd	fe 02 	. . 
	jr z,la6d4h		;a6bf	28 13 	( . 
	cp 003h		;a6c1	fe 03 	. . 
	jr z,la6f2h		;a6c3	28 2d 	( - 
	ld a,001h		;a6c5	3e 01 	> . 
	ld (iy+000h),a		;a6c7	fd 77 00 	. w . 
	jr sub_a6b2h		;a6ca	18 e6 	. . 
la6cch:
	ld a,c			;a6cc	79 	y 
	cp 001h		;a6cd	fe 01 	. . 
	ret nz			;a6cf	c0 	. 
	inc (iy+000h)		;a6d0	fd 34 00 	. 4 . 
	ret			;a6d3	c9 	. 
la6d4h:
	ld a,c			;a6d4	79 	y 
	cp b			;a6d5	b8 	. 
	jr nz,la6dch		;a6d6	20 04 	  . 
	inc (iy+000h)		;a6d8	fd 34 00 	. 4 . 
	ret			;a6db	c9 	. 
la6dch:
	ld a,(ix+000h)		;a6dc	dd 7e 00 	. ~ . 
	cp 044h		;a6df	fe 44 	. D 
	jr nz,la6e8h		;a6e1	20 05 	  . 
	inc (iy+000h)		;a6e3	fd 34 00 	. 4 . 
	jr la6f2h		;a6e6	18 0a 	. . 
la6e8h:
	ld a,001h		;a6e8	3e 01 	> . 
	ld (iy+000h),a		;a6ea	fd 77 00 	. w . 
	xor a			;a6ed	af 	. 
	ld (iy+001h),a		;a6ee	fd 77 01 	. w . 
	ret			;a6f1	c9 	. 
la6f2h:
	ld a,c			;a6f2	79 	y 
	cp 002h		;a6f3	fe 02 	. . 
	jr nz,la703h		;a6f5	20 0c 	  . 
	ld a,020h		;a6f7	3e 20 	>   
	ld (iy+00bh),a		;a6f9	fd 77 0b 	. w . 
	call sub_a75fh		;a6fc	cd 5f a7 	. _ . 
	inc (iy+000h)		;a6ff	fd 34 00 	. 4 . 
	ret			;a702	c9 	. 
la703h:
	inc (iy+001h)		;a703	fd 34 01 	. 4 . 
	ld a,005h		;a706	3e 05 	> . 
	sub (iy+001h)		;a708	fd 96 01 	. . . 
	call c,la6e8h		;a70b	dc e8 a6 	. . . 
	ret			;a70e	c9 	. 
la70fh:
	ld a,c			;a70f	79 	y 
	cp 003h		;a710	fe 03 	. . 
	jp z,la79eh		;a712	ca 9e a7 	. . . 
	jp la7b9h		;a715	c3 b9 a7 	. . . 
sub_a718h:
	ld e,(iy+002h)		;a718	fd 5e 02 	. ^ . 
	ld d,(iy+003h)		;a71b	fd 56 03 	. V . 
	inc de			;a71e	13 	. 
	ld a,(ix+000h)		;a71f	dd 7e 00 	. ~ . 
	or a			;a722	b7 	. 
	jr z,la75ch		;a723	28 37 	( 7 
	cp 002h		;a725	fe 02 	. . 
	jr z,la72fh		;a727	28 06 	( . 
	ld ix,05539h		;a729	dd 21 39 55 	. ! 9 U 
	jr la733h		;a72d	18 04 	. . 
la72fh:
	ld ix,0553dh		;a72f	dd 21 3d 55 	. ! = U 
la733h:
	ld l,(ix+002h)		;a733	dd 6e 02 	. n . 
	ld h,(ix+003h)		;a736	dd 66 03 	. f . 
	call CMP_HLDE		;a739	cd 20 0f 	.   . 
	jr c,la74ah		;a73c	38 0c 	8 . 
	ld l,(ix+000h)		;a73e	dd 6e 00 	. n . 
	ld h,(ix+001h)		;a741	dd 66 01 	. f . 
	ex de,hl			;a744	eb 	. 
	call CMP_HLDE		;a745	cd 20 0f 	.   . 
	jr nc,la754h		;a748	30 0a 	0 . 
la74ah:
	ld l,(ix+000h)		;a74a	dd 6e 00 	. n . 
	ld h,(ix+001h)		;a74d	dd 66 01 	. f . 
	ld a,h			;a750	7c 	| 
	or l			;a751	b5 	. 
	jr z,la75ch		;a752	28 08 	( . 
la754h:
	ld (iy+002h),l		;a754	fd 75 02 	. u . 
	ld (iy+003h),h		;a757	fd 74 03 	. t . 
	xor a			;a75a	af 	. 
	ret			;a75b	c9 	. 
la75ch:
	ld a,0ffh		;a75c	3e ff 	> . 
	ret			;a75e	c9 	. 
sub_a75fh:
	call sub_a718h		;a75f	cd 18 a7 	. . . 
	cp 0ffh		;a762	fe ff 	. . 
	jp z,la6e8h		;a764	ca e8 a6 	. . . 
	call sub_07f9h		;a767	cd f9 07 	. . . 
	cp 0ffh		;a76a	fe ff 	. . 
	jp z,la6e8h		;a76c	ca e8 a6 	. . . 
	call sub_a773h		;a76f	cd 73 a7 	. s . 
	ret			;a772	c9 	. 
sub_a773h:
	ld (iy+00ah),a		;a773	fd 77 0a 	. w . 
	call SETMEMMAP		;a776	cd 1a 0f 	. . . 
	set 0,(hl)		;a779	cb c6 	. . 
	ld de,0002fh		;a77b	11 2f 00 	. / . 
	add hl,de			;a77e	19 	. 
	ld (iy+004h),l		;a77f	fd 75 04 	. u . 
	ld (iy+005h),h		;a782	fd 74 05 	. t . 
	ld d,000h		;a785	16 00 	. . 
	ld e,(iy+00bh)		;a787	fd 5e 0b 	. ^ . 
	ex de,hl			;a78a	eb 	. 
	add hl,de			;a78b	19 	. 
	ld (iy+008h),l		;a78c	fd 75 08 	. u . 
	ld (iy+009h),h		;a78f	fd 74 09 	. t . 
	inc de			;a792	13 	. 
	ex de,hl			;a793	eb 	. 
	call sub_a187h		;a794	cd 87 a1 	. . . 
	ld (iy+006h),l		;a797	fd 75 06 	. u . 
	ld (iy+007h),h		;a79a	fd 74 07 	. t . 
	ret			;a79d	c9 	. 
la79eh:
	call sub_a7a4h		;a79e	cd a4 a7 	. . . 
	jp la6e8h		;a7a1	c3 e8 a6 	. . . 
sub_a7a4h:
	ld a,(iy+00ah)		;a7a4	fd 7e 0a 	. ~ . 
	call SETMEMMAP		;a7a7	cd 1a 0f 	. . . 
	ld l,(iy+006h)		;a7aa	fd 6e 06 	. n . 
	ld h,(iy+007h)		;a7ad	fd 66 07 	. f . 
	ld de,0fe91h		;a7b0	11 91 fe 	. . . 
	add hl,de			;a7b3	19 	. 
	res 0,(hl)		;a7b4	cb 86 	. . 
	set 3,(hl)		;a7b6	cb de 	. . 
	ret			;a7b8	c9 	. 
la7b9h:
	ld a,(iy+00ah)		;a7b9	fd 7e 0a 	. ~ . 
	call SETMEMMAP		;a7bc	cd 1a 0f 	. . . 
	ld a,(05541h)		;a7bf	3a 41 55 	: A U 
	cp 044h		;a7c2	fe 44 	. D 
	jr nz,la7cbh		;a7c4	20 05 	  . 
	ld a,c			;a7c6	79 	y 
	cp 00dh		;a7c7	fe 0d 	. . 
	jr z,la801h		;a7c9	28 36 	( 6 
la7cbh:
	ld a,c			;a7cb	79 	y 
	cp 00ah		;a7cc	fe 0a 	. . 
	jr z,la801h		;a7ce	28 31 	( 1 
	cp 020h		;a7d0	fe 20 	.   
	ret c			;a7d2	d8 	. 
	ld e,(iy+004h)		;a7d3	fd 5e 04 	. ^ . 
	ld d,(iy+005h)		;a7d6	fd 56 05 	. V . 
	inc de			;a7d9	13 	. 
la7dah:
	ld l,(iy+006h)		;a7da	fd 6e 06 	. n . 
	ld h,(iy+007h)		;a7dd	fd 66 07 	. f . 
	call CMP_HLDE		;a7e0	cd 20 0f 	.   . 
	jr c,la79eh		;a7e3	38 b9 	8 . 
	ld l,(iy+008h)		;a7e5	fd 6e 08 	. n . 
	ld h,(iy+009h)		;a7e8	fd 66 09 	. f . 
	call CMP_HLDE		;a7eb	cd 20 0f 	.   . 
	jr c,la801h		;a7ee	38 11 	8 . 
	ex de,hl			;a7f0	eb 	. 
	ld (hl),c			;a7f1	71 	q 
	ld a,01fh		;a7f2	3e 1f 	> . 
	cp c			;a7f4	b9 	. 
	jr c,la7fah		;a7f5	38 03 	8 . 
	ld (hl),020h		;a7f7	36 20 	6   
	dec hl			;a7f9	2b 	+ 
la7fah:
	ld (iy+004h),l		;a7fa	fd 75 04 	. u . 
	ld (iy+005h),h		;a7fd	fd 74 05 	. t . 
	ret			;a800	c9 	. 
la801h:
	ld e,(iy+008h)		;a801	fd 5e 08 	. ^ . 
	ld d,(iy+009h)		;a804	fd 56 09 	. V . 
	ld hl,00028h		;a807	21 28 00 	! ( . 
	add hl,de			;a80a	19 	. 
	ld (iy+008h),l		;a80b	fd 75 08 	. u . 
	ld (iy+009h),h		;a80e	fd 74 09 	. t . 
	ld hl,00009h		;a811	21 09 00 	! . . 
	add hl,de			;a814	19 	. 
	ex de,hl			;a815	eb 	. 
	jr la7dah		;a816	18 c2 	. . 
sub_a818h:
	cp 07eh		;a818	fe 7e 	. ~ 
	jr nz,la81eh		;a81a	20 02 	  . 
	ld a,063h		;a81c	3e 63 	> c 
la81eh:
	cp 060h		;a81e	fe 60 	. ` 
	jr nz,la824h		;a820	20 02 	  . 
	ld a,027h		;a822	3e 27 	> ' 
la824h:
	cp 07ch		;a824	fe 7c 	. | 
	ret nz			;a826	c0 	. 
	ld a,05ch		;a827	3e 5c 	> \ 
	ret			;a829	c9 	. 
HANDLE_FIFO6:
	ld de,FIFO6		;a82a	11 f4 40 	. . @ 
	call FIFO_READ		;a82d	cd e1 0e 	. . . 
	ret c			;a830	d8 	. 
	ld c,a			;a831	4f 	O 
	ld a,(00017h)		;a832	3a 17 00 	: . . 
	cp 0aah		;a835	fe aa 	. . 
	jp z,laaa0h		;a837	ca a0 aa 	. . . 
	ld hl,05c1ch		;a83a	21 1c 5c 	! . \ 
	ld a,(0558bh)		;a83d	3a 8b 55 	: . U 
	cp 042h		;a840	fe 42 	. B 
	ld a,c			;a842	79 	y 
	jr nz,la84ah		;a843	20 05 	  . 
	M_CALL_WITH_MMAP0 sub_c103h
la84ah:
	res 7,a		;a84a	cb bf 	. . 
	ld b,005h		;a84c	06 05 	. . 
	call LOG_CHAR		;a84e	cd e6 1a 	. . . 
	call sub_a85eh		;a851	cd 5e a8 	. ^ . 
	ret z			;a854	c8 	. 
	call sub_a870h		;a855	cd 70 a8 	. p . 
	call sub_a89dh		;a858	cd 9d a8 	. . . 
	jp laa2ah		;a85b	c3 2a aa 	. * . 
sub_a85eh:
	call sub_a8e7h		;a85e	cd e7 a8 	. . . 
	or a			;a861	b7 	. 
	ret z			;a862	c8 	. 
	ld bc,00003h		;a863	01 03 00 	. . . 
	ld hl,05c1eh		;a866	21 1e 5c 	! . \ 
	ld de,05c1dh		;a869	11 1d 5c 	. . \ 
	ldir		;a86c	ed b0 	. . 
	ld (de),a			;a86e	12 	. 
	ret			;a86f	c9 	. 
sub_a870h:
	call sub_a881h		;a870	cd 81 a8 	. . . 
	or a			;a873	b7 	. 
	jr nz,la879h		;a874	20 03 	  . 
	jp la993h		;a876	c3 93 a9 	. . . 
la879h:
	call sub_a88fh		;a879	cd 8f a8 	. . . 
	or a			;a87c	b7 	. 
	ret nz			;a87d	c0 	. 
	jp la9c0h		;a87e	c3 c0 a9 	. . . 
sub_a881h:
	ld b,004h		;a881	06 04 	. . 
	ld hl,05c1dh		;a883	21 1d 5c 	! . \ 
la886h:
	ld a,(hl)			;a886	7e 	~ 
	sub 04eh		;a887	d6 4e 	. N 
	ret nz			;a889	c0 	. 
	inc hl			;a88a	23 	# 
	djnz la886h		;a88b	10 f9 	. . 
	xor a			;a88d	af 	. 
	ret			;a88e	c9 	. 
sub_a88fh:
	ld a,(05c1fh)		;a88f	3a 1f 5c 	: . \ 
	sub 024h		;a892	d6 24 	. $ 
	ret nz			;a894	c0 	. 
	ld a,(05c20h)		;a895	3a 20 5c 	:   \ 
	sub 024h		;a898	d6 24 	. $ 
	ret nz			;a89a	c0 	. 
	xor a			;a89b	af 	. 
	ret			;a89c	c9 	. 
sub_a89dh:
	ld c,008h		;a89d	0e 08 	. . 
	ld ix,05543h		;a89f	dd 21 43 55 	. ! C U 
	ld iy,05c21h		;a8a3	fd 21 21 5c 	. ! ! \ 
la8a7h:
	call sub_a8b8h		;a8a7	cd b8 a8 	. . . 
	ld de,00009h		;a8aa	11 09 00 	. . . 
	add ix,de		;a8ad	dd 19 	. . 
	ld de,0000eh		;a8af	11 0e 00 	. . . 
	add iy,de		;a8b2	fd 19 	. . 
	dec c			;a8b4	0d 	. 
	jr nz,la8a7h		;a8b5	20 f0 	  . 
	ret			;a8b7	c9 	. 
sub_a8b8h:
	ld a,(iy+000h)		;a8b8	fd 7e 00 	. ~ . 
	cp 004h		;a8bb	fe 04 	. . 
	ret z			;a8bd	c8 	. 
	ld a,(ix+002h)		;a8be	dd 7e 02 	. ~ . 
	or (ix+003h)		;a8c1	dd b6 03 	. . . 
	ret z			;a8c4	c8 	. 
	push ix		;a8c5	dd e5 	. . 
	ld hl,05c1dh		;a8c7	21 1d 5c 	! . \ 
	ld b,004h		;a8ca	06 04 	. . 
la8cch:
	ld a,(ix+005h)		;a8cc	dd 7e 05 	. ~ . 
	sub (hl)			;a8cf	96 	. 
	jr nz,la8e4h		;a8d0	20 12 	  . 
	inc ix		;a8d2	dd 23 	. # 
	inc hl			;a8d4	23 	# 
	djnz la8cch		;a8d5	10 f5 	. . 
	pop ix		;a8d7	dd e1 	. . 
	ld (iy+002h),000h		;a8d9	fd 36 02 00 	. 6 . . 
	ld (iy+003h),000h		;a8dd	fd 36 03 00 	. 6 . . 
	jp la934h		;a8e1	c3 34 a9 	. 4 . 
la8e4h:
	pop ix		;a8e4	dd e1 	. . 
	ret			;a8e6	c9 	. 
sub_a8e7h:
	cp 00dh		;a8e7	fe 0d 	. . 
	jr z,la8f0h		;a8e9	28 05 	( . 
	cp 020h		;a8eb	fe 20 	.   
	ret nc			;a8ed	d0 	. 
	xor a			;a8ee	af 	. 
	ret			;a8ef	c9 	. 
la8f0h:
	ld a,020h		;a8f0	3e 20 	>   
	ret			;a8f2	c9 	. 
sub_a8f3h:
	ld e,(iy+002h)		;a8f3	fd 5e 02 	. ^ . 
	ld d,(iy+003h)		;a8f6	fd 56 03 	. V . 
	inc de			;a8f9	13 	. 
	ld l,(ix+002h)		;a8fa	dd 6e 02 	. n . 
	ld h,(ix+003h)		;a8fd	dd 66 03 	. f . 
	ld a,h			;a900	7c 	| 
	or l			;a901	b5 	. 
	jr z,la92fh		;a902	28 2b 	( + 
	call CMP_HLDE		;a904	cd 20 0f 	.   . 
	jr c,la92fh		;a907	38 26 	8 & 
	ld l,(ix+000h)		;a909	dd 6e 00 	. n . 
	ld h,(ix+001h)		;a90c	dd 66 01 	. f . 
	ex de,hl			;a90f	eb 	. 
	call CMP_HLDE		;a910	cd 20 0f 	.   . 
	jr c,la91dh		;a913	38 08 	8 . 
	ld (iy+002h),l		;a915	fd 75 02 	. u . 
	ld (iy+003h),h		;a918	fd 74 03 	. t . 
	or a			;a91b	b7 	. 
	ret			;a91c	c9 	. 
la91dh:
	ld l,(ix+000h)		;a91d	dd 6e 00 	. n . 
	ld h,(ix+001h)		;a920	dd 66 01 	. f . 
	ld a,h			;a923	7c 	| 
	or l			;a924	b5 	. 
	jr z,la92fh		;a925	28 08 	( . 
	ld (iy+002h),l		;a927	fd 75 02 	. u . 
	ld (iy+003h),h		;a92a	fd 74 03 	. t . 
	or a			;a92d	b7 	. 
	ret			;a92e	c9 	. 
la92fh:
	call la6e8h		;a92f	cd e8 a6 	. . . 
	scf			;a932	37 	7 
	ret			;a933	c9 	. 
la934h:
	push bc			;a934	c5 	. 
	ld a,020h		;a935	3e 20 	>   
	ld (iy+00bh),a		;a937	fd 77 0b 	. w . 
	call sub_a8f3h		;a93a	cd f3 a8 	. . . 
	jr c,la94fh		;a93d	38 10 	8 . 
	call sub_07f9h		;a93f	cd f9 07 	. . . 
	cp 0ffh		;a942	fe ff 	. . 
	jr z,la94fh		;a944	28 09 	( . 
	call sub_a773h		;a946	cd 73 a7 	. s . 
	ld (iy+000h),004h		;a949	fd 36 00 04 	. 6 . . 
	pop bc			;a94d	c1 	. 
	ret			;a94e	c9 	. 
la94fh:
	call la6e8h		;a94f	cd e8 a6 	. . . 
	pop bc			;a952	c1 	. 
	ret			;a953	c9 	. 
sub_a954h:
	push bc			;a954	c5 	. 
	call sub_a9ceh		;a955	cd ce a9 	. . . 
	ld e,(iy+008h)		;a958	fd 5e 08 	. ^ . 
	ld d,(iy+009h)		;a95b	fd 56 09 	. V . 
	ld hl,00028h		;a95e	21 28 00 	! ( . 
	add hl,de			;a961	19 	. 
	ld e,(iy+006h)		;a962	fd 5e 06 	. ^ . 
	ld d,(iy+007h)		;a965	fd 56 07 	. V . 
	ex de,hl			;a968	eb 	. 
	call CMP_HLDE		;a969	cd 20 0f 	.   . 
	jr nc,la979h		;a96c	30 0b 	0 . 
	call sub_a7a4h		;a96e	cd a4 a7 	. . . 
	call la934h		;a971	cd 34 a9 	. 4 . 
	call sub_aa04h		;a974	cd 04 aa 	. . . 
	pop bc			;a977	c1 	. 
	ret			;a978	c9 	. 
la979h:
	ex de,hl			;a979	eb 	. 
	ld d,000h		;a97a	16 00 	. . 
	ld e,(iy+00bh)		;a97c	fd 5e 0b 	. ^ . 
	ld (iy+008h),l		;a97f	fd 75 08 	. u . 
	ld (iy+009h),h		;a982	fd 74 09 	. t . 
	or a			;a985	b7 	. 
	sbc hl,de		;a986	ed 52 	. R 
	ld (iy+004h),l		;a988	fd 75 04 	. u . 
	ld (iy+005h),h		;a98b	fd 74 05 	. t . 
	call sub_aa04h		;a98e	cd 04 aa 	. . . 
	pop bc			;a991	c1 	. 
	ret			;a992	c9 	. 
la993h:
	ld iy,05c21h		;a993	fd 21 21 5c 	. ! ! \ 
	ld ix,05543h		;a997	dd 21 43 55 	. ! C U 
	ld b,008h		;a99b	06 08 	. . 
la99dh:
	call sub_a9adh		;a99d	cd ad a9 	. . . 
	ld de,0000eh		;a9a0	11 0e 00 	. . . 
	add iy,de		;a9a3	fd 19 	. . 
	ld de,00009h		;a9a5	11 09 00 	. . . 
	add ix,de		;a9a8	dd 19 	. . 
	djnz la99dh		;a9aa	10 f1 	. . 
	ret			;a9ac	c9 	. 
sub_a9adh:
	ld a,(iy+000h)		;a9ad	fd 7e 00 	. ~ . 
	cp 004h		;a9b0	fe 04 	. . 
	ret nz			;a9b2	c0 	. 
	ld (iy+000h),001h		;a9b3	fd 36 00 01 	. 6 . . 
	call sub_a7a4h		;a9b7	cd a4 a7 	. . . 
	push bc			;a9ba	c5 	. 
	call sub_aa84h		;a9bb	cd 84 aa 	. . . 
	pop bc			;a9be	c1 	. 
	ret			;a9bf	c9 	. 
la9c0h:
	call laa2ah		;a9c0	cd 2a aa 	. * . 
	ld a,020h		;a9c3	3e 20 	>   
	call sub_a85eh		;a9c5	cd 5e a8 	. ^ . 
	call laa2ah		;a9c8	cd 2a aa 	. * . 
	jp la993h		;a9cb	c3 93 a9 	. . . 
sub_a9ceh:
	ld bc,0		;a9ce	01 00 00 	. . . 
	ld a,(ix+004h)		;a9d1	dd 7e 04 	. ~ . 
	cp 059h		;a9d4	fe 59 	. Y 
	ret nz			;a9d6	c0 	. 
	ld a,(05c1dh)		;a9d7	3a 1d 5c 	: . \ 
	cp 020h		;a9da	fe 20 	.   
	ret z			;a9dc	c8 	. 
	ld a,020h		;a9dd	3e 20 	>   
	ld l,(iy+004h)		;a9df	fd 6e 04 	. n . 
	ld h,(iy+005h)		;a9e2	fd 66 05 	. f . 
	ld c,(iy+00bh)		;a9e5	fd 4e 0b 	. N . 
	cpdr		;a9e8	ed b9 	. . 
	ld a,b			;a9ea	78 	x 
	or c			;a9eb	b1 	. 
	ret z			;a9ec	c8 	. 
	inc bc			;a9ed	03 	. 
	ld a,(iy+00bh)		;a9ee	fd 7e 0b 	. ~ . 
	sub c			;a9f1	91 	. 
	ld c,a			;a9f2	4f 	O 
	ret z			;a9f3	c8 	. 
	inc hl			;a9f4	23 	# 
	push hl			;a9f5	e5 	. 
	inc hl			;a9f6	23 	# 
	push hl			;a9f7	e5 	. 
	ld de,05c91h		;a9f8	11 91 5c 	. . \ 
	ldir		;a9fb	ed b0 	. . 
	pop de			;a9fd	d1 	. 
	pop hl			;a9fe	e1 	. 
	ld c,a			;a9ff	4f 	O 
	ldir		;aa00	ed b0 	. . 
	ld c,a			;aa02	4f 	O 
	ret			;aa03	c9 	. 
sub_aa04h:
	ld a,c			;aa04	79 	y 
	ld e,(iy+004h)		;aa05	fd 5e 04 	. ^ . 
	ld d,(iy+005h)		;aa08	fd 56 05 	. V . 
	or a			;aa0b	b7 	. 
	jr nz,laa1ch		;aa0c	20 0e 	  . 
	ld a,(ix+004h)		;aa0e	dd 7e 04 	. ~ . 
	cp 059h		;aa11	fe 59 	. Y 
	ret nz			;aa13	c0 	. 
	ld a,(05c1dh)		;aa14	3a 1d 5c 	: . \ 
	cp 020h		;aa17	fe 20 	.   
	ret nz			;aa19	c0 	. 
	jr laa22h		;aa1a	18 06 	. . 
laa1ch:
	inc de			;aa1c	13 	. 
	ld hl,05c91h		;aa1d	21 91 5c 	! . \ 
	ldir		;aa20	ed b0 	. . 
laa22h:
	dec de			;aa22	1b 	. 
	ld (iy+004h),e		;aa23	fd 73 04 	. s . 
	ld (iy+005h),d		;aa26	fd 72 05 	. r . 
	ret			;aa29	c9 	. 
laa2ah:
	ld iy,05c21h		;aa2a	fd 21 21 5c 	. ! ! \ 
	ld ix,05543h		;aa2e	dd 21 43 55 	. ! C U 
	ld a,(05c1dh)		;aa32	3a 1d 5c 	: . \ 
	ld c,a			;aa35	4f 	O 
	ld b,008h		;aa36	06 08 	. . 
laa38h:
	ld a,(iy+000h)		;aa38	fd 7e 00 	. ~ . 
	cp 004h		;aa3b	fe 04 	. . 
	call z,sub_aa4dh		;aa3d	cc 4d aa 	. M . 
	ld de,00009h		;aa40	11 09 00 	. . . 
	add ix,de		;aa43	dd 19 	. . 
	ld de,0000eh		;aa45	11 0e 00 	. . . 
	add iy,de		;aa48	fd 19 	. . 
	djnz laa38h		;aa4a	10 ec 	. . 
	ret			;aa4c	c9 	. 
sub_aa4dh:
	ld a,(iy+00ah)		;aa4d	fd 7e 0a 	. ~ . 
	call SETMEMMAP		;aa50	cd 1a 0f 	. . . 
	ld a,c			;aa53	79 	y 
	cp 020h		;aa54	fe 20 	.   
	ret c			;aa56	d8 	. 
	ld e,(iy+004h)		;aa57	fd 5e 04 	. ^ . 
	ld d,(iy+005h)		;aa5a	fd 56 05 	. V . 
	inc de			;aa5d	13 	. 
	ld l,(iy+008h)		;aa5e	fd 6e 08 	. n . 
	ld h,(iy+009h)		;aa61	fd 66 09 	. f . 
	call CMP_HLDE		;aa64	cd 20 0f 	.   . 
	jr nc,laa7bh		;aa67	30 12 	0 . 
	call sub_a954h		;aa69	cd 54 a9 	. T . 
	ld a,c			;aa6c	79 	y 
	ld e,(iy+004h)		;aa6d	fd 5e 04 	. ^ . 
	ld d,(iy+005h)		;aa70	fd 56 05 	. V . 
	inc de			;aa73	13 	. 
	cp 020h		;aa74	fe 20 	.   
	jr nz,laa7bh		;aa76	20 03 	  . 
	ex de,hl			;aa78	eb 	. 
	jr laa7dh		;aa79	18 02 	. . 
laa7bh:
	ex de,hl			;aa7b	eb 	. 
	ld (hl),c			;aa7c	71 	q 
laa7dh:
	ld (iy+004h),l		;aa7d	fd 75 04 	. u . 
	ld (iy+005h),h		;aa80	fd 74 05 	. t . 
	ret			;aa83	c9 	. 
sub_aa84h:
	call sub_a8f3h		;aa84	cd f3 a8 	. . . 
	jr nc,laa94h		;aa87	30 0b 	0 . 
laa89h:
	xor a			;aa89	af 	. 
	ld (iy+002h),a		;aa8a	fd 77 02 	. w . 
	ld (iy+003h),a		;aa8d	fd 77 03 	. w . 
	ld (iy+000h),a		;aa90	fd 77 00 	. w . 
	ret			;aa93	c9 	. 
laa94h:
	call sub_07f9h		;aa94	cd f9 07 	. . . 
	cp 0ffh		;aa97	fe ff 	. . 
	jr z,laa89h		;aa99	28 ee 	( . 
	call sub_a773h		;aa9b	cd 73 a7 	. s . 
	jr sub_aa84h		;aa9e	18 e4 	. . 
laaa0h:
	ld a,(CFG8)		;aaa0	3a 3d 00 	: = . 
	bit 1,a		;aaa3	cb 4f 	. O 
	ld a,c			;aaa5	79 	y 
	jr z,laacfh		;aaa6	28 27 	( ' 
	and 03fh		;aaa8	e6 3f 	. ? 
	cp 036h		;aaaa	fe 36 	. 6 
	ret z			;aaac	c8 	. 
	cp 02bh		;aaad	fe 2b 	. + 
	ret z			;aaaf	c8 	. 
	cp 032h		;aab0	fe 32 	. 2 
	ret z			;aab2	c8 	. 
	cp 01fh		;aab3	fe 1f 	. . 
	ret z			;aab5	c8 	. 
	ld b,020h		;aab6	06 20 	.   
	cp 02fh		;aab8	fe 2f 	. / 
	jr z,laacch		;aaba	28 10 	( . 
	cp 02ah		;aabc	fe 2a 	. * 
	jr z,laacch		;aabe	28 0c 	( . 
	ld b,02ah		;aac0	06 2a 	. * 
	cp 037h		;aac2	fe 37 	. 7 
	jr z,laacch		;aac4	28 06 	( . 
	ld b,098h		;aac6	06 98 	. . 
	cp 027h		;aac8	fe 27 	. ' 
	jr nz,laacfh		;aaca	20 03 	  . 
laacch:
	ld a,b			;aacc	78 	x 
	jr laad2h		;aacd	18 03 	. . 
laacfh:
	call KEY2CHAR		;aacf	cd f2 0f 	. . . 
laad2h:
	ld b,005h		;aad2	06 05 	. . 
	call LOG_CHAR		;aad4	cd e6 1a 	. . . 
	ld (0604eh),a		;aad7	32 4e 60 	2 N ` 
	ld a,0ffh		;aada	3e ff 	> . 
	ld (05fd5h),a		;aadc	32 d5 5f 	2 . _ 
	ld a,(06043h)		;aadf	3a 43 60 	: C ` 
	or a			;aae2	b7 	. 
	jr z,lab34h		;aae3	28 4f 	( O 
	call sub_abcah		;aae5	cd ca ab 	. . . 
	ld a,(06044h)		;aae8	3a 44 60 	: D ` 
	cp 008h		;aaeb	fe 08 	. . 
	ret nz			;aaed	c0 	. 
	xor a			;aaee	af 	. 
	ld (06043h),a		;aaef	32 43 60 	2 C ` 
	ld a,(06049h)		;aaf2	3a 49 60 	: I ` 
	ld hl,0603ah		;aaf5	21 3a 60 	! : ` 
	ld de,00003h		;aaf8	11 03 00 	. . . 
	cp 001h		;aafb	fe 01 	. . 
	jr z,lab05h		;aafd	28 06 	( . 
	add hl,de			;aaff	19 	. 
	cp 002h		;ab00	fe 02 	. . 
	jr z,lab05h		;ab02	28 01 	( . 
	add hl,de			;ab04	19 	. 
lab05h:
	ld a,(hl)			;ab05	7e 	~ 
	call SETMEMMAP		;ab06	cd 1a 0f 	. . . 
	inc hl			;ab09	23 	# 
	ld e,(hl)			;ab0a	5e 	^ 
	inc hl			;ab0b	23 	# 
	ld d,(hl)			;ab0c	56 	V 
	ld a,(de)			;ab0d	1a 	. 
	and 080h		;ab0e	e6 80 	. . 
	ld a,000h		;ab10	3e 00 	> . 
	jr z,lab18h		;ab12	28 04 	( . 
	ld a,(06052h)		;ab14	3a 52 60 	: R ` 
	inc a			;ab17	3c 	< 
lab18h:
	ld b,a			;ab18	47 	G 
	push bc			;ab19	c5 	. 
	call sub_abfah		;ab1a	cd fa ab 	. . . 
	call SETMEMMAP		;ab1d	cd 1a 0f 	. . . 
	pop bc			;ab20	c1 	. 
	ld (hl),0c8h		;ab21	36 c8 	6 . 
	ld hl,(06050h)		;ab23	2a 50 60 	* P ` 
	ld a,l			;ab26	7d 	} 
	or h			;ab27	b4 	. 
	ret z			;ab28	c8 	. 
	ld a,(hl)			;ab29	7e 	~ 
	or a			;ab2a	b7 	. 
	ret z			;ab2b	c8 	. 
	cp 00ch		;ab2c	fe 0c 	. . 
	ret nc			;ab2e	d0 	. 
	ld a,b			;ab2f	78 	x 
	or a			;ab30	b7 	. 
	ret z			;ab31	c8 	. 
	ld (hl),a			;ab32	77 	w 
	ret			;ab33	c9 	. 
lab34h:
	ld hl,(0558dh)		;ab34	2a 8d 55 	* . U 
	ld a,l			;ab37	7d 	} 
	or h			;ab38	b4 	. 
	ret z			;ab39	c8 	. 
	ld de,(0604ah)		;ab3a	ed 5b 4a 60 	. [ J ` 
	call CMP_HLDE		;ab3e	cd 20 0f 	.   . 
	jr z,lab6fh		;ab41	28 2c 	( , 
	ld (0604ah),hl		;ab43	22 4a 60 	" J ` 
	call sub_07f9h		;ab46	cd f9 07 	. . . 
	ld (0603ah),a		;ab49	32 3a 60 	2 : ` 
	ld (0603bh),hl		;ab4c	22 3b 60 	" ; ` 
	ld hl,(0604ah)		;ab4f	2a 4a 60 	* J ` 
	inc hl			;ab52	23 	# 
	call sub_07f9h		;ab53	cd f9 07 	. . . 
	ld (0603dh),a		;ab56	32 3d 60 	2 = ` 
	ld (0603eh),hl		;ab59	22 3e 60 	" > ` 
	ld hl,(0604ah)		;ab5c	2a 4a 60 	* J ` 
	inc hl			;ab5f	23 	# 
	inc hl			;ab60	23 	# 
	call sub_07f9h		;ab61	cd f9 07 	. . . 
	ld (06040h),a		;ab64	32 40 60 	2 @ ` 
	ld (06041h),hl		;ab67	22 41 60 	" A ` 
	ld a,002h		;ab6a	3e 02 	> . 
	ld (06049h),a		;ab6c	32 49 60 	2 I ` 
lab6fh:
	ld a,(06049h)		;ab6f	3a 49 60 	: I ` 
	inc a			;ab72	3c 	< 
	cp 003h		;ab73	fe 03 	. . 
	jr c,lab79h		;ab75	38 02 	8 . 
	ld a,000h		;ab77	3e 00 	> . 
lab79h:
	ld (06049h),a		;ab79	32 49 60 	2 I ` 
	call sub_abfah		;ab7c	cd fa ab 	. . . 
	call SETMEMMAP		;ab7f	cd 1a 0f 	. . . 
	ld (06048h),a		;ab82	32 48 60 	2 H ` 
	ld a,(hl)			;ab85	7e 	~ 
	and 080h		;ab86	e6 80 	. . 
	jr z,lab91h		;ab88	28 07 	( . 
	ld a,(0604fh)		;ab8a	3a 4f 60 	: O ` 
	inc a			;ab8d	3c 	< 
	ld (0604fh),a		;ab8e	32 4f 60 	2 O ` 
lab91h:
	ld (hl),040h		;ab91	36 40 	6 @ 
	ld de,00012h		;ab93	11 12 00 	. . . 
	add hl,de			;ab96	19 	. 
	ld a,(hl)			;ab97	7e 	~ 
	and 007h		;ab98	e6 07 	. . 
	push hl			;ab9a	e5 	. 
	ld hl,TABLE1		;ab9b	21 e1 22 	! . " 
	ld e,a			;ab9e	5f 	_ 
	ld d,000h		;ab9f	16 00 	. . 
	add hl,de			;aba1	19 	. 
	ld a,(hl)			;aba2	7e 	~ 
	ld (0604ch),a		;aba3	32 4c 60 	2 L ` 
	ld b,a			;aba6	47 	G 
	ld a,028h		;aba7	3e 28 	> ( 
	sub b			;aba9	90 	. 
	ld (0604dh),a		;abaa	32 4d 60 	2 M ` 
	ld hl,TABLE2		;abad	21 0f ac 	! . . 
	add hl,de			;abb0	19 	. 
	ld a,(hl)			;abb1	7e 	~ 
	ld (06052h),a		;abb2	32 52 60 	2 R ` 
	pop hl			;abb5	e1 	. 
	ld de,0001eh		;abb6	11 1e 00 	. . . 
	add hl,de			;abb9	19 	. 
	ld (06046h),hl		;abba	22 46 60 	" F ` 
	ld a,000h		;abbd	3e 00 	> . 
	ld (06044h),a		;abbf	32 44 60 	2 D ` 
	ld (06045h),a		;abc2	32 45 60 	2 E ` 
	ld a,001h		;abc5	3e 01 	> . 
	ld (06043h),a		;abc7	32 43 60 	2 C ` 
sub_abcah:
	ld hl,(06046h)		;abca	2a 46 60 	* F ` 
	ld a,(06048h)		;abcd	3a 48 60 	: H ` 
	call SETMEMMAP		;abd0	cd 1a 0f 	. . . 
	ld a,(0604eh)		;abd3	3a 4e 60 	: N ` 
	ld (hl),a			;abd6	77 	w 
	inc hl			;abd7	23 	# 
	ld a,(0604ch)		;abd8	3a 4c 60 	: L ` 
	ld d,a			;abdb	57 	W 
	ld a,(0604dh)		;abdc	3a 4d 60 	: M ` 
	ld e,a			;abdf	5f 	_ 
	ld a,(06045h)		;abe0	3a 45 60 	: E ` 
	inc a			;abe3	3c 	< 
	cp d			;abe4	ba 	. 
	jr c,labf3h		;abe5	38 0c 	8 . 
	ld d,000h		;abe7	16 00 	. . 
	add hl,de			;abe9	19 	. 
	ld a,(06044h)		;abea	3a 44 60 	: D ` 
	inc a			;abed	3c 	< 
	ld (06044h),a		;abee	32 44 60 	2 D ` 
	ld a,000h		;abf1	3e 00 	> . 
labf3h:
	ld (06045h),a		;abf3	32 45 60 	2 E ` 
	ld (06046h),hl		;abf6	22 46 60 	" F ` 
	ret			;abf9	c9 	. 
sub_abfah:
	ld a,(06049h)		;abfa	3a 49 60 	: I ` 
	inc a			;abfd	3c 	< 
	ld b,a			;abfe	47 	G 
	ld de,00003h		;abff	11 03 00 	. . . 
	ld hl,06037h		;ac02	21 37 60 	! 7 ` 
lac05h:
	add hl,de			;ac05	19 	. 
	djnz lac05h		;ac06	10 fd 	. . 
	ld a,(hl)			;ac08	7e 	~ 
	inc hl			;ac09	23 	# 
	ld e,(hl)			;ac0a	5e 	^ 
	inc hl			;ac0b	23 	# 
	ld d,(hl)			;ac0c	56 	V 
	ex de,hl			;ac0d	eb 	. 
	ret			;ac0e	c9 	. 

TABLE2:
	db 0x03, 0x04, 0x06, 0x07, 0x09, 0x09, 0x09, 0x09

FUN_93:
	ld bc,000c8h		;ac17	01 c8 00 	. . . 
	ld de,v53c2		;ac1a	11 c2 53 	. . S 
	ld hl,054eeh		;ac1d	21 ee 54 	! . T 
	ldir		;ac20	ed b0 	. . 
	call sub_2a82h		;ac22	cd 82 2a 	. . * 
	ld a,(05cbah)		;ac25	3a ba 5c 	: . \ 
	cp 005h		;ac28	fe 05 	. . 
	jr nz,lac34h		;ac2a	20 08 	  . 
	ld a,058h		;ac2c	3e 58 	> X 
	ld hl,0		;ac2e	21 00 00 	! . . 
	call sub_88dch		;ac31	cd dc 88 	. . . 
lac34h:
	M_OUT_MSG 0xd77a, 0x55 ; 0F "EXTERNAL DATA SELECT  " CRLF CRLF "1 AP" CRLF "2 UPI" CRLF "3 REUTERS" CRLF "4 NOAA" CRLF "5 STOCKS" CRLF "6 BROADCAST" CRLF "7 DOW JONES"
	M_GOTO_YX 1,22
	ld h,7
	call INPUT_NUM		;ac41	cd 48 3d 	. H = 
	push hl			;ac44	e5 	. 
	push de			;ac45	d5 	. 
	push af			;ac46	f5 	. 
	ld a,l			;ac47	7d 	} 
	ld d,007h		;ac48	16 07 	. . 
	cp d			;ac4a	ba 	. 
	jr c,lac4eh		;ac4b	38 01 	8 . 
	ld a,d			;ac4d	7a 	z 
lac4eh:
	ld de,lac5dh		;ac4e	11 5d ac 	. ] . 
	ld l,a			;ac51	6f 	o 
	ld h,000h		;ac52	26 00 	& . 
	add hl,hl			;ac54	29 	) 
	add hl,de			;ac55	19 	. 
	ld a,(hl)			;ac56	7e 	~ 
	inc hl			;ac57	23 	# 
	ld h,(hl)			;ac58	66 	f 
	ld l,a			;ac59	6f 	o 
	pop af			;ac5a	f1 	. 
	pop de			;ac5b	d1 	. 
	jp (hl)			;ac5c	e9 	. 
lac5dh:
	ld l,l			;ac5d	6d 	m 
	xor h			;ac5e	ac 	. 
	sbc a,a			;ac5f	9f 	. 
	xor h			;ac60	ac 	. 
	rst 10h			;ac61	d7 	. 
	xor h			;ac62	ac 	. 
	rrca			;ac63	0f 	. 
	xor l			;ac64	ad 	. 
	ld d,0adh		;ac65	16 ad 	. . 
	ld d,c			;ac67	51 	Q 
	xor l			;ac68	ad 	. 
	ld a,l			;ac69	7d 	} 
	xor l			;ac6a	ad 	. 
	xor l			;ac6b	ad 	. 
	xor l			;ac6c	ad 	. 
	pop hl			;ac6d	e1 	. 
	call sub_2a82h		;ac6e	cd 82 2a 	. . * 
	ld a,(CFG12)		;ac71	3a 14 00 	: . . 
	cp 0ffh		;ac74	fe ff 	. . 
	jp nz,laed0h		;ac76	c2 d0 ae 	. . . 
	M_OUT_MSG 0xd7cf, 0x03 ; 0F "AP"
	M_OUT_MSG 0xd7de, 0x47 ; " NEWS SPLITS" CRLF "PAGE BLOCK START PAGE STOP PAGE" CRLF "    1" 08 0B "2" 08 0B "3" 08 0B "4" 08 0B "5" 08 0B "6" 08 0B "7" 08 0B "8"
	M_OUT_MSG 0xd825, 0x6b ; CRLF CRLF "NEWS CATEGORY   BLOCK" CRLF "GENERAL NEWS" CRLF "REGIONAL NEWS" CRLF "FINANCIAL" CRLF "STOCKS" CRLF "SPORTS" CRLF "SPORTS SCORES" CRLF "BULLETINS" CRLF "FEATURES"
	M_OUT_UP 6
	M_RIGHT 15
	ld c,008h		;ac93	0e 08 	. . 
	ld iy,v53c2		;ac95	fd 21 c2 53 	. ! . S 
	call sub_ae18h		;ac99	cd 18 ae 	. . . 
	jp ladb1h		;ac9c	c3 b1 ad 	. . . 
	pop hl			;ac9f	e1 	. 
	call sub_2a82h		;aca0	cd 82 2a 	. . * 
	ld a,(CFG9)		;aca3	3a 15 00 	: . . 
	cp 0ffh		;aca6	fe ff 	. . 
	jp nz,laed0h		;aca8	c2 d0 ae 	. . . 
	M_OUT_MSG 0xd7d2, 0x04 ; 0F "UPI"
	M_OUT_MSG 0xd7de, 0x44 ; " NEWS SPLITS" CRLF "PAGE BLOCK START PAGE STOP PAGE" CRLF "    1" 08 0B "2" 08 0B "3" 08 0B "4" 08 0B "5" 08 0B "6" 08 0B "7"
	M_OUT_MSG 0xd825, 0x4b ; CRLF CRLF "NEWS CATEGORY   BLOCK" CRLF "GENERAL NEWS" CRLF "REGIONAL NEWS" CRLF "FINANCIAL" CRLF "STOCKS" CRLF "SPORTS" CRLF 
	M_OUT_MSG 0xd87e, 0x12 ; "BULLETINS" CRLF "FEATURES"
	M_OUT_UP 5
	M_RIGHT 15
	ld c,007h		;accb	0e 07 	. . 
	ld iy,053eah		;accd	fd 21 ea 53 	. ! . S 
	call sub_ae18h		;acd1	cd 18 ae 	. . . 
	jp ladb1h		;acd4	c3 b1 ad 	. . . 
	pop hl			;acd7	e1 	. 
	call sub_2a82h		;acd8	cd 82 2a 	. . * 
	ld a,(CFG9)		;acdb	3a 15 00 	: . . 
	cp 0aah		;acde	fe aa 	. . 
	jp nz,laed0h		;ace0	c2 d0 ae 	. . . 
	M_OUT_MSG 0xd7d6, 0x3d ; 0F "REUTERS NEWS SPLITS" CRLF "PAGE BLOCK START PAGE STOP PAGE" CRLF "    1" 08 0B "2"
	M_OUT_MSG 0xd825, 0x24 ; CRLF CRLF "NEWS CATEGORY   BLOCK" CRLF "GENERAL NEWS"
	M_OUT_MSG 0xd857, 0x0a ; CRLF "FINANCIAL"
	M_OUT_CH '/' 
	M_OUT_MSG 0xd869, 0x06 ; "SPORTS"
	M_RIGHT 7
	ld c,002h		;ad03	0e 02 	. . 
	ld iy,0540dh		;ad05	fd 21 0d 54 	. ! . T 
	call sub_ae18h		;ad09	cd 18 ae 	. . . 
	jp ladb1h		;ad0c	c3 b1 ad 	. . . 
	pop hl			;ad0f	e1 	. 
	call sub_aed9h		;ad10	cd d9 ae 	. . . 
	jp ladb1h		;ad13	c3 b1 ad 	. . . 
	pop hl			;ad16	e1 	. 
	call sub_2a82h		;ad17	cd 82 2a 	. . * 
	ld a,(00017h)		;ad1a	3a 17 00 	: . . 
	cp 0aah		;ad1d	fe aa 	. . 
	jr z,lad29h		;ad1f	28 08 	( . 
	ld a,(CFG9)		;ad21	3a 15 00 	: . . 
	cp 055h		;ad24	fe 55 	. U 
	jp nz,laed0h		;ad26	c2 d0 ae 	. . . 
lad29h:
	ld iy,05461h		;ad29	fd 21 61 54 	. ! a T 
	M_OUT_MSG 0xd862, 0x06 ; "STOCKS"
	call sub_adf5h
	; Adrs is IY
	M_SOMETHING1 0x0000, 0x03
	M_RIGHT 8
	inc hl			;ad40	23 	# 
	inc hl			;ad41	23 	# 
	ld (iy+002h),l		;ad42	fd 75 02 	. u . 
	ld (iy+003h),h		;ad45	fd 74 03 	. t . 
	M_OUT_VAR 0x0002, 0x03
	jp ladb1h		;ad4e	c3 b1 ad 	. . . 
	pop hl			;ad51	e1 	. 
	call sub_2a82h		;ad52	cd 82 2a 	. . * 
	ld a,(CFG12)		;ad55	3a 14 00 	: . . 
	cp 0aah		;ad58	fe aa 	. . 
	jp nz,laed0h		;ad5a	c2 d0 ae 	. . . 
	ld iy,v53c2		;ad5d	fd 21 c2 53 	. ! . S 
	M_OUT_MSG 0xd8fd, 0x0e ; "BROADCAST NEWS"
	call sub_adf5h		;ad67	cd f5 ad 	. . . 
	; Adrs is IY
	M_SOMETHING1 0x0000, 0x03
	M_RIGHT 10
	; Adrs is IY+2
	M_SOMETHING1 0x0002, 0x03
	jp ladb1h		;ad7a	c3 b1 ad 	. . . 
	pop hl			;ad7d	e1 	. 
	call sub_2a82h		;ad7e	cd 82 2a 	. . * 
	ld a,(CFG9)		;ad81	3a 15 00 	: . . 
	cp 0aah		;ad84	fe aa 	. . 
	jp nz,laed0h		;ad86	c2 d0 ae 	. . . 
	ld iy,0540dh		;ad89	fd 21 0d 54 	. ! . T 
	M_OUT_MSG 0xd7c6, 0x09 ; "DOW JONES"
	call sub_adf5h		;ad93	cd f5 ad 	. . . 
	; Adrs is IY
	M_SOMETHING1 0x0000, 0x03
	M_RIGHT 10
	; Adrs is IY+2
	M_SOMETHING1 0x0002, 0x03
	ld (iy+008h),044h		;ada6	fd 36 08 44 	. 6 . D 
	jp ladb1h		;adaa	c3 b1 ad 	. . . 
	pop hl			;adad	e1 	. 
	jp l1925h		;adae	c3 25 19 	. % . 
ladb1h:
	ld bc,000c8h		;adb1	01 c8 00 	. . . 
	ld de,054eeh		;adb4	11 ee 54 	. . T 
	ld hl,v53c2		;adb7	21 c2 53 	! . S 
	ld a,(05cbah)		;adba	3a ba 5c 	: . \ 
	cp 005h		;adbd	fe 05 	. . 
	jr nz,ladcch		;adbf	20 0b 	  . 
	ld de,05cc6h		;adc1	11 c6 5c 	. . \ 
	ldir		;adc4	ed b0 	. . 
	call l893fh		;adc6	cd 3f 89 	. ? . 
	jp l1925h		;adc9	c3 25 19 	. % . 
ladcch:
	ldir		;adcc	ed b0 	. . 
	M_CALL_WITH_MMAP0 INIT
	jp l1925h		;add3	c3 25 19 	. % . 
	; Adrs is IY
	M_SOMETHING1 0x0000, 0x03
	M_RIGHT 5

sub_ade0h:
	ex de,hl			;ade0	eb 	. 
	inc iy		;ade1	fd 23 	. # 
	inc iy		;ade3	fd 23 	. # 
_again:
	M_SOMETHING1 0x0000, 0x13
	call CMP_HLDE
	ret nc
	M_SOMETHING2 0x03
	jr _again

sub_adf5h:
	push iy		;adf5	fd e5 	. . 
	M_GOTO_YX 3,1
	M_OUT_MSG 0xd7f6, 0x14 ; "START PAGE STOP PAGE"
	M_GOTO_YX 4,5
	call OUT_VAR3_INC		;ae07	cd c5 ae 	. . . 
	M_RIGHT 7
	call OUT_VAR3_INC		;ae0e	cd c5 ae 	. . . 
	pop iy		;ae11	fd e1 	. . 
	M_LEFT 11
	ret			;ae17	c9 	. 
sub_ae18h:
	M_OUT_MSG 0xd890, 0x26 ; "ENTER" 0B 08 08 08 08 08 "0=NONE" 0B 08 08 08 08 08 08 "1 TO" 0B 08 08 08 08 "     "
	M_OUT_UP 1
	ld a,c
	or 0x30
	call OUT_CH
	M_GOTO_YX 3,16
	M_OUT_CH 0x0f
	ld b,c			;ae31	41 	A 
	push iy		;ae32	fd e5 	. . 
_loop:
	call OUT_VAR3_INC		;ae34	cd c5 ae 	. . . 
	M_RIGHT 8
	call OUT_VAR3_INC		;ae3b	cd c5 ae 	. . . 
	M_LEFT 14
	M_DOWN 1
	djnz _loop
	M_RIGHT 3
	M_DOWN 2
	ld b,c
_loop2:
	ld a,(iy+000h) 
	inc iy 
	cp 'A' 			; Weird, look like it is either 'A' or a number between 0 and 9 (not ascii)
	jr z,_skip	 
	or 030h 		; Make it a number ?
_skip:
	call OUT_CH
	M_LEFT 1
	M_DOWN 1
	djnz _loop2
	M_GOTO_YX 3,18
	ld b,c
	pop iy
lae71h:
	; Adrs is IY
	M_SOMETHING1 0x0000, 0x03
	M_RIGHT 11
	call sub_ade0h		;ae7b	cd e0 ad 	. . . 
	call LEFT_INLINE		;ae7e	cd 6c 15 	. l . 
	dec bc			;ae81	0b 	. 
	call DOWN_INLINE		;ae82	cd 68 15 	. h . 
	ld bc,023fdh		;ae85	01 fd 23 	. . # 
	inc iy		;ae88	fd 23 	. # 
	djnz lae71h		;ae8a	10 e5 	. . 
	call RIGHT_INLINE		;ae8c	cd 70 15 	. p . 
	ld bc,068cdh		;ae8f	01 cd 68 	. . h 
	dec d			;ae92	15 	. 
	ld (bc),a			;ae93	02 	. 
	ld b,c			;ae94	41 	A 
	inc c			;ae95	0c 	. 
	ld a,030h		;ae96	3e 30 	> 0 
	add a,c			;ae98	81 	. 
	ld e,a			;ae99	5f 	_ 
lae9ah:
	call NEXT_MACRO_OR_KEY		;ae9a	cd a7 17 	. . . 
	cp 00ah		;ae9d	fe 0a 	. . 
	jr z,laebch		;ae9f	28 1b 	( . 
	cp 030h		;aea1	fe 30 	. 0 
	jr c,lae9ah		;aea3	38 f5 	8 . 
	cp e			;aea5	bb 	. 
	jr c,laeaeh		;aea6	38 06 	8 . 
	and 0dfh		;aea8	e6 df 	. . 
	cp 041h		;aeaa	fe 41 	. A 
	jr nz,lae9ah		;aeac	20 ec 	  . 
laeaeh:
	call OUT_CH		;aeae	cd 84 10 	. . . 
	and 04fh		;aeb1	e6 4f 	. O 
	ld (iy+000h),a		;aeb3	fd 77 00 	. w . 
	call LEFT_INLINE		;aeb6	cd 6c 15 	. l . 
	ld bc,0de18h		;aeb9	01 18 de 	. . . 
laebch:
	call DOWN_INLINE		;aebc	cd 68 15 	. h . 
	ld bc,023fdh		;aebf	01 fd 23 	. . # 
	djnz lae9ah		;aec2	10 d6 	. . 
	ret			;aec4	c9 	. 

; Prints the 2 bytes variable at IY with 3 digits, and increment to the next variable
OUT_VAR3_INC:
	M_OUT_VAR 0x0000, 0x03
	inc iy
	inc iy
	ret

; FReD : lookat this, sounds really promising
laed0h:
	M_OUT_MSG 0xd8eb, 0x12 ; "OPTION NOT ENABLED"
	jp l1934h		;aed6	c3 34 19 	. 4 . 
sub_aed9h:
	ld iy,05417h		;aed9	fd 21 17 54 	. ! . T 
	call sub_2a82h		;aedd	cd 82 2a 	. . * 
	ld a,(00017h)		;aee0	3a 17 00 	: . . 
	cp 0ffh		;aee3	fe ff 	. . 
	jr nz,laed0h		;aee5	20 e9 	  . 
	M_OUT_MSG 0xd90b, 0x50 ; 0F "      NOAA WEATHER SERVICE" CRLF CRLF " START  STOP  WORD  OPEN" CRLF " PAGE   PAGE  WRAP  CODE" CRLF CRLF 
	ld b,008h		;aeed	06 08 	. . 
laeefh:
	call sub_af44h		;aeef	cd 44 af 	. D . 
	djnz laeefh		;aef2	10 fb 	. . 
	M_GOTO_YX 15,2
	M_OUT_CH 0x0f 
	M_OUT_MSG 0xd95b, 0x07 ; "INPUT  "
	ld a,(iy+000h)		;af03	fd 7e 00 	. ~ . 
	cp 041h		;af06	fe 41 	. A 
	jr z,laf0eh		;af08	28 04 	( . 
	ld (iy+000h),042h		;af0a	fd 36 00 42 	. 6 . B 
laf0eh:
	M_OUT_MSG 0x0000, 0x01 ; F3 
	M_OUT_MSG 0xd962, 0x12 ; "  A=ASCII,B=BAUDOT"
	M_GOTO_YX 6,5
	M_OUT_CH 0x0e
	ld iy,05417h		;af22	fd 21 17 54 	. ! . T
	ld b,008h		;af27	06 08 	. . 
laf29h:
	call sub_af7fh		;af29	cd 7f af 	.  . 
	djnz laf29h		;af2c	10 fb 	. . 
	M_GOTO_YX 15,9
_again:
	M_INPUT v545f, 0x01
	ld a,(v545f)
	cp 'A'				;	(A)SCII
	ret z 
	cp 'B'				;	(B)audot 
	jr nz,_again 
	ret 
sub_af44h:
	call RIGHT_INLINE		;af44	cd 70 15 	. p . 
	ld (bc),a			;af47	02 	. 
	M_OUT_VAR 0x0000, 0x03
	call RIGHT_INLINE		;af4e	cd 70 15 	. p . 
	inc b			;af51	04 	. 
	M_OUT_VAR 0x0002, 0x03
	call RIGHT_INLINE		;af58	cd 70 15 	. p . 
	inc b			;af5b	04 	. 
	ld a,(iy+004h)		;af5c	fd 7e 04 	. ~ . 
	cp 059h		;af5f	fe 59 	. Y 
	jr z,laf68h		;af61	28 05 	( . 
	ld a,04eh		;af63	3e 4e 	> N 
	ld (iy+004h),a		;af65	fd 77 04 	. w . 
laf68h:
	call OUT_CH		;af68	cd 84 10 	. . . 
	call RIGHT_INLINE		;af6b	cd 70 15 	. p . 
	inc bc			;af6e	03 	. 
	; FReD : weird
	M_OUT_MSG 0x0005, 0x04 ; FF FF FF FF 
	M_OUT_CH CRLF
	ld de,00009h		;af79	11 09 00 	. . . 
	add iy,de		;af7c	fd 19 	. . 
	ret			;af7e	c9 	. 
sub_af7fh:
	push iy		;af7f	fd e5 	. . 
	; Adrs is IY
	M_SOMETHING1 0x0000, 0x03
	call RIGHT_INLINE		;af87	cd 70 15 	. p . 
	rlca			;af8a	07 	. 
	ex de,hl			;af8b	eb 	. 
laf8ch:
	; IY is IY+2
	M_SOMETHING1 0x0002, 0x13
	call CMP_HLDE		;af92	cd 20 0f 	.   . 
	jr nc,laf9dh		;af95	30 06 	0 . 
	M_SOMETHING2 0x03
	jr laf8ch		;af9b	18 ef 	. . 
laf9dh:
	call RIGHT_INLINE		;af9d	cd 70 15 	. p . 
	dec b			;afa0	05 	. 
lafa1h:
	ld a,(iy+004h)		;afa1	fd 7e 04 	. ~ . 
	ld (0548ah),a		;afa4	32 8a 54 	2 . T 
	M_INPUT v548a, 0x01
	ld a,(v548a)
	cp 'Y'
	jr z,lafb8h		;afb2	28 04 	( . 
	cp 'N'
	jr nz,lafa1h		;afb6	20 e9 	  . 
lafb8h:
	ld (iy+004h),a		;afb8	fd 77 04 	. w . 
	call RIGHT_INLINE		;afbb	cd 70 15 	. p . 
	rlca			;afbe	07 	. 
	; Stores in IY+5
	M_INPUT 0x0005, 0x44
	M_OUT_CH CRLF
	call RIGHT_INLINE		;afc9	cd 70 15 	. p . 
	inc b			;afcc	04 	. 
	pop iy		;afcd	fd e1 	. . 
	ld de,00009h		;afcf	11 09 00 	. . . 
	add iy,de		;afd2	fd 19 	. . 
	ret			;afd4	c9 	. 

FUN_96:
	ld hl,0		;afd5	21 00 00 	! . . 
	ld (v53c2),hl		;afd8	22 c2 53 	" . S 
	ld (053c4h),hl		;afdb	22 c4 53 	" . S 
	call sub_2a82h		;afde	cd 82 2a 	. . * 
	M_OUT_MSG 0xd974, 0x16 ; "SET PAGES 0000 TO 0000"
	call LEFT_INLINE
	add hl,bc			;afea	09 	. 
	M_SOMETHING1 v53c2, 0x04
	call RIGHT_INLINE		;aff1	cd 70 15 	. p . 
	ex af,af'			;aff4	08 	. 
laff5h:
	M_SOMETHING1 v53c4, 0x14
	ld de,(v53c2)		;affb	ed 5b c2 53 	. [ . S 
	call CMP_HLDE		;afff	cd 20 0f 	.   . 
	jr c,lb040h		;b002	38 3c 	8 < 
	ex de,hl			;b004	eb 	. 
	ld a,(05cbah)		;b005	3a ba 5c 	: . \ 
	cp 005h		;b008	fe 05 	. . 
	jr nz,lb02dh		;b00a	20 21 	  ! 
	ld (05e8eh),hl		;b00c	22 8e 5e 	" . ^ 
	ld (05e90h),de		;b00f	ed 53 90 5e 	. S . ^ 
	ld de,05cc6h		;b013	11 c6 5c 	. . \ 
	ld hl,04a3eh		;b016	21 3e 4a 	! > J 
	ld bc,001c8h		;b019	01 c8 01 	. . . 
	ldir		;b01c	ed b0 	. . 
	ld a,000h		;b01e	3e 00 	> . 
	ld (05cc3h),a		;b020	32 c3 5c 	2 . \ 
	ld a,04dh		;b023	3e 4d 	> M 
	ld (05cc2h),a		;b025	32 c2 5c 	2 . \ 
	call l893fh		;b028	cd 3f 89 	. ? . 
	jr lb030h		;b02b	18 03 	. . 
lb02dh:
	call sub_b05ch		;b02d	cd 5c b0 	. \ . 
lb030h:
	xor a			;b030	af 	. 
	call SETMEMMAP		;b031	cd 1a 0f 	. . . 
	call 0b0a5h		;b034	cd a5 b0 	. . . 
	M_OUT_MSG 0xd98a, 0x0a ; "MEMORY SET"
	jp l1934h		;b03d	c3 34 19 	. 4 . 
lb040h:
	M_SOMETHING2 0x04
	jr laff5h		;b044	18 af 	. . 
	push hl			;b046	e5 	. 
	xor a			;b047	af 	. 
	call SETMEMMAP		;b048	cd 1a 0f 	. . . 
	call sub_22f0h		;b04b	cd f0 22 	. . " 
	call sub_2318h		;b04e	cd 18 23 	. . # 
	pop hl			;b051	e1 	. 
	ld de,007cfh		;b052	11 cf 07 	. . . 
	call sub_b05ch		;b055	cd 5c b0 	. \ . 
	xor a			;b058	af 	. 
	jp SETMEMMAP		;b059	c3 1a 0f 	. . . 
sub_b05ch:
	ex de,hl			;b05c	eb 	. 
	call CMP_HLDE		;b05d	cd 20 0f 	.   . 
	ex de,hl			;b060	eb 	. 
	ret c			;b061	d8 	. 
	ld a,(040fch)		;b062	3a fc 40 	: . @ 
	cp 0aah		;b065	fe aa 	. . 
	call nz,sub_0334h		;b067	c4 34 03 	. 4 . 
	push hl			;b06a	e5 	. 
	push de			;b06b	d5 	. 
	call sub_07f9h		;b06c	cd f9 07 	. . . 
	cp 0ffh		;b06f	fe ff 	. . 
	jr z,lb080h		;b071	28 0d 	( . 
	call SETMEMMAP		;b073	cd 1a 0f 	. . . 
	call sub_b0b4h		;b076	cd b4 b0 	. . . 
	pop de			;b079	d1 	. 
	pop hl			;b07a	e1 	. 
	inc hl			;b07b	23 	# 
	in a,(PORT_FF)
	jr sub_b05ch		;b07e	18 dc 	. . 
lb080h:
	pop hl			;b080	e1 	. 
	pop hl			;b081	e1 	. 
	ret			;b082	c9 	. 
sub_b083h:
	push bc			;b083	c5 	. 
	ld b,004h		;b084	06 04 	. . 
lb086h:
	call sub_0334h		;b086	cd 34 03 	. 4 . 
	djnz lb086h		;b089	10 fb 	. . 
	pop bc			;b08b	c1 	. 
	ret			;b08c	c9 	. 
	call 0b0a5h		;b08d	cd a5 b0 	. . . 
	M_OUT_MSG 0xd994, 0x04 ; "PAGE"
	call RIGHT_INLINE		;b096	cd 70 15 	. p . 
	ld (bc),a			;b099	02 	. 
	M_OUT_VAR 0x4f89, 0x04
	call LEFT_INLINE		;b0a0	cd 6c 15 	. l . 
	ld bc,0cdc9h		;b0a3	01 c9 cd 	. . . 
	jr lb0bbh		;b0a6	18 13 	. . 
	inc b			;b0a8	04 	. 
	M_OUT_CH 0x03
	ret			;b0ad	c9 	. 
	call sub_07f9h		;b0ae	cd f9 07 	. . . 
	cp 0ffh		;b0b1	fe ff 	. . 
	ret z			;b0b3	c8 	. 
sub_b0b4h:
	ex de,hl			;b0b4	eb 	. 
	ld hl,04a3eh		;b0b5	21 3e 4a 	! > J 
	ld bc,00030h		;b0b8	01 30 00 	. 0 . 
lb0bbh:
	ldir		;b0bb	ed b0 	. . 
	ld bc,l0140h		;b0bd	01 40 01 	. @ . 
	ld hl,04ac6h		;b0c0	21 c6 4a 	! . J 
lb0c3h:
	ldir		;b0c3	ed b0 	. . 
	xor a			;b0c5	af 	. 
	ret			;b0c6	c9 	. 

FUN_95:
	ld hl,0		;b0c7	21 00 00 	! . . 
	ld (v53c2),hl		;b0ca	22 c2 53 	" . S 
	ld (053c4h),hl		;b0cd	22 c4 53 	" . S 
	ld (053c6h),hl		;b0d0	22 c6 53 	" . S 
	call sub_2a82h		;b0d3	cd 82 2a 	. . * 
	M_OUT_MSG 0xd998, 0x20 ; "COPY 000 PAGES FROM 0000 TO 0000"
	call LEFT_INLINE
	add hl,de			;b0df	19 	. 
	M_SOMETHING1 v53c6, 0x03
	push hl			;b0e6	e5 	. 
	call RIGHT_INLINE		;b0e7	cd 70 15 	. p . 
	djnz $-49		;b0ea	10 cd 	. . 
	call po,0c213h		;b0ec	e4 13 c2 	. . . 
	ld d,e			;b0ef	53 	S 
	inc b			;b0f0	04 	. 
	push hl			;b0f1	e5 	. 
	call RIGHT_INLINE		;b0f2	cd 70 15 	. p . 
	ex af,af'			;b0f5	08 	. 
	M_SOMETHING1 v53c4, 0x04
	pop de			;b0fc	d1 	. 
	ex de,hl			;b0fd	eb 	. 
	pop bc			;b0fe	c1 	. 
	ld a,(05cbah)		;b0ff	3a ba 5c 	: . \ 
	cp 005h		;b102	fe 05 	. . 
	jr nz,lb120h		;b104	20 1a 	  . 
	ld (05cc6h),hl		;b106	22 c6 5c 	" . \ 
	ld (05cc8h),de		;b109	ed 53 c8 5c 	. S . \ 
	ld (05ccah),bc		;b10d	ed 43 ca 5c 	. C . \ 
	ld a,000h		;b111	3e 00 	> . 
	ld (05cc3h),a		;b113	32 c3 5c 	2 . \ 
	ld a,043h		;b116	3e 43 	> C 
	ld (05cc2h),a		;b118	32 c2 5c 	2 . \ 
	call l893fh		;b11b	cd 3f 89 	. ? . 
	jr lb123h		;b11e	18 03 	. . 
lb120h:
	call sub_b139h		;b120	cd 39 b1 	. 9 . 
lb123h:
	xor a			;b123	af 	. 
	call SETMEMMAP		;b124	cd 1a 0f 	. . . 
	call sub_22f0h		;b127	cd f0 22 	. . " 
	call sub_2318h		;b12a	cd 18 23 	. . # 
	call 0b0a5h		;b12d	cd a5 b0 	. . . 
	M_OUT_MSG 0xd9b8, 0x12 ; "PAGE COPY COMPLETE"
	jp l1934h		;b136	c3 34 19 	. 4 . 
sub_b139h:
	ld a,b			;b139	78 	x 
	or c			;b13a	b1 	. 
	ret z			;b13b	c8 	. 
	call CMP_HLDE		;b13c	cd 20 0f 	.   . 
	ret z			;b13f	c8 	. 
	ld a,000h		;b140	3e 00 	> . 
	jr nc,lb14ch		;b142	30 08 	0 . 
	add hl,bc			;b144	09 	. 
	dec hl			;b145	2b 	+ 
	ex de,hl			;b146	eb 	. 
	add hl,bc			;b147	09 	. 
	dec hl			;b148	2b 	+ 
	ex de,hl			;b149	eb 	. 
	ld a,0ffh		;b14a	3e ff 	> . 
lb14ch:
	ld (053c8h),a		;b14c	32 c8 53 	2 . S 
	ld ix,0fffdh		;b14f	dd 21 fd ff 	. ! . . 
	add ix,sp		;b153	dd 39 	. 9 
	ld sp,ix		;b155	dd f9 	. . 
lb157h:
	call sub_b083h		;b157	cd 83 b0 	. . . 
	push bc			;b15a	c5 	. 
	push hl			;b15b	e5 	. 
	push de			;b15c	d5 	. 
	call sub_07f9h		;b15d	cd f9 07 	. . . 
	cp 0ffh		;b160	fe ff 	. . 
	jr z,lb1a0h		;b162	28 3c 	( < 
	ld (ix+000h),a		;b164	dd 77 00 	. w . 
	ex de,hl			;b167	eb 	. 
	pop hl			;b168	e1 	. 
	push hl			;b169	e5 	. 
	call sub_07f9h		;b16a	cd f9 07 	. . . 
	cp 0ffh		;b16d	fe ff 	. . 
	jr z,lb1a0h		;b16f	28 2f 	( / 
	ld (ix+001h),a		;b171	dd 77 01 	. w . 
	push hl			;b174	e5 	. 
	ex de,hl			;b175	eb 	. 
	ld (ix+002h),002h		;b176	dd 36 02 02 	. 6 . . 
lb17ah:
	ld a,(ix+000h)		;b17a	dd 7e 00 	. ~ . 
	call SETMEMMAP		;b17d	cd 1a 0f 	. . . 
	ld de,053cch		;b180	11 cc 53 	. . S 
	ld bc,000b8h		;b183	01 b8 00 	. . . 
	ldir		;b186	ed b0 	. . 
	ld a,(ix+001h)		;b188	dd 7e 01 	. ~ . 
	call SETMEMMAP		;b18b	cd 1a 0f 	. . . 
	ex (sp),hl			;b18e	e3 	. 
	ex de,hl			;b18f	eb 	. 
	ld hl,053cch		;b190	21 cc 53 	! . S 
	ld bc,000b8h		;b193	01 b8 00 	. . . 
	ldir		;b196	ed b0 	. . 
	ex de,hl			;b198	eb 	. 
	ex (sp),hl			;b199	e3 	. 
	dec (ix+002h)		;b19a	dd 35 02 	. 5 . 
	jr nz,lb17ah		;b19d	20 db 	  . 
	pop hl			;b19f	e1 	. 
lb1a0h:
	pop de			;b1a0	d1 	. 
	pop hl			;b1a1	e1 	. 
	pop bc			;b1a2	c1 	. 
	ld a,(053c8h)		;b1a3	3a c8 53 	: . S 
	or a			;b1a6	b7 	. 
	jr z,lb1adh		;b1a7	28 04 	( . 
	dec hl			;b1a9	2b 	+ 
	dec de			;b1aa	1b 	. 
	jr lb1afh		;b1ab	18 02 	. . 
lb1adh:
	inc hl			;b1ad	23 	# 
	inc de			;b1ae	13 	. 
lb1afh:
	dec bc			;b1af	0b 	. 
	ld a,b			;b1b0	78 	x 
	or c			;b1b1	b1 	. 
	jr nz,lb157h		;b1b2	20 a3 	  . 
	ld ix,00003h		;b1b4	dd 21 03 00 	. ! . . 
	add ix,sp		;b1b8	dd 39 	. 9 
	ld sp,ix		;b1ba	dd f9 	. . 
	ret			;b1bc	c9 	. 
	ld de,(05b77h)		;b1bd	ed 5b 77 5b 	. [ w [ 
	call CMP_HLDE		;b1c1	cd 20 0f 	.   . 
	ret			;b1c4	c9 	. 

FUN_9A:
	ld bc,12		;b1c5	01 0c 00 	. . . 
	ld de,v53c2		;b1c8	11 c2 53 	. . S 
	ld hl,05b93h		;b1cb	21 93 5b 	! . [ 
	ldir		;b1ce	ed b0 	. . 
	ld a,(05cbah)		;b1d0	3a ba 5c 	: . \ 
	cp 005h		;b1d3	fe 05 	. . 
	jr nz,lb1dfh		;b1d5	20 08 	  . 
	ld a,054h		;b1d7	3e 54 	> T 
	ld hl,0		;b1d9	21 00 00 	! . . 
	call sub_88dch		;b1dc	cd dc 88 	. . . 
lb1dfh:
	ld a,(053c5h)		;b1df	3a c5 53 	: . S 
	or a			;b1e2	b7 	. 
	jr nz,lb1eah		;b1e3	20 05 	  . 
	ld a,055h		;b1e5	3e 55 	> U 
	ld (053c5h),a		;b1e7	32 c5 53 	2 . S 
lb1eah:
	call sub_2a82h		;b1ea	cd 82 2a 	. . * 
	M_OUT_CH 0x0f
	M_GOTO_YX 3,1
	ld iy, 053cah
	call sub_b5e7h
lb1fdh:
	ld a,(05b9fh)		;b1fd	3a 9f 5b 	: . [ 
	cp 0 
	jr z,_skip 
	M_GOTO_YX 5,1
	M_OUT_MSG 0xd9e1, 0x11 ; "CLOCK CHIP ACTIVE"
_skip:
	ld b,0
	call sub_3866h		;b211	cd 66 38 	. f 8 
	xor a			;b214	af 	. 
lb215h:
	ld (05686h),a		;b215	32 86 56 	2 . V 
lb218h:
	ld bc,v53c2		;b218	01 c2 53 	. . S 
	ld de,053ceh		;b21b	11 ce 53 	. . S 
	call sub_b3b5h		;b21e	cd b5 b3 	. . . 
	M_OUT_CH 0x0f
	M_OUT_CH 0x04
	M_OUT_MSG 0x53ce, 0x20 ; *** RAM data ***
	M_OUT_CH 0x04
	ld a,(05686h)		;b233	3a 86 56 	: . V 
	ld e,a			;b236	5f 	_ 
	ld d,000h		;b237	16 00 	. . 
	ld hl,lb2e3h		;b239	21 e3 b2 	! . . 
	add hl,de			;b23c	19 	. 
	ld b,(hl)			;b23d	46 	F 
	ld a,009h		;b23e	3e 09 	> . 
	call OUT_CH_REPEAT		;b240	cd 7c 15 	. | . 
	M_OUT_CH 0x0e
	call NEXT_MACRO_OR_KEY
	cp 020h		;b24a	fe 20 	.   
	jr nz,lb25fh		;b24c	20 11 	  . 
	ld a,(05686h)		;b24e	3a 86 56 	: . V 
	ld hl,0b2ebh		;b251	21 eb b2 	! . . 
	call 0193dh		;b254	cd 3d 19 	. = . 
	ld de,lb218h		;b257	11 18 b2 	. . . 
	push de			;b25a	d5 	. 
	ld de,v53c2		;b25b	11 c2 53 	. . S 
	jp (hl)			;b25e	e9 	. 
lb25fh:
	cp 00ah		;b25f	fe 0a 	. . 
	jr nz,$-26		;b261	20 e4 	  . 
	ld a,(05686h)		;b263	3a 86 56 	: . V 
	inc a			;b266	3c 	< 
	cp 008h		;b267	fe 08 	. . 
	jr c,lb215h		;b269	38 aa 	8 . 
	M_GOTO_YX 3,14
	call sub_b600h
	ld bc,12		;b273	01 0c 00 	. . . 
	ld de,05b93h		;b276	11 93 5b 	. . [ 
	ld hl,v53c2		;b279	21 c2 53 	! . S 
	ld a,(05cbah)		;b27c	3a ba 5c 	: . \ 
	cp 005h		;b27f	fe 05 	. . 
	jr nz,lb293h		;b281	20 10 	  . 
	ld de,05cc6h		;b283	11 c6 5c 	. . \ 
	ldir		;b286	ed b0 	. . 
	ld a,054h		;b288	3e 54 	> T 
	ld (05cc2h),a		;b28a	32 c2 5c 	2 . \ 
	call l893fh		;b28d	cd 3f 89 	. ? . 
	jp l1925h		;b290	c3 25 19 	. % . 
lb293h:
	ldir		;b293	ed b0 	. . 
	ld a,0ffh		;b295	3e ff 	> . 
	ld (055b6h),a		;b297	32 b6 55 	2 . U 
	call sub_b2a0h		;b29a	cd a0 b2 	. . . 
	jp l1925h		;b29d	c3 25 19 	. % . 
sub_b2a0h:
	call sub_b3afh		;b2a0	cd af b3 	. . . 
	ld hl,(05b9bh)		;b2a3	2a 9b 5b 	* . [ 
	ld a,l			;b2a6	7d 	} 
	or h			;b2a7	b4 	. 
	ret z			;b2a8	c8 	. 
lb2a9h:
	push hl			;b2a9	e5 	. 
	call sub_07f9h		;b2aa	cd f9 07 	. . . 
	cp 0ffh		;b2ad	fe ff 	. . 
	jp z,lb2d2h		;b2af	ca d2 b2 	. . . 
	call SETMEMMAP		;b2b2	cd 1a 0f 	. . . 
	push hl			;b2b5	e5 	. 
	pop ix		;b2b6	dd e1 	. . 
	ld (ix+000h),000h		;b2b8	dd 36 00 00 	. 6 . . 
	ld (ix+001h),001h		;b2bc	dd 36 01 01 	. 6 . . 
	ld (ix+003h),001h		;b2c0	dd 36 03 01 	. 6 . . 
	ld (ix+004h),000h		;b2c4	dd 36 04 00 	. 6 . . 
	ld a,(ix+012h)		;b2c8	dd 7e 12 	. ~ . 
	and 0f0h		;b2cb	e6 f0 	. . 
	or 009h		;b2cd	f6 09 	. . 
	ld (ix+012h),a		;b2cf	dd 77 12 	. w . 
lb2d2h:
	pop hl			;b2d2	e1 	. 
	inc hl			;b2d3	23 	# 
	push de			;b2d4	d5 	. 
	push hl			;b2d5	e5 	. 
	ex de,hl			;b2d6	eb 	. 
	ld hl,(05b9dh)		;b2d7	2a 9d 5b 	* . [ 
	or a			;b2da	b7 	. 
	sbc hl,de		;b2db	ed 52 	. R 
	pop hl			;b2dd	e1 	. 
	pop de			;b2de	d1 	. 
	jp nc,lb2a9h		;b2df	d2 a9 b2 	. . . 
	ret			;b2e2	c9 	. 
lb2e3h:
	ld (bc),a			;b2e3	02 	. 
	ld b,009h		;b2e4	06 09 	. . 
	ld c,016h		;b2e6	0e 16 	. . 
	add hl,de			;b2e8	19 	. 
	inc e			;b2e9	1c 	. 
	ld e,031h		;b2ea	1e 31 	. 1 
	or e			;b2ec	b3 	. 
	scf			;b2ed	37 	7 
	or e			;b2ee	b3 	. 
	dec a			;b2ef	3d 	= 
	or e			;b2f0	b3 	. 
	ld e,(hl)			;b2f1	5e 	^ 
	or e			;b2f2	b3 	. 
	ld h,h			;b2f3	64 	d 
	or e			;b2f4	b3 	. 
	ld l,a			;b2f5	6f 	o 
	or e			;b2f6	b3 	. 
	add a,d			;b2f7	82 	. 
	or e			;b2f8	b3 	. 
	adc a,b			;b2f9	88 	. 
	or e			;b2fa	b3 	. 
	ld de,05b93h		;b2fb	11 93 5b 	. . [ 
	call sub_b382h		;b2fe	cd 82 b3 	. . . 
	jr c,lb31dh		;b301	38 1a 	8 . 
	call sub_b3a9h		;b303	cd a9 b3 	. . . 
	call sub_b36fh		;b306	cd 6f b3 	. o . 
	call nc,sub_b364h		;b309	d4 64 b3 	. d . 
	call nc,sub_b388h		;b30c	d4 88 b3 	. . . 
	jr c,lb31dh		;b30f	38 0c 	8 . 
	call sub_b331h		;b311	cd 31 b3 	. 1 . 
	call sub_b33dh		;b314	cd 3d b3 	. = . 
	call nc,sub_b337h		;b317	d4 37 b3 	. 7 . 
	call nc,sub_b35eh		;b31a	d4 5e b3 	. ^ . 
lb31dh:
	ld bc,05b93h		;b31d	01 93 5b 	. . [ 
	ld de,055b7h		;b320	11 b7 55 	. . U 
	call sub_b3b5h		;b323	cd b5 b3 	. . . 
	ld a,(055b6h)		;b326	3a b6 55 	: . U 
	or a			;b329	b7 	. 
	ret nz			;b32a	c0 	. 
	ld a,0feh		;b32b	3e fe 	> . 
	ld (055cbh),a		;b32d	32 cb 55 	2 . U 
	ret			;b330	c9 	. 
sub_b331h:
	ld b,007h		;b331	06 07 	. . 
	ld l,000h		;b333	2e 00 	. . 
	jr lb38ch		;b335	18 55 	. U 
sub_b337h:
	ld b,00ch		;b337	06 0c 	. . 
	ld l,001h		;b339	2e 01 	. . 
	jr lb38ch		;b33b	18 4f 	. O 
sub_b33dh:
	ld hl,00001h		;b33d	21 01 00 	! . . 
	add hl,de			;b340	19 	. 
	ld c,(hl)			;b341	4e 	N 
	ld b,000h		;b342	06 00 	. . 
	ld hl,lb397h		;b344	21 97 b3 	! . . 
	add hl,bc			;b347	09 	. 
	ld b,(hl)			;b348	46 	F 
	ld l,002h		;b349	2e 02 	. . 
	ld a,b			;b34b	78 	x 
	cp 01ch		;b34c	fe 1c 	. . 
	jr nz,lb38ch		;b34e	20 3c 	  < 
	ld hl,00003h		;b350	21 03 00 	! . . 
	add hl,de			;b353	19 	. 
	ld a,(hl)			;b354	7e 	~ 
	ld l,002h		;b355	2e 02 	. . 
	and 003h		;b357	e6 03 	. . 
	jr nz,lb38ch		;b359	20 31 	  1 
	inc b			;b35b	04 	. 
	jr lb38ch		;b35c	18 2e 	. . 
sub_b35eh:
	ld b,064h		;b35e	06 64 	. d 
	ld l,003h		;b360	2e 03 	. . 
	jr lb38ch		;b362	18 28 	. ( 
sub_b364h:
	ld b,00ch		;b364	06 0c 	. . 
	ld l,004h		;b366	2e 04 	. . 
	call lb38ch		;b368	cd 8c b3 	. . . 
	call z,sub_b388h		;b36b	cc 88 b3 	. . . 
	ret			;b36e	c9 	. 
sub_b36fh:
	ld b,03ch		;b36f	06 3c 	. < 
	ld l,005h		;b371	2e 05 	. . 
	ld a,(05fd5h)		;b373	3a d5 5f 	: . _ 
	sla a		;b376	cb 27 	. ' 
	ld (05fd5h),a		;b378	32 d5 5f 	2 . _ 
	ld a,0aah		;b37b	3e aa 	> . 
	ld (v5fa7),a		;b37d	32 a7 5f 	2 . _ 
	jr lb38ch		;b380	18 0a 	. . 
sub_b382h:
	ld b,03ch		;b382	06 3c 	. < 
	ld l,006h		;b384	2e 06 	. . 
	jr lb38ch		;b386	18 04 	. . 
sub_b388h:
	ld b,002h		;b388	06 02 	. . 
	ld l,007h		;b38a	2e 07 	. . 
lb38ch:
	ld h,000h		;b38c	26 00 	& . 
	add hl,de			;b38e	19 	. 
	ld a,(hl)			;b38f	7e 	~ 
	inc a			;b390	3c 	< 
	cp b			;b391	b8 	. 
	jr c,lb395h		;b392	38 01 	8 . 
	xor a			;b394	af 	. 
lb395h:
	ld (hl),a			;b395	77 	w 
	ret			;b396	c9 	. 
lb397h:
	rra			;b397	1f 	. 
	inc e			;b398	1c 	. 
	rra			;b399	1f 	. 
	ld e,01fh		;b39a	1e 1f 	. . 
	ld e,01fh		;b39c	1e 1f 	. . 
	rra			;b39e	1f 	. 
	ld e,01fh		;b39f	1e 1f 	. . 
	ld e,01fh		;b3a1	1e 1f 	. . 
	M_CALL_WITH_MMAP0 sub_c45eh
	ret

sub_b3a9h:
	M_CALL_WITH_MMAP0 sub_c554h
	ret

sub_b3afh:
	M_CALL_WITH_MMAP0 sub_c5cbh
	ret

sub_b3b5h:
	M_CALL_WITH_MMAP0 sub_c60bh
	ret

FUN_F7:	; Weather SETUP
	call sub_2a82h		;b3bb	cd 82 2a 	. . * 
	M_OUT_MSG 0xdb32, 0x33 ; 0F "WEATHER MENU SELECT" CRLF CRLF "1 U.S. SYSTEM" CRLF "2 METRIC SYSTEM"
	M_GOTO_YX 1,21
	ld h,0x02
	call INPUT_NUM		;b3cb	cd 48 3d 	. H = 
	ld a,l			;b3ce	7d 	} 
	ld (fUS_SI),a		;b3cf	32 66 54 	2 f T 
	call sub_2a82h		;b3d2	cd 82 2a 	. . * 
	M_OUT_CH 0x0f
	ld a,(fUS_SI)
	bit 0,a
	jp nz,_si_units			; SI units
	ld de,REF_TEXT_TEMP_US
	jp _cont				; US units
_si_units:
	ld de,REF_TEXT_TEMP_SI		;b3e7	11 92 da 	. . . 
_cont:
	push de			;b3ea	d5 	. 
	ld a,(05cbah)		;b3eb	3a ba 5c 	: . \ 
	cp 005h		;b3ee	fe 05 	. . 
	jr nz,lb404h		;b3f0	20 12 	  . 
	ld a,(fUS_SI)		;b3f2	3a 66 54 	: f T 
	push af			;b3f5	f5 	. 
	ld a,057h		;b3f6	3e 57 	> W 
	ld hl,0		;b3f8	21 00 00 	! . . 
	call sub_88dch		;b3fb	cd dc 88 	. . . 
	pop af			;b3fe	f1 	. 
	ld (fUS_SI),a		;b3ff	32 66 54 	2 f T 
	jr lb40fh		;b402	18 0b 	. . 
lb404h:
	ld bc,000a4h		;b404	01 a4 00 	. . . 
	ld de,v53c2		;b407	11 c2 53 	. . S 
	ld hl,055e1h		;b40a	21 e1 55 	! . U 
	ldir		;b40d	ed b0 	. . 
lb40fh:
	ld hl,pWEATHER_CONF		;b40f	21 67 54 	! g T 
	pop de			;b412	d1 	. 
	push de			;b413	d5 	. 
	push hl			;b414	e5 	. 
	ld ix,053c6h		;b415	dd 21 c6 53 	. ! . S 
	ld b,0a0h		;b419	06 a0 	. . 
	ld c,000h		;b41b	0e 00 	. . 
lb41dh:
	ld a,(de)			;b41d	1a 	. 
	cp 030h		;b41e	fe 30 	. 0 
	jr nz,lb455h		;b420	20 33 	  3 
	ld a,(ix+000h)		;b422	dd 7e 00 	. ~ . 
	push bc			;b425	c5 	. 
	ld c,a			;b426	4f 	O 
	ld a,020h		;b427	3e 20 	>   
	ld b,a			;b429	47 	G 
	ld a,c			;b42a	79 	y 
	sub b			;b42b	90 	. 
	ld a,c			;b42c	79 	y 
	pop bc			;b42d	c1 	. 
	jp nc,lb433h		;b42e	d2 33 b4 	. 3 . 
	ld a,030h		;b431	3e 30 	> 0 
lb433h:
	push bc			;b433	c5 	. 
	ld c,a			;b434	4f 	O 
	ld a,02eh		;b435	3e 2e 	> . 
	ld b,a			;b437	47 	G 
	ld a,c			;b438	79 	y 
	sub b			;b439	90 	. 
	ld a,c			;b43a	79 	y 
	pop bc			;b43b	c1 	. 
	jp nz,lb441h		;b43c	c2 41 b4 	. A . 
	ld a,030h		;b43f	3e 30 	> 0 
lb441h:
	push bc			;b441	c5 	. 
	ld b,a			;b442	47 	G 
	ld a,005h		;b443	3e 05 	> . 
	push de			;b445	d5 	. 
	ld d,b			;b446	50 	P 
	ld b,a			;b447	47 	G 
	ld a,c			;b448	79 	y 
	ld c,d			;b449	4a 	J 
	pop de			;b44a	d1 	. 
	sub b			;b44b	90 	. 
	ld a,c			;b44c	79 	y 
	pop bc			;b44d	c1 	. 
	jp c,lb453h		;b44e	da 53 b4 	. S . 
	ld a,058h		;b451	3e 58 	> X 
lb453h:
	ld (hl),a			;b453	77 	w 
	inc hl			;b454	23 	# 
lb455h:
	push bc			;b455	c5 	. 
	ld c,a			;b456	4f 	O 
	ld a,020h		;b457	3e 20 	>   
	ld b,a			;b459	47 	G 
	ld a,(ix+000h)		;b45a	dd 7e 00 	. ~ . 
	sub b			;b45d	90 	. 
	ld a,c			;b45e	79 	y 
	pop bc			;b45f	c1 	. 
	jp nz,lb467h		;b460	c2 67 b4 	. g . 
	inc c			;b463	0c 	. 
	jp lb469h		;b464	c3 69 b4 	. i . 
lb467h:
	ld c,000h		;b467	0e 00 	. . 
lb469h:
	cp 05ch		;b469	fe 5c 	. \ 
	call z,KBD_TRANSLATE		;b46b	cc 41 10 	. A . 
	call OUT_CH		;b46e	cd 84 10 	. . . 
	inc de			;b471	13 	. 
	inc ix		;b472	dd 23 	. # 
	djnz lb41dh		;b474	10 a7 	. . 
	ld (hl),0ffh		;b476	36 ff 	6 . 
	M_GOTO_YX 6,1
	ld iy,v53c2		;b47d	fd 21 c2 53 	. ! . S 
	call sub_b5e7h		;b481	cd e7 b5 	. . . 
	M_OUT_CH 0x04
	pop hl			;b488	e1 	. 
	pop de			;b489	d1 	. 
lb48ah:
	ld a,(de)			;b48a	1a 	. 
	cp 030h		;b48b	fe 30 	. 0 
	jr z,lb49fh		;b48d	28 10 	( . 
	inc de			;b48f	13 	. 
	cp 005h		;b490	fe 05 	. . 
	jr nz,lb499h		;b492	20 05 	  . 
	call OUT_CH		;b494	cd 84 10 	. . . 
	jr lb48ah		;b497	18 f1 	. . 
lb499h:
	M_OUT_CH RIGHT
	jr lb48ah		;b49d	18 eb 	. . 
lb49fh:
	push de			;b49f	d5 	. 
lb4a0h:
	inc de			;b4a0	13 	. 
	ld a,(de)			;b4a1	1a 	. 
	cp 02eh		;b4a2	fe 2e 	. . 
	jr z,lb4aah		;b4a4	28 04 	( . 
	cp 030h		;b4a6	fe 30 	. 0 
	jr nz,lb4b0h		;b4a8	20 06 	  . 
lb4aah:
	M_OUT_CH RIGHT
	jr lb4a0h		;b4ae	18 f0 	. . 
lb4b0h:
	M_OUT_CH 0x0e
	pop de
lb4b5h:
	push hl			;b4b5	e5 	. 
	push de			;b4b6	d5 	. 
lb4b7h:
	call NEXT_MACRO_OR_KEY		;b4b7	cd a7 17 	. . . 
	cp 02dh		;b4ba	fe 2d 	. - 
	jr z,lb50fh		;b4bc	28 51 	( Q 
	cp 00ah		;b4be	fe 0a 	. . 
	jr z,lb534h		;b4c0	28 72 	( r 
	cp 058h		;b4c2	fe 58 	. X 
	jr z,lb4d6h		;b4c4	28 10 	( . 
	cp 078h		;b4c6	fe 78 	. x 
	jr nz,lb4ceh		;b4c8	20 04 	  . 
	res 5,a		;b4ca	cb af 	. . 
	jr lb4d6h		;b4cc	18 08 	. . 
lb4ceh:
	cp 030h		;b4ce	fe 30 	. 0 
	jr c,lb4b7h		;b4d0	38 e5 	8 . 
	cp 03ah		;b4d2	fe 3a 	. : 
	jr nc,lb4b7h		;b4d4	30 e1 	0 . 
lb4d6h:
	ld c,a			;b4d6	4f 	O 
	M_OUT_CH 0x0f
lb4dbh:
	inc hl			;b4db	23 	# 
	inc de			;b4dc	13 	. 
	ld a,(de)			;b4dd	1a 	. 
	cp 030h		;b4de	fe 30 	. 0 
	jr nz,lb4efh		;b4e0	20 0d 	  . 
	ld a,(hl)			;b4e2	7e 	~ 
	cp 030h		;b4e3	fe 30 	. 0 
	jr z,lb4ebh		;b4e5	28 04 	( . 
	cp 020h		;b4e7	fe 20 	.   
	jr nz,lb4efh		;b4e9	20 04 	  . 
lb4ebh:
	ld (hl),020h		;b4eb	36 20 	6   
	jr lb4dbh		;b4ed	18 ec 	. . 
lb4efh:
	pop de			;b4ef	d1 	. 
	pop hl			;b4f0	e1 	. 
	push hl			;b4f1	e5 	. 
	push de			;b4f2	d5 	. 
lb4f3h:
	inc de			;b4f3	13 	. 
	ld a,(de)			;b4f4	1a 	. 
	cp 02eh		;b4f5	fe 2e 	. . 
	jr z,lb502h		;b4f7	28 09 	( . 
	cp 030h		;b4f9	fe 30 	. 0 
	jr nz,lb508h		;b4fb	20 0b 	  . 
	inc hl			;b4fd	23 	# 
	ld a,(hl)			;b4fe	7e 	~ 
	dec hl			;b4ff	2b 	+ 
	ld (hl),a			;b500	77 	w 
	inc hl			;b501	23 	# 
lb502h:
	M_OUT_CH 0x08
	jr lb4f3h		;b506	18 eb 	. . 
lb508h:
	ld (hl),c			;b508	71 	q 
	pop de			;b509	d1 	. 
	pop hl			;b50a	e1 	. 
	push hl			;b50b	e5 	. 
	push de			;b50c	d5 	. 
	jr lb516h		;b50d	18 07 	. . 
lb50fh:
	call sub_b5d8h		;b50f	cd d8 b5 	. . . 
	pop de			;b512	d1 	. 
	push de			;b513	d5 	. 
	ld (hl),02dh		;b514	36 2d 	6 - 
lb516h:
	ld a,(de)			;b516	1a 	. 
	cp 02eh		;b517	fe 2e 	. . 
	jr z,lb521h		;b519	28 06 	( . 
	cp 030h		;b51b	fe 30 	. 0 
	jr nz,lb527h		;b51d	20 08 	  . 
	ld a,(hl)			;b51f	7e 	~ 
	inc hl			;b520	23 	# 
lb521h:
	call OUT_CH		;b521	cd 84 10 	. . . 
	inc de			;b524	13 	. 
	jr lb516h		;b525	18 ef 	. . 
lb527h:
	M_OUT_CH 0x08
	M_OUT_CH 0x0e
	pop de
	pop hl			;b530	e1 	. 
	jp lb4b5h		;b531	c3 b5 b4 	. . . 

; Something about weather fields configuration
; Unsure what 'de'/'hl' points to
lb534h:
	pop de
	pop hl
	M_OUT_CH 0x0f 
	M_OUT_CH RIGHT

	; hl++;  while (*de++ in ['.','0]) hl++
lb53eh:
	inc hl
lb53fh:
	inc de
	ld a,(de)
	cp '.'
	jr z,lb53fh		; Ignore '.'
	cp '0'
	jr z,lb53eh		; Loop for every '0'

	; if (*hl==-1)
	ld a,(hl)
	cp 0ffh
	jp nz,lb48ah
	M_GOTO_YX 6,14
	ld iy,v53c2
	call sub_b600h		; Something with keyboard reading
	ld hl,053c6h		;b55b	21 c6 53 	! . S 
	ld a,(fUS_SI)
	bit 0,a
	jp nz,_si_units 
	ld de,REF_TEXT_TEMP_US
	jp _cont
_si_units:
	ld de,REF_TEXT_TEMP_SI		; Ref text with '0's
_cont:
	ld ix,pWEATHER_CONF	; 'X' if field should be ignored

						; Length of the 5 weather fields
						; If there is an 'X' in any of the digits, the entire field is ignored
						; Some fields can contain 2 measurements
	ld iy,WEATHER_FIELDS_LENGTHS
lb577h:
	ld b,(iy+000h)
	ld c,0

	; We copy B characters from DE to HL
	; When copying a '0', if the corresponding entry in ix is 'X',
	; we replace it by 'X'
	; (note ix contains only entries for digits)
	; C is 0 or FF (FF if we found any 'X')
_loop:
	ld a,(de)
	cp '0'
	jr nz,_copy		; Normal text, we copy
	ld a,(ix+000h)
	inc ix
	cp 'X'
	jp nz,_copy		; Digit no 'Xed', we copy
	ld c,0xff		; Set flag to 0xff
_copy:
	ld (hl),a 
	inc de 
	inc hl 
	djnz _loop		; Next character

		; ?
	push bc 
	ld b,a 
	ld a,0 
	push de 
	ld d,b 
	ld b,a 
	ld a,c 
	ld c,d 
	pop de 
	sub b 
	ld a,c 
	pop bc

	jp z,lb5afh

	ld c,(iy+000h)
	xor a
	sbc hl,bc
	ld b,c
	ld a,' '
_fill_loop:				; Fills with spaces
	ld (hl),a
	inc hl
	djnz _fill_loop

lb5afh:
	inc iy		;b5af	fd 23 	. # 
	ld a,(ix+000h)		;b5b1	dd 7e 00 	. ~ . 
	cp 0ffh		;b5b4	fe ff 	. . 
	jr nz,lb577h		;b5b6	20 bf 	  . 
	ld bc,000a5h		;b5b8	01 a5 00 	. . . 
	ld hl,v53c2		;b5bb	21 c2 53 	! . S 
	ld a,(05cbah)		;b5be	3a ba 5c 	: . \ 
	cp 005h		;b5c1	fe 05 	. . 
	jr nz,lb5d0h		;b5c3	20 0b 	  . 
	ld de,05cc6h		;b5c5	11 c6 5c 	. . \ 
	ldir		;b5c8	ed b0 	. . 
	call l893fh		;b5ca	cd 3f 89 	. ? . 
	jp l1925h		;b5cd	c3 25 19 	. % . 
lb5d0h:
	ld de,055e1h		;b5d0	11 e1 55 	. . U 
	ldir		;b5d3	ed b0 	. . 
	jp l1925h		;b5d5	c3 25 19 	. % . 
sub_b5d8h:
	inc de			;b5d8	13 	. 
	ld a,(de)			;b5d9	1a 	. 
	cp 02eh		;b5da	fe 2e 	. . 
	jr z,lb5e1h		;b5dc	28 03 	( . 
	cp 030h		;b5de	fe 30 	. 0 
	ret nz			;b5e0	c0 	. 
lb5e1h:
	M_OUT_CH 0x08
	jr sub_b5d8h		;b5e5	18 f1 	. . 
sub_b5e7h:
	M_OUT_MSG 0xd9ca, 0x0b ; "START PAGE "
	M_OUT_VAR 0x0000, 0x03
	M_OUT_MSG 0xd9d5, 0x0c ; "  STOP PAGE "
	M_OUT_VAR 0x0002, 0x03
	ret			;b5ff	c9 	. 
sub_b600h:
	; Adrs is IY
	M_SOMETHING1 0x0000, 0x03
	M_RIGHT 15
	ex de,hl			;b60a	eb 	. 
lb60bh:
	; Adrs is IY+2
	M_SOMETHING1 0x0002, 0x13
	call CMP_HLDE		;b611	cd 20 0f 	.   . 
	ret nc			;b614	d0 	. 
	M_SOMETHING2 0x03
	jr lb60bh		;b619	18 f0 	. . 

FUN_D3:
	ld a,(CFG5)		;b61b	3a 0c 00 	: . . 
	cp 0aah		;b61e	fe aa 	. . 
	jr nz,lb64dh		;b620	20 2b 	  + 
	call sub_2a82h		;b622	cd 82 2a 	. . * 
	M_OUT_MSG 0xdc18, 0x39 ; "ACTION  L     L=LINE LEVELS" CRLF "              T=OUTPUT TO VTR"
	ld a,'L'
	ld (v53c2),a		;b62d	32 c2 53 	2 . S 
	M_GOTO_YX 1,9
_again:
	M_INPUT v53c2,0x51
	ld a,(v53c2)		;b63b	3a c2 53 	: . S 
	cp 'T'
	jp z,01719h		;b640	ca 19 17 	. . . 
	cp 'L'
	jr z,lb64dh		;b645	28 06 	( . 
	M_SOMETHING2 0x12
	jr _again		;b64b	18 e8 	. . 
lb64dh:
	call sub_2a82h		;b64d	cd 82 2a 	. . * 
	call sub_b65fh		;b650	cd 5f b6 	. _ . 
	call sub_b6cch		;b653	cd cc b6 	. . . 
	call sub_b7f8h		;b656	cd f8 b7 	. . . 
	call sub_b821h		;b659	cd 21 b8 	. ! . 
	jp l1925h		;b65c	c3 25 19 	. % . 
sub_b65fh:
	ld de,v53c2		;b65f	11 c2 53 	. . S 
	ld hl,053bdh		;b662	21 bd 53 	! . S 
	ld bc,5		;b665	01 05 00 	. . . 
	ldir		;b668	ed b0 	. . 
	ld a,(05cbah)		;b66a	3a ba 5c 	: . \ 
	cp 005h		;b66d	fe 05 	. . 
	jr nz,lb679h		;b66f	20 08 	  . 
	ld a,04ch		;b671	3e 4c 	> L 
	ld hl,0		;b673	21 00 00 	! . . 
	call sub_88dch		;b676	cd dc 88 	. . . 
lb679h:
	ld a,(v53c2)		;b679	3a c2 53 	: . S 
	ld (05426h),a		;b67c	32 26 54 	2 & T 
	ld hl,053c7h		;b67f	21 c7 53 	! . S 
	call sub_b689h		;b682	cd 89 b6 	. . . 
	call sub_b69dh		;b685	cd 9d b6 	. . . 
	ret			;b688	c9 	. 
sub_b689h:
	ld c,a			;b689	4f 	O 
	ld d,001h		;b68a	16 01 	. . 
	ld b,004h		;b68c	06 04 	. . 
lb68eh:
	and d			;b68e	a2 	. 
	ld a,048h		;b68f	3e 48 	> H 
	jr nz,lb695h		;b691	20 02 	  . 
	ld a,04ch		;b693	3e 4c 	> L 
lb695h:
	ld (hl),a			;b695	77 	w 
	sla d		;b696	cb 22 	. " 
	ld a,c			;b698	79 	y 
	inc hl			;b699	23 	# 
	djnz lb68eh		;b69a	10 f2 	. . 
	ret			;b69c	c9 	. 

; May be worth exploring
sub_b69dh:
	ld ix,vUserCodes		;b69d	dd 21 c3 53 	. ! . S 
	ld b,002h		;b6a1	06 02 	. . 
lb6a3h:
	ld a,(ix+000h)		;b6a3	dd 7e 00 	. ~ . 
	cp 'P'
	jr z,lb6b0h		;b6a8	28 06 	( . 
	cp 'S'
	jr z,lb6b0h		;b6ac	28 02 	( . 
	ld a,'N' 
lb6b0h:
	ld (hl),a			;b6b0	77 	w 
	inc ix		;b6b1	dd 23 	. # 
	inc hl			;b6b3	23 	# 
	djnz lb6a3h		;b6b4	10 ed 	. . 
	ld b,002h		;b6b6	06 02 	. . 
lb6b8h:
	ld a,(ix+000h)		;b6b8	dd 7e 00 	. ~ . 
	cp '1'
	jr c,lb6c3h		;b6bd	38 04 	8 . 
	cp '7'
	jr c,lb6c5h		;b6c1	38 02 	8 . 
lb6c3h:
	ld a,'A'
lb6c5h:
	ld (hl),a			;b6c5	77 	w 
	inc ix		;b6c6	dd 23 	. # 
	inc hl			;b6c8	23 	# 
	djnz lb6b8h		;b6c9	10 ed 	. . 
	ret			;b6cb	c9 	. 

sub_b6cch:
	M_OUT_MSG 0xdb6a, 0xae ; CRLF "LINE LEVELS" CRLF CRLF "OUT     1  2  3  4" CRLF CRLF CRLF " H=HIGH, L=LOW, N=NO CHANGE" CRLF CRLF CRLF "IN      1  2" CRLF CRLF "ACTION        N=NONE, P=PAGE END" CRLF "              S=SEQUENCE RESET" CRLF CRLF "REGION        1 TO 6 OR A=ALL" CRLF 
	M_OUT_UP 10		; Back first line
	M_RIGHT 8		; Second column
	ld b,4
	ld hl,053c7h
_loop1:
	ld a,(hl)
	call OUT_CH		; LINE LEVELS
	M_RIGHT 2
	inc hl
	djnz _loop1
	M_LEFT 12
	M_DOWN 6
	ld b,2
_loop2:
	ld a,(hl)
	call OUT_CH
	M_RIGHT 2
	inc hl
	djnz _loop2
	M_DOWN 3
	M_LEFT 6
	ld b,2
_loop3:
	ld a,(hl)
	call OUT_CH
	M_RIGHT 2
	inc hl
	djnz _loop3
	M_OUT_UP RIGHT
	M_LEFT 6
	ld b,4
	ld hl,053c7h
lb721h:
	call NEXT_MACRO_OR_KEY
	cp 0x7f
	jr nz,lb735h
	ld a,b
	cp 4
	jr z,lb721h		;b72b	28 f4 	( . 
	inc b			;b72d	04 	. 
	dec hl			;b72e	2b 	+ 
	call LEFT_INLINE		;b72f	cd 6c 15 	. l . 
	inc bc			;b732	03 	. 
	jr lb721h		;b733	18 ec 	. . 
lb735h:
	cp 00ah		;b735	fe 0a 	. . 
	jr z,lb751h		;b737	28 18 	( . 
	res 5,a		;b739	cb af 	. . 
	cp 048h		;b73b	fe 48 	. H 
	jr z,lb747h		;b73d	28 08 	( . 
	cp 04ch		;b73f	fe 4c 	. L 
	jr z,lb747h		;b741	28 04 	( . 
	cp 04eh		;b743	fe 4e 	. N 
	jr nz,lb721h		;b745	20 da 	  . 
lb747h:
	ld (hl),a			;b747	77 	w 
	call OUT_CH		;b748	cd 84 10 	. . . 
	call LEFT_INLINE		;b74b	cd 6c 15 	. l . 
	ld bc,0d018h		;b74e	01 18 d0 	. . . 
lb751h:
	call RIGHT_INLINE		;b751	cd 70 15 	. p . 
	inc bc			;b754	03 	. 
	inc hl			;b755	23 	# 
	djnz lb721h		;b756	10 c9 	. . 
	call LEFT_INLINE		;b758	cd 6c 15 	. l . 
	inc c			;b75b	0c 	. 
	call DOWN_INLINE		;b75c	cd 68 15 	. h . 
	ld b,006h		;b75f	06 06 	. . 
	ld (bc),a			;b761	02 	. 
lb762h:
	call NEXT_MACRO_OR_KEY		;b762	cd a7 17 	. . . 
	cp 07fh		;b765	fe 7f 	.  
	jr nz,lb782h		;b767	20 19 	  . 
	dec hl			;b769	2b 	+ 
	ld a,b			;b76a	78 	x 
	cp 002h		;b76b	fe 02 	. . 
	jr nz,lb77bh		;b76d	20 0c 	  . 
	call RIGHT_INLINE		;b76f	cd 70 15 	. p . 
	add hl,bc			;b772	09 	. 
	call OUT_C_INLINE		;b773	cd 64 15 	. d . 
	ld b,006h		;b776	06 06 	. . 
	ld bc,la618h		;b778	01 18 a6 	. . . 
lb77bh:
	call LEFT_INLINE		;b77b	cd 6c 15 	. l . 
	inc bc			;b77e	03 	. 
	inc b			;b77f	04 	. 
	jr lb762h		;b780	18 e0 	. . 
lb782h:
	cp 00ah		;b782	fe 0a 	. . 
	jr z,lb79eh		;b784	28 18 	( . 
	res 5,a		;b786	cb af 	. . 
	cp 050h		;b788	fe 50 	. P 
	jr z,lb794h		;b78a	28 08 	( . 
	cp 053h		;b78c	fe 53 	. S 
	jr z,lb794h		;b78e	28 04 	( . 
	cp 04eh		;b790	fe 4e 	. N 
	jr nz,lb762h		;b792	20 ce 	  . 
lb794h:
	ld (hl),a			;b794	77 	w 
	call OUT_CH		;b795	cd 84 10 	. . . 
	call LEFT_INLINE		;b798	cd 6c 15 	. l . 
	ld bc,0c418h		;b79b	01 18 c4 	. . . 
lb79eh:
	call RIGHT_INLINE		;b79e	cd 70 15 	. p . 
	inc bc			;b7a1	03 	. 
	inc hl			;b7a2	23 	# 
	djnz lb762h		;b7a3	10 bd 	. . 
	call LEFT_INLINE		;b7a5	cd 6c 15 	. l . 
	ld b,0cdh		;b7a8	06 cd 	. . 
	ld l,b			;b7aa	68 	h 
	dec d			;b7ab	15 	. 
	inc bc			;b7ac	03 	. 
	ld b,002h		;b7ad	06 02 	. . 
lb7afh:
	call NEXT_MACRO_OR_KEY		;b7af	cd a7 17 	. . . 
	cp 07fh		;b7b2	fe 7f 	.  
	jr nz,lb7cfh		;b7b4	20 19 	  . 
	dec hl			;b7b6	2b 	+ 
	ld a,b			;b7b7	78 	x 
	cp 002h		;b7b8	fe 02 	. . 
	jr nz,lb7c8h		;b7ba	20 0c 	  . 
	call RIGHT_INLINE		;b7bc	cd 70 15 	. p . 
	inc bc			;b7bf	03 	. 
	call OUT_C_INLINE		;b7c0	cd 64 15 	. d . 
	inc bc			;b7c3	03 	. 
	ld b,001h		;b7c4	06 01 	. . 
	jr lb762h		;b7c6	18 9a 	. . 
lb7c8h:
	call LEFT_INLINE		;b7c8	cd 6c 15 	. l . 
	inc bc			;b7cb	03 	. 
	inc b			;b7cc	04 	. 
	jr lb7afh		;b7cd	18 e0 	. . 
lb7cfh:
	cp 00ah		;b7cf	fe 0a 	. . 
	jr z,lb7edh		;b7d1	28 1a 	( . 
	cp 041h		;b7d3	fe 41 	. A 
	jr z,lb7e3h		;b7d5	28 0c 	( . 
	cp 061h		;b7d7	fe 61 	. a 
	jr z,lb7e3h		;b7d9	28 08 	( . 
	cp 031h		;b7db	fe 31 	. 1 
	jr c,lb7afh		;b7dd	38 d0 	8 . 
	cp 037h		;b7df	fe 37 	. 7 
	jr nc,lb7afh		;b7e1	30 cc 	0 . 
lb7e3h:
	ld (hl),a			;b7e3	77 	w 
	call OUT_CH		;b7e4	cd 84 10 	. . . 
	call LEFT_INLINE		;b7e7	cd 6c 15 	. l . 
	ld bc,0c218h		;b7ea	01 18 c2 	. . . 
lb7edh:
	call RIGHT_INLINE		;b7ed	cd 70 15 	. p . 
	inc bc			;b7f0	03 	. 
	inc hl			;b7f1	23 	# 
	djnz lb7afh		;b7f2	10 bb 	. . 
	ld hl,053c7h		;b7f4	21 c7 53 	! . S 
	ret			;b7f7	c9 	. 
sub_b7f8h:
	ld a,(v53c2)		;b7f8	3a c2 53 	: . S 
	ld b,a			;b7fb	47 	G 
	ld d,001h		;b7fc	16 01 	. . 
	ld e,0feh		;b7fe	1e fe 	. . 
lb800h:
	ld a,(hl)			;b800	7e 	~ 
	cp 048h		;b801	fe 48 	. H 
	jr nz,lb80ah		;b803	20 05 	  . 
	ld a,b			;b805	78 	x 
	or d			;b806	b2 	. 
	ld b,a			;b807	47 	G 
	jr lb811h		;b808	18 07 	. . 
lb80ah:
	cp 04ch		;b80a	fe 4c 	. L 
	jr nz,lb811h		;b80c	20 03 	  . 
	ld a,b			;b80e	78 	x 
	and e			;b80f	a3 	. 
	ld b,a			;b810	47 	G 
lb811h:
	bit 3,d		;b811	cb 5a 	. Z 
	jr nz,lb81ch		;b813	20 07 	  . 
	rlc d		;b815	cb 02 	. . 
	rlc e		;b817	cb 03 	. . 
	inc hl			;b819	23 	# 
	jr lb800h		;b81a	18 e4 	. . 
lb81ch:
	ld a,b			;b81c	78 	x 
	ld (053cah),a		;b81d	32 ca 53 	2 . S 
	ret			;b820	c9 	. 
sub_b821h:
	ld hl,053cah		;b821	21 ca 53 	! . S 
	ld de,053bdh		;b824	11 bd 53 	. . S 
	ld bc,5		;b827	01 05 00 	. . . 
	ld a,(05cbah)		;b82a	3a ba 5c 	: . \ 
	cp 005h		;b82d	fe 05 	. . 
	jr z,lb837h		;b82f	28 06 	( . 
	ld a,(hl)			;b831	7e 	~ 
	out (PORT_05),a		;b832	d3 05 	. . 
	ldir		;b834	ed b0 	. . 
	ret			;b836	c9 	. 
lb837h:
	ld de,05cc6h		;b837	11 c6 5c 	. . \ 
	ldir		;b83a	ed b0 	. . 
	ld a,04ch		;b83c	3e 4c 	> L 
	ld (05cc2h),a		;b83e	32 c2 5c 	2 . \ 
	call l893fh		;b841	cd 3f 89 	. ? . 
	ret			;b844	c9 	. 
sub_b845h:
	push hl			;b845	e5 	. 
	ld b,004h		;b846	06 04 	. . 
	ld d,001h		;b848	16 01 	. . 
	ld e,010h		;b84a	1e 10 	. . 
	ld c,a			;b84c	4f 	O 
lb84dh:
	ld a,c			;b84d	79 	y 
	and d			;b84e	a2 	. 
	jr z,lb85bh		;b84f	28 0a 	( . 
	ld a,c			;b851	79 	y 
	and e			;b852	a3 	. 
	ld a,050h		;b853	3e 50 	> P 
	jr nz,lb863h		;b855	20 0c 	  . 
	ld a,048h		;b857	3e 48 	> H 
	jr lb863h		;b859	18 08 	. . 
lb85bh:
	ld a,c			;b85b	79 	y 
	and e			;b85c	a3 	. 
	ld a,04eh		;b85d	3e 4e 	> N 
	jr z,lb863h		;b85f	28 02 	( . 
	ld a,04ch		;b861	3e 4c 	> L 
lb863h:
	ld (hl),a			;b863	77 	w 
	inc hl			;b864	23 	# 
	sla d		;b865	cb 22 	. " 
	sla e		;b867	cb 23 	. # 
	djnz lb84dh		;b869	10 e2 	. . 
	pop hl			;b86b	e1 	. 
	ret			;b86c	c9 	. 
sub_b86dh:
	ld b,004h		;b86d	06 04 	. . 
lb86fh:
	ld a,(hl)			;b86f	7e 	~ 
	call OUT_CH		;b870	cd 84 10 	. . . 
	call RIGHT_INLINE		;b873	cd 70 15 	. p . 
	ld (bc),a			;b876	02 	. 
	inc hl			;b877	23 	# 
	djnz lb86fh		;b878	10 f5 	. . 
	ret			;b87a	c9 	. 
sub_b87bh:
	ld b,004h		;b87b	06 04 	. . 
	push hl			;b87d	e5 	. 
lb87eh:
	call NEXT_MACRO_OR_KEY		;b87e	cd a7 17 	. . . 
	cp 07fh		;b881	fe 7f 	.  
	jr nz,lb892h		;b883	20 0d 	  . 
	ld a,b			;b885	78 	x 
	cp 004h		;b886	fe 04 	. . 
	jr z,lb87eh		;b888	28 f4 	( . 
	inc b			;b88a	04 	. 
	dec hl			;b88b	2b 	+ 
	call LEFT_INLINE		;b88c	cd 6c 15 	. l . 
	inc bc			;b88f	03 	. 
	jr lb87eh		;b890	18 ec 	. . 
lb892h:
	cp 00ah		;b892	fe 0a 	. . 
	jr z,lb8b2h		;b894	28 1c 	( . 
	res 5,a		;b896	cb af 	. . 
	cp 048h		;b898	fe 48 	. H 
	jr z,lb8a8h		;b89a	28 0c 	( . 
	cp 050h		;b89c	fe 50 	. P 
	jr z,lb8a8h		;b89e	28 08 	( . 
	cp 04ch		;b8a0	fe 4c 	. L 
	jr z,lb8a8h		;b8a2	28 04 	( . 
	cp 04eh		;b8a4	fe 4e 	. N 
	jr nz,lb87eh		;b8a6	20 d6 	  . 
lb8a8h:
	ld (hl),a			;b8a8	77 	w 
	call OUT_CH		;b8a9	cd 84 10 	. . . 
	call LEFT_INLINE		;b8ac	cd 6c 15 	. l . 
	ld bc,0cc18h		;b8af	01 18 cc 	. . . 
lb8b2h:
	call RIGHT_INLINE		;b8b2	cd 70 15 	. p . 
	inc bc			;b8b5	03 	. 
	inc hl			;b8b6	23 	# 
	djnz lb87eh		;b8b7	10 c5 	. . 
	ld b,004h		;b8b9	06 04 	. . 
	xor a			;b8bb	af 	. 
	ld c,a			;b8bc	4f 	O 
	ld d,008h		;b8bd	16 08 	. . 
	ld e,080h		;b8bf	1e 80 	. . 
lb8c1h:
	dec hl			;b8c1	2b 	+ 
	ld a,(hl)			;b8c2	7e 	~ 
	cp 04eh		;b8c3	fe 4e 	. N 
	jr z,lb8d8h		;b8c5	28 11 	( . 
	cp 048h		;b8c7	fe 48 	. H 
	jr z,lb8d5h		;b8c9	28 0a 	( . 
	cp 050h		;b8cb	fe 50 	. P 
	ld a,c			;b8cd	79 	y 
	jr nz,lb8d1h		;b8ce	20 01 	  . 
	or d			;b8d0	b2 	. 
lb8d1h:
	or e			;b8d1	b3 	. 
	ld c,a			;b8d2	4f 	O 
	jr lb8d8h		;b8d3	18 03 	. . 
lb8d5h:
	ld a,c			;b8d5	79 	y 
	or d			;b8d6	b2 	. 
	ld c,a			;b8d7	4f 	O 
lb8d8h:
	srl d		;b8d8	cb 3a 	. : 
	srl e		;b8da	cb 3b 	. ; 
	djnz lb8c1h		;b8dc	10 e3 	. . 
	ld a,c			;b8de	79 	y 
	pop hl			;b8df	e1 	. 
	ret			;b8e0	c9 	. 

FUN_FA:
	ld bc,FLAG_DISP		;b8e1	01 04 00 	. . . 
	ld de,v53c2		;b8e4	11 c2 53 	. . S 
	ld hl,05faeh		;b8e7	21 ae 5f 	! . _ 
	ldir		;b8ea	ed b0 	. . 
	ld a,(05cbah)		;b8ec	3a ba 5c 	: . \ 
	cp 005h		;b8ef	fe 05 	. . 
	jr nz,lb8fbh		;b8f1	20 08 	  . 
	ld a,042h		;b8f3	3e 42 	> B 
	ld hl,0		;b8f5	21 00 00 	! . . 
	call sub_88dch		;b8f8	cd dc 88 	. . . 
lb8fbh:
	call sub_2a82h		;b8fb	cd 82 2a 	. . * 
	M_OUT_MSG 0xdc51, 0x29 ; " BLOCK EDIT" CRLF CRLF " FIRST  LAST" CRLF " PAGE   PAGE" CRLF CRLF " "
	M_OUT_VAR 0x53c2, 0x04
	call RIGHT_INLINE		;b90a	cd 70 15 	. p . 
	inc bc			;b90d	03 	. 
	M_OUT_VAR 0x53c4, 0x04
	M_GOTO_YX 6,5
	M_SOMETHING1 v53c2, 0x14
	call RIGHT_INLINE		;b91f	cd 70 15 	. p . 
	rlca			;b922	07 	. 
lb923h:
	M_SOMETHING1 v53c4, 0x14
	ld hl,(053c4h)		;b929	2a c4 53 	* . S 
	ld de,(v53c2)		;b92c	ed 5b c2 53 	. [ . S 
	call CMP_HLDE		;b930	cd 20 0f 	.   . 
	jr nc,lb93bh		;b933	30 06 	0 . 
	M_SOMETHING2 0x04
	jr lb923h		;b939	18 e8 	. . 
lb93bh:
	ld bc,FLAG_DISP		;b93b	01 04 00 	. . . 
	ld de,05faeh		;b93e	11 ae 5f 	. . _ 
	ld hl,v53c2		;b941	21 c2 53 	! . S 
	ld a,(05cbah)		;b944	3a ba 5c 	: . \ 
	cp 005h		;b947	fe 05 	. . 
	jr nz,lb95ch		;b949	20 11 	  . 
	ld de,05cc6h		;b94b	11 c6 5c 	. . \ 
	ldir		;b94e	ed b0 	. . 
	call l893fh		;b950	cd 3f 89 	. ? . 
	ld hl,v53c2		;b953	21 c2 53 	! . S 
	ld de,05fb2h		;b956	11 b2 5f 	. . _ 
	ld bc,FLAG_DISP		;b959	01 04 00 	. . . 
lb95ch:
	ldir		;b95c	ed b0 	. . 
	jp l1925h		;b95e	c3 25 19 	. % . 

FUN_F2:
	call sub_b96fh		;b961	cd 6f b9 	. o . 
	call sub_b9b6h		;b964	cd b6 b9 	. . . 
lb967h:
	call sub_b9c0h		;b967	cd c0 b9 	. . . 
	call sub_b9cah		;b96a	cd ca b9 	. . . 
	jr lb967h		;b96d	18 f8 	. . 
sub_b96fh:
	ld hl,(05fa4h)		;b96f	2a a4 5f 	* . _ 
sub_b972h:
	ld iy,v53c2		;b972	fd 21 c2 53 	. ! . S 
	ld a,(05cbah)		;b976	3a ba 5c 	: . \ 
	cp 005h		;b979	fe 05 	. . 
	jr nz,lb991h		;b97b	20 14 	  . 
	call sub_8b36h		;b97d	cd 36 8b 	. 6 . 
	call sub_889bh		;b980	cd 9b 88 	. . . 
	cp 0ffh		;b983	fe ff 	. . 
	jr nz,lb98ch		;b985	20 05 	  . 
	call sub_bc13h		;b987	cd 13 bc 	. . . 
	jr sub_b96fh		;b98a	18 e3 	. . 
lb98ch:
	ld hl,05cc6h		;b98c	21 c6 5c 	! . \ 
	jr lb9adh		;b98f	18 1c 	. . 
lb991h:
	ld de,(05b79h)		;b991	ed 5b 79 5b 	. [ y [ 
	ld hl,(05fa4h)		;b995	2a a4 5f 	* . _ 
	call CMP_HLDE		;b998	cd 20 0f 	.   . 
	jr c,lb9a2h		;b99b	38 05 	8 . 
	call sub_bc13h		;b99d	cd 13 bc 	. . . 
	jr lb991h		;b9a0	18 ef 	. . 
lb9a2h:
	ld a,003h		;b9a2	3e 03 	> . 
	call SETMEMMAP		;b9a4	cd 1a 0f 	. . . 
	ld (05fa4h),hl		;b9a7	22 a4 5f 	" . _ 
	call sub_bf2fh		;b9aa	cd 2f bf 	. / . 
lb9adh:
	ld de,v53c2		;b9ad	11 c2 53 	. . S 
	ld bc,00020h		;b9b0	01 20 00 	.   . 
	ldir		;b9b3	ed b0 	. . 
	ret			;b9b5	c9 	. 
sub_b9b6h:
	call sub_b9d1h		;b9b6	cd d1 b9 	. . . 
	call sub_b9feh		;b9b9	cd fe b9 	. . . 
	call sub_bae5h		;b9bc	cd e5 ba 	. . . 
	ret			;b9bf	c9 	. 
sub_b9c0h:
	call sub_bbffh		;b9c0	cd ff bb 	. . . 
	call sub_bc50h		;b9c3	cd 50 bc 	. P . 
	call sub_bd75h		;b9c6	cd 75 bd 	. u . 
	ret			;b9c9	c9 	. 
sub_b9cah:
	call sub_be25h		;b9ca	cd 25 be 	. % . 
	call sub_be8ch		;b9cd	cd 8c be 	. . . 
	ret			;b9d0	c9 	. 
sub_b9d1h:
	call sub_2a82h		;b9d1	cd 82 2a 	. . * 
	M_OUT_MSG 0xdc7a, 0xa2 ; "EVENT        ACTIVE     Y OR N" CRLF CRLF "MINUTE      0 TO 59" CRLF "HOUR        1 TO 12, A=ALL" CRLF "AM/PM       A=AM, P=PM" CRLF "DAY         1 TO 7, A=ALL" CRLF "ACTION      L=LEVELS, S=SEQUENCE" CRLF CRLF 
	ld a,(CFG5)
	cp 0aah		;b9dd	fe aa 	. . 
	jr nz,$+13		;b9df	20 0b 	  . 
	M_GOTO_YX 8,12
	M_OUT_MSG 0xdd1c, 0x08 ; "T=TAPE" CRLF CRLF 
	ld a,(CFG10)		;b9e6	cd c8 13 	. . . 
	cp 0aah		;b9ef	fe aa 	. . 
	ret nz			;b9f1	c0 	. 
	M_GOTO_YX 8,21
	M_OUT_MSG 0xdd24, 0x0c ; "B=BATCH T." CRLF CRLF 
	ret
sub_b9feh:
	M_GOTO_YX 1,8
	M_OUT_VAR 0x5fa4, 0x03
	call RIGHT_INLINE		;ba09	cd 70 15 	. p . 
	ld a,(bc)			;ba0c	0a 	. 
	ld a,(iy+000h)		;ba0d	fd 7e 00 	. ~ . 
	cp 059h		;ba10	fe 59 	. Y 
	jr z,lba16h		;ba12	28 02 	( . 
	ld a,04eh		;ba14	3e 4e 	> N 
lba16h:
	ld (iy+000h),a		;ba16	fd 77 00 	. w . 
	call OUT_CH		;ba19	cd 84 10 	. . . 
	M_GOTO_YX 3,9
	ld a,(iy+001h)		;ba21	fd 7e 01 	. ~ . 
	cp 03ch		;ba24	fe 3c 	. < 
	jr c,lba2ch		;ba26	38 04 	8 . 
	ld (iy+001h),000h		;ba28	fd 36 01 00 	. 6 . . 
lba2ch:
	M_OUT_VAR 0x0001, 0x42
	call DOWN_INLINE		;ba32	cd 68 15 	. h . 
	ld bc,06ccdh		;ba35	01 cd 6c 	. . l 
	dec d			;ba38	15 	. 
	ld (bc),a			;ba39	02 	. 
lba3ah:
	ld a,(iy+002h)		;ba3a	fd 7e 02 	. ~ . 
	and 07fh		;ba3d	e6 7f 	.  
	cp 001h		;ba3f	fe 01 	. . 
	jr c,lba4bh		;ba41	38 08 	8 . 
	cp 041h		;ba43	fe 41 	. A 
	jr z,lba57h		;ba45	28 10 	( . 
	cp 00dh		;ba47	fe 0d 	. . 
	jr c,lba5ah		;ba49	38 0f 	8 . 
lba4bh:
	ld a,(iy+002h)		;ba4b	fd 7e 02 	. ~ . 
	and 080h		;ba4e	e6 80 	. . 
	or 001h		;ba50	f6 01 	. . 
	ld (iy+002h),a		;ba52	fd 77 02 	. w . 
	jr lba3ah		;ba55	18 e3 	. . 
lba57h:
	ld (iy+002h),a		;ba57	fd 77 02 	. w . 
lba5ah:
	ld b,020h		;ba5a	06 20 	.   
	ld c,a			;ba5c	4f 	O 
	cp 041h		;ba5d	fe 41 	. A 
	jr z,lba6ch		;ba5f	28 0b 	( . 
	add a,030h		;ba61	c6 30 	. 0 
	cp 03ah		;ba63	fe 3a 	. : 
	jr c,lba6bh		;ba65	38 04 	8 . 
	ld b,031h		;ba67	06 31 	. 1 
	sub 00ah		;ba69	d6 0a 	. . 
lba6bh:
	ld c,a			;ba6b	4f 	O 
lba6ch:
	ld a,b			;ba6c	78 	x 
	call OUT_CH		;ba6d	cd 84 10 	. . . 
	ld (053f4h),a		;ba70	32 f4 53 	2 . S 
	ld a,c			;ba73	79 	y 
	call OUT_CH		;ba74	cd 84 10 	. . . 
	ld (053f5h),a		;ba77	32 f5 53 	2 . S 
	call DOWN_INLINE		;ba7a	cd 68 15 	. h . 
	ld bc,06ccdh		;ba7d	01 cd 6c 	. . l 
	dec d			;ba80	15 	. 
	ld bc,07efdh		;ba81	01 fd 7e 	. . ~ 
	ld (bc),a			;ba84	02 	. 
	rla			;ba85	17 	. 
	ld a,041h		;ba86	3e 41 	> A 
	jr nc,lba8ch		;ba88	30 02 	0 . 
	ld a,050h		;ba8a	3e 50 	> P 
lba8ch:
	call OUT_CH		;ba8c	cd 84 10 	. . . 
	call DOWN_INLINE		;ba8f	cd 68 15 	. h . 
	ld bc,06ccdh		;ba92	01 cd 6c 	. . l 
	dec d			;ba95	15 	. 
	ld bc,07efdh		;ba96	01 fd 7e 	. . ~ 
	inc bc			;ba99	03 	. 
	cp 041h		;ba9a	fe 41 	. A 
	jr z,lbaach		;ba9c	28 0e 	( . 
	cp 007h		;ba9e	fe 07 	. . 
	jr nc,lbaa6h		;baa0	30 04 	0 . 
	add a,031h		;baa2	c6 31 	. 1 
	jr lbaach		;baa4	18 06 	. . 
lbaa6h:
	xor a			;baa6	af 	. 
	ld (iy+003h),a		;baa7	fd 77 03 	. w . 
	ld a,031h		;baaa	3e 31 	> 1 
lbaach:
	call OUT_CH		;baac	cd 84 10 	. . . 
	call DOWN_INLINE		;baaf	cd 68 15 	. h . 
	ld bc,06ccdh		;bab2	01 cd 6c 	. . l 
	dec d			;bab5	15 	. 
	ld bc,07efdh		;bab6	01 fd 7e 	. . ~ 
	inc b			;bab9	04 	. 
	cp 04ch		;baba	fe 4c 	. L 
	jr z,lbae1h		;babc	28 23 	( # 
	cp 053h		;babe	fe 53 	. S 
	jr z,lbae1h		;bac0	28 1f 	( . 
	cp 054h		;bac2	fe 54 	. T 
	jr nz,lbacfh		;bac4	20 09 	  . 
	ld a,(CFG5)		;bac6	3a 0c 00 	: . . 
	cp 0aah		;bac9	fe aa 	. . 
	ld a,054h		;bacb	3e 54 	> T 
	jr z,lbae1h		;bacd	28 12 	( . 
lbacfh:
	cp 042h		;bacf	fe 42 	. B 
	jr nz,lbadch		;bad1	20 09 	  . 
	ld a,(0000eh)		;bad3	3a 0e 00 	: . . 
	cp 0aah		;bad6	fe aa 	. . 
	ld a,042h		;bad8	3e 42 	> B 
	jr z,lbae1h		;bada	28 05 	( . 
lbadch:
	ld a,04eh		;badc	3e 4e 	> N 
	ld (iy+004h),a		;bade	fd 77 04 	. w . 
lbae1h:
	call OUT_CH		;bae1	cd 84 10 	. . . 
	ret			;bae4	c9 	. 
sub_bae5h:
	M_GOTO_YX 9,1
	ld c,14
	call sub_bf24h		;baec	cd 24 bf 	. $ . 
	M_GOTO_YX 9,1
	ld a,(iy+4)
	cp 'L'
	jr z,lbb0ah		;baf9	28 0f 	( . 
	cp 'S'
	jr z,lbb2ch		;bafd	28 2d 	( - 
	cp 'T'
	jp z,lbc31h		;bb01	ca 31 bc 	. 1 . 
	cp 'B'
	jp z,lbc42h		;bb06	ca 42 bc 	. B . 
	ret
lbb0ah:
	M_OUT_MSG 0xd149, 0x0c ; "LINE LEVELS "
	M_GOTO_YX 11,10
	M_OUT_MSG 0xd157, 0x0a ; "1  2  3  4"
	M_GOTO_YX 13,10
	ld hl,053c7h		;bb20	21 c7 53 	! . S 
	ld a,(hl)			;bb23	7e 	~ 
	inc hl			;bb24	23 	# 
	call sub_b845h		;bb25	cd 45 b8 	. E . 
	call sub_b86dh		;bb28	cd 6d b8 	. m . 
	ret			;bb2b	c9 	. 
lbb2ch:
	M_OUT_MSG 0xdd30, 0x50 ; "TYPE     F=FILE CHANGE, I=INSERT" CRLF "TIMING   I=IMMEDIATE, D=DELAYED" CRLF "REGION   1 TO 6"
	M_GOTO_YX 9,8
	ld a,(iy+005h)		;bb37	fd 7e 05 	. ~ . 
	cp 049h		;bb3a	fe 49 	. I 
	jr z,lbb43h		;bb3c	28 05 	( . 
	ld a,046h		;bb3e	3e 46 	> F 
	ld (iy+005h),a		;bb40	fd 77 05 	. w . 
lbb43h:
	call OUT_CH		;bb43	cd 84 10 	. . . 
	call LEFT_INLINE		;bb46	cd 6c 15 	. l . 
	ld bc,068cdh		;bb49	01 cd 68 	. . h 
	dec d			;bb4c	15 	. 
	ld bc,07efdh		;bb4d	01 fd 7e 	. . ~ 
	ld b,0feh		;bb50	06 fe 	. . 
	ld b,h			;bb52	44 	D 
	jr z,lbb5ah		;bb53	28 05 	( . 
	ld a,049h		;bb55	3e 49 	> I 
	ld (iy+006h),a		;bb57	fd 77 06 	. w . 
lbb5ah:
	call OUT_CH		;bb5a	cd 84 10 	. . . 
	call LEFT_INLINE		;bb5d	cd 6c 15 	. l . 
	ld bc,068cdh		;bb60	01 cd 68 	. . h 
	dec d			;bb63	15 	. 
	ld bc,07efdh		;bb64	01 fd 7e 	. . ~ 
	rlca			;bb67	07 	. 
	cp 001h		;bb68	fe 01 	. . 
	jr c,lbb70h		;bb6a	38 04 	8 . 
	cp 007h		;bb6c	fe 07 	. . 
	jr c,lbb75h		;bb6e	38 05 	8 . 
lbb70h:
	ld a,001h		;bb70	3e 01 	> . 
	ld (iy+007h),a		;bb72	fd 77 07 	. w . 
lbb75h:
	add a,030h		;bb75	c6 30 	. 0 
	call OUT_CH		;bb77	cd 84 10 	. . . 
	M_GOTO_YX 13,1
	ld c,10
	call sub_bf24h		;bb81	cd 24 bf 	. $ . 
	M_GOTO_YX 13,1
	ld a,(iy+5)
	cp 'I'
	jr nz,lbb94h		;bb8e	20 04 	  . 
	call sub_bbd8h		;bb90	cd d8 bb 	. . . 
	ret			;bb93	c9 	. 
lbb94h:
	cp 046h		;bb94	fe 46 	. F 
	ret nz			;bb96	c0 	. 
	M_OUT_MSG 0xdd80, 0x45 ; "FILE  START   STOP  CHANGE" CRLF "       PAGE   PAGE   FILE" CRLF CRLF "  1" CRLF "  2" CRLF "  3" CRLF "  4"
	M_GOTO_YX 16,8
	push iy		;bba2	fd e5 	. . 
	ld iy,053cah		;bba4	fd 21 ca 53 	. ! . S 
	ld c,004h		;bba8	0e 04 	. . 
lbbaah:
	call lbbbbh		;bbaa	cd bb bb 	. . . 
	call DOWN_INLINE		;bbad	cd 68 15 	. h . 
	ld bc,06ccdh		;bbb0	01 cd 6c 	. . l 
	dec d			;bbb3	15 	. 
	dec d			;bbb4	15 	. 
	dec c			;bbb5	0d 	. 
	jr nz,lbbaah		;bbb6	20 f2 	  . 
	pop iy		;bbb8	fd e1 	. . 
	ret			;bbba	c9 	. 
lbbbbh:
	ld b,003h		;bbbb	06 03 	. . 
lbbbdh:
	call sub_bbcbh		;bbbd	cd cb bb 	. . . 
	inc iy		;bbc0	fd 23 	. # 
	inc iy		;bbc2	fd 23 	. # 
	call RIGHT_INLINE		;bbc4	cd 70 15 	. p . 
	inc bc			;bbc7	03 	. 
	djnz lbbbdh		;bbc8	10 f3 	. . 
	ret			;bbca	c9 	. 
sub_bbcbh:
	ld l,(iy+000h)		;bbcb	fd 6e 00 	. n . 
	ld h,(iy+001h)		;bbce	fd 66 01 	. f . 
	M_OUT_VAR 0x0000, 0x04
	ret			;bbd7	c9 	. 
sub_bbd8h:
	M_GOTO_YX 13,1
	M_OUT_MSG 0xddc5, 0x25 ; "      START   STOP" CRLF "       PAGE   PAGE"
	M_GOTO_YX 16,8
	push iy		;bbe8	fd e5 	. . 
	ld iy,053cah		;bbea	fd 21 ca 53 	. ! . S 
	call sub_bbcbh		;bbee	cd cb bb 	. . . 
	call RIGHT_INLINE		;bbf1	cd 70 15 	. p . 
	inc bc			;bbf4	03 	. 
	inc iy		;bbf5	fd 23 	. # 
	inc iy		;bbf7	fd 23 	. # 
	call sub_bbcbh		;bbf9	cd cb bb 	. . . 
	pop iy		;bbfc	fd e1 	. . 
	ret			;bbfe	c9 	. 
sub_bbffh:
	ld hl,(05fa4h)		;bbff	2a a4 5f 	* . _ 
	push hl			;bc02	e5 	. 
	call sub_bc1bh		;bc03	cd 1b bc 	. . . 
	pop de			;bc06	d1 	. 
	call CMP_HLDE		;bc07	cd 20 0f 	.   . 
	ret z			;bc0a	c8 	. 
	call sub_b972h		;bc0b	cd 72 b9 	. r . 
	call sub_b9b6h		;bc0e	cd b6 b9 	. . . 
	jr sub_bbffh		;bc11	18 ec 	. . 
sub_bc13h:
	call sub_b9d1h		;bc13	cd d1 b9 	. . . 
	ld b,007h		;bc16	06 07 	. . 
	call sub_3866h		;bc18	cd 66 38 	. f 8 
sub_bc1bh:
	M_GOTO_YX 1,8
	M_OUT_VAR 0x5fa4, 0x03
	call LEFT_INLINE		;bc26	cd 6c 15 	. l . 
	ld bc,0e4cdh		;bc29	01 cd e4 	. . . 
	inc de			;bc2c	13 	. 
	and h			;bc2d	a4 	. 
	ld e,a			;bc2e	5f 	_ 
	inc de			;bc2f	13 	. 
	ret			;bc30	c9 	. 
lbc31h:
	ld a,(CFG5)		;bc31	3a 0c 00 	: . . 
	cp 0aah		;bc34	fe aa 	. . 
	ret nz			;bc36	c0 	. 
	ld hl,053c9h		;bc37	21 c9 53 	! . S 
	M_GOTO_YX 10,1
	jp sub_15b0h
lbc42h:
	ld a,(0000eh)		;bc42	3a 0e 00 	: . . 
	cp 0aah		;bc45	fe aa 	. . 
	ret nz			;bc47	c0 	. 
	M_GOTO_YX 10,1
	jp sub_92cch
sub_bc50h:
	M_GOTO_YX 1,21
	ld hl, v53c2
	call 0xbea7
	call DOWN_INLINE		;bc5b	cd 68 15 	. h . 
	ld (bc),a			;bc5e	02 	. 
	call LEFT_INLINE		;bc5f	cd 6c 15 	. l . 
	dec bc			;bc62	0b 	. 
lbc63h:
	; Adrs is IY+1
	M_SOMETHING1 0x0001, 0x52
	ld a,l			;bc69	7d 	} 
	cp 03ch		;bc6a	fe 3c 	. < 
	jr c,lbc74h		;bc6c	38 06 	8 . 
	M_SOMETHING2 0x02
	jr lbc63h		;bc72	18 ef 	. . 
lbc74h:
	call DOWN_INLINE		;bc74	cd 68 15 	. h . 
	ld bc,01fcdh		;bc77	01 cd 1f 	. . . 
	inc de			;bc7a	13 	. 
	call p,05253h		;bc7b	f4 53 52 	. S R 
	ld de,(053f4h)		;bc7e	ed 5b f4 53 	. [ . S 
	ld hl,04141h		;bc82	21 41 41 	! A A 
	call CMP_HLDE		;bc85	cd 20 0f 	.   . 
	jr z,lbc99h		;bc88	28 0f 	( . 
	ld l,020h		;bc8a	2e 20 	.   
	call CMP_HLDE		;bc8c	cd 20 0f 	.   . 
	jr z,lbc99h		;bc8f	28 08 	( . 
	ld hl,02041h		;bc91	21 41 20 	! A   
	call CMP_HLDE		;bc94	cd 20 0f 	.   . 
	jr nz,lbca3h		;bc97	20 0a 	  . 
lbc99h:
	ld (iy+002h),041h		;bc99	fd 36 02 41 	. 6 . A 
	call DOWN_INLINE		;bc9d	cd 68 15 	. h . 
	ld (bc),a			;bca0	02 	. 
	jr $+97		;bca1	18 5f 	. _ 
lbca3h:
	ld b,000h		;bca3	06 00 	. . 
	ld a,e			;bca5	7b 	{ 
	cp 020h		;bca6	fe 20 	.   
	jr z,lbcb4h		;bca8	28 0a 	( . 
	cp 030h		;bcaa	fe 30 	. 0 
	jr z,lbcb4h		;bcac	28 06 	( . 
	ld b,00ah		;bcae	06 0a 	. . 
	cp 031h		;bcb0	fe 31 	. 1 
	jr nz,lbcc6h		;bcb2	20 12 	  . 
lbcb4h:
	ld a,d			;bcb4	7a 	z 
	sub 030h		;bcb5	d6 30 	. 0 
	jr c,lbcc6h		;bcb7	38 0d 	8 . 
	cp 00ah		;bcb9	fe 0a 	. . 
	jr nc,lbcc6h		;bcbb	30 09 	0 . 
	add a,b			;bcbd	80 	. 
	cp 001h		;bcbe	fe 01 	. . 
	jr c,lbcc6h		;bcc0	38 04 	8 . 
	cp 00dh		;bcc2	fe 0d 	. . 
	jr c,lbccch		;bcc4	38 06 	8 . 
lbcc6h:
	M_SOMETHING2 0x02
	jr $-82		;bcca	18 ac 	. . 
lbccch:
	ld c,a			;bccc	4f 	O 
	ld a,(iy+002h)		;bccd	fd 7e 02 	. ~ . 
	and 080h		;bcd0	e6 80 	. . 
	or c			;bcd2	b1 	. 
	ld (iy+002h),a		;bcd3	fd 77 02 	. w . 
	call DOWN_INLINE		;bcd6	cd 68 15 	. h . 
	ld bc,0a7cdh		;bcd9	01 cd a7 	. . . 
	rla			;bcdc	17 	. 
	cp 00ah		;bcdd	fe 0a 	. . 
	jr z,lbcfeh		;bcdf	28 1d 	( . 
	and 0dfh		;bce1	e6 df 	. . 
	cp 041h		;bce3	fe 41 	. A 
	jr nz,lbcedh		;bce5	20 06 	  . 
	res 7,(iy+002h)		;bce7	fd cb 02 be 	. . . . 
	jr lbcf5h		;bceb	18 08 	. . 
lbcedh:
	cp 050h		;bced	fe 50 	. P 
	jr nz,$-21		;bcef	20 e9 	  . 
	set 7,(iy+002h)		;bcf1	fd cb 02 fe 	. . . . 
lbcf5h:
	call OUT_CH		;bcf5	cd 84 10 	. . . 
	call LEFT_INLINE		;bcf8	cd 6c 15 	. l . 
	ld bc,0dc18h		;bcfb	01 18 dc 	. . . 
lbcfeh:
	call DOWN_INLINE		;bcfe	cd 68 15 	. h . 
	ld bc,0a7cdh		;bd01	01 cd a7 	. . . 
	rla			;bd04	17 	. 
	cp 00ah		;bd05	fe 0a 	. . 
	jr z,lbd2bh		;bd07	28 22 	( " 
	ld b,a			;bd09	47 	G 
	and 0dfh		;bd0a	e6 df 	. . 
	cp 041h		;bd0c	fe 41 	. A 
	jr z,lbd19h		;bd0e	28 09 	( . 
	ld a,b			;bd10	78 	x 
	cp 031h		;bd11	fe 31 	. 1 
	jr c,$-17		;bd13	38 ed 	8 . 
	cp 038h		;bd15	fe 38 	. 8 
	jr nc,$-21		;bd17	30 e9 	0 . 
lbd19h:
	call OUT_CH		;bd19	cd 84 10 	. . . 
	cp 041h		;bd1c	fe 41 	. A 
	jr z,lbd22h		;bd1e	28 02 	( . 
	sub 031h		;bd20	d6 31 	. 1 
lbd22h:
	ld (iy+003h),a		;bd22	fd 77 03 	. w . 
	call LEFT_INLINE		;bd25	cd 6c 15 	. l . 
	ld bc,0d718h		;bd28	01 18 d7 	. . . 
lbd2bh:
	call DOWN_INLINE		;bd2b	cd 68 15 	. h . 
	ld bc,04efdh		;bd2e	01 fd 4e 	. . N 
	inc b			;bd31	04 	. 
lbd32h:
	call NEXT_MACRO_OR_KEY		;bd32	cd a7 17 	. . . 
	cp 00ah		;bd35	fe 0a 	. . 
	jr z,lbd69h		;bd37	28 30 	( 0 
	res 5,a		;bd39	cb af 	. . 
	cp 04ch		;bd3b	fe 4c 	. L 
	jr z,lbd5fh		;bd3d	28 20 	(   
	cp 053h		;bd3f	fe 53 	. S 
	jr z,lbd5fh		;bd41	28 1c 	( . 
	cp 054h		;bd43	fe 54 	. T 
	jr nz,lbd52h		;bd45	20 0b 	  . 
	ld a,(CFG5)		;bd47	3a 0c 00 	: . . 
	cp 0aah		;bd4a	fe aa 	. . 
	ld a,054h		;bd4c	3e 54 	> T 
	jr nz,lbd32h		;bd4e	20 e2 	  . 
	jr lbd5fh		;bd50	18 0d 	. . 
lbd52h:
	cp 042h		;bd52	fe 42 	. B 
	jr nz,lbd32h		;bd54	20 dc 	  . 
	ld a,(0000eh)		;bd56	3a 0e 00 	: . . 
	cp 0aah		;bd59	fe aa 	. . 
	ld a,042h		;bd5b	3e 42 	> B 
	jr nz,lbd32h		;bd5d	20 d3 	  . 
lbd5fh:
	call OUT_CH		;bd5f	cd 84 10 	. . . 
	ld c,a			;bd62	4f 	O 
	call LEFT_INLINE		;bd63	cd 6c 15 	. l . 
	ld bc,0c918h		;bd66	01 18 c9 	. . . 
lbd69h:
	ld a,(iy+004h)		;bd69	fd 7e 04 	. ~ . 
	cp c			;bd6c	b9 	. 
	ret z			;bd6d	c8 	. 
	ld (iy+004h),c		;bd6e	fd 71 04 	. q . 
	call sub_bae5h		;bd71	cd e5 ba 	. . . 
	ret			;bd74	c9 	. 
sub_bd75h:
	ld a,(iy+004h)		;bd75	fd 7e 04 	. ~ . 
	cp 04ch		;bd78	fe 4c 	. L 
	jr z,lbd9ah		;bd7a	28 1e 	( . 
	cp 053h		;bd7c	fe 53 	. S 
	jr z,lbdb1h		;bd7e	28 31 	( 1 
	cp 054h		;bd80	fe 54 	. T 
	jr z,lbd8fh		;bd82	28 0b 	( . 
	cp 042h		;bd84	fe 42 	. B 
	ret nz			;bd86	c0 	. 
	M_GOTO_YX 10,1
	jp sub_932ch
lbd8fh:
	M_GOTO_YX 10,1
	ld hl,v53c9
	jp sub_162bh		;bd97	c3 2b 16 	. + . 
lbd9ah:
	ld b,006h		;bd9a	06 06 	. . 
	call sub_3866h		;bd9c	cd 66 38 	. f 8 
	M_GOTO_YX 13,10
	ld hl,053c8h		;bda4	21 c8 53 	! . S 
	call sub_b87bh		;bda7	cd 7b b8 	. { . 
	ld (053c7h),a		;bdaa	32 c7 53 	2 . S 
	call sub_bec1h		;bdad	cd c1 be 	. . . 
	ret			;bdb0	c9 	. 
lbdb1h:
	M_GOTO_YX 9,8
	ld c,(iy+005h)		;bdb6	fd 4e 05 	. N . 
lbdb9h:
	call NEXT_MACRO_OR_KEY		;bdb9	cd a7 17 	. . . 
	cp 00ah		;bdbc	fe 0a 	. . 
	jr z,lbdd4h		;bdbe	28 14 	( . 
	res 5,a		;bdc0	cb af 	. . 
	cp 046h		;bdc2	fe 46 	. F 
	jr z,lbdcah		;bdc4	28 04 	( . 
	cp 049h		;bdc6	fe 49 	. I 
	jr nz,lbdb9h		;bdc8	20 ef 	  . 
lbdcah:
	call OUT_CH		;bdca	cd 84 10 	. . . 
	ld c,a			;bdcd	4f 	O 
	call LEFT_INLINE		;bdce	cd 6c 15 	. l . 
	ld bc,0e518h		;bdd1	01 18 e5 	. . . 
lbdd4h:
	ld a,(iy+005h)		;bdd4	fd 7e 05 	. ~ . 
	cp c			;bdd7	b9 	. 
	ld (iy+005h),c		;bdd8	fd 71 05 	. q . 
	call nz,sub_bae5h		;bddb	c4 e5 ba 	. . . 
	M_GOTO_YX 10,8
lbde3h:
	call NEXT_MACRO_OR_KEY		;bde3	cd a7 17 	. . . 
	cp 00ah		;bde6	fe 0a 	. . 
	jr z,lbe00h		;bde8	28 16 	( . 
	res 5,a		;bdea	cb af 	. . 
	cp 049h		;bdec	fe 49 	. I 
	jr z,lbdf4h		;bdee	28 04 	( . 
	cp 044h		;bdf0	fe 44 	. D 
	jr nz,lbde3h		;bdf2	20 ef 	  . 
lbdf4h:
	ld (iy+006h),a		;bdf4	fd 77 06 	. w . 
	call OUT_CH		;bdf7	cd 84 10 	. . . 
	call LEFT_INLINE		;bdfa	cd 6c 15 	. l . 
	ld bc,0e318h		;bdfd	01 18 e3 	. . . 
lbe00h:
	call DOWN_INLINE		;be00	cd 68 15 	. h . 
	ld bc,0a7cdh		;be03	01 cd a7 	. . . 
	rla			;be06	17 	. 
	cp 00ah		;be07	fe 0a 	. . 
	jr z,lbe21h		;be09	28 16 	( . 
	cp 031h		;be0b	fe 31 	. 1 
	jr c,$-9		;be0d	38 f5 	8 . 
	cp 037h		;be0f	fe 37 	. 7 
	jr nc,$-13		;be11	30 f1 	0 . 
	call OUT_CH		;be13	cd 84 10 	. . . 
	and 007h		;be16	e6 07 	. . 
	ld (iy+007h),a		;be18	fd 77 07 	. w . 
	call LEFT_INLINE		;be1b	cd 6c 15 	. l . 
	ld bc,0e318h		;be1e	01 18 e3 	. . . 
lbe21h:
	call sub_bed4h		;be21	cd d4 be 	. . . 
	ret			;be24	c9 	. 
sub_be25h:
	M_GOTO_YX 24,1
	M_OUT_MSG 0xddea, 0x12 ; "STORE EVENT NUMBER"
	call RIGHT_INLINE		;be30	cd 70 15 	. p . 
	ld (bc),a			;be33	02 	. 
	M_OUT_VAR 0x5fa4, 0x03
	M_OUT_MSG 0xddd8, 0x07 ; "       "
	call LEFT_INLINE
	ex af,af'			;be43	08 	. 
lbe44h:
	M_SOMETHING1 v5fa4, 0x13
	ld a,003h		;be4a	3e 03 	> . 
	call SETMEMMAP		;be4c	cd 1a 0f 	. . . 
	ld hl,(05fa4h)		;be4f	2a a4 5f 	* . _ 
	ld a,(05cbah)		;be52	3a ba 5c 	: . \ 
	cp 005h		;be55	fe 05 	. . 
	jr nz,lbe76h		;be57	20 1d 	  . 
	ld (05cc3h),hl		;be59	22 c3 5c 	" . \ 
	ld hl,v53c2		;be5c	21 c2 53 	! . S 
	ld de,05cc6h		;be5f	11 c6 5c 	. . \ 
	ld bc,00020h		;be62	01 20 00 	.   . 
	ldir		;be65	ed b0 	. . 
	call sub_8b36h		;be67	cd 36 8b 	. 6 . 
	call sub_87d0h		;be6a	cd d0 87 	. . . 
	cp 0ffh		;be6d	fe ff 	. . 
	ret nz			;be6f	c0 	. 
lbe70h:
	M_SOMETHING2 0x03
	jr lbe44h		;be74	18 ce 	. . 
lbe76h:
	ld de,(05b79h)		;be76	ed 5b 79 5b 	. [ y [ 
	call CMP_HLDE		;be7a	cd 20 0f 	.   . 
	jr nc,lbe70h		;be7d	30 f1 	0 . 
	call sub_bf2fh		;be7f	cd 2f bf 	. / . 
	ld de,v53c2		;be82	11 c2 53 	. . S 
	ex de,hl			;be85	eb 	. 
	ld bc,00020h		;be86	01 20 00 	.   . 
	ldir		;be89	ed b0 	. . 
	ret			;be8b	c9 	. 
sub_be8ch:
	M_GOTO_YX 24,1
	M_OUT_MSG 0xddfc, 0x1e ; "      EVENT NUMBER      STORED"
	call LEFT_INLINE		;be97	cd 6c 15 	. l . 
	ld a,(bc)			;be9a	0a 	. 
	M_OUT_VAR 0x5fa4, 0x03
	M_GOTO_YX 1,8
	ret
lbea7h:
	call NEXT_MACRO_OR_KEY		;bea7	cd a7 17 	. . . 
	cp 00ah		;beaa	fe 0a 	. . 
	ret z			;beac	c8 	. 
	res 5,a		;bead	cb af 	. . 
	cp 059h		;beaf	fe 59 	. Y 
	jr z,lbeb7h		;beb1	28 04 	( . 
	cp 04eh		;beb3	fe 4e 	. N 
	jr nz,lbea7h		;beb5	20 f0 	  . 
lbeb7h:
	ld (hl),a			;beb7	77 	w 
	call OUT_CH		;beb8	cd 84 10 	. . . 
	call LEFT_INLINE		;bebb	cd 6c 15 	. l . 
	ld bc,0e618h		;bebe	01 18 e6 	. . . 
sub_bec1h:
	M_GOTO_YX 25,1
	ld a,' '
	ld b,32
	call OUT_CH_REPEAT
	ret
sub_beceh:
	add hl,hl			;bece	29 	) 
	add hl,hl			;becf	29 	) 
	add hl,hl			;bed0	29 	) 
	add hl,hl			;bed1	29 	) 
	add hl,hl			;bed2	29 	) 
	ret			;bed3	c9 	. 
sub_bed4h:
	M_GOTO_YX 16,11
	ld a,(iy+005h)		;bed9	fd 7e 05 	. ~ . 
	cp 'F'
	jr nz,lbf0ch		;bede	20 2c 	  , 
	push iy		;bee0	fd e5 	. . 
	ld iy,053cah		;bee2	fd 21 ca 53 	. ! . S 
	ld c,004h		;bee6	0e 04 	. . 
lbee8h:
	call sub_bef9h		;bee8	cd f9 be 	. . . 
	call DOWN_INLINE		;beeb	cd 68 15 	. h . 
	ld bc,06ccdh		;beee	01 cd 6c 	. . l 
	dec d			;bef1	15 	. 
	ld c,00dh		;bef2	0e 0d 	. . 
	jr nz,lbee8h		;bef4	20 f2 	  . 
	pop iy		;bef6	fd e1 	. . 
	ret			;bef8	c9 	. 
sub_bef9h:
	call sub_bf18h		;bef9	cd 18 bf 	. . . 
	call RIGHT_INLINE		;befc	cd 70 15 	. p . 
	rlca			;beff	07 	. 
	; Adrs is IY+4
	M_SOMETHING1 0x0004, 0x14
	ld de,6		;bf06	11 06 00 	. . . 
	add iy,de		;bf09	fd 19 	. . 
	ret			;bf0b	c9 	. 
lbf0ch:
	push iy		;bf0c	fd e5 	. . 
	ld iy,053cah		;bf0e	fd 21 ca 53 	. ! . S 
	call sub_bf18h		;bf12	cd 18 bf 	. . . 
	pop iy		;bf15	fd e1 	. . 
	ret			;bf17	c9 	. 
sub_bf18h:
	call sub_3cdfh		;bf18	cd df 3c 	. . < 
	call RIGHT_INLINE		;bf1b	cd 70 15 	. p . 
	rlca			;bf1e	07 	. 
	ex de,hl			;bf1f	eb 	. 
	call sub_3d11h		;bf20	cd 11 3d 	. . = 
	ret			;bf23	c9 	. 
sub_bf24h:
	ld a,020h		;bf24	3e 20 	>   
lbf26h:
	ld b,020h		;bf26	06 20 	.   
	call OUT_CH_REPEAT		;bf28	cd 7c 15 	. | . 
	dec c			;bf2b	0d 	. 
	jr nz,lbf26h		;bf2c	20 f8 	  . 
	ret			;bf2e	c9 	. 
sub_bf2fh:
	inc hl			;bf2f	23 	# 
	call sub_beceh		;bf30	cd ce be 	. . . 
	ld a,l			;bf33	7d 	} 
	cpl			;bf34	2f 	/ 
	ld l,a			;bf35	6f 	o 
	ld a,h			;bf36	7c 	| 
	cpl			;bf37	2f 	/ 
	ld h,a			;bf38	67 	g 
	inc hl			;bf39	23 	# 
	ret			;bf3a	c9 	. 

FUN_D2:
	ld hl,(05fa4h)		;bf3b	2a a4 5f 	* . _ 
	inc hl			;bf3e	23 	# 
	ld (05fa4h),hl		;bf3f	22 a4 5f 	" . _ 
	jp FUN_F2		;bf42	c3 61 b9 	. a . 

FUN_92:
	ld hl,(05fa4h)		;bf45	2a a4 5f 	* . _ 
	dec hl			;bf48	2b 	+ 
	ld (05fa4h),hl		;bf49	22 a4 5f 	" . _ 
	jp FUN_F2		;bf4c	c3 61 b9 	. a . 

	ds 0xc000-$, 0x00

	; ---------------------------------------
	;	16K ROM U22
	;   ORG : C000
	; ---------------------------------------

; Looks like initialisation to me
INIT:
	ld a,007h		;c000	3e 07 	> . 
	out (PORT_06),a		;c002	d3 06 	. . 
	out (PORT_07),a		;c004	d3 07 	. . 
	ld a,(CFG5)		;c006	3a 0c 00 	: . . 
	cp 0aah		;c009	fe aa 	. . 
	jr nz,lc017h		;c00b	20 0a 	  . 
	ld a,0cfh		;c00d	3e cf 	> . 
	out (PORT_06),a		;c00f	d3 06 	. . 
	ld a,000h		;c011	3e 00 	> . 
	out (PORT_06),a		;c013	d3 06 	. . 
	jr lc01fh		;c015	18 08 	. . 
lc017h:
	ld a,0cfh		;c017	3e cf 	> . 
	out (PORT_06),a		;c019	d3 06 	. . 
	ld a,0ffh		;c01b	3e ff 	> . 
	out (PORT_06),a		;c01d	d3 06 	. . 
lc01fh:
	ld a,0xcf
	out (PORT_07),a
	ld a,0xf0
	out (PORT_07),a

	im 2			; Interrupt mode 2
	xor a			;
	ld i,a			; I = 0, so CPU jumps to address stored at (0x0000+databus)

	ld a,0x97
	out (PORT_07),a
	ld a,0x7f
	out (PORT_07),a
	ld a,0x10
	out (PORT_07),a
	ld a,(053bdh)
	ld (5),a				; ??? Makes no sense, bug?

		; Init keyboard
	ld b,4
	ld c,PORT_DATAKBD_CMD
	ld hl,KEYBOARD_INIT
	otir
	ld b,8 
	ld hl,KEYBOARD_INIT2
	otir

		; Init serial port
	ld c,PORT_SERIAL_CMD 
	ld b,8 
	ld hl,PORT_SERIAL_INIT 
	otir

		; Init port 13
	ld b,4 
	ld c,0x13 
	ld hl,PORT13_INIT
	otir

		; Different init sequences for port 8
	ld b,8
	ld hl,PORT13_INIT2A 
	ld a,(CFG9) 
	cp 0xff 
	jr z,_init 
	ld hl,PORT13_INIT2B 
	cp 0xaa 
	jr z,_init
	ld hl,PORT13_INIT2C 
	ld a,(CFG8) 
	bit 1,a 
	jr z,_init
	ld hl,PORT13_INIT2D 
_init:
	otir

	ld c,PORT_12 
	ld b,8
	ld hl,PORT_12_INITA
	ld a,(CFG12)
	cp 0xaa
	jr nz,lc093h
	ld hl,PORT_12_INITB
lc093h:
	otir
; FReD continue parsing init data

		;	Init PORT 17
	ld b,4 
	ld c,PORT_17
	ld hl,PORT_17_INIT
	otir


	ld hl,PORT13_INIT2C		; Wrong name
	ld b,8
	ld a,(CFG8)
	bit 1,a
	jr z,lc0adh
	ld hl,PORT13_INIT2D
lc0adh:
	ld a,(CFG13)
	cp 0xaa
	jr z,lc0c1h
	ld hl,PORT_17_INIT2
	ld a,(0558bh)
	cp 041h
	jr z,lc0c1h
	ld hl,PORT_17_INIT3
lc0c1h:
	otir
	ld a,(05cbah)
	cp 0
	ret nz
	ld c,PORT_16
	ld b,8
	ld hl,PORT_16_INIT
	otir
	ret

; Special case PORT13 Initialisation data
PORT13_INIT2D:
	db 0x04, 0x84, 0x05, 0x60, 0x03, 0x81, 0x01, 0x1c

sub_c0dbh:
	push bc
	ld c,h			;c0dc	4c 	L 
	ld a,l			;c0dd	7d 	} 
	call sub_c0e5h		;c0de	cd e5 c0 	. . . 
	ld d,c			;c0e1	51 	Q 
	ld e,a			;c0e2	5f 	_ 
	pop bc			;c0e3	c1 	. 
	ret			;c0e4	c9 	. 
sub_c0e5h:
	ld b,00fh		;c0e5	06 0f 	. . 
	ld hl,0		;c0e7	21 00 00 	! . . 
	sla a		;c0ea	cb 27 	. ' 
	rl c		;c0ec	cb 11 	. . 
lc0eeh:
	jr nc,lc0f6h		;c0ee	30 06 	0 . 
	add hl,de			;c0f0	19 	. 
	adc a,000h		;c0f1	ce 00 	. . 
	jr nc,lc0f6h		;c0f3	30 01 	0 . 
	inc c			;c0f5	0c 	. 
lc0f6h:
	add hl,hl			;c0f6	29 	) 
	rla			;c0f7	17 	. 
	rl c		;c0f8	cb 11 	. . 
	djnz lc0eeh		;c0fa	10 f2 	. . 
	ret nc			;c0fc	d0 	. 
	add hl,de			;c0fd	19 	. 
	adc a,000h		;c0fe	ce 00 	. . 
	ret nc			;c100	d0 	. 
	inc c			;c101	0c 	. 
	ret			;c102	c9 	. 

; Some kind of key handling routine
sub_c103h:
	and %00011111
	cp 0x1b					; ESC (?)
	call z,_shifton		; Yes, set bit 0 to 1
	cp 01fh					; DEL (?) [this looks more like some sort of mode shift to me]
							; Maybe graphics, manual page 3-79 ?
	call z,_shiftoff		; Clear bit 0
	bit 0,(hl)				; 
	jr z,_lookup				; No shift mode 
	set 5,a					; Apply shift mode
_lookup:
	ld hl,KEYTABLE2			; Second keytable 
	ld d,0 
	ld e,a
	add hl,de				; Offset to char
	ld a,(hl)				; Get char
	ret						; Done
_shifton:
	set 0,(hl)				; Shift mode on 
	ret
_shiftoff:
	res 0,(hl)				; Shift mode off
	ret

KEYTABLE2:
	; Two 32 char tables, usage unknown
	db " E\nA SIU\rDRJNFCKTZLWHYPQOBG"
	db 0x1c
	db "MXV"
	db 0x1f ; End of table marker?
	;	+32 (set 5,a of 0xc113)
	db " 3\n- ", 0x07, "87\r"
	db "$4',!:(5", 0x22, ")2 6019?&", 0x1c, "./;"
	db 0x1f ; End of table marker?
	; End of table

sub_c164h:
	ld b,00ch		;c164	06 0c 	. . 
lc166h:
	add ix,ix		;c166	dd 29 	. ) 
	rla			;c168	17 	. 
	jr c,lc176h		;c169	38 0b 	8 . 
lc16bh:
	add ix,ix		;c16b	dd 29 	. ) 
	rla			;c16d	17 	. 
	jr c,lc180h		;c16e	38 10 	8 . 
	djnz lc166h		;c170	10 f4 	. . 
	ld de,0		;c172	11 00 00 	. . . 
	ret			;c175	c9 	. 
lc176h:
	ld hl,00001h		;c176	21 01 00 	! . . 
lc179h:
	add ix,ix		;c179	dd 29 	. ) 
	rla			;c17b	17 	. 
	rl l		;c17c	cb 15 	. . 
	jr lc183h		;c17e	18 03 	. . 
lc180h:
	ld hl,00001h		;c180	21 01 00 	! . . 
lc183h:
	ld de,00001h		;c183	11 01 00 	. . . 
	dec b			;c186	05 	. 
	ret z			;c187	c8 	. 
	or a			;c188	b7 	. 
	sbc hl,de		;c189	ed 52 	. R 
lc18bh:
	add ix,ix		;c18b	dd 29 	. ) 
lc18dh:
	rla			;c18d	17 	. 
	adc hl,hl		;c18e	ed 6a 	. j 
lc190h:
	add ix,ix		;c190	dd 29 	. ) 
	rla			;c192	17 	. 
	adc hl,hl		;c193	ed 6a 	. j 
	sla e		;c195	cb 23 	. # 
	rl d		;c197	cb 12 	. . 
	push de			;c199	d5 	. 
	sla e		;c19a	cb 23 	. # 
	rl d		;c19c	cb 12 	. . 
	inc e			;c19e	1c 	. 
	or a			;c19f	b7 	. 
	sbc hl,de		;c1a0	ed 52 	. R 
	jp nc,lc1aah		;c1a2	d2 aa c1 	. . . 
	add hl,de			;c1a5	19 	. 
	pop de			;c1a6	d1 	. 
	jp lc1ach		;c1a7	c3 ac c1 	. . . 
lc1aah:
	pop de			;c1aa	d1 	. 
	inc e			;c1ab	1c 	. 
lc1ach:
	djnz lc18bh		;c1ac	10 dd 	. . 
	ret			;c1ae	c9 	. 
sub_c1afh:
	ld de,5		;c1af	11 05 00 	. . . 
	ld a,(05fd0h)		;c1b2	3a d0 5f 	: . _ 
	ld c,a			;c1b5	4f 	O 
	ld a,(05fd1h)		;c1b6	3a d1 5f 	: . _ 
	call sub_c0e5h		;c1b9	cd e5 c0 	. . . 
	ld l,h			;c1bc	6c 	l 
	ld h,a			;c1bd	67 	g 
	push hl			;c1be	e5 	. 
	ld hl,(05fd1h)		;c1bf	2a d1 5f 	* . _ 
	ld a,l			;c1c2	7d 	} 
	ld l,h			;c1c3	6c 	l 
	ld h,a			;c1c4	67 	g 
	push hl			;c1c5	e5 	. 
	pop ix		;c1c6	dd e1 	. . 
	ld a,(05fd0h)		;c1c8	3a d0 5f 	: . _ 
	call sub_c164h		;c1cb	cd 64 c1 	. d . 
	ld c,000h		;c1ce	0e 00 	. . 
	ld a,04dh		;c1d0	3e 4d 	> M 
	call sub_c0e5h		;c1d2	cd e5 c0 	. . . 
	ld l,h			;c1d5	6c 	l 
	ld h,a			;c1d6	67 	g 
	ld de,00077h		;c1d7	11 77 00 	. w . 
	add hl,de			;c1da	19 	. 
	pop de			;c1db	d1 	. 
	or a			;c1dc	b7 	. 
	sbc hl,de		;c1dd	ed 52 	. R 
	push hl			;c1df	e5 	. 
	ld hl,05800h		;c1e0	21 00 58 	! . X 
	ld a,(LAST_TEMP)		;c1e3	3a db 55 	: . U 
	ld d,a			;c1e6	57 	W 
	ld e,000h		;c1e7	1e 00 	. . 
	or a			;c1e9	b7 	. 
	sbc hl,de		;c1ea	ed 52 	. R 
	ld c,h			;c1ec	4c 	L 
	ld a,l			;c1ed	7d 	} 
	pop de			;c1ee	d1 	. 
	call sub_c0e5h		;c1ef	cd e5 c0 	. . . 
	ld d,a			;c1f2	57 	W 
	ld e,h			;c1f3	5c 	\ 
	ld hl,02100h		;c1f4	21 00 21 	! . ! 
	or a			;c1f7	b7 	. 
	sbc hl,de		;c1f8	ed 52 	. R 
	ret			;c1fa	c9 	.
 
; Multiplies HL by 10
MUL_HL_10:
	push de
	ld d,h
	ld e,l
	add hl,hl
	add hl,hl
	add hl,de
	add hl,hl
	pop de
	ret

; Multiplies HL by 18
MUL_HL_18:
	push de
	ld d,h 
	ld e,l 
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,de
	add hl,hl
	pop de
	ret

; Multiplies HL by 87
MUL_HL_87:
	push de
	ld d,h 
	ld e,l 
	add hl,hl			; *2 
	add hl,hl			; *4 
	add hl,de			; *5 
	add hl,hl			; *10 
	add hl,hl			; *20 
	add hl,de			; *21 
	add hl,hl			; *42 
	add hl,de			; *43 
	add hl,hl			; *86 
	add hl,de			; *87 
	pop de
	ret 

sub_c21dh:
	ld a,(CFG7)		;c21d	3a 3c 00 	: < . 
	cp 0bbh		;c220	fe bb 	. . 
	jr nz,$+13		;c222	20 0b 	  . 
	M_GOTO_YX 25,1
	M_OUT_MSG 0xc443, 0x1b ; "CTRL-S = DISCONNECT BATTERY"
	ld a,0x98
	ld (04f76h),a		;c231	32 76 4f 	2 v O 
	M_GOTO_YX 3,1
	M_OUT_MSG 0xc3a4, 0x3a ; 0F "CHANNEL NAME" CRLF CRLF "REGION   DISPLAY LINES" CRLF "NUMBER    PER REGION"
	M_GOTO_YX 3,15
	M_OUT_MSG v53c2, 0x02 ; *** RAM data ***
	M_GOTO_YX 6,1
	ld iy,053c4h		;c24f	fd 21 c4 53 	. ! . S 
	ld b,000h		;c253	06 00 	. . 
lc255h:
	inc b			;c255	04 	. 
	M_OUT_CH CRLF
	call RIGHT_INLINE		;c25a	cd 70 15 	. p . 
	db 0x03
	ld a,b			;c25e	78 	x 
	or 030h		;c25f	f6 30 	. 0 
	call OUT_CH		;c261	cd 84 10 	. . . 
	call RIGHT_INLINE		;c264	cd 70 15 	. p . 
	ld a,(bc)			;c267	0a 	. 
	M_OUT_VAR 0x0000, 0x42
	inc iy		;c26e	fd 23 	. # 
	push bc			;c270	c5 	. 
	ld c,a			;c271	4f 	O 
	ld a,006h		;c272	3e 06 	> . 
	push de			;c274	d5 	. 
	ld d,b			;c275	50 	P 
	ld b,a			;c276	47 	G 
	ld a,d			;c277	7a 	z 
	pop de			;c278	d1 	. 
	sub b			;c279	90 	. 
	ld a,c			;c27a	79 	y 
	pop bc			;c27b	c1 	. 
	jp nz,lc255h		;c27c	c2 55 c2 	. U . 
	M_OUT_MSG 0xc416, 0x2d ; CRLF CRLF "SEQUENCE FROM" CRLF "     EXTERNAL DEVICE?  (Y/N) "
	call sub_c2b1h		;c285	cd b1 c2 	. . . 
	M_OUT_MSG 0xc3f1, 0x14 ; CRLF CRLF "NUMBER OF EVENTS  "
	M_OUT_VAR 0x53cc, 0x04
	M_OUT_MSG 0xc405, 0x0a ; "  MAX 512" CRLF 
	call RIGHT_INLINE
	jr 0xc26c		;c29d	18 cd 	. . 
	ret z			;c29f	c8 	. 
	inc de			;c2a0	13 	. 
	rrca			;c2a1	0f 	. 
	call nz,0xcd07		;c2a2	c4 07 cd 	. . . 
	ret z			;c2a5	c8 	. 
	inc de			;c2a6	13 	. 
	sbc a,0c3h		;c2a7	de c3 	. . 
	inc de			;c2a9	13 	. 
	M_OUT_VAR 0x53ca, 0x04
	ret			;c2b0	c9 	. 
sub_c2b1h:
	M_GOTO_YX 15,30
	M_OUT_MSG 0x53d7, 0x01 ; *** RAM data ***
	call LEFT_INLINE
	db 0x01
	ret
sub_c2c1h:
	ld hl,0
	ld (053d8h),hl		;c2c4	22 d8 53 	" . S 
	call sub_c2b1h		;c2c7	cd b1 c2 	. . . 
	ld b,080h		;c2ca	06 80 	. . 
	ld hl,053d7h		;c2cc	21 d7 53 	! . S 
	call sub_3ae0h		;c2cf	cd e0 3a 	. . : 
	ld a,(hl)			;c2d2	7e 	~ 
	ld (hl),0d9h		;c2d3	36 d9 	6 . 
	and 080h		;c2d5	e6 80 	. . 
	jr nz,lc2dbh		;c2d7	20 02 	  . 
	ld (hl),04eh		;c2d9	36 4e 	6 N 
lc2dbh:
	ld hl,(053cch)		;c2db	2a cc 53 	* . S 
	ld (05426h),hl		;c2de	22 26 54 	" & T 
	M_GOTO_YX 17,22
	ld a,(053d7h)
	cp 'N'
	jr nz,lc2f5h		;c2eb	20 08 	  . 
	M_SOMETHING1 v53cc, 0x14
	jr lc308h		;c2f3	18 13 	. . 
lc2f5h:
	ld hl,00200h		;c2f5	21 00 02 	! . . 
	ld (053cch),hl		;c2f8	22 cc 53 	" . S 
	push hl			;c2fb	e5 	. 
	M_GOTO_YX 17,19
	call 0x1431
	db 0xcc, 0x53, 0x04
	pop hl			;c307	e1 	. 
lc308h:
	ld de,00201h		;c308	11 01 02 	. . . 
	call CMP_HLDE		;c30b	cd 20 0f 	.   . 
	jr c,lc316h		;c30e	38 06 	8 . 
	M_SOMETHING2 0x04
	jr $-46		;c314	18 d0 	. . 
lc316h:
	ld de,00010h		;c316	11 10 00 	. . . 
	call CMP_HLDE		;c319	cd 20 0f 	.   . 
	jr nc,lc324h		;c31c	30 06 	0 . 
	M_SOMETHING2 0x04
	jr $-60		;c322	18 c2 	. . 
lc324h:
	ld a,(053d7h)		;c324	3a d7 53 	: . S 
	ld b,a			;c327	47 	G 
	ld a,(053dah)		;c328	3a da 53 	: . S 
	ld de,(053cch)		;c32b	ed 5b cc 53 	. [ . S 
	call sub_c357h		;c32f	cd 57 c3 	. W . 
	ld (053d8h),hl		;c332	22 d8 53 	" . S 
	ld (053cah),hl		;c335	22 ca 53 	" . S 
	ld (053cch),de		;c338	ed 53 cc 53 	. S . S 
	M_GOTO_YX 19,19
	M_OUT_VAR 0x53ca, 0x04
	ld hl,(053cch)		;c347	2a cc 53 	* . S 
	ld de,(05426h)		;c34a	ed 5b 26 54 	. [ & T 
	call CMP_HLDE		;c34e	cd 20 0f 	.   . 
	jr nz,lc2dbh		;c351	20 88 	  . 
	ld hl,(053cah)		;c353	2a ca 53 	* . S 
	ret			;c356	c9 	. 
sub_c357h:
	push de			;c357	d5 	. 
	ld hl,0002ch		;c358	21 2c 00 	! , . 
	ld d,000h		;c35b	16 00 	. . 
	ld e,a			;c35d	5f 	_ 
	call sub_c0dbh		;c35e	cd db c0 	. . . 
	ld de,015h		;c361	11 15 00 	. . . 
	add hl,de			;c364	19 	. 
	dec hl			;c365	2b 	+ 
	pop de			;c366	d1 	. 
	ld a,(053d7h)		;c367	3a d7 53 	: . S 
sub_c36ah:
	push hl			;c36a	e5 	. 
	ex de,hl			;c36b	eb 	. 
	rla			;c36c	17 	. 
	jr nc,lc37ah		;c36d	30 0b 	0 . 
	pop hl			;c36f	e1 	. 
	ld de,00040h		;c370	11 40 00 	. @ . 
	xor a			;c373	af 	. 
	sbc hl,de		;c374	ed 52 	. R 
	push hl			;c376	e5 	. 
	ld hl,00200h		;c377	21 00 02 	! . . 
lc37ah:
	ld de,00201h		;c37a	11 01 02 	. . . 
	call CMP_HLDE		;c37d	cd 20 0f 	.   . 
	jr c,lc385h		;c380	38 03 	8 . 
	ld hl,00200h		;c382	21 00 02 	! . . 
lc385h:
	ld de,00010h		;c385	11 10 00 	. . . 
	call CMP_HLDE		;c388	cd 20 0f 	.   . 
	jr nc,lc390h		;c38b	30 03 	0 . 
	ld hl,00010h		;c38d	21 10 00 	! . . 
lc390h:
	pop de			;c390	d1 	. 
	push hl			;c391	e5 	. 
	push de			;c392	d5 	. 
	add hl,hl			;c393	29 	) 
	add hl,hl			;c394	29 	) 
	add hl,hl			;c395	29 	) 
	ld d,05ch		;c396	16 5c 	. \ 
	call sub_071fh		;c398	cd 1f 07 	. . . 
	pop hl			;c39b	e1 	. 
	ld d,000h		;c39c	16 00 	. . 
	ld e,a			;c39e	5f 	_ 
	xor a			;c39f	af 	. 
	sbc hl,de		;c3a0	ed 52 	. R 
	pop de			;c3a2	d1 	. 
	ret			;c3a3	c9 	. 

	db                         0x0f, 0x43, 0x48, 0x41   ; c3a4 :     .CHA
	db 0x4e, 0x4e, 0x45, 0x4c, 0x20, 0x4e, 0x41, 0x4d   ; c3a8 : NNEL NAM
	db 0x45, 0x05, 0x05, 0x52, 0x45, 0x47, 0x49, 0x4f   ; c3b0 : E..REGIO
	db 0x4e, 0x20, 0x20, 0x20, 0x44, 0x49, 0x53, 0x50   ; c3b8 : N   DISP
	db 0x4c, 0x41, 0x59, 0x20, 0x4c, 0x49, 0x4e, 0x45   ; c3c0 : LAY LINE
	db 0x53, 0x05, 0x4e, 0x55, 0x4d, 0x42, 0x45, 0x52   ; c3c8 : S.NUMBER
	db 0x20, 0x20, 0x20, 0x20, 0x50, 0x45, 0x52, 0x20   ; c3d0 :     PER 
	db 0x52, 0x45, 0x47, 0x49, 0x4f, 0x4e, 0x05, 0x4e   ; c3d8 : REGION.N
	db 0x55, 0x4d, 0x42, 0x45, 0x52, 0x20, 0x4f, 0x46   ; c3e0 : UMBER OF
	db 0x20, 0x50, 0x41, 0x47, 0x45, 0x53, 0x20, 0x20   ; c3e8 :  PAGES  
	db 0x20, 0x05, 0x05, 0x4e, 0x55, 0x4d, 0x42, 0x45   ; c3f0 :  ..NUMBE
	db 0x52, 0x20, 0x4f, 0x46, 0x20, 0x45, 0x56, 0x45   ; c3f8 : R OF EVE
	db 0x4e, 0x54, 0x53, 0x20, 0x20, 0x20, 0x20, 0x4d   ; c400 : NTS    M
	db 0x41, 0x58, 0x20, 0x35, 0x31, 0x32, 0x05, 0x4d   ; c408 : AX 512.M
	db 0x49, 0x4e, 0x20, 0x20, 0x31, 0x36, 0x05, 0x05   ; c410 : IN  16..
	db 0x53, 0x45, 0x51, 0x55, 0x45, 0x4e, 0x43, 0x45   ; c418 : SEQUENCE
	db 0x20, 0x46, 0x52, 0x4f, 0x4d, 0x05, 0x20, 0x20   ; c420 :  FROM.  
	db 0x20, 0x20, 0x20, 0x45, 0x58, 0x54, 0x45, 0x52   ; c428 :    EXTER
	db 0x4e, 0x41, 0x4c, 0x20, 0x44, 0x45, 0x56, 0x49   ; c430 : NAL DEVI
	db 0x43, 0x45, 0x3f, 0x20, 0x20, 0x28, 0x59, 0x2f   ; c438 : CE?  (Y/
	db 0x4e, 0x29, 0x20, 0x43, 0x54, 0x52, 0x4c, 0x2d   ; c440 : N) CTRL-
	db 0x53, 0x20, 0x3d, 0x20, 0x44, 0x49, 0x53, 0x43   ; c448 : S = DISC
	db 0x4f, 0x4e, 0x4e, 0x45, 0x43, 0x54, 0x20, 0x42   ; c450 : ONNECT B
	db 0x41, 0x54, 0x54, 0x45, 0x52, 0x59               ; c458 : ATTERY

sub_c45eh:
	ld a,(CFG7)		;c45e	3a 3c 00 	: < . 
	cp 0bbh		;c461	fe bb 	. . 
	jp z,lc755h		;c463	ca 55 c7 	. U . 
	in a,(PORT_20)		;c466	db 20 	.   
lc468h:
	ld a,00fh		;c468	3e 0f 	> . 
	out (PORT_20),a		;c46a	d3 20 	.   
	ld a,000h		;c46c	3e 00 	> . 
	out (PORT_2F),a		;c46e	d3 2f 	. / 
	ld a,005h		;c470	3e 05 	> . 
	out (PORT_20),a		;c472	d3 20 	.   
	ld a,058h		;c474	3e 58 	> X 
	out (PORT_2E),a		;c476	d3 2e 	. . 
	xor a			;c478	af 	. 
lc479h:
	in a,(PORT_2E)		;c479	db 2e 	. . 
	cp 058h		;c47b	fe 58 	. X 
	jr z,lc499h		;c47d	28 1a 	( . 
	ld a,008h		;c47f	3e 08 	> . 
	out (PORT_2C),a		;c481	d3 2c 	. , 
	ld a,008h		;c483	3e 08 	> . 
	out (PORT_2D),a		;c485	d3 2d 	. - 
lc487h:
	in a,(PORT_2C)		;c487	db 2c 	. , 
	and 00fh		;c489	e6 0f 	. . 
	cp 008h		;c48b	fe 08 	. . 
	jp nz,lc499h		;c48d	c2 99 c4 	. . . 
	in a,(PORT_2D)		;c490	db 2d 	. - 
	and 00fh		;c492	e6 0f 	. . 
	cp 008h		;c494	fe 08 	. . 
	jp z,lc49fh		;c496	ca 9f c4 	. . . 
lc499h:
	ld a,000h		;c499	3e 00 	> . 
	ld (05b9fh),a		;c49b	32 9f 5b 	2 . [ 
	ret			;c49e	c9 	. 
lc49fh:
	ld a,001h		;c49f	3e 01 	> . 
	out (PORT_20),a		;c4a1	d3 20 	.   
	ld a,005h		;c4a3	3e 05 	> . 
	ld (05b9fh),a		;c4a5	32 9f 5b 	2 . [ 
	ret			;c4a8	c9 	. 

sub_c4a9h:
	ld a,(CFG7)		;c4a9	3a 3c 00 	: < . 
	cp 0bbh		;c4ac	fe bb 	. . 
	jp z,lc79ah		;c4ae	ca 9a c7 	. . . 
	ld d,3
_loop:
	ld c,PORT_20
	ld hl,05ba0h
	ld b,14
	in a,(c)
	inc c
	inc c
_loop_port:
	in a,(c)		; 22, 23, 24, ... 2E, 2F
	and %00001111
	ld (hl),a
	inc c
	inc hl
	djnz _loop_port
	in a,(PORT_20)
	bit 3,a
	jp z,_done
	dec d
	jp z,_loop
_done:
	call sub_c4d6h
	ret

sub_c4d6h:
	ld a,(CFG7)		;c4d6	3a 3c 00 	: < . 
	cp 0bbh		;c4d9	fe bb 	. . 
	jp z,lc7c3h		;c4db	ca c3 c7 	. . . 
	ld b,006h		;c4de	06 06 	. . 
	ld hl,05ba0h		;c4e0	21 a0 5b 	! . [ 
lc4e3h:
	ld a,(hl)			;c4e3	7e 	~ 
	inc hl			;c4e4	23 	# 
	ld c,(hl)			;c4e5	4e 	N 
	dec c			;c4e6	0d 	. 
	inc c			;c4e7	0c 	. 
	jp z,lc4f1h		;c4e8	ca f1 c4 	. . . 
lc4ebh:
	add a,00ah		;c4eb	c6 0a 	. . 
	dec c			;c4ed	0d 	. 
	jp nz,lc4ebh		;c4ee	c2 eb c4 	. . . 
lc4f1h:
	ld (hl),a			;c4f1	77 	w 
	inc hl			;c4f2	23 	# 
	djnz lc4e3h		;c4f3	10 ee 	. . 
	ld a,(05bach)		;c4f5	3a ac 5b 	: . [ 
	dec a			;c4f8	3d 	= 
	cp 007h		;c4f9	fe 07 	. . 
	jr nc,lc551h		;c4fb	30 54 	0 T 
	ld (05ba0h),a		;c4fd	32 a0 5b 	2 . [ 
	ld a,(05ba1h)		;c500	3a a1 5b 	: . [ 
	cp 03ch		;c503	fe 3c 	. < 
	jr nc,lc551h		;c505	30 4a 	0 J 
	ld (05ba6h),a		;c507	32 a6 5b 	2 . [ 
	ld a,(05ba9h)		;c50a	3a a9 5b 	: . [ 
	dec a			;c50d	3d 	= 
	cp 00ch		;c50e	fe 0c 	. . 
	jr nc,lc551h		;c510	30 3f 	0 ? 
	ld (05ba1h),a		;c512	32 a1 5b 	2 . [ 
	ld a,(05ba7h)		;c515	3a a7 5b 	: . [ 
	dec a			;c518	3d 	= 
	cp 01fh		;c519	fe 1f 	. . 
	jr nc,lc551h		;c51b	30 34 	0 4 
	ld (05ba2h),a		;c51d	32 a2 5b 	2 . [ 
	ld a,(05ba5h)		;c520	3a a5 5b 	: . [ 
	dec a			;c523	3d 	= 
	cp 00ch		;c524	fe 0c 	. . 
	jr nc,lc551h		;c526	30 29 	0 ) 
	inc a			;c528	3c 	< 
	cp 00ch		;c529	fe 0c 	. . 
	jr nz,lc52fh		;c52b	20 02 	  . 
	ld a,000h		;c52d	3e 00 	> . 
lc52fh:
	ld (05ba4h),a		;c52f	32 a4 5b 	2 . [ 
	ld a,(05ba3h)		;c532	3a a3 5b 	: . [ 
	cp 03ch		;c535	fe 3c 	. < 
	jr nc,lc551h		;c537	30 18 	0 . 
	ld (05ba5h),a		;c539	32 a5 5b 	2 . [ 
	ld a,(05babh)		;c53c	3a ab 5b 	: . [ 
	cp 064h		;c53f	fe 64 	. d 
	jr nc,lc551h		;c541	30 0e 	0 . 
	ld (05ba3h),a		;c543	32 a3 5b 	2 . [ 
	ld a,(05badh)		;c546	3a ad 5b 	: . [ 
	and 002h		;c549	e6 02 	. . 
	rrca			;c54b	0f 	. 
	ld (05ba7h),a		;c54c	32 a7 5b 	2 . [ 
	xor a			;c54f	af 	. 
	ret			;c550	c9 	. 
lc551h:
	ld a,0ffh		;c551	3e ff 	> . 
	ret			;c553	c9 	. 

sub_c554h:
	ld a,(05b9fh)
	or a
	ret z
	call sub_c4a9h
	ld bc,8
	ld hl,05ba0h
	ld de,05b93h
	or a
	ret nz
	push hl
	ldir			; memcpy( 0x5b93, 0x5ba0, 8 )
	pop de
	ret

sub_c56ch:
	ld a,(CFG7)		;c56c	3a 3c 00 	: < . 
	cp 0bbh		;c56f	fe bb 	. . 
	jp z,lc80eh		;c571	ca 0e c8 	. . . 
	ld hl,05b93h		;c574	21 93 5b 	! . [ 
	ld a,(hl)			;c577	7e 	~ 
	inc a			;c578	3c 	< 
	ld (05bach),a		;c579	32 ac 5b 	2 . [ 
	inc hl			;c57c	23 	# 
	ld a,(hl)			;c57d	7e 	~ 
	inc a			;c57e	3c 	< 
	ld (05ba9h),a		;c57f	32 a9 5b 	2 . [ 
	inc hl			;c582	23 	# 
	ld a,(hl)			;c583	7e 	~ 
	inc a			;c584	3c 	< 
	ld (05ba7h),a		;c585	32 a7 5b 	2 . [ 
	inc hl			;c588	23 	# 
	ld a,(hl)			;c589	7e 	~ 
	ld (05babh),a		;c58a	32 ab 5b 	2 . [ 
	rla			;c58d	17 	. 
	rla			;c58e	17 	. 
	and 00ch		;c58f	e6 0c 	. . 
	ld b,a			;c591	47 	G 
	inc hl			;c592	23 	# 
	ld a,(hl)			;c593	7e 	~ 
	cp 000h		;c594	fe 00 	. . 
	jp nz,lc59bh		;c596	c2 9b c5 	. . . 
	ld a,00ch		;c599	3e 0c 	> . 
lc59bh:
	ld (05ba5h),a		;c59b	32 a5 5b 	2 . [ 
	inc hl			;c59e	23 	# 
	ld a,(hl)			;c59f	7e 	~ 
	ld (05ba3h),a		;c5a0	32 a3 5b 	2 . [ 
	inc hl			;c5a3	23 	# 
	ld a,(hl)			;c5a4	7e 	~ 
	ld (05ba1h),a		;c5a5	32 a1 5b 	2 . [ 
	inc hl			;c5a8	23 	# 
	ld a,(hl)			;c5a9	7e 	~ 
	cp 000h		;c5aa	fe 00 	. . 
	jr z,lc5b0h		;c5ac	28 02 	( . 
	ld a,002h		;c5ae	3e 02 	> . 
lc5b0h:
	or b			;c5b0	b0 	. 
	ld (05badh),a		;c5b1	32 ad 5b 	2 . [ 
	ld b,006h		;c5b4	06 06 	. . 
	ld hl,05babh		;c5b6	21 ab 5b 	! . [ 
lc5b9h:
	ld a,(hl)			;c5b9	7e 	~ 
	ld c,000h		;c5ba	0e 00 	. . 
lc5bch:
	ld d,a			;c5bc	57 	W 
	sub 00ah		;c5bd	d6 0a 	. . 
	jr c,lc5c4h		;c5bf	38 03 	8 . 
	inc c			;c5c1	0c 	. 
	jr lc5bch		;c5c2	18 f8 	. . 
lc5c4h:
	ld (hl),c			;c5c4	71 	q 
	dec hl			;c5c5	2b 	+ 
	ld (hl),d			;c5c6	72 	r 
	dec hl			;c5c7	2b 	+ 
	djnz lc5b9h		;c5c8	10 ef 	. . 
	ret			;c5ca	c9 	. 
sub_c5cbh:
	ld a,(CFG7)		;c5cb	3a 3c 00 	: < . 
	cp 0bbh		;c5ce	fe bb 	. . 
	jp z,lc847h		;c5d0	ca 47 c8 	. G . 
	call sub_c45eh		;c5d3	cd 5e c4 	. ^ . 
	cp 000h		;c5d6	fe 00 	. . 
	ret z			;c5d8	c8 	. 
	call sub_c56ch		;c5d9	cd 6c c5 	. l . 
	ld a,00fh		;c5dc	3e 0f 	> . 
	out (PORT_20),a		;c5de	d3 20 	.   
	ld a,000h		;c5e0	3e 00 	> . 
	out (PORT_2F),a		;c5e2	d3 2f 	. / 
	ld a,005h		;c5e4	3e 05 	> . 
	out (PORT_20),a		;c5e6	d3 20 	.   
	ld a,000h		;c5e8	3e 00 	> . 
	out (PORT_2F),a		;c5ea	d3 2f 	. / 
	ld c,022h		;c5ec	0e 22 	. " 
	ld hl,05ba0h		;c5ee	21 a0 5b 	! . [ 
	ld b,00eh		;c5f1	06 0e 	. . 
xxx
lc5f3h:
	ld a,(hl)			;c5f3	7e 	~ 
	out (c),a		;c5f4	ed 79 	. y 
	inc c			;c5f6	0c 	. 
	inc hl			;c5f7	23 	# 
	djnz lc5f3h		;c5f8	10 f9 	. . 
	ld a,001h		;c5fa	3e 01 	> . 
	out (PORT_20),a		;c5fc	d3 20 	.   
	ld a,003h		;c5fe	3e 03 	> . 
	out (PORT_20),a		;c600	d3 20 	.   
	ld a,00bh		;c602	3e 0b 	> . 
	out (PORT_2F),a		;c604	d3 2f 	. / 
	ld a,000h		;c606	3e 00 	> . 
	out (PORT_20),a		;c608	d3 20 	.   
	ret			;c60a	c9 	. 
sub_c60bh:
	ld a,(CFG4_LANG) 
	cp LANG_DE 
	ld hl,TIME_LABEL_EN		;c610	21 0a c7 	! . . 
	push hl			;c613	e5 	. 
	ld hl,MONTH_EN		;c614	21 e6 c6 	! . . 
	push hl			;c617	e5 	. 
	ld a,(bc)			;c618	0a 	. 
	ld hl,WEEKDAY_EN		;c619	21 d1 c6 	! . . 
	jr nz,lc62bh		;c61c	20 0d 	  . 
	pop hl			;c61e	e1 	. 
	pop hl			;c61f	e1 	. 
	ld hl,TIME_LABEL_DE		;c620	21 4c c7 	! L . 
	push hl			;c623	e5 	. 
	ld hl,MONTH_DE		;c624	21 28 c7 	! ( . 
	push hl			;c627	e5 	. 
	ld hl,WEEKDAY_DE		;c628	21 13 c7 	! . . 
lc62bh:
	call sub_c6a1h		;c62b	cd a1 c6 	. . . 
	inc bc			;c62e	03 	. 
	ld a,(bc)			;c62f	0a 	. 
	pop hl			;c630	e1 	. 
	call sub_c6a1h		;c631	cd a1 c6 	. . . 
	inc bc			;c634	03 	. 
	ld a,(bc)			;c635	0a 	. 
	call sub_c6b4h		;c636	cd b4 c6 	. . . 
	pop hl			;c639	e1 	. 
	push bc			;c63a	c5 	. 
	ld bc,00003h		;c63b	01 03 00 	. . . 
	ldir		;c63e	ed b0 	. . 
	pop bc			;c640	c1 	. 
	push hl			;c641	e5 	. 
	inc bc			;c642	03 	. 
	ld a,(bc)			;c643	0a 	. 
	call sub_c6c1h		;c644	cd c1 c6 	. . . 
	pop hl			;c647	e1 	. 
	push bc			;c648	c5 	. 
	ld bc,6		;c649	01 06 00 	. . . 
	ldir		;c64c	ed b0 	. . 
	pop bc			;c64e	c1 	. 
	inc bc			;c64f	03 	. 
	ld a,(CFG4_LANG) 
	cp LANG_DE
	jr nz,lc66ch		;c655	20 15 	  . 
	ld a,020h		;c657	3e 20 	>   
	ld (de),a			;c659	12 	. 
	inc de			;c65a	13 	. 
	ld (de),a			;c65b	12 	. 
	inc de			;c65c	13 	. 
	inc bc			;c65d	03 	. 
	inc bc			;c65e	03 	. 
	inc bc			;c65f	03 	. 
	ld a,(bc)			;c660	0a 	. 
	dec bc			;c661	0b 	. 
	dec bc			;c662	0b 	. 
	dec bc			;c663	0b 	. 
	or a			;c664	b7 	. 
	ld a,(bc)			;c665	0a 	. 
	jr z,lc672h		;c666	28 0a 	( . 
	add a,00ch		;c668	c6 0c 	. . 
	jr lc672h		;c66a	18 06 	. . 
lc66ch:
	ld a,(bc)			;c66c	0a 	. 
	or a			;c66d	b7 	. 
	jr nz,lc672h		;c66e	20 02 	  . 
	ld a,00ch		;c670	3e 0c 	> . 
lc672h:
	dec a			;c672	3d 	= 
	call sub_c6b4h		;c673	cd b4 c6 	. . . 
	ld a,03ah		;c676	3e 3a 	> : 
	ld (de),a			;c678	12 	. 
	inc de			;c679	13 	. 
	inc bc			;c67a	03 	. 
	ld a,(bc)			;c67b	0a 	. 
	call sub_c6c1h		;c67c	cd c1 c6 	. . . 
	ld a,03ah		;c67f	3e 3a 	> : 
	ld (de),a			;c681	12 	. 
	inc de			;c682	13 	. 
	inc bc			;c683	03 	. 
	ld a,(bc)			;c684	0a 	. 
	call sub_c6c1h		;c685	cd c1 c6 	. . . 
	ld a,020h		;c688	3e 20 	>   
	ld (de),a			;c68a	12 	. 
	inc de			;c68b	13 	. 
	inc bc			;c68c	03 	. 
	ld a,(CFG4_LANG) 
	cp LANG_DE 
	ret z
	ld a,(bc)			;c693	0a 	. 
	or a			;c694	b7 	. 
	ld a,041h		;c695	3e 41 	> A 
	jr z,lc69bh		;c697	28 02 	( . 
	ld a,050h		;c699	3e 50 	> P 
lc69bh:
	ld (de),a			;c69b	12 	. 
	inc de			;c69c	13 	. 
	ld a,04dh		;c69d	3e 4d 	> M 
	ld (de),a			;c69f	12 	. 
	ret			;c6a0	c9 	. 
sub_c6a1h:
	push bc			;c6a1	c5 	. 
	ld b,a			;c6a2	47 	G 
	add a,a			;c6a3	87 	. 
	add a,b			;c6a4	80 	. 
	ld c,a			;c6a5	4f 	O 
	ld b,000h		;c6a6	06 00 	. . 
	add hl,bc			;c6a8	09 	. 
	ld bc,00003h		;c6a9	01 03 00 	. . . 
	ldir		;c6ac	ed b0 	. . 
	ld a,020h		;c6ae	3e 20 	>   
	ld (de),a			;c6b0	12 	. 
	inc de			;c6b1	13 	. 
	pop bc			;c6b2	c1 	. 
	ret			;c6b3	c9 	. 
sub_c6b4h:
	push de			;c6b4	d5 	. 
	inc a			;c6b5	3c 	< 
	call sub_c6c1h		;c6b6	cd c1 c6 	. . . 
	pop hl			;c6b9	e1 	. 
	ld a,(hl)			;c6ba	7e 	~ 
	cp 030h		;c6bb	fe 30 	. 0 
	ret nz			;c6bd	c0 	. 
	ld (hl),020h		;c6be	36 20 	6   
	ret			;c6c0	c9 	. 

sub_c6c1h:
	ld l,02fh		;c6c1	2e 2f 	. / 
lc6c3h:
	inc l			;c6c3	2c 	, 
	sub 00ah		;c6c4	d6 0a 	. . 
	jr nc,lc6c3h		;c6c6	30 fb 	0 . 
	add a,03ah		;c6c8	c6 3a 	. : 
	ex de,hl			;c6ca	eb 	. 
	ld (hl),e			;c6cb	73 	s 
	inc hl			;c6cc	23 	# 
	ld (hl),a			;c6cd	77 	w 
	inc hl			;c6ce	23 	# 
	ex de,hl			;c6cf	eb 	. 
	ret			;c6d0	c9 	. 

WEEKDAY_EN:
	db "SUNMONTUEWEDTHUFRISAT"
MONTH_EN:
	db "JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC"
TIME_LABEL_EN:
	db ",19 TIME "
WEEKDAY_DE:
	db "SONMONDIEMITDONFRESAM"
MONTH_DE:
	db "JANFEBMARAPRMAIJUNJULAUGSEPOKTNOVDEZ"
TIME_LABEL_DE:
	db ",19  ZEIT"

lc755h:
	ld a,0 
	out (PORT_30),a
	out (PORT_31),a
	ld a,058h
	out (PORT_2E),a
	ld a,003h
	out (PORT_2C),a
	in a,(PORT_2E)
	cp 058h
	jr nz,_exit
	in a,(PORT_2C)
	cp 003h
	jr z,lc774h
_exit:
	xor a
	ld (05b9fh),a
	ret

lc774h:
	xor a			;c774	af 	. 
	out (PORT_20),a		;c775	d3 20 	.   
	ld a,00ch		;c777	3e 0c 	> . 
	out (PORT_21),a		;c779	d3 21 	. ! 
	xor a			;c77b	af 	. 
	out (PORT_22),a		;c77c	d3 22 	. " 
	out (PORT_23),a		;c77e	d3 23 	. # 
	inc a			;c780	3c 	< 
	out (PORT_24),a		;c781	d3 24 	. $ 
	out (PORT_25),a		;c783	d3 25 	. % 
	ld a,058h		;c785	3e 58 	> X 
	out (PORT_26),a		;c787	d3 26 	. & 
	xor a			;c789	af 	. 
	out (PORT_27),a		;c78a	d3 27 	. ' 
	ld a,018h		;c78c	3e 18 	> . 
	out (PORT_31),a		;c78e	d3 31 	. 1 
	ld a,008h		;c790	3e 08 	> . 
	out (PORT_30),a		;c792	d3 30 	. 0 
	ld a,005h		;c794	3e 05 	> . 
	ld (05b9fh),a		;c796	32 9f 5b 	2 . [ 
	ret			;c799	c9 	. 
lc79ah:
	in a,(PORT_20)		;c79a	db 20 	.   
	in a,(PORT_21)		;c79c	db 21 	. ! 
	ld (05ba4h),a		;c79e	32 a4 5b 	2 . [ 
	in a,(PORT_22)		;c7a1	db 22 	. " 
	ld (05ba5h),a		;c7a3	32 a5 5b 	2 . [ 
	in a,(PORT_23)		;c7a6	db 23 	. # 
	ld (05ba6h),a		;c7a8	32 a6 5b 	2 . [ 
	in a,(PORT_24)		;c7ab	db 24 	. $ 
	ld (05ba1h),a		;c7ad	32 a1 5b 	2 . [ 
	in a,(PORT_25)		;c7b0	db 25 	. % 
	ld (05ba2h),a		;c7b2	32 a2 5b 	2 . [ 
	in a,(PORT_26)		;c7b5	db 26 	. & 
	ld (05ba3h),a		;c7b7	32 a3 5b 	2 . [ 
	in a,(PORT_27)		;c7ba	db 27 	. ' 
	ld (05ba0h),a		;c7bc	32 a0 5b 	2 . [ 
	call lc7c3h		;c7bf	cd c3 c7 	. . . 
	ret			;c7c2	c9 	. 
lc7c3h:
	ld hl,05ba0h		;c7c3	21 a0 5b 	! . [ 
	ld a,(hl)			;c7c6	7e 	~ 
	cp 007h		;c7c7	fe 07 	. . 
	jr nc,lc80bh		;c7c9	30 40 	0 @ 
	inc hl			;c7cb	23 	# 
	ld a,(hl)			;c7cc	7e 	~ 
	dec a			;c7cd	3d 	= 
	cp 00ch		;c7ce	fe 0c 	. . 
	jr nc,lc80bh		;c7d0	30 39 	0 9 
	ld (hl),a			;c7d2	77 	w 
	inc hl			;c7d3	23 	# 
	ld a,(hl)			;c7d4	7e 	~ 
	dec a			;c7d5	3d 	= 
	cp 01fh		;c7d6	fe 1f 	. . 
	jr nc,lc80bh		;c7d8	30 31 	0 1 
	ld (hl),a			;c7da	77 	w 
	inc hl			;c7db	23 	# 
	ld a,(hl)			;c7dc	7e 	~ 
	cp 064h		;c7dd	fe 64 	. d 
	jr nc,lc80bh		;c7df	30 2a 	0 * 
	inc hl			;c7e1	23 	# 
	ld b,(hl)			;c7e2	46 	F 
	ld a,080h		;c7e3	3e 80 	> . 
	and b			;c7e5	a0 	. 
	jr z,lc7eah		;c7e6	28 02 	( . 
	ld a,001h		;c7e8	3e 01 	> . 
lc7eah:
	ld (05ba7h),a		;c7ea	32 a7 5b 	2 . [ 
	ld a,b			;c7ed	78 	x 
	and 07fh		;c7ee	e6 7f 	.  
	dec a			;c7f0	3d 	= 
	cp 00ch		;c7f1	fe 0c 	. . 
	jr nc,lc80bh		;c7f3	30 16 	0 . 
	inc a			;c7f5	3c 	< 
	cp 00ch		;c7f6	fe 0c 	. . 
	jr nz,lc7fch		;c7f8	20 02 	  . 
	ld a,000h		;c7fa	3e 00 	> . 
lc7fch:
	ld (hl),a			;c7fc	77 	w 
	inc hl			;c7fd	23 	# 
	ld a,(hl)			;c7fe	7e 	~ 
	cp 03ch		;c7ff	fe 3c 	. < 
	jr nc,lc80bh		;c801	30 08 	0 . 
	inc hl			;c803	23 	# 
	ld a,(hl)			;c804	7e 	~ 
	cp 03ch		;c805	fe 3c 	. < 
	jr nc,lc80bh		;c807	30 02 	0 . 
	xor a			;c809	af 	. 
	ret			;c80a	c9 	. 
lc80bh:
	ld a,0ffh		;c80b	3e ff 	> . 
	ret			;c80d	c9 	. 
lc80eh:
	ld hl,05b93h		;c80e	21 93 5b 	! . [ 
	ld a,(hl)			;c811	7e 	~ 
	ld (05ba6h),a		;c812	32 a6 5b 	2 . [ 
	inc hl			;c815	23 	# 
	ld a,(hl)			;c816	7e 	~ 
	inc a			;c817	3c 	< 
	ld (05ba3h),a		;c818	32 a3 5b 	2 . [ 
	inc hl			;c81b	23 	# 
	ld a,(hl)			;c81c	7e 	~ 
	inc a			;c81d	3c 	< 
	ld (05ba4h),a		;c81e	32 a4 5b 	2 . [ 
	inc hl			;c821	23 	# 
	ld a,(hl)			;c822	7e 	~ 
	ld (05ba5h),a		;c823	32 a5 5b 	2 . [ 
	inc hl			;c826	23 	# 
	ld a,(hl)			;c827	7e 	~ 
	cp 000h		;c828	fe 00 	. . 
	jr nz,lc82eh		;c82a	20 02 	  . 
	ld a,00ch		;c82c	3e 0c 	> . 
lc82eh:
	ld b,a			;c82e	47 	G 
	ld a,(05b9ah)		;c82f	3a 9a 5b 	: . [ 
	and 0ffh		;c832	e6 ff 	. . 
	jr z,lc838h		;c834	28 02 	( . 
	ld a,080h		;c836	3e 80 	> . 
lc838h:
	or b			;c838	b0 	. 
	ld (05ba0h),a		;c839	32 a0 5b 	2 . [ 
	inc hl			;c83c	23 	# 
	ld a,(hl)			;c83d	7e 	~ 
	ld (05ba1h),a		;c83e	32 a1 5b 	2 . [ 
	inc hl			;c841	23 	# 
	ld a,(hl)			;c842	7e 	~ 
	ld (05ba2h),a		;c843	32 a2 5b 	2 . [ 
	ret			;c846	c9 	. 
lc847h:
	call lc755h		;c847	cd 55 c7 	. U . 
	cp 000h		;c84a	fe 00 	. . 
	ret z			;c84c	c8 	. 
	call lc80eh		;c84d	cd 0e c8 	. . . 
	xor a			;c850	af 	. 
	out (PORT_31),a		;c851	d3 31 	. 1 
	out (PORT_30),a		;c853	d3 30 	. 0 
	ld c,PORT_20   
	out (c),a		;c857	ed 79 	. y 
	ld hl,05ba0h		;c859	21 a0 5b 	! . [ 
	ld b,007h		;c85c	06 07 	. . 
lc85eh:
	inc c			;c85e	0c 	. 
	outi		;c85f	ed a3 	. . 
	jr nz,lc85eh		;c861	20 fb 	  . 
	ld a,018h		;c863	3e 18 	> . 
	out (PORT_31),a		;c865	d3 31 	. 1 
	ld a,008h		;c867	3e 08 	> . 
	out (PORT_30),a		;c869	d3 30 	. 0 
	ret			;c86b	c9 	. 

HANDLE_SERIAL:
	ld de,FIFO_SERIAL
	call FIFO_READ		; Read char in A
	ret c				; Exit if empty
	ld b,DBG_SERIAL
	call LOG_CHAR
	ld c,a
	ld a,(05b94h)		;c879	3a 94 5b 	: . [ 
	ld b,a			;c87c	47 	G 
	ld a,(055dah)		;c87d	3a da 55 	: . U 
	cp b			;c880	b8 	. 
	jr nz,CLEAR_RAIN_MONTH		; 00.00 in RAIN MONTH
	ld a,(05b95h)		;c883	3a 95 5b 	: . [ 
	ld b,a			;c886	47 	G 
	ld a,(055d9h)		;c887	3a d9 55 	: . U 
	cp b			;c88a	b8 	. 
	jr nz,CLEAR_RAIN_DAY		; 0.00 in RAIN DAY 
	ld a,(05b97h)		;c88d	3a 97 5b 	: . [ 
	ld b,a			;c890	47 	G 
	ld a,(055d8h)		;c891	3a d8 55 	: . U 
	cp b			;c894	b8 	. 
	jr nz,lc8dfh		;c895	20 48 	  H 
	jr WEATHER_PARSE

; Clear rain month value (and day and temp hi/lo and gusts)
; RAIN DAY 0.00" MONTH 00.00"
CLEAR_RAIN_MONTH:
	ld a,(SCRN_RAIN_LBL)		; "R"AIN
	cp ' '
	jr z,SKIP_RAIN

		; Fills SCRN_RAIN_DAY with " 00.00"
		; (must already contain the '.')
	ld a,'.'
	ld hl,SCRN_RAIN_DAY
	ld (hl),' '
	ld d,'0'			; Fill with '0'
	inc hl
	ld b,4				; 5 char long
_loop:
	cp (hl)
	jr z,_skip			; Skip '.'
	ld (hl),d			; Write '0'
_skip:
	inc hl
	djnz _loop

; Clear rain day value (and temp hi/lo and gusts)
CLEAR_RAIN_DAY:
	ld a,(SCRN_RAIN_LBL)
	cp ' '
	jr z,SKIP_RAIN

		; Fills SCRN_RAIN_MONTH with " 0.00"
		; (must already contain the '.')
	ld a,'.' 
	ld hl,SCRN_RAIN_MONTH
	ld (hl),' '
	ld d,'0'
	inc hl
	ld b,3
_loop:
	cp (hl)
	jr z,_skip			; Skip '.'
	ld (hl),d			; Write '0'
_skip:
	inc hl
	djnz _loop

; Clear temp hi/lo (and gusts)
SKIP_RAIN:
		; Copies TEMP to TEMP_HI and TEMP_LO
		; (2 bytes + 1 byte)
	ld hl,(SCRN_TEMP_VAL)
	ld (SCRN_TEMP_HI),hl
	ld (SCRN_TEMP_LO),hl
	ld a,(SCRN_TEMP_VAL+2)
	ld (SCRN_TEMP_HI+2),a
	ld (SCRN_TEMP_LO+2),a

; Clear gusts = wind
; WINDS 00-00
; (speed, gusts)
lc8dfh:
	ld a,(SCRN_WIND_LBL)		; "W"IND
	cp ' '
	jr z,_skip
	ld hl,(SCRN_WIND_SPEED)		;c8e6	2a 12 56 	* . V 
	ld (SCRN_WIND_GUSTS),hl		;c8e9	22 15 56 	" . V 

_skip:
		; Not sure what happens
	ld a,(05b94h)		;c8ec	3a 94 5b 	: . [ 
	ld (055dah),a		;c8ef	32 da 55 	2 . U 
	ld a,(05b95h)		;c8f2	3a 95 5b 	: . [ 
	ld (055d9h),a		;c8f5	32 d9 55 	2 . U 
	ld a,(05b97h)		;c8f8	3a 97 5b 	: . [ 
	ld (055d8h),a		;c8fb	32 d8 55 	2 . U 

; Parse serial input as weather command
; c contains current char
WEATHER_PARSE:
	ld a,c				; Serial char read
	cp MAGIC1
	ld a,(WEATHER_PARSE_INDEX)	; a is index/state
	jr nz,_notmagic1    ; 

		;	char is MAGIC1 (0xff)
		; State 1 or 2 => state = 1
	cp 3
	jr c,WEATHER_PARSE_RESET

		; State !=8 => next state
	cp 8
	jr nz,WEATHER_PARSE_NEXT

		; State == 8
	ld a,(WEATHER_COUNTER_UNK)
	cp 5
	jp z,WEATHER_PARSE_IX8
	inc a
	ld (WEATHER_COUNTER_UNK),a 
	jr WEATHER_PARSE_NEXT

_notmagic1:

	cp 8
	jr nz,_label

		; State == 8
	ld a,0 
	ld (WEATHER_COUNTER_UNK),a 
	jp WEATHER_PARSE_IX8

_label:
	cp 2
	jr c,WEATHER_PARSE_IX1	; = 1
	jr z,WEATHER_PARSE_IX2	; = 2 
	cp 4
	jr c,WEATHER_PARSE_IX3	; = 3 
	jp z,WEATHER_PARSE_IX4	; = 4 
	cp 6
	jp c,WEATHER_PARSE_IX5	; = 5
	jp z,WEATHER_PARSE_IX6	; = 6
	cp 8
	jp c,WEATHER_PARSE_IX7	; = 7
	jp z,WEATHER_PARSE_IX8	; = 8
	cp 10
	jr c,WEATHER_PARSE_NEXT	; = 9

							; = 10 or more	
WEATHER_PARSE_RESET:	; back to char 1 (accepted MAGIC1)
	xor a
	ld (WEATHER_PARSE_INDEX),a
WEATHER_PARSE_NEXT:
	ld a,(WEATHER_PARSE_INDEX) 
	inc a 
	ld (WEATHER_PARSE_INDEX),a
	ret

WEATHER_PARSE_IX1:
	ld a,c
	cp MAGIC2
	jr z,WEATHER_PARSE_NEXT
	jr WEATHER_PARSE_RESET

WEATHER_PARSE_IX2:
	ld a,c
	cp MAGIC3 
	jr z,WEATHER_PARSE_NEXT 
	jr WEATHER_PARSE_RESET

; Fahrenheit formula: C*18-670
; Celcius    formula: C*10-550
WEATHER_PARSE_IX3:
	ld a,(SCRN_TEMP_LBL) 
	cp ' '
	jr z,WEATHER_PARSE_NEXT
	ld a,(LAST_TEMP)
	ld b,a
	ld a,c 
	ld (LAST_TEMP),a 				; Update LAST_TEMP
	cp b
	jr nz,WEATHER_PARSE_NEXT		; Temp unchanged
	ld h,0
	ld l,b
	ld a,(TEMP_LOCALE)
	bit 0,a
	jp z,_fahrenheit
	call MUL_HL_10		; *10
	ld de,550
	jp _convert_temp
_fahrenheit:
	call MUL_HL_18		; *18
	ld de,670
_convert_temp:
	xor a
	sbc hl,de
	jr c,DISPLAY_NEG_TEMP
	ld de,SCRN_TEMP_VAL
	ld c,4
	call NUM2STR
	ld hl,SCRN_TEMP_VAL 
	call REMOVE_LEADING_ZEROES
	jr UPDATE_DEGREE_SIGNS		;c9a2	18 29 	. ) 

REMOVE_LEADING_ZEROES:
	ld a,'0'
	cp (hl)
	ret nz
	ld (hl),' '
	inc hl
	cp (hl)
	ret nz 
	ld (hl),' '
	inc hl
	ret

DISPLAY_NEG_TEMP:
		; HL = -HL (using 2 complement)
	ld a,l
	cpl 
	ld l,a 
	ld a,h
	cpl
	ld h,a
	inc hl

		; Display temp
	ld de,SCRN_TEMP_VAL+1
	ld c,3
	call NUM2STR				; Print 3 digits

		; Remove leading zeroes and put minus sign
	ld hl,SCRN_TEMP_VAL+1 
	ld a,(hl) 
	cp '0' 
	jr nz,_print_minus
	ld (hl),' '   
_print_minus:
	dec hl
	ld (hl),'-'

UPDATE_DEGREE_SIGNS:
	ld a,DEGREE_US
	call LOCAL_DEGREE	; Convert to German if needed
	ld (SCRN_TEMP_DEG),a  ; Store in screen

	ld a,(LAST_LAST_TEMP)
	ld b,a
	ld a,(LAST_TEMP)
	dec b 
	cp b 
	jr c,_temp_up		; Temp<Prev temp-1
	inc b
	inc b
	inc b 
	cp b 
	jr c,_temp_stable			; Temp<Prev temp+2 
	ld a,ARROW_DOWN
	jr _update_arrow
_temp_up:
	ld a,ARROW_UP
_update_arrow:
	ld (SCRN_TEMP_DIR),a
	ld a,(LAST_TEMP)
	ld (LAST_LAST_TEMP),a	; Only updated if we changed the arrow


; Now complicated logic to update TEMP_LO and SCRN_TEMP_HI
; which depends on the sign of the temp
_temp_stable:
	ld a,(SCRN_TEMP_VAL)
	cp '-'
	jr nz,lca51h
	ld a,(SCRN_TEMP_HI)		;c9fc	3a f8 55 	: . U 
	cp '-'
	jr nz,lca1ah		;ca01	20 17 	  . 
	ld de,SCRN_TEMP_VAL+1		;ca03	11 ec 55 	. . U 
	ld hl,SCRN_TEMP_HI+1		;ca06	21 f9 55 	! . U 
	ld b,(hl)			;ca09	46 	F 
	ld a,(de)			;ca0a	1a 	. 
	cp b			;ca0b	b8 	. 
	jr c,lca17h		;ca0c	38 09 	8 . 
	jr nz,lca1ah		;ca0e	20 0a 	  . 
	inc hl			;ca10	23 	# 
	inc de			;ca11	13 	. 
	ld b,(hl)			;ca12	46 	F 
	ld a,(de)			;ca13	1a 	. 
	cp b			;ca14	b8 	. 
	jr nc,lca1ah		;ca15	30 03 	0 . 
lca17h:
	call sub_ca3dh		;ca17	cd 3d ca 	. = . 
lca1ah:
	ld a,(SCRN_TEMP_LO)		;ca1a	3a 00 56 	: . V 
	cp 02dh		;ca1d	fe 2d 	. - 
	jr nz,lca37h		;ca1f	20 16 	  . 
	ld hl,SCRN_TEMP_VAL+1		;ca21	21 ec 55 	! . U 
	ld de,SCRN_TEMP_LO+1		;ca24	11 01 56 	. . V 
	ld b,(hl)			;ca27	46 	F 
	ld a,(de)			;ca28	1a 	. 
	cp b			;ca29	b8 	. 
	jr c,lca37h		;ca2a	38 0b 	8 . 
	jp nz,WEATHER_PARSE_NEXT		;ca2c	c2 4d c9 	. M . 
	inc hl			;ca2f	23 	# 
	inc de			;ca30	13 	. 
	ld b,(hl)			;ca31	46 	F 
	ld a,(de)			;ca32	1a 	. 
	cp b			;ca33	b8 	. 
	jp nc,WEATHER_PARSE_NEXT		;ca34	d2 4d c9 	. M . 
lca37h:
	call sub_ca45h		;ca37	cd 45 ca 	. E . 
	jp WEATHER_PARSE_NEXT		;ca3a	c3 4d c9 	. M . 
sub_ca3dh:
	ld hl,SCRN_TEMP_VAL		;ca3d	21 eb 55 	! . U 
	ld de,SCRN_TEMP_HI		;ca40	11 f8 55 	. . U 
	jr lca4bh		;ca43	18 06 	. . 
sub_ca45h:
	ld hl,SCRN_TEMP_VAL		;ca45	21 eb 55 	! . U 
	ld de,SCRN_TEMP_LO		;ca48	11 00 56 	. . V 
lca4bh:
	ld bc,00003h		;ca4b	01 03 00 	. . . 
	ldir		;ca4e	ed b0 	. . 
	ret			;ca50	c9 	. 
lca51h:
	ld de,SCRN_TEMP_HI		;ca51	11 f8 55 	. . U 
	ld a,(de)			;ca54	1a 	. 
	cp 02dh		;ca55	fe 2d 	. - 
	jr z,lca73h		;ca57	28 1a 	( . 
	ld hl,SCRN_TEMP_VAL		;ca59	21 eb 55 	! . U 
	ld a,(de)			;ca5c	1a 	. 
	ld b,(hl)			;ca5d	46 	F 
	cp b			;ca5e	b8 	. 
	jr c,lca73h		;ca5f	38 12 	8 . 
	jr nz,lca76h		;ca61	20 13 	  . 
	inc de			;ca63	13 	. 
	inc hl			;ca64	23 	# 
	ld a,(de)			;ca65	1a 	. 
	ld b,(hl)			;ca66	46 	F 
	cp b			;ca67	b8 	. 
	jr c,lca73h		;ca68	38 09 	8 . 
	jr nz,lca76h		;ca6a	20 0a 	  . 
	inc hl			;ca6c	23 	# 
	inc de			;ca6d	13 	. 
	ld a,(de)			;ca6e	1a 	. 
	ld b,(hl)			;ca6f	46 	F 
	cp b			;ca70	b8 	. 
	jr nc,lca76h		;ca71	30 03 	0 . 
lca73h:
	call sub_ca3dh		;ca73	cd 3d ca 	. = . 
lca76h:
	ld hl,SCRN_TEMP_LO		;ca76	21 00 56 	! . V 
	ld a,(hl)			;ca79	7e 	~ 
	cp 02dh		;ca7a	fe 2d 	. - 
	jp z,WEATHER_PARSE_NEXT		;ca7c	ca 4d c9 	. M . 
	ld de,SCRN_TEMP_VAL		;ca7f	11 eb 55 	. . U 
	ld a,(de)			;ca82	1a 	. 
	ld b,(hl)			;ca83	46 	F 
	cp b			;ca84	b8 	. 
	jr c,lca9ch		;ca85	38 15 	8 . 
	jp nz,WEATHER_PARSE_NEXT		;ca87	c2 4d c9 	. M . 
	inc hl			;ca8a	23 	# 
	inc de			;ca8b	13 	. 
	ld a,(de)			;ca8c	1a 	. 
	ld b,(hl)			;ca8d	46 	F 
	cp b			;ca8e	b8 	. 
	jr c,lca9ch		;ca8f	38 0b 	8 . 
	jp nz,WEATHER_PARSE_NEXT		;ca91	c2 4d c9 	. M . 
	inc hl			;ca94	23 	# 
	inc de			;ca95	13 	. 
	ld a,(de)			;ca96	1a 	. 
	ld b,(hl)			;ca97	46 	F 
	cp b			;ca98	b8 	. 
	jp nc,WEATHER_PARSE_NEXT		;ca99	d2 4d c9 	. M . 
lca9ch:
	call sub_ca45h		;ca9c	cd 45 ca 	. E . 
	jp WEATHER_PARSE_NEXT		;ca9f	c3 4d c9 	. M . 

WEATHER_PARSE_IX4:
	;  0 => 15 - skip
	;  1 => 14 - skip
	;  2 => 13 - skip
	;  3 => 12 - skip
	;  4 => 11 - skip
	;  5 => 10 => "NE"
	;  6 =>  9 => "NW"
	;  7 =>  8 => "N "
	;  8 =>  7 => skip
	;  9 =>  6 => "SE"
	; 10 =>  5 => "SW"
	; 11 =>  4 => "S "
	; 12 =>  3 => skip
	; 13 =>  2 => "E "
	; 14 =>  1 => "W "
	; 15 =>  0 => skip
	ld a,(SCRN_WIND_LBL)
	cp ' '   
	jp z,WEATHER_PARSE_NEXT
	ld a,c
	cpl							; xor $ff
	and %00001111
	cp 11
	jp nc,WEATHER_PARSE_NEXT	; Skip if >= 11
	or a
	jp z,WEATHER_PARSE_NEXT		; Skip if 0
	cp 003h
	jp z,WEATHER_PARSE_NEXT		; Skip if 3 
	cp 007h
	jp z,WEATHER_PARSE_NEXT		; Skip if 7

		; Get the two chars at DIRECTION_TABLE[(A-1)*2]
	dec a 
	add a,a 
	ld hl,DIRECTION_TABLE
	ld e,a
	ld d,0
	add hl,de
	ld e,(hl)
	inc hl
	ld d,(hl)
	ex de,hl
	ld (SCRN_WIND_SPACES),hl
	jp WEATHER_PARSE_NEXT

lcad4h:
	ld a,(LAST_TEMP)		;cad4	3a db 55 	: . U 
	cp 03fh		;cad7	fe 3f 	. ? 
	jp nc,UPDATE_WIND_DIRECTION		;cad9	d2 b6 cb 	. . . 
	ld a,(05fd0h)		;cadc	3a d0 5f 	: . _ 
	cp 5
	jp nc,lcaech		;cae1	d2 ec ca 	. . . 
	ld a,(CFG8)		;cae4	3a 3d 00 	: = . 
	and %00001000
	jp z,UPDATE_WIND_DIRECTION		;cae9	ca b6 cb 	. . . 
lcaech:
	ld (SCRN_WIND_FROM_LBL),hl	; Full 2bytes copied ?
	ld hl,CHILL_LBL
	ld de,SCRN_WIND_CHILL_LBL 
	ld bc,9
	ldir
	ld a,(05fd0h)		;cafa	3a d0 5f 	: . _ 
	cp 005h		;cafd	fe 05 	. . 
	jr nc,lcb0fh		;caff	30 0e 	0 . 

	; Copies temperature into the wind field?
	; Like in the wind temperature field?
	ld hl,055eah		;cb01	21 ea 55 	! . U 
	ld de,05627h		;cb04	11 27 56 	. ' V 
	ld bc,4 
	ldir		;cb0a	ed b0 	. . 
	jp lcbaah		;cb0c	c3 aa cb 	. . . 
lcb0fh:
	call sub_c1afh		;cb0f	cd af c1 	. . . 
	ld a,(TEMP_LOCALE)		;cb12	3a 85 56 	: . V 
	bit 0,a		;cb15	cb 47 	. G 
	jp z,lcb50h		;cb17	ca 50 cb 	. P . 
	ld a,h			;cb1a	7c 	| 
	or a			;cb1b	b7 	. 
	jp m,lcb33h		;cb1c	fa 33 cb 	. 3 . 
	ld c,003h		;cb1f	0e 03 	. . 
	ld de,05628h		;cb21	11 28 56 	. ( V 
	ld l,h			;cb24	6c 	l 
	ld h,000h		;cb25	26 00 	& . 
	call NUM2STR		;cb27	cd 9e 0f 	. . . 
	ld hl,05628h		;cb2a	21 28 56 	! ( V 
	call REMOVE_LEADING_ZEROES		;cb2d	cd a4 c9 	. . . 
	jp lcb4dh		;cb30	c3 4d cb 	. M . 
lcb33h:
	ld de,0		;cb33	11 00 00 	. . . 
	ex de,hl			;cb36	eb 	. 
	sbc hl,de		;cb37	ed 52 	. R 
	ld l,h			;cb39	6c 	l 
	ld h,000h		;cb3a	26 00 	& . 
	ld de,05628h		;cb3c	11 28 56 	. ( V 
	ld c,003h		;cb3f	0e 03 	. . 
	call NUM2STR		;cb41	cd 9e 0f 	. . . 
	ld hl,05628h		;cb44	21 28 56 	! ( V 
	call REMOVE_LEADING_ZEROES		;cb47	cd a4 c9 	. . . 
	dec hl			;cb4a	2b 	+ 
	ld (hl),02dh		;cb4b	36 2d 	6 - 
lcb4dh:
	jp lcbaah		;cb4d	c3 aa cb 	. . . 
lcb50h:
	ld a,h			;cb50	7c 	| 
	or a			;cb51	b7 	. 
	jp m,lcb62h		;cb52	fa 62 cb 	. b . 
	ld c,h			;cb55	4c 	L 
	ld a,l			;cb56	7d 	} 
	ld de,00012h		;cb57	11 12 00 	. . . 
	call sub_c0e5h		;cb5a	cd e5 c0 	. . . 
	ld l,h			;cb5d	6c 	l 
	ld h,a			;cb5e	67 	g 
	jp lcb78h		;cb5f	c3 78 cb 	. x . 
lcb62h:
	ld de,0		;cb62	11 00 00 	. . . 
	ex de,hl			;cb65	eb 	. 
	sbc hl,de		;cb66	ed 52 	. R 
	ld c,h			;cb68	4c 	L 
	ld a,l			;cb69	7d 	} 
	ld de,00012h		;cb6a	11 12 00 	. . . 
	call sub_c0e5h		;cb6d	cd e5 c0 	. . . 
	ld e,h			;cb70	5c 	\ 
	ld d,a			;cb71	57 	W 
	ld hl,0		;cb72	21 00 00 	! . . 
	or a			;cb75	b7 	. 
	sbc hl,de		;cb76	ed 52 	. R 
lcb78h:
	ld de,l0140h		;cb78	11 40 01 	. @ . 
	or a			;cb7b	b7 	. 
	adc hl,de		;cb7c	ed 5a 	. Z 
	jp m,lcb92h		;cb7e	fa 92 cb 	. . . 
	ld c,004h		;cb81	0e 04 	. . 
	ld de,05628h		;cb83	11 28 56 	. ( V 
	call NUM2STR		;cb86	cd 9e 0f 	. . . 
	ld hl,05628h		;cb89	21 28 56 	! ( V 
	call REMOVE_LEADING_ZEROES		;cb8c	cd a4 c9 	. . . 
	jp lcbaah		;cb8f	c3 aa cb 	. . . 
lcb92h:
	ld de,0		;cb92	11 00 00 	. . . 
	ex de,hl			;cb95	eb 	. 
	or a			;cb96	b7 	. 
	sbc hl,de		;cb97	ed 52 	. R 
	ld c,004h		;cb99	0e 04 	. . 
	ld de,05628h		;cb9b	11 28 56 	. ( V 
	call NUM2STR		;cb9e	cd 9e 0f 	. . . 
	ld hl,05628h		;cba1	21 28 56 	! ( V 
	call REMOVE_LEADING_ZEROES		;cba4	cd a4 c9 	. . . 
	dec hl			;cba7	2b 	+ 
	ld (hl),02dh		;cba8	36 2d 	6 - 
lcbaah:
	ld a,DEGREE_US 
	call LOCAL_DEGREE		; Convert to German if needed
	ld hl,0562bh		;cbaf	21 2b 56 	! + V 
	ld (hl),a			;cbb2	77 	w 
	jp WEATHER_PARSE_NEXT		;cbb3	c3 4d c9 	. M . 

; HL contains two characters for wind dircection
UPDATE_WIND_DIRECTION:
		; Copies "FROM   " in right side of WIND
	push hl
	ld hl,FROM_LBL	; "FROM       "
	ld de,SCRN_WIND_FROM_LBL
	ld bc,15
	ldir
	pop hl
	ld (SCRN_WIND_DIRECTION),hl
	jp WEATHER_PARSE_NEXT


; Weather-related stuff

DIRECTION_TABLE:
	db "W "		; 0x1e
	db "E "		; 0x1d
	db "  "
	db "S "
	db "SW"
	db "SE"
	db "  "
	db "N "
	db "NW"		; 0x16
	db "NE"		; 0x15
FROM_LBL:
	db "FROM           " ; 15 bytes
CHILL_LBL:
	db "  CHILL  "		 ; 9 bytes

; Humidity
WEATHER_PARSE_IX5:
	ld a,(SCRN_BARO_HUM_LBL)
	cp ' '
	jp z,WEATHER_PARSE_NEXT
	ld a,99 
	cp c
	jp c,WEATHER_PARSE_NEXT		; Ignore if >99
	ld l,c
	ld h,0 
	ld de,SCRN_BARO_HUM_VAL 
	ld c,2 
	call NUM2STR
	jp WEATHER_PARSE_NEXT

; WIND SPEED
WEATHER_PARSE_IX6:
	ld a,(SCRN_WIND_LBL)
	cp ' '
	jp z,WEATHER_PARSE_NEXT
	ld ix,05fd0h 
	ld a,(CFG8)
	and %00001000 
	jr z,_metric		;  unit == Metrics
	ld a,0
	ld (ix+002h),a
	ld h,c 
	ld l,a 
	srl h
	rr l			; HL /= 2 
	jr lcc5bh
_metric:
	push bc			;cc31	c5 	. 
	ld h,(ix+000h)		;cc32	dd 66 00 	. f . 
	ld l,(ix+001h)		;cc35	dd 6e 01 	. n . 
	ld a,(ix+002h)		;cc38	dd 7e 02 	. ~ . 
	ld d,h			;cc3b	54 	T 
	ld e,l			;cc3c	5d 	] 
	ld c,a			;cc3d	4f 	O 
	ld b,5
_loop:
	srl d		;cc40	cb 3a 	. : 
	rr e		;cc42	cb 1b 	. . 
	rr c		;cc44	cb 19 	. . 
	djnz _loop		;cc46	10 f8 	. . 
	sub c			;cc48	91 	. 
	ld (ix+002h),a		;cc49	dd 77 02 	. w . 
	sbc hl,de		;cc4c	ed 52 	. R 
	pop bc			;cc4e	c1 	. 
	ld d,000h		;cc4f	16 00 	. . 
	ld e,c			;cc51	59 	Y 
	sla e		;cc52	cb 23 	. # 
	rl d		;cc54	cb 12 	. . 
	sla e		;cc56	cb 23 	. # 
	rl d		;cc58	cb 12 	. . 
	add hl,de			;cc5a	19 	. 
lcc5bh:
	ld (ix+000h),h		;cc5b	dd 74 00 	. t . 
	ld (ix+001h),l		;cc5e	dd 75 01 	. u . 
	ld a,(TEMP_LOCALE)		;cc61	3a 85 56 	: . V 
	bit 0,a		;cc64	cb 47 	. G 
	jr z,lcc76h		;cc66	28 0e 	( . 
	ld a,c			;cc68	79 	y 
	srl c		;cc69	cb 39 	. 9 
	srl c		;cc6b	cb 39 	. 9 
	sub c			;cc6d	91 	. 
	srl c		;cc6e	cb 39 	. 9 
	srl c		;cc70	cb 39 	. 9 
	add a,c			;cc72	81 	. 
	ld c,a			;cc73	4f 	O 
	jr lcc78h		;cc74	18 02 	. . 
lcc76h:
	srl c		;cc76	cb 39 	. 9 
lcc78h:
	ld a,063h		;cc78	3e 63 	> c 
	cp c			;cc7a	b9 	. 
	jr c,_skip_to_direction 
	ld l,c			;cc7d	69 	i 
	ld h,000h		;cc7e	26 00 	& . 
	push hl			;cc80	e5 	. 
	ld de,SCRN_WIND_SPEED		;cc81	11 12 56 	. . V 
	ld c,2 
	call NUM2STR		;cc86	cd 9e 0f 	. . . 
	ld de,SCRN_WIND_GUSTS		;cc89	11 15 56 	. . V 
	ld c,2
	call STR2NUM		;cc8e	cd 54 0f 	. T . 
	ld a,l			;cc91	7d 	} 
	pop hl			;cc92	e1 	. 
	cp l			;cc93	bd 	. 
	jr nc,_skip_to_direction
	ld hl,(SCRN_WIND_SPEED)		;cc96	2a 12 56 	* . V 
	ld (SCRN_WIND_GUSTS),hl		;cc99	22 15 56 	" . V 
_skip_to_direction:
	ld hl,(SCRN_WIND_SPACES)		; Two "spaces" used to place before "   CHILL"
	ld a,' '
	ld (SCRN_WIND_SPACES),a		; Next time it will really be spaces
	ld (SCRN_WIND_SPACES+1),a 
	jp lcad4h

; Barometer
WEATHER_PARSE_IX7:
	ld a,(SCRN_BARO_LBL) 
	cp ' '
	jp z,WEATHER_PARSE_NEXT	; not interested, skip 

	ld a,(LAST_BARO)
	and %11111000 
	ld b,a 
	ld a,c
	ld (LAST_BARO),A		; Update last
	and %11111000
	cp b
	jp nz,WEATHER_PARSE_NEXT		; Skip if change not signifcant

	ld l,c
	ld h,0 
	ld a,(TEMP_LOCALE)
	bit 0,a
	jr z,_inches			;	inches

; convert to KPas and display
	call MUL_HL_87			; *=87
	ld l,h					;
	ld h,000h		 		; /256 
	ld de,983
	add hl,de			; (x*87)/256+983

	ld de,0563ah		; Store as "nnn.n"
	ld c,4 
	call NUM2STR
	ld hl,0563dh 
	ld a,(hl)
	ld (hl),'.'
	inc hl
	ld (hl),a

	ld hl,05643h		;cce6	21 43 56 	! C V 
	jr _displayXX		;cce9	18 1a 	. . 

; convert to inches and display
_inches:
	ld de,2900 
	add hl,de
	ld de,SCRN_BARO_VAL		; Store as "nn.nn"
	ld c,4 
	call NUM2STR 
	ld hl,(0563dh) 
	ld (0563eh),hl 
	ld a,'.'
	ld (0563dh),a

	ld hl,SCRN_BARO_DIRECTON

_displayXX:
	ld a,(LAST_LAST_BARO) 
	ld b,a 
	ld a,(LAST_BARO) 
	inc b 
	inc b 
	cp b
	jr nc,_down
	dec b 
	dec b
	dec b 
	cp b 
	jp nc,WEATHER_PARSE_NEXT 
	ld (LAST_LAST_BARO),a 
	ld a,ARROW_UP
	ld (hl),a
	jp WEATHER_PARSE_NEXT

_down:
	ld a,(LAST_BARO)
	ld (LAST_LAST_BARO),a
	ld a,ARROW_DOWN
	ld (hl),a
	jp WEATHER_PARSE_NEXT

WEATHER_PARSE_IX8:
	ld a,(SCRN_RAIN_LBL)
	cp ' '
	jp z,WEATHER_PARSE_NEXT		; not interested, skip 
	ld a,(WEATHER_PREVIOUS_XXX) 
	cp c
	jp z,WEATHER_PARSE_NEXT		; no change, skip
	ld b,a
	ld a,c
	ld (WEATHER_PREVIOUS_XXX),a
	inc b
	cp b
	jp nz,WEATHER_PARSE_NEXT	; Has to be +1

	ld a,(TEMP_LOCALE)
	bit 0,a 
	jr z,_inches
	ld a,(RAIN_COUNTER_XXX) 
	inc a
	ld (RAIN_COUNTER_XXX),a
	cp 4 
	jp c,WEATHER_PARSE_NEXT
	xor a 
	ld (RAIN_COUNTER_XXX),a

_inches:
	ld hl,SCRN_RAIN_DAY_VAL 
	call INCREMENT_ASCII_NUMBER 
	ld hl,SCRN_RAIN_MONTH_VAL 
	call INCREMENT_ASCII_NUMBER 
	jp WEATHER_PARSE_NEXT 

; Increments an ASCII number in memory
; Pass pointer to last digit
; Increment at most 'b' characters
; "XXX  99.99" => "XXX 100.00"
; "XXXXX99.99" => "XXXX100.00"
; (seems 'b' is often 255 due to sequential calls)
INCREMENT_ASCII_NUMBER:
	ld a,(hl)			; Current digit
	cp '.'
	jr z,_skip 
	cp ' '
	jr nz,_inc_digit
	ld a,'0' 			; space is '0'
_inc_digit:
	inc a 				; next number
	ld (hl),a 
	cp '9'+1			; overflow?
	ret nz				; nope, increment finished
	ld (hl),'0'			; yes, this digit is 0
_skip:
	dec hl				; and move to prev
	djnz INCREMENT_ASCII_NUMBER 
	ret 

; Makes sure the correct 'degree' symbol is used
; A='``' if German (called with A='\')
LOCAL_DEGREE:
	push bc 
	ld b,a 
	ld a,(CFG4_LANG)
	ld a,b
	cp LANG_DE 
	jp nz,_skip 
	ld a,DEGREE_DE
_skip:
	pop bc 
	ret 

	; Fills with 0 until 0xd000
	ds 0xd000-$, 0x00

	db 0x53, 0x4f, 0x46, 0x54, 0x57, 0x41, 0x52, 0x45   ; d000 : SOFTWARE
	db 0x20, 0x56, 0x45, 0x52, 0x53, 0x49, 0x4f, 0x4e   ; d008 :  VERSION
	db 0x20, 0x54, 0x4f, 0x20, 0x44, 0x49, 0x53, 0x43   ; d010 :  TO DISC
	db 0x4f, 0x4e, 0x4e, 0x45, 0x43, 0x54, 0x20, 0x42   ; d018 : ONNECT B
	db 0x41, 0x54, 0x54, 0x45, 0x52, 0x59, 0x20, 0x42   ; d020 : ATTERY B
	db 0x41, 0x43, 0x4b, 0x55, 0x50, 0x05, 0x46, 0x4f   ; d028 : ACKUP.FO
	db 0x52, 0x20, 0x53, 0x48, 0x49, 0x50, 0x50, 0x49   ; d030 : R SHIPPI
	db 0x4e, 0x47, 0x20, 0x54, 0x59, 0x50, 0x45, 0x20   ; d038 : NG TYPE 
	db 0x43, 0x54, 0x52, 0x4c, 0x2d, 0x44, 0x05, 0x42   ; d040 : CTRL-D.B
	db 0x41, 0x54, 0x54, 0x45, 0x52, 0x59, 0x20, 0x44   ; d048 : ATTERY D
	db 0x49, 0x53, 0x43, 0x4f, 0x4e, 0x4e, 0x45, 0x43   ; d050 : ISCONNEC
	db 0x54, 0x45, 0x44, 0x05, 0x54, 0x55, 0x52, 0x4e   ; d058 : TED.TURN
	db 0x20, 0x50, 0x4f, 0x57, 0x45, 0x52, 0x20, 0x4f   ; d060 :  POWER O
	db 0x46, 0x46, 0x52, 0x45, 0x51, 0x55, 0x45, 0x53   ; d068 : FFREQUES
	db 0x54, 0x20, 0x43, 0x41, 0x4e, 0x43, 0x45, 0x4c   ; d070 : T CANCEL
	db 0x45, 0x44, 0x09, 0x09, 0x53, 0x54, 0x4f, 0x52   ; d078 : ED..STOR
	db 0x45, 0x44, 0x50, 0x41, 0x47, 0x45, 0x20, 0x04   ; d080 : EDPAGE .
	db 0x49, 0x4e, 0x56, 0x41, 0x4c, 0x49, 0x44, 0x20   ; d088 : INVALID 
	db 0x50, 0x41, 0x47, 0x45, 0x20, 0x4e, 0x55, 0x4d   ; d090 : PAGE NUM
	db 0x42, 0x45, 0x52, 0x0f, 0x44, 0x49, 0x53, 0x50   ; d098 : BER.DISP
	db 0x4c, 0x41, 0x59, 0x20, 0x54, 0x59, 0x50, 0x45   ; d0a0 : LAY TYPE
	db 0x05, 0x44, 0x49, 0x53, 0x50, 0x4c, 0x41, 0x59   ; d0a8 : .DISPLAY
	db 0x20, 0x53, 0x50, 0x45, 0x45, 0x44, 0x05, 0x44   ; d0b0 :  SPEED.D
	db 0x49, 0x53, 0x50, 0x4c, 0x41, 0x59, 0x20, 0x54   ; d0b8 : ISPLAY T
	db 0x49, 0x4d, 0x45, 0x20, 0x20, 0x20, 0x20, 0x20   ; d0c0 : IME     
	db 0x53, 0x45, 0x43, 0x4f, 0x4e, 0x44, 0x53, 0x05   ; d0c8 : SECONDS.
	db 0x50, 0x41, 0x47, 0x45, 0x20, 0x53, 0x4b, 0x49   ; d0d0 : PAGE SKI
	db 0x50, 0x05, 0x50, 0x41, 0x47, 0x45, 0x20, 0x4c   ; d0d8 : P.PAGE L
	db 0x49, 0x4e, 0x4b, 0x05, 0x50, 0x41, 0x47, 0x45   ; d0e0 : INK.PAGE
	db 0x20, 0x57, 0x41, 0x49, 0x54, 0x05, 0x05, 0x20   ; d0e8 :  WAIT.. 
	db 0x20, 0x20, 0x20, 0x20, 0x20, 0x44, 0x49, 0x53   ; d0f0 :      DIS
	db 0x50, 0x4c, 0x41, 0x59, 0x20, 0x54, 0x49, 0x4d   ; d0f8 : PLAY TIM
	db 0x45, 0x20, 0x57, 0x49, 0x4e, 0x44, 0x4f, 0x57   ; d100 : E WINDOW
	db 0x05, 0x05, 0x46, 0x49, 0x52, 0x53, 0x54, 0x20   ; d108 : ..FIRST 
	db 0x44, 0x41, 0x59, 0x05, 0x20, 0x20, 0x20, 0x20   ; d110 : DAY.    
	db 0x20, 0x20, 0x54, 0x49, 0x4d, 0x45, 0x05, 0x05   ; d118 :   TIME..
	db 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20   ; d120 :         
	db 0x20, 0x20, 0x20, 0x20, 0x54, 0x48, 0x52, 0x4f   ; d128 :     THRO
	db 0x55, 0x47, 0x48, 0x05, 0x05, 0x4c, 0x41, 0x53   ; d130 : UGH..LAS
	db 0x54, 0x20, 0x44, 0x41, 0x59, 0x05, 0x20, 0x20   ; d138 : T DAY.  
	db 0x20, 0x20, 0x20, 0x54, 0x49, 0x4d, 0x45, 0x05   ; d140 :    TIME.
	db 0x05, 0x4c, 0x49, 0x4e, 0x45, 0x20, 0x4c, 0x45   ; d148 : .LINE LE
	db 0x56, 0x45, 0x4c, 0x53, 0x20, 0x20, 0x20, 0x31   ; d150 : VELS   1
	db 0x20, 0x20, 0x32, 0x20, 0x20, 0x33, 0x20, 0x20   ; d158 :   2  3  
	db 0x34, 0x04, 0x42, 0x41, 0x4e, 0x47, 0x06, 0x53   ; d160 : 4.BANG.S
	db 0x50, 0x4c, 0x41, 0x53, 0x48, 0x05, 0x43, 0x52   ; d168 : PLASH.CR
	db 0x41, 0x57, 0x4c, 0x04, 0x52, 0x4f, 0x4c, 0x4c   ; d170 : AWL.ROLL
	db 0x0a, 0x50, 0x41, 0x47, 0x45, 0x20, 0x50, 0x52   ; d178 : .PAGE PR
	db 0x49, 0x4e, 0x54, 0x04, 0x53, 0x4c, 0x4f, 0x57   ; d180 : INT.SLOW
	db 0x06, 0x4d, 0x45, 0x44, 0x49, 0x55, 0x4d, 0x04   ; d188 : .MEDIUM.
	db 0x46, 0x41, 0x53, 0x54, 0x13, 0x53, 0x50, 0x41   ; d190 : FAST.SPA
	db 0x43, 0x45, 0x20, 0x42, 0x41, 0x52, 0x20, 0x54   ; d198 : CE BAR T
	db 0x4f, 0x20, 0x43, 0x48, 0x41, 0x4e, 0x47, 0x45   ; d1a0 : O CHANGE
	db 0x0e, 0x45, 0x4e, 0x54, 0x45, 0x52, 0x20, 0x30   ; d1a8 : .ENTER 0
	db 0x30, 0x20, 0x54, 0x4f, 0x20, 0x39, 0x39, 0x0a   ; d1b0 : 0 TO 99.
	db 0x59, 0x3d, 0x59, 0x45, 0x53, 0x20, 0x4e, 0x3d   ; d1b8 : Y=YES N=
	db 0x4e, 0x4f, 0x1d, 0x30, 0x30, 0x20, 0x54, 0x4f   ; d1c0 : NO.00 TO
	db 0x20, 0x31, 0x32, 0x20, 0x28, 0x30, 0x20, 0x48   ; d1c8 :  12 (0 H
	db 0x4f, 0x55, 0x52, 0x20, 0x3d, 0x20, 0x41, 0x4c   ; d1d0 : OUR = AL
	db 0x4c, 0x20, 0x48, 0x4f, 0x55, 0x52, 0x53, 0x29   ; d1d8 : L HOURS)
	db 0x0e, 0x45, 0x4e, 0x54, 0x45, 0x52, 0x20, 0x30   ; d1e0 : .ENTER 0
	db 0x30, 0x20, 0x54, 0x4f, 0x20, 0x35, 0x39, 0x0e   ; d1e8 : 0 TO 59.
	db 0x45, 0x4e, 0x54, 0x45, 0x52, 0x20, 0x30, 0x31   ; d1f0 : ENTER 01
	db 0x20, 0x54, 0x4f, 0x20, 0x31, 0x32, 0x20, 0x48   ; d1f8 :  TO 12 H
	db 0x3d, 0x48, 0x49, 0x47, 0x48, 0x20, 0x4c, 0x3d   ; d200 : =HIGH L=
	db 0x4c, 0x4f, 0x57, 0x20, 0x50, 0x3d, 0x50, 0x55   ; d208 : LOW P=PU
	db 0x4c, 0x53, 0x45, 0x20, 0x4e, 0x3d, 0x4e, 0x4f   ; d210 : LSE N=NO
	db 0x20, 0x43, 0x48, 0x41, 0x4e, 0x47, 0x45, 0x1c   ; d218 :  CHANGE.
	db 0x50, 0x4c, 0x45, 0x41, 0x53, 0x45, 0x20, 0x45   ; d220 : PLEASE E
	db 0x4e, 0x54, 0x45, 0x52, 0x20, 0x56, 0x41, 0x4c   ; d228 : NTER VAL
	db 0x49, 0x44, 0x20, 0x45, 0x56, 0x45, 0x4e, 0x54   ; d230 : ID EVENT
	db 0x20, 0x4e, 0x4f, 0x2e, 0x1d, 0x4e, 0x3d, 0x4e   ; d238 :  NO..N=N
	db 0x4f, 0x4e, 0x45, 0x20, 0x50, 0x3d, 0x50, 0x4c   ; d240 : ONE P=PL
	db 0x41, 0x59, 0x20, 0x53, 0x3d, 0x53, 0x54, 0x4f   ; d248 : AY S=STO
	db 0x50, 0x20, 0x52, 0x3d, 0x52, 0x45, 0x57, 0x49   ; d250 : P R=REWI
	db 0x4e, 0x44, 0x1f, 0x30, 0x31, 0x2d, 0x31, 0x34   ; d258 : ND.01-14
	db 0x3d, 0x56, 0x54, 0x52, 0x20, 0x20, 0x41, 0x3d   ; d260 : =VTR  A=
	db 0x56, 0x49, 0x44, 0x45, 0x4f, 0x20, 0x41, 0x20   ; d268 : VIDEO A 
	db 0x20, 0x42, 0x3d, 0x56, 0x49, 0x44, 0x45, 0x4f   ; d270 :  B=VIDEO
	db 0x20, 0x42, 0x0b, 0x49, 0x47, 0x4e, 0x4f, 0x52   ; d278 :  B.IGNOR
	db 0x45, 0x20, 0x54, 0x49, 0x4d, 0x45, 0x03, 0x53   ; d280 : E TIME.S
	db 0x55, 0x4e, 0x03, 0x4d, 0x4f, 0x4e, 0x03, 0x54   ; d288 : UN.MON.T
	db 0x55, 0x45, 0x03, 0x57, 0x45, 0x44, 0x03, 0x54   ; d290 : UE.WED.T
	db 0x48, 0x55, 0x03, 0x46, 0x52, 0x49, 0x03, 0x53   ; d298 : HU.FRI.S
	db 0x41, 0x54, 0x08, 0x41, 0x4c, 0x4c, 0x20, 0x44   ; d2a0 : AT.ALL D
	db 0x41, 0x59, 0x53, 0x02, 0x41, 0x4d, 0x02, 0x50   ; d2a8 : AYS.AM.P
	db 0x4d, 0x09, 0x41, 0x4c, 0x4c, 0x20, 0x48, 0x4f   ; d2b0 : M.ALL HO
	db 0x55, 0x52, 0x53, 0x09, 0x3a, 0x09, 0x0f, 0x53   ; d2b8 : URS.:..S
	db 0x45, 0x51, 0x55, 0x45, 0x4e, 0x43, 0x45, 0x20   ; d2c0 : EQUENCE 
	db 0x46, 0x4f, 0x52, 0x20, 0x52, 0x45, 0x47, 0x49   ; d2c8 : FOR REGI
	db 0x4f, 0x4e, 0x20, 0x20, 0x0e, 0x0f, 0x05, 0x05   ; d2d0 : ON  ....
	db 0x46, 0x49, 0x4c, 0x45, 0x20, 0x20, 0x53, 0x54   ; d2d8 : FILE  ST
	db 0x41, 0x52, 0x54, 0x20, 0x20, 0x53, 0x54, 0x4f   ; d2e0 : ART  STO
	db 0x50, 0x20, 0x20, 0x43, 0x48, 0x41, 0x4e, 0x47   ; d2e8 : P  CHANG
	db 0x45, 0x05, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20   ; d2f0 : E.      
	db 0x50, 0x41, 0x47, 0x45, 0x20, 0x20, 0x20, 0x50   ; d2f8 : PAGE   P
	db 0x41, 0x47, 0x45, 0x20, 0x20, 0x20, 0x46, 0x49   ; d300 : AGE   FI
	db 0x4c, 0x45, 0x05, 0x05, 0x43, 0x4f, 0x4e, 0x54   ; d308 : LE..CONT
	db 0x52, 0x4f, 0x4c, 0x20, 0x4b, 0x45, 0x59, 0x20   ; d310 : ROL KEY 
	db 0x46, 0x55, 0x4e, 0x43, 0x54, 0x49, 0x4f, 0x4e   ; d318 : FUNCTION
	db 0x53, 0x05, 0x05, 0x4c, 0x49, 0x4e, 0x45, 0x20   ; d320 : S..LINE 
	db 0x53, 0x45, 0x50, 0x41, 0x52, 0x41, 0x54, 0x4f   ; d328 : SEPARATO
	db 0x52, 0x05, 0x20, 0x43, 0x2d, 0x43, 0x4f, 0x4c   ; d330 : R. C-COL
	db 0x4f, 0x52, 0x05, 0x20, 0x54, 0x2d, 0x54, 0x4f   ; d338 : OR. T-TO
	db 0x50, 0x20, 0x4f, 0x4e, 0x2f, 0x4f, 0x46, 0x46   ; d340 : P ON/OFF
	db 0x05, 0x20, 0x42, 0x2d, 0x42, 0x4f, 0x54, 0x54   ; d348 : . B-BOTT
	db 0x4f, 0x4d, 0x20, 0x4f, 0x4e, 0x2f, 0x4f, 0x46   ; d350 : OM ON/OF
	db 0x46, 0x05, 0x57, 0x4f, 0x52, 0x44, 0x20, 0x43   ; d358 : F.WORD C
	db 0x4f, 0x4e, 0x54, 0x52, 0x4f, 0x4c, 0x20, 0x43   ; d360 : ONTROL C
	db 0x48, 0x41, 0x52, 0x41, 0x43, 0x54, 0x45, 0x52   ; d368 : HARACTER
	db 0x53, 0x05, 0x20, 0x46, 0x2d, 0x41, 0x4c, 0x54   ; d370 : S. F-ALT
	db 0x45, 0x52, 0x4e, 0x41, 0x54, 0x45, 0x20, 0x46   ; d378 : ERNATE F
	db 0x4f, 0x4e, 0x54, 0x05, 0x20, 0x58, 0x2d, 0x45   ; d380 : ONT. X-E
	db 0x58, 0x54, 0x45, 0x52, 0x4e, 0x41, 0x4c, 0x20   ; d388 : XTERNAL 
	db 0x56, 0x49, 0x44, 0x45, 0x4f, 0x05, 0x45, 0x44   ; d390 : VIDEO.ED
	db 0x49, 0x54, 0x20, 0x46, 0x55, 0x4e, 0x43, 0x54   ; d398 : IT FUNCT
	db 0x49, 0x4f, 0x4e, 0x53, 0x05, 0x20, 0x4c, 0x2d   ; d3a0 : IONS. L-
	db 0x45, 0x52, 0x41, 0x53, 0x45, 0x20, 0x54, 0x4f   ; d3a8 : ERASE TO
	db 0x20, 0x45, 0x4e, 0x44, 0x20, 0x4f, 0x46, 0x20   ; d3b0 :  END OF 
	db 0x4c, 0x49, 0x4e, 0x45, 0x05, 0x20, 0x50, 0x2d   ; d3b8 : LINE. P-
	db 0x45, 0x52, 0x41, 0x53, 0x45, 0x20, 0x54, 0x4f   ; d3c0 : ERASE TO
	db 0x20, 0x45, 0x4e, 0x44, 0x20, 0x4f, 0x46, 0x20   ; d3c8 :  END OF 
	db 0x50, 0x41, 0x47, 0x45, 0x05, 0x20, 0x41, 0x2d   ; d3d0 : PAGE. A-
	db 0x45, 0x52, 0x41, 0x53, 0x45, 0x20, 0x50, 0x41   ; d3d8 : ERASE PA
	db 0x47, 0x45, 0x20, 0x41, 0x54, 0x54, 0x52, 0x49   ; d3e0 : GE ATTRI
	db 0x42, 0x55, 0x54, 0x45, 0x53, 0x05, 0x20, 0x53   ; d3e8 : BUTES. S
	db 0x2d, 0x43, 0x48, 0x41, 0x52, 0x41, 0x43, 0x54   ; d3f0 : -CHARACT
	db 0x45, 0x52, 0x20, 0x49, 0x4e, 0x53, 0x45, 0x52   ; d3f8 : ER INSER
	db 0x54, 0x05, 0x20, 0x44, 0x2d, 0x43, 0x48, 0x41   ; d400 : T. D-CHA
	db 0x52, 0x41, 0x43, 0x54, 0x45, 0x52, 0x20, 0x44   ; d408 : RACTER D
	db 0x45, 0x4c, 0x45, 0x54, 0x45, 0x05, 0x20, 0x56   ; d410 : ELETE. V
	db 0x2d, 0x4c, 0x49, 0x4e, 0x45, 0x20, 0x49, 0x4e   ; d418 : -LINE IN
	db 0x53, 0x45, 0x52, 0x54, 0x05, 0x20, 0x4b, 0x2d   ; d420 : SERT. K-
	db 0x4c, 0x49, 0x4e, 0x45, 0x20, 0x44, 0x45, 0x4c   ; d428 : LINE DEL
	db 0x45, 0x54, 0x45, 0x05, 0x20, 0x52, 0x2d, 0x42   ; d430 : ETE. R-B
	db 0x4f, 0x52, 0x44, 0x45, 0x52, 0x05, 0x53, 0x59   ; d438 : ORDER.SY
	db 0x53, 0x54, 0x45, 0x4d, 0x20, 0x46, 0x55, 0x4e   ; d440 : STEM FUN
	db 0x43, 0x54, 0x49, 0x4f, 0x4e, 0x53, 0x05, 0x20   ; d448 : CTIONS. 
	db 0x45, 0x2d, 0x53, 0x45, 0x4c, 0x45, 0x43, 0x54   ; d450 : E-SELECT
	db 0x20, 0x43, 0x48, 0x41, 0x4e, 0x4e, 0x45, 0x4c   ; d458 :  CHANNEL
	db 0x20, 0x46, 0x4f, 0x52, 0x20, 0x45, 0x44, 0x49   ; d460 :  FOR EDI
	db 0x54, 0x49, 0x4e, 0x47, 0x05, 0x20, 0x4f, 0x2d   ; d468 : TING. O-
	db 0x4f, 0x46, 0x46, 0x20, 0x4c, 0x49, 0x4e, 0x45   ; d470 : OFF LINE
	db 0x20, 0x42, 0x41, 0x54, 0x43, 0x48, 0x20, 0x54   ; d478 :  BATCH T
	db 0x52, 0x41, 0x4e, 0x53, 0x46, 0x45, 0x52, 0x0f   ; d480 : RANSFER.
	db 0x53, 0x45, 0x4c, 0x45, 0x43, 0x54, 0x05, 0x05   ; d488 : SELECT..
	db 0x45, 0x2d, 0x45, 0x44, 0x49, 0x54, 0x05, 0x46   ; d490 : E-EDIT.F
	db 0x2d, 0x46, 0x4f, 0x52, 0x4d, 0x41, 0x54, 0x45   ; d498 : -FORMATE
	db 0x44, 0x20, 0x45, 0x44, 0x49, 0x54, 0x05, 0x44   ; d4a0 : D EDIT.D
	db 0x2d, 0x44, 0x49, 0x53, 0x50, 0x4c, 0x41, 0x59   ; d4a8 : -DISPLAY
	db 0x20, 0x52, 0x45, 0x53, 0x55, 0x4d, 0x45, 0x05   ; d4b0 :  RESUME.
	db 0x52, 0x2d, 0x52, 0x45, 0x43, 0x41, 0x4c, 0x4c   ; d4b8 : R-RECALL
	db 0x20, 0x50, 0x41, 0x47, 0x45, 0x05, 0x53, 0x2d   ; d4c0 :  PAGE.S-
	db 0x53, 0x54, 0x4f, 0x52, 0x45, 0x20, 0x50, 0x41   ; d4c8 : STORE PA
	db 0x47, 0x45, 0x05, 0x4e, 0x2d, 0x4e, 0x45, 0x58   ; d4d0 : GE.N-NEX
	db 0x54, 0x20, 0x50, 0x41, 0x47, 0x45, 0x05, 0x4c   ; d4d8 : T PAGE.L
	db 0x2d, 0x4c, 0x41, 0x53, 0x54, 0x20, 0x50, 0x41   ; d4e0 : -LAST PA
	db 0x47, 0x45, 0x05, 0x43, 0x2d, 0x43, 0x4c, 0x4f   ; d4e8 : GE.C-CLO
	db 0x43, 0x4b, 0x20, 0x53, 0x45, 0x54, 0x05, 0x50   ; d4f0 : CK SET.P
	db 0x2d, 0x50, 0x41, 0x47, 0x45, 0x20, 0x43, 0x4f   ; d4f8 : -PAGE CO
	db 0x50, 0x59, 0x05, 0x4d, 0x2d, 0x4d, 0x45, 0x4d   ; d500 : PY.M-MEM
	db 0x4f, 0x52, 0x59, 0x20, 0x53, 0x45, 0x54, 0x05   ; d508 : ORY SET.
	db 0x58, 0x2d, 0x45, 0x58, 0x54, 0x45, 0x52, 0x4e   ; d510 : X-EXTERN
	db 0x41, 0x4c, 0x20, 0x4c, 0x49, 0x4e, 0x45, 0x20   ; d518 : AL LINE 
	db 0x4c, 0x45, 0x56, 0x45, 0x4c, 0x53, 0x05, 0x42   ; d520 : LEVELS.B
	db 0x2d, 0x42, 0x4c, 0x4f, 0x43, 0x4b, 0x20, 0x45   ; d528 : -BLOCK E
	db 0x44, 0x49, 0x54, 0x05, 0x48, 0x2d, 0x48, 0x45   ; d530 : DIT.H-HE
	db 0x4c, 0x50, 0x20, 0x4d, 0x45, 0x4e, 0x55, 0x20   ; d538 : LP MENU 
	db 0x46, 0x4f, 0x52, 0x20, 0x43, 0x4f, 0x4e, 0x54   ; d540 : FOR CONT
	db 0x52, 0x4f, 0x4c, 0x20, 0x43, 0x4f, 0x44, 0x45   ; d548 : ROL CODE
	db 0x53, 0x05, 0x53, 0x45, 0x54, 0x55, 0x50, 0x2d   ; d550 : S.SETUP-
	db 0x4e, 0x45, 0x58, 0x54, 0x20, 0x4d, 0x45, 0x4e   ; d558 : NEXT MEN
	db 0x55, 0x53, 0x45, 0x4c, 0x45, 0x43, 0x54, 0x05   ; d560 : USELECT.
	db 0x05, 0x43, 0x2d, 0x43, 0x48, 0x41, 0x4e, 0x4e   ; d568 : .C-CHANN
	db 0x45, 0x4c, 0x20, 0x52, 0x45, 0x47, 0x49, 0x4f   ; d570 : EL REGIO
	db 0x4e, 0x20, 0x53, 0x45, 0x54, 0x55, 0x50, 0x05   ; d578 : N SETUP.
	db 0x53, 0x2d, 0x53, 0x45, 0x51, 0x55, 0x45, 0x4e   ; d580 : S-SEQUEN
	db 0x43, 0x45, 0x05, 0x45, 0x2d, 0x45, 0x56, 0x45   ; d588 : CE.E-EVE
	db 0x4e, 0x54, 0x53, 0x05, 0x4e, 0x2d, 0x4e, 0x45   ; d590 : NTS.N-NE
	db 0x58, 0x54, 0x20, 0x45, 0x56, 0x45, 0x4e, 0x54   ; d598 : XT EVENT
	db 0x05, 0x4c, 0x2d, 0x4c, 0x41, 0x53, 0x54, 0x20   ; d5a0 : .L-LAST 
	db 0x45, 0x56, 0x45, 0x4e, 0x54, 0x05, 0x44, 0x2d   ; d5a8 : EVENT.D-
	db 0x44, 0x41, 0x54, 0x41, 0x20, 0x45, 0x58, 0x54   ; d5b0 : DATA EXT
	db 0x45, 0x52, 0x4e, 0x41, 0x4c, 0x20, 0x53, 0x4f   ; d5b8 : ERNAL SO
	db 0x55, 0x52, 0x43, 0x45, 0x05, 0x57, 0x2d, 0x57   ; d5c0 : URCE.W-W
	db 0x45, 0x41, 0x54, 0x48, 0x45, 0x52, 0x20, 0x53   ; d5c8 : EATHER S
	db 0x45, 0x54, 0x55, 0x50, 0x05, 0x42, 0x2d, 0x42   ; d5d0 : ETUP.B-B
	db 0x41, 0x54, 0x43, 0x48, 0x20, 0x54, 0x52, 0x41   ; d5d8 : ATCH TRA
	db 0x4e, 0x53, 0x46, 0x45, 0x52, 0x05, 0x52, 0x2d   ; d5e0 : NSFER.R-
	db 0x52, 0x45, 0x4d, 0x4f, 0x54, 0x45, 0x20, 0x45   ; d5e8 : REMOTE E
	db 0x44, 0x49, 0x54, 0x05, 0x4b, 0x2d, 0x4b, 0x45   ; d5f0 : DIT.K-KE
	db 0x59, 0x42, 0x4f, 0x41, 0x52, 0x44, 0x20, 0x44   ; d5f8 : YBOARD D
	db 0x49, 0x52, 0x45, 0x43, 0x54, 0x05, 0x41, 0x2d   ; d600 : IRECT.A-
	db 0x41, 0x55, 0x54, 0x48, 0x4f, 0x52, 0x49, 0x5a   ; d608 : AUTHORIZ
	db 0x41, 0x54, 0x49, 0x4f, 0x4e, 0x20, 0x43, 0x4f   ; d610 : ATION CO
	db 0x44, 0x45, 0x53, 0x4b, 0x45, 0x59, 0x42, 0x4f   ; d618 : DESKEYBO
	db 0x41, 0x52, 0x44, 0x20, 0x44, 0x49, 0x52, 0x45   ; d620 : ARD DIRE
	db 0x43, 0x54, 0x20, 0x20, 0x53, 0x59, 0x53, 0x54   ; d628 : CT  SYST
	db 0x45, 0x4d, 0x20, 0x4e, 0x41, 0x4d, 0x45, 0x20   ; d630 : EM NAME 
	db 0x20, 0x20, 0x05, 0x4f, 0x4e, 0x20, 0x4c, 0x49   ; d638 :   .ON LI
	db 0x4e, 0x45, 0x20, 0x52, 0x45, 0x4d, 0x4f, 0x54   ; d640 : NE REMOT
	db 0x45, 0x20, 0x45, 0x44, 0x49, 0x54, 0x20, 0x20   ; d648 : E EDIT  
	db 0x53, 0x59, 0x53, 0x54, 0x45, 0x4d, 0x20, 0x4e   ; d650 : SYSTEM N
	db 0x41, 0x4d, 0x45, 0x20, 0x20, 0x20, 0x05, 0x45   ; d658 : AME   .E
	db 0x52, 0x52, 0x4f, 0x52, 0x05, 0x43, 0x4f, 0x4d   ; d660 : RROR.COM
	db 0x50, 0x4c, 0x45, 0x54, 0x45, 0x42, 0x41, 0x54   ; d668 : PLETEBAT
	db 0x43, 0x48, 0x20, 0x54, 0x52, 0x41, 0x4e, 0x53   ; d670 : CH TRANS
	db 0x46, 0x45, 0x52, 0x20, 0x20, 0x53, 0x59, 0x53   ; d678 : FER  SYS
	db 0x54, 0x45, 0x4d, 0x20, 0x4e, 0x41, 0x4d, 0x45   ; d680 : TEM NAME
	db 0x20, 0x20, 0x20, 0x20, 0x05, 0x44, 0x49, 0x52   ; d688 :     .DIR
	db 0x45, 0x43, 0x54, 0x49, 0x4f, 0x4e, 0x20, 0x20   ; d690 : ECTION  
	db 0x20, 0x20, 0x20, 0x28, 0x53, 0x3d, 0x53, 0x45   ; d698 :    (S=SE
	db 0x4e, 0x44, 0x20, 0x46, 0x3d, 0x46, 0x45, 0x54   ; d6a0 : ND F=FET
	db 0x43, 0x48, 0x29, 0x05, 0x05, 0x53, 0x4f, 0x55   ; d6a8 : CH)..SOU
	db 0x52, 0x43, 0x45, 0x20, 0x20, 0x53, 0x4f, 0x55   ; d6b0 : RCE  SOU
	db 0x52, 0x43, 0x45, 0x20, 0x20, 0x44, 0x45, 0x53   ; d6b8 : RCE  DES
	db 0x54, 0x49, 0x4e, 0x20, 0x20, 0x50, 0x52, 0x45   ; d6c0 : TIN  PRE
	db 0x53, 0x45, 0x4e, 0x54, 0x05, 0x20, 0x46, 0x49   ; d6c8 : SENT. FI
	db 0x52, 0x53, 0x54, 0x20, 0x20, 0x20, 0x4c, 0x41   ; d6d0 : RST   LA
	db 0x53, 0x54, 0x20, 0x20, 0x20, 0x20, 0x46, 0x49   ; d6d8 : ST    FI
	db 0x52, 0x53, 0x54, 0x20, 0x20, 0x54, 0x52, 0x41   ; d6e0 : RST  TRA
	db 0x4e, 0x53, 0x46, 0x45, 0x52, 0x05, 0x20, 0x30   ; d6e8 : NSFER. 0
	db 0x30, 0x30, 0x30, 0x20, 0x20, 0x20, 0x20, 0x30   ; d6f0 : 000    0
	db 0x30, 0x30, 0x30, 0x20, 0x20, 0x20, 0x20, 0x30   ; d6f8 : 000    0
	db 0x30, 0x30, 0x30, 0x20, 0x20, 0x20, 0x20, 0x30   ; d700 : 000    0
	db 0x30, 0x30, 0x30, 0x05, 0x4c, 0x4f, 0x47, 0x4f   ; d708 : 000.LOGO
	db 0x4e, 0x20, 0x49, 0x44, 0x20, 0x20, 0x20, 0x20   ; d710 : N ID    
	db 0x20, 0x20, 0x20, 0x20, 0x05, 0x4e, 0x4f, 0x20   ; d718 :     .NO 
	db 0x41, 0x43, 0x43, 0x45, 0x53, 0x53, 0x20, 0x20   ; d720 : ACCESS  
	db 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20   ; d728 :         
	db 0x05, 0x4f, 0x46, 0x46, 0x20, 0x4c, 0x49, 0x4e   ; d730 : .OFF LIN
	db 0x45, 0x20, 0x4c, 0x49, 0x4d, 0x49, 0x54, 0x20   ; d738 : E LIMIT 
	db 0x52, 0x45, 0x4d, 0x4f, 0x54, 0x45, 0x20, 0x41   ; d740 : REMOTE A
	db 0x43, 0x43, 0x45, 0x53, 0x53, 0x3f, 0x20, 0x20   ; d748 : CCESS?  
	db 0x20, 0x20, 0x28, 0x59, 0x20, 0x2f, 0x20, 0x4e   ; d750 :   (Y / N
	db 0x29, 0x05, 0x55, 0x53, 0x45, 0x52, 0x20, 0x43   ; d758 : ).USER C
	db 0x4f, 0x44, 0x45, 0x20, 0x20, 0x53, 0x54, 0x41   ; d760 : ODE  STA
	db 0x52, 0x54, 0x20, 0x50, 0x41, 0x47, 0x45, 0x20   ; d768 : RT PAGE 
	db 0x20, 0x53, 0x54, 0x4f, 0x50, 0x20, 0x50, 0x41   ; d770 :  STOP PA
	db 0x47, 0x45, 0x0f, 0x45, 0x58, 0x54, 0x45, 0x52   ; d778 : GE.EXTER
	db 0x4e, 0x41, 0x4c, 0x20, 0x44, 0x41, 0x54, 0x41   ; d780 : NAL DATA
	db 0x20, 0x53, 0x45, 0x4c, 0x45, 0x43, 0x54, 0x20   ; d788 :  SELECT 
	db 0x20, 0x05, 0x05, 0x31, 0x20, 0x41, 0x50, 0x05   ; d790 :  ..1 AP.
	db 0x32, 0x20, 0x55, 0x50, 0x49, 0x05, 0x33, 0x20   ; d798 : 2 UPI.3 
	db 0x52, 0x45, 0x55, 0x54, 0x45, 0x52, 0x53, 0x05   ; d7a0 : REUTERS.
	db 0x34, 0x20, 0x4e, 0x4f, 0x41, 0x41, 0x05, 0x35   ; d7a8 : 4 NOAA.5
	db 0x20, 0x53, 0x54, 0x4f, 0x43, 0x4b, 0x53, 0x05   ; d7b0 :  STOCKS.
	db 0x36, 0x20, 0x42, 0x52, 0x4f, 0x41, 0x44, 0x43   ; d7b8 : 6 BROADC
	db 0x41, 0x53, 0x54, 0x05, 0x37, 0x20, 0x44, 0x4f   ; d7c0 : AST.7 DO
	db 0x57, 0x20, 0x4a, 0x4f, 0x4e, 0x45, 0x53, 0x0f   ; d7c8 : W JONES.
	db 0x41, 0x50, 0x0f, 0x55, 0x50, 0x49, 0x0f, 0x52   ; d7d0 : AP.UPI.R
	db 0x45, 0x55, 0x54, 0x45, 0x52, 0x53, 0x20, 0x4e   ; d7d8 : EUTERS N
	db 0x45, 0x57, 0x53, 0x20, 0x53, 0x50, 0x4c, 0x49   ; d7e0 : EWS SPLI
	db 0x54, 0x53, 0x05, 0x50, 0x41, 0x47, 0x45, 0x20   ; d7e8 : TS.PAGE 
	db 0x42, 0x4c, 0x4f, 0x43, 0x4b, 0x20, 0x53, 0x54   ; d7f0 : BLOCK ST
	db 0x41, 0x52, 0x54, 0x20, 0x50, 0x41, 0x47, 0x45   ; d7f8 : ART PAGE
	db 0x20, 0x53, 0x54, 0x4f, 0x50, 0x20, 0x50, 0x41   ; d800 :  STOP PA
	db 0x47, 0x45, 0x05, 0x20, 0x20, 0x20, 0x20, 0x31   ; d808 : GE.    1
	db 0x08, 0x0b, 0x32, 0x08, 0x0b, 0x33, 0x08, 0x0b   ; d810 : ..2..3..
	db 0x34, 0x08, 0x0b, 0x35, 0x08, 0x0b, 0x36, 0x08   ; d818 : 4..5..6.
	db 0x0b, 0x37, 0x08, 0x0b, 0x38, 0x05, 0x05, 0x4e   ; d820 : .7..8..N
	db 0x45, 0x57, 0x53, 0x20, 0x43, 0x41, 0x54, 0x45   ; d828 : EWS CATE
	db 0x47, 0x4f, 0x52, 0x59, 0x20, 0x20, 0x20, 0x42   ; d830 : GORY   B
	db 0x4c, 0x4f, 0x43, 0x4b, 0x05, 0x47, 0x45, 0x4e   ; d838 : LOCK.GEN
	db 0x45, 0x52, 0x41, 0x4c, 0x20, 0x4e, 0x45, 0x57   ; d840 : ERAL NEW
	db 0x53, 0x05, 0x52, 0x45, 0x47, 0x49, 0x4f, 0x4e   ; d848 : S.REGION
	db 0x41, 0x4c, 0x20, 0x4e, 0x45, 0x57, 0x53, 0x05   ; d850 : AL NEWS.
	db 0x46, 0x49, 0x4e, 0x41, 0x4e, 0x43, 0x49, 0x41   ; d858 : FINANCIA
	db 0x4c, 0x05, 0x53, 0x54, 0x4f, 0x43, 0x4b, 0x53   ; d860 : L.STOCKS
	db 0x05, 0x53, 0x50, 0x4f, 0x52, 0x54, 0x53, 0x05   ; d868 : .SPORTS.
	db 0x53, 0x50, 0x4f, 0x52, 0x54, 0x53, 0x20, 0x53   ; d870 : SPORTS S
	db 0x43, 0x4f, 0x52, 0x45, 0x53, 0x05, 0x42, 0x55   ; d878 : CORES.BU
	db 0x4c, 0x4c, 0x45, 0x54, 0x49, 0x4e, 0x53, 0x05   ; d880 : LLETINS.
	db 0x46, 0x45, 0x41, 0x54, 0x55, 0x52, 0x45, 0x53   ; d888 : FEATURES
	db 0x45, 0x4e, 0x54, 0x45, 0x52, 0x0b, 0x08, 0x08   ; d890 : ENTER...
	db 0x08, 0x08, 0x08, 0x30, 0x3d, 0x4e, 0x4f, 0x4e   ; d898 : ...0=NON
	db 0x45, 0x0b, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08   ; d8a0 : E.......
	db 0x31, 0x20, 0x54, 0x4f, 0x0b, 0x08, 0x08, 0x08   ; d8a8 : 1 TO....
	db 0x08, 0x20, 0x20, 0x20, 0x20, 0x20, 0x50, 0x4f   ; d8b0 : .     PO
	db 0x52, 0x54, 0x20, 0x4f, 0x50, 0x54, 0x49, 0x4f   ; d8b8 : RT OPTIO
	db 0x4e, 0x20, 0x20, 0x20, 0x20, 0x30, 0x3d, 0x4e   ; d8c0 : N    0=N
	db 0x4f, 0x54, 0x20, 0x55, 0x53, 0x45, 0x44, 0x0b   ; d8c8 : OT USED.
	db 0x31, 0x3d, 0x55, 0x53, 0x45, 0x20, 0x52, 0x45   ; d8d0 : 1=USE RE
	db 0x4d, 0x4f, 0x54, 0x45, 0x0b, 0x32, 0x3d, 0x55   ; d8d8 : MOTE.2=U
	db 0x53, 0x45, 0x20, 0x55, 0x50, 0x49, 0x20, 0x50   ; d8e0 : SE UPI P
	db 0x4f, 0x52, 0x54, 0x4f, 0x50, 0x54, 0x49, 0x4f   ; d8e8 : ORTOPTIO
	db 0x4e, 0x20, 0x4e, 0x4f, 0x54, 0x20, 0x45, 0x4e   ; d8f0 : N NOT EN
	db 0x41, 0x42, 0x4c, 0x45, 0x44, 0x42, 0x52, 0x4f   ; d8f8 : ABLEDBRO
	db 0x41, 0x44, 0x43, 0x41, 0x53, 0x54, 0x20, 0x4e   ; d900 : ADCAST N
	db 0x45, 0x57, 0x53, 0x0f, 0x20, 0x20, 0x20, 0x20   ; d908 : EWS.    
	db 0x20, 0x20, 0x4e, 0x4f, 0x41, 0x41, 0x20, 0x57   ; d910 :   NOAA W
	db 0x45, 0x41, 0x54, 0x48, 0x45, 0x52, 0x20, 0x53   ; d918 : EATHER S
	db 0x45, 0x52, 0x56, 0x49, 0x43, 0x45, 0x05, 0x05   ; d920 : ERVICE..
	db 0x20, 0x53, 0x54, 0x41, 0x52, 0x54, 0x20, 0x20   ; d928 :  START  
	db 0x53, 0x54, 0x4f, 0x50, 0x20, 0x20, 0x57, 0x4f   ; d930 : STOP  WO
	db 0x52, 0x44, 0x20, 0x20, 0x4f, 0x50, 0x45, 0x4e   ; d938 : RD  OPEN
	db 0x05, 0x20, 0x50, 0x41, 0x47, 0x45, 0x20, 0x20   ; d940 : . PAGE  
	db 0x20, 0x50, 0x41, 0x47, 0x45, 0x20, 0x20, 0x57   ; d948 :  PAGE  W
	db 0x52, 0x41, 0x50, 0x20, 0x20, 0x43, 0x4f, 0x44   ; d950 : RAP  COD
	db 0x45, 0x05, 0x05, 0x49, 0x4e, 0x50, 0x55, 0x54   ; d958 : E..INPUT
	db 0x20, 0x20, 0x20, 0x20, 0x41, 0x3d, 0x41, 0x53   ; d960 :     A=AS
	db 0x43, 0x49, 0x49, 0x2c, 0x42, 0x3d, 0x42, 0x41   ; d968 : CII,B=BA
	db 0x55, 0x44, 0x4f, 0x54, 0x53, 0x45, 0x54, 0x20   ; d970 : UDOTSET 
	db 0x50, 0x41, 0x47, 0x45, 0x53, 0x20, 0x30, 0x30   ; d978 : PAGES 00
	db 0x30, 0x30, 0x20, 0x54, 0x4f, 0x20, 0x30, 0x30   ; d980 : 00 TO 00
	db 0x30, 0x30, 0x4d, 0x45, 0x4d, 0x4f, 0x52, 0x59   ; d988 : 00MEMORY
	db 0x20, 0x53, 0x45, 0x54, 0x50, 0x41, 0x47, 0x45   ; d990 :  SETPAGE
	db 0x43, 0x4f, 0x50, 0x59, 0x20, 0x30, 0x30, 0x30   ; d998 : COPY 000
	db 0x20, 0x50, 0x41, 0x47, 0x45, 0x53, 0x20, 0x46   ; d9a0 :  PAGES F
	db 0x52, 0x4f, 0x4d, 0x20, 0x30, 0x30, 0x30, 0x30   ; d9a8 : ROM 0000
	db 0x20, 0x54, 0x4f, 0x20, 0x30, 0x30, 0x30, 0x30   ; d9b0 :  TO 0000
	db 0x50, 0x41, 0x47, 0x45, 0x20, 0x43, 0x4f, 0x50   ; d9b8 : PAGE COP
	db 0x59, 0x20, 0x43, 0x4f, 0x4d, 0x50, 0x4c, 0x45   ; d9c0 : Y COMPLE
	db 0x54, 0x45, 0x53, 0x54, 0x41, 0x52, 0x54, 0x20   ; d9c8 : TESTART 
	db 0x50, 0x41, 0x47, 0x45, 0x20, 0x20, 0x20, 0x53   ; d9d0 : PAGE   S
	db 0x54, 0x4f, 0x50, 0x20, 0x50, 0x41, 0x47, 0x45   ; d9d8 : TOP PAGE
	db 0x20, 0x43, 0x4c, 0x4f, 0x43, 0x4b, 0x20, 0x43   ; d9e0 :  CLOCK C
	db 0x48, 0x49, 0x50, 0x20, 0x41, 0x43, 0x54, 0x49   ; d9e8 : HIP ACTI
	db 0x56, 0x45										; d9f0 : VE
REF_TEXT_TEMP_US
	db             0x54, 0x45, 0x4d, 0x50, 0x2e, 0x20   ; d9f2 :   TEMP. 
	db 0x30, 0x30, 0x30, 0x5c, 0x46, 0x5e, 0x20, 0x20   ; d9f8 : 000\F^  
	db 0x20, 0x20, 0x48, 0x49, 0x20, 0x30, 0x30, 0x30   ; da00 :   HI 000
	db 0x5c, 0x20, 0x4c, 0x4f, 0x20, 0x30, 0x30, 0x30   ; da08 : \ LO 000
	db 0x5c, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20   ; da10 : \       
	db 0x20, 0x20, 0x57, 0x49, 0x4e, 0x44, 0x20, 0x30   ; da18 :   WIND 0
	db 0x30, 0x2d, 0x30, 0x30, 0x20, 0x4d, 0x50, 0x48   ; da20 : 0-00 MPH
	db 0x20, 0x20, 0x46, 0x52, 0x4f, 0x4d, 0x20, 0x20   ; da28 :   FROM  
	db 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20   ; da30 :         
	db 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20   ; da38 :         
	db 0x20, 0x20, 0x42, 0x41, 0x52, 0x4f, 0x2e, 0x20   ; da40 :   BARO. 
	db 0x30, 0x30, 0x2e, 0x30, 0x30, 0x22, 0x20, 0x5e   ; da48 : 00.00" ^
	db 0x20, 0x20, 0x48, 0x55, 0x4d, 0x49, 0x44, 0x49   ; da50 :   HUMIDI
	db 0x54, 0x59, 0x20, 0x20, 0x30, 0x30, 0x25, 0x20   ; da58 : TY  00% 
	db 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20   ; da60 :         
	db 0x20, 0x20, 0x52, 0x41, 0x49, 0x4e, 0x20, 0x44   ; da68 :   RAIN D
	db 0x41, 0x59, 0x20, 0x30, 0x2e, 0x30, 0x30, 0x22   ; da70 : AY 0.00"
	db 0x20, 0x20, 0x4d, 0x4f, 0x4e, 0x54, 0x48, 0x20   ; da78 :   MONTH 
	db 0x30, 0x30, 0x2e, 0x30, 0x30, 0x22, 0x20, 0x20   ; da80 : 00.00"  
	db 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20   ; da88 :         
	db 0x20, 0x20
REF_TEXT_TEMP_SI:
	db             0x54, 0x45, 0x4d, 0x50, 0x2e, 0x20   ; da92 :   TEMP. 
	db 0x30, 0x30, 0x30, 0x5c, 0x43, 0x5e, 0x20, 0x20   ; da98 : 000\C^  
	db 0x20, 0x20, 0x48, 0x49, 0x20, 0x30, 0x30, 0x30   ; daa0 :   HI 000
	db 0x5c, 0x20, 0x4c, 0x4f, 0x20, 0x30, 0x30, 0x30   ; daa8 : \ LO 000
	db 0x5c, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20   ; dab0 : \       
	db 0x20, 0x20, 0x57, 0x49, 0x4e, 0x44, 0x20, 0x30   ; dab8 :   WIND 0
	db 0x30, 0x2d, 0x30, 0x30, 0x20, 0x4b, 0x4d, 0x2f   ; dac0 : 0-00 KM/
	db 0x48, 0x20, 0x46, 0x52, 0x4f, 0x4d, 0x20, 0x20   ; dac8 : H FROM  
	db 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20   ; dad0 :         
	db 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20   ; dad8 :         
	db 0x20, 0x20, 0x42, 0x41, 0x52, 0x4f, 0x20, 0x30   ; dae0 :   BARO 0
	db 0x30, 0x30, 0x2e, 0x30, 0x20, 0x4b, 0x50, 0x41   ; dae8 : 00.0 KPA
	db 0x5e, 0x20, 0x48, 0x55, 0x4d, 0x49, 0x44, 0x49   ; daf0 : ^ HUMIDI
	db 0x54, 0x59, 0x20, 0x20, 0x30, 0x30, 0x25, 0x20   ; daf8 : TY  00% 
	db 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20   ; db00 :         
	db 0x20, 0x20, 0x52, 0x41, 0x49, 0x4e, 0x20, 0x44   ; db08 :   RAIN D
	db 0x41, 0x59, 0x20, 0x30, 0x30, 0x2e, 0x30, 0x43   ; db10 : AY 00.0C
	db 0x4d, 0x20, 0x4d, 0x4f, 0x4e, 0x54, 0x48, 0x20   ; db18 : M MONTH 
	db 0x30, 0x30, 0x30, 0x2e, 0x30, 0x43, 0x4d, 0x20   ; db20 : 000.0CM 
	db 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20   ; db28 :         
	db 0x20, 0x20, 0x0f, 0x57, 0x45, 0x41, 0x54, 0x48   ; db30 :   .WEATH
	db 0x45, 0x52, 0x20, 0x4d, 0x45, 0x4e, 0x55, 0x20   ; db38 : ER MENU 
	db 0x53, 0x45, 0x4c, 0x45, 0x43, 0x54, 0x05, 0x05   ; db40 : SELECT..
	db 0x31, 0x20, 0x55, 0x2e, 0x53, 0x2e, 0x20, 0x53   ; db48 : 1 U.S. S
	db 0x59, 0x53, 0x54, 0x45, 0x4d, 0x05, 0x32, 0x20   ; db50 : YSTEM.2 
	db 0x4d, 0x45, 0x54, 0x52, 0x49, 0x43, 0x20, 0x53   ; db58 : METRIC S
	db 0x59, 0x53, 0x54, 0x45, 0x4d						; db60 : YSTEM
WEATHER_FIELDS_LENGTHS:
	db 0x28, 0x28, 0x10, 0x18, 0x28
	db             0x05, 0x4c, 0x49, 0x4e, 0x45, 0x20   ; db68 :   .LINE 
	db 0x4c, 0x45, 0x56, 0x45, 0x4c, 0x53, 0x05, 0x05   ; db70 : LEVELS..
	db 0x4f, 0x55, 0x54, 0x20, 0x20, 0x20, 0x20, 0x20   ; db78 : OUT     
	db 0x31, 0x20, 0x20, 0x32, 0x20, 0x20, 0x33, 0x20   ; db80 : 1  2  3 
	db 0x20, 0x34, 0x05, 0x05, 0x05, 0x20, 0x48, 0x3d   ; db88 :  4... H=
	db 0x48, 0x49, 0x47, 0x48, 0x2c, 0x20, 0x4c, 0x3d   ; db90 : HIGH, L=
	db 0x4c, 0x4f, 0x57, 0x2c, 0x20, 0x4e, 0x3d, 0x4e   ; db98 : LOW, N=N
	db 0x4f, 0x20, 0x43, 0x48, 0x41, 0x4e, 0x47, 0x45   ; dba0 : O CHANGE
	db 0x05, 0x05, 0x05, 0x49, 0x4e, 0x20, 0x20, 0x20   ; dba8 : ...IN   
	db 0x20, 0x20, 0x20, 0x31, 0x20, 0x20, 0x32, 0x05   ; dbb0 :    1  2.
	db 0x05, 0x41, 0x43, 0x54, 0x49, 0x4f, 0x4e, 0x20   ; dbb8 : .ACTION 
	db 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x4e   ; dbc0 :        N
	db 0x3d, 0x4e, 0x4f, 0x4e, 0x45, 0x2c, 0x20, 0x50   ; dbc8 : =NONE, P
	db 0x3d, 0x50, 0x41, 0x47, 0x45, 0x20, 0x45, 0x4e   ; dbd0 : =PAGE EN
	db 0x44, 0x05, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20   ; dbd8 : D.      
	db 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20   ; dbe0 :         
	db 0x53, 0x3d, 0x53, 0x45, 0x51, 0x55, 0x45, 0x4e   ; dbe8 : S=SEQUEN
	db 0x43, 0x45, 0x20, 0x52, 0x45, 0x53, 0x45, 0x54   ; dbf0 : CE RESET
	db 0x05, 0x05, 0x52, 0x45, 0x47, 0x49, 0x4f, 0x4e   ; dbf8 : ..REGION
	db 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20   ; dc00 :         
	db 0x31, 0x20, 0x54, 0x4f, 0x20, 0x36, 0x20, 0x4f   ; dc08 : 1 TO 6 O
	db 0x52, 0x20, 0x41, 0x3d, 0x41, 0x4c, 0x4c, 0x05   ; dc10 : R A=ALL.
	db 0x41, 0x43, 0x54, 0x49, 0x4f, 0x4e, 0x20, 0x20   ; dc18 : ACTION  
	db 0x4c, 0x20, 0x20, 0x20, 0x20, 0x20, 0x4c, 0x3d   ; dc20 : L     L=
	db 0x4c, 0x49, 0x4e, 0x45, 0x20, 0x4c, 0x45, 0x56   ; dc28 : LINE LEV
	db 0x45, 0x4c, 0x53, 0x05, 0x20, 0x20, 0x20, 0x20   ; dc30 : ELS.    
	db 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20   ; dc38 :         
	db 0x20, 0x20, 0x54, 0x3d, 0x4f, 0x55, 0x54, 0x50   ; dc40 :   T=OUTP
	db 0x55, 0x54, 0x20, 0x54, 0x4f, 0x20, 0x56, 0x54   ; dc48 : UT TO VT
	db 0x52, 0x20, 0x42, 0x4c, 0x4f, 0x43, 0x4b, 0x20   ; dc50 : R BLOCK 
	db 0x45, 0x44, 0x49, 0x54, 0x05, 0x05, 0x20, 0x46   ; dc58 : EDIT.. F
	db 0x49, 0x52, 0x53, 0x54, 0x20, 0x20, 0x4c, 0x41   ; dc60 : IRST  LA
	db 0x53, 0x54, 0x05, 0x20, 0x50, 0x41, 0x47, 0x45   ; dc68 : ST. PAGE
	db 0x20, 0x20, 0x20, 0x50, 0x41, 0x47, 0x45, 0x05   ; dc70 :    PAGE.
	db 0x05, 0x20, 0x45, 0x56, 0x45, 0x4e, 0x54, 0x20   ; dc78 : . EVENT 
	db 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x41   ; dc80 :        A
	db 0x43, 0x54, 0x49, 0x56, 0x45, 0x20, 0x20, 0x20   ; dc88 : CTIVE   
	db 0x20, 0x20, 0x59, 0x20, 0x4f, 0x52, 0x20, 0x4e   ; dc90 :   Y OR N
	db 0x05, 0x05, 0x4d, 0x49, 0x4e, 0x55, 0x54, 0x45   ; dc98 : ..MINUTE
	db 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x30, 0x20   ; dca0 :       0 
	db 0x54, 0x4f, 0x20, 0x35, 0x39, 0x05, 0x48, 0x4f   ; dca8 : TO 59.HO
	db 0x55, 0x52, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20   ; dcb0 : UR      
	db 0x20, 0x20, 0x31, 0x20, 0x54, 0x4f, 0x20, 0x31   ; dcb8 :   1 TO 1
	db 0x32, 0x2c, 0x20, 0x41, 0x3d, 0x41, 0x4c, 0x4c   ; dcc0 : 2, A=ALL
	db 0x05, 0x41, 0x4d, 0x2f, 0x50, 0x4d, 0x20, 0x20   ; dcc8 : .AM/PM  
	db 0x20, 0x20, 0x20, 0x20, 0x20, 0x41, 0x3d, 0x41   ; dcd0 :      A=A
	db 0x4d, 0x2c, 0x20, 0x50, 0x3d, 0x50, 0x4d, 0x05   ; dcd8 : M, P=PM.
	db 0x44, 0x41, 0x59, 0x20, 0x20, 0x20, 0x20, 0x20   ; dce0 : DAY     
	db 0x20, 0x20, 0x20, 0x20, 0x31, 0x20, 0x54, 0x4f   ; dce8 :     1 TO
	db 0x20, 0x37, 0x2c, 0x20, 0x41, 0x3d, 0x41, 0x4c   ; dcf0 :  7, A=AL
	db 0x4c, 0x05, 0x41, 0x43, 0x54, 0x49, 0x4f, 0x4e   ; dcf8 : L.ACTION
	db 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x4c, 0x3d   ; dd00 :       L=
	db 0x4c, 0x45, 0x56, 0x45, 0x4c, 0x53, 0x2c, 0x20   ; dd08 : LEVELS, 
	db 0x53, 0x3d, 0x53, 0x45, 0x51, 0x55, 0x45, 0x4e   ; dd10 : S=SEQUEN
	db 0x43, 0x45, 0x05, 0x05, 0x54, 0x3d, 0x54, 0x41   ; dd18 : CE..T=TA
	db 0x50, 0x45, 0x05, 0x05, 0x42, 0x3d, 0x42, 0x41   ; dd20 : PE..B=BA
	db 0x54, 0x43, 0x48, 0x20, 0x54, 0x2e, 0x05, 0x05   ; dd28 : TCH T...
	db 0x54, 0x59, 0x50, 0x45, 0x20, 0x20, 0x20, 0x20   ; dd30 : TYPE    
	db 0x20, 0x46, 0x3d, 0x46, 0x49, 0x4c, 0x45, 0x20   ; dd38 :  F=FILE 
	db 0x43, 0x48, 0x41, 0x4e, 0x47, 0x45, 0x2c, 0x20   ; dd40 : CHANGE, 
	db 0x49, 0x3d, 0x49, 0x4e, 0x53, 0x45, 0x52, 0x54   ; dd48 : I=INSERT
	db 0x05, 0x54, 0x49, 0x4d, 0x49, 0x4e, 0x47, 0x20   ; dd50 : .TIMING 
	db 0x20, 0x20, 0x49, 0x3d, 0x49, 0x4d, 0x4d, 0x45   ; dd58 :   I=IMME
	db 0x44, 0x49, 0x41, 0x54, 0x45, 0x2c, 0x20, 0x44   ; dd60 : DIATE, D
	db 0x3d, 0x44, 0x45, 0x4c, 0x41, 0x59, 0x45, 0x44   ; dd68 : =DELAYED
	db 0x05, 0x52, 0x45, 0x47, 0x49, 0x4f, 0x4e, 0x20   ; dd70 : .REGION 
	db 0x20, 0x20, 0x31, 0x20, 0x54, 0x4f, 0x20, 0x36   ; dd78 :   1 TO 6
	db 0x46, 0x49, 0x4c, 0x45, 0x20, 0x20, 0x53, 0x54   ; dd80 : FILE  ST
	db 0x41, 0x52, 0x54, 0x20, 0x20, 0x20, 0x53, 0x54   ; dd88 : ART   ST
	db 0x4f, 0x50, 0x20, 0x20, 0x43, 0x48, 0x41, 0x4e   ; dd90 : OP  CHAN
	db 0x47, 0x45, 0x05, 0x20, 0x20, 0x20, 0x20, 0x20   ; dd98 : GE.     
	db 0x20, 0x20, 0x50, 0x41, 0x47, 0x45, 0x20, 0x20   ; dda0 :   PAGE  
	db 0x20, 0x50, 0x41, 0x47, 0x45, 0x20, 0x20, 0x20   ; dda8 :  PAGE   
	db 0x46, 0x49, 0x4c, 0x45, 0x05, 0x05, 0x20, 0x20   ; ddb0 : FILE..  
	db 0x31, 0x05, 0x20, 0x20, 0x32, 0x05, 0x20, 0x20   ; ddb8 : 1.  2.  
	db 0x33, 0x05, 0x20, 0x20, 0x34, 0x20, 0x20, 0x20   ; ddc0 : 3.  4   
	db 0x20, 0x20, 0x20, 0x53, 0x54, 0x41, 0x52, 0x54   ; ddc8 :    START
	db 0x20, 0x20, 0x20, 0x53, 0x54, 0x4f, 0x50, 0x05   ; ddd0 :    STOP.
	db 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x50   ; ddd8 :        P
	db 0x41, 0x47, 0x45, 0x20, 0x20, 0x20, 0x50, 0x41   ; dde0 : AGE   PA
	db 0x47, 0x45, 0x53, 0x54, 0x4f, 0x52, 0x45, 0x20   ; dde8 : GESTORE 
	db 0x45, 0x56, 0x45, 0x4e, 0x54, 0x20, 0x4e, 0x55   ; ddf0 : EVENT NU
	db 0x4d, 0x42, 0x45, 0x52, 0x20, 0x20, 0x20, 0x20   ; ddf8 : MBER    
	db 0x20, 0x20, 0x45, 0x56, 0x45, 0x4e, 0x54, 0x20   ; de00 :   EVENT 
	db 0x4e, 0x55, 0x4d, 0x42, 0x45, 0x52, 0x20, 0x20   ; de08 : NUMBER  
	db 0x20, 0x20, 0x20, 0x20, 0x53, 0x54, 0x4f, 0x52   ; de10 :     STOR
	db 0x45, 0x44, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00   ; de18 : ED......
	; Fills with 0x00 until 0xde80
	ds 0xde80-$, 0x00

	; Fills with 0xff until 0xe000
	ds 0xe000-$, 0xff

	; ---------------------------------------
	; e000 
	; ---------------------------------------

ROM_MAGIC:
	dw 0xaaaa		; Magic number
ROM_DEMO:
	db             0xf9, 0x11, 0xff, 0x87, 0xa1, 0xb1   ; e000 : ........
	db 0xe4, 0x0a, 0x0a, 0x0a, 0x0a, 0x59, 0x0a, 0x0a   ; e008 : .....Y..
	db 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x96, 0x31   ; e010 : .......1
	db 0x34, 0x35, 0x0a, 0x31, 0x34, 0x37, 0x0a, 0x96   ; e018 : 45.147..
	db 0x31, 0x34, 0x39, 0x0a, 0x31, 0x35, 0x30, 0x0a   ; e020 : 149.150.
	db 0xe4, 0x0a, 0x0a, 0x0a, 0x0a, 0x4e, 0x0a, 0x0a   ; e028 : .....N..
	db 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x1d   ; e030 : ........
	db 0x1d, 0x1d, 0x1d, 0x1d, 0x1d, 0x1d, 0x54, 0x48   ; e038 : ......TH
	db 0x49, 0x53, 0x08, 0x08, 0x08, 0x68, 0x69, 0x73   ; e040 : IS...his
	db 0x20, 0x69, 0x73, 0x20, 0x61, 0x6e, 0x20, 0x69   ; e048 :  is an i
	db 0x6e, 0x74, 0x72, 0x6f, 0x64, 0x75, 0x63, 0x74   ; e050 : ntroduct
	db 0x69, 0x6f, 0x6e, 0x20, 0x74, 0x6f, 0x20, 0x74   ; e058 : ion to t
	db 0x68, 0x65, 0x05, 0x66, 0x75, 0x6e, 0x63, 0x74   ; e060 : he.funct
	db 0x69, 0x6f, 0x6e, 0x73, 0x20, 0x61, 0x6e, 0x64   ; e068 : ions and
	db 0x20, 0x6f, 0x70, 0x65, 0x72, 0x61, 0x74, 0x69   ; e070 :  operati
	db 0x6e, 0x67, 0x05, 0x70, 0x72, 0x6f, 0x63, 0x65   ; e078 : ng.proce
	db 0x64, 0x75, 0x72, 0x65, 0x73, 0x20, 0x6f, 0x66   ; e080 : dures of
	db 0x20, 0x74, 0x68, 0x65, 0x20, 0x53, 0x50, 0x45   ; e088 :  the SPE
	db 0x43, 0x54, 0x52, 0x41, 0x47, 0x45, 0x4e, 0x05   ; e090 : CTRAGEN.
	db 0x74, 0x65, 0x78, 0x74, 0x20, 0x67, 0x65, 0x6e   ; e098 : text gen
	db 0x65, 0x72, 0x61, 0x74, 0x6f, 0x72, 0x05, 0x77   ; e0a0 : erator.w
	db 0x69, 0x74, 0x68, 0x20, 0x61, 0x05, 0x53, 0x49   ; e0a8 : ith a.SI
	db 0x4d, 0x50, 0x4c, 0x49, 0x46, 0x49, 0x45, 0x44   ; e0b0 : MPLIFIED
	db 0x20, 0x4f, 0x50, 0x45, 0x52, 0x41, 0x54, 0x49   ; e0b8 :  OPERATI
	db 0x4e, 0x47, 0x20, 0x47, 0x55, 0x49, 0x44, 0x45   ; e0c0 : NG GUIDE
	db 0x05, 0x05, 0xa1, 0x14, 0x0b, 0x14, 0x0b, 0x14   ; e0c8 : ........
	db 0x0b, 0x14, 0x0b, 0x14, 0x0b, 0x14, 0x0c, 0x0c   ; e0d0 : ........
	db 0x0c, 0x0c, 0x0c, 0x50, 0x72, 0x65, 0x73, 0x73   ; e0d8 : ...Press
	db 0x20, 0x22, 0x4e, 0x45, 0x58, 0x54, 0x20, 0x50   ; e0e0 :  "NEXT P
	db 0x41, 0x47, 0x45, 0x22, 0x20, 0x6b, 0x65, 0x79   ; e0e8 : AGE" key
	db 0xb1, 0x84, 0xfd, 0x31, 0x33, 0x38, 0x0a, 0xf9   ; e0f0 : ...138..
	db 0xa1, 0xb1, 0xa1, 0x12, 0x10, 0x13, 0x0b, 0x13   ; e0f8 : ........
	db 0x10, 0x0b, 0x13, 0x10, 0x0b, 0x13, 0x10, 0x0b   ; e100 : ........
	db 0x13, 0x10, 0x0b, 0x13, 0x10, 0x0b, 0x13, 0x10   ; e108 : ........
	db 0x04, 0x03, 0x05, 0x54, 0x68, 0x65, 0x20, 0x6b   ; e110 : ...The k
	db 0x65, 0x79, 0x62, 0x6f, 0x61, 0x72, 0x64, 0x20   ; e118 : eyboard 
	db 0x68, 0x61, 0x73, 0x20, 0x34, 0x20, 0x6d, 0x61   ; e120 : has 4 ma
	db 0x69, 0x6e, 0x20, 0x6b, 0x65, 0x79, 0x70, 0x61   ; e128 : in keypa
	db 0x64, 0x20, 0x61, 0x72, 0x65, 0x61, 0x73, 0x05   ; e130 : d areas.
	db 0x2a, 0x20, 0x54, 0x68, 0x65, 0x20, 0x6d, 0x61   ; e138 : * The ma
	db 0x69, 0x6e, 0x20, 0x6f, 0x66, 0x08, 0x72, 0xe2   ; e140 : in of.r.
	db 0x74, 0x79, 0x70, 0x65, 0x77, 0x72, 0x69, 0x74   ; e148 : typewrit
	db 0x65, 0x72, 0xe2, 0x6b, 0x65, 0x79, 0x70, 0x61   ; e150 : er.keypa
	db 0x64, 0x03, 0x05, 0x2a, 0x20, 0x54, 0x68, 0x65   ; e158 : d..* The
	db 0x20, 0x74, 0x6f, 0x70, 0x20, 0x72, 0x6f, 0x77   ; e160 :  top row
	db 0xe2, 0x64, 0x69, 0x73, 0x70, 0x6c, 0x61, 0x79   ; e168 : .display
	db 0x20, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c   ; e170 :  control
	db 0xe2, 0x6b, 0x65, 0x79, 0x73, 0x05, 0x2a, 0x20   ; e178 : .keys.* 
	db 0x54, 0x68, 0x65, 0x20, 0x6c, 0x65, 0x66, 0x74   ; e180 : The left
	db 0x20, 0x6b, 0x65, 0x79, 0x70, 0x61, 0x64, 0x20   ; e188 :  keypad 
	db 0x08, 0xe2, 0x70, 0x61, 0x67, 0x65, 0x20, 0x63   ; e190 : ..page c
	db 0x72, 0x65, 0x61, 0x74, 0x69, 0x6f, 0x6e, 0xe2   ; e198 : reation.
	db 0x6b, 0x65, 0x79, 0x73, 0x05, 0x2a, 0x20, 0x54   ; e1a0 : keys.* T
	db 0x68, 0x65, 0x20, 0x72, 0x69, 0x67, 0x68, 0x74   ; e1a8 : he right
	db 0x20, 0x6b, 0x65, 0x79, 0x70, 0x61, 0x64, 0xe2   ; e1b0 :  keypad.
	db 0x77, 0x6f, 0x72, 0x64, 0x20, 0x70, 0x72, 0x6f   ; e1b8 : word pro
	db 0x63, 0x65, 0x73, 0x73, 0x69, 0x6e, 0x67, 0xe2   ; e1c0 : cessing.
	db 0x6b, 0x65, 0x79, 0x73, 0xfd, 0x31, 0x33, 0x39   ; e1c8 : keys.139
	db 0x0a, 0xf9, 0x11, 0x10, 0x0b, 0x11, 0x10, 0x0b   ; e1d0 : ........
	db 0x11, 0x10, 0x0b, 0x11, 0x10, 0x0b, 0x11, 0x10   ; e1d8 : ........
	db 0x0b, 0x11, 0x10, 0x0b, 0x11, 0x10, 0x04, 0x54   ; e1e0 : .......T
	db 0x68, 0x65, 0x20, 0x6b, 0x65, 0x79, 0x62, 0x6f   ; e1e8 : he keybo
	db 0x61, 0x72, 0x64, 0x20, 0x68, 0x61, 0x73, 0x20   ; e1f0 : ard has 
	db 0x63, 0x6f, 0x6c, 0x6f, 0x72, 0x20, 0x63, 0x6f   ; e1f8 : color co
	db 0x64, 0x65, 0x64, 0x20, 0x6c, 0x65, 0x67, 0x65   ; e200 : ded lege
	db 0x6e, 0x64, 0x73, 0x20, 0x6f, 0x66, 0x08, 0x72   ; e208 : nds of.r
	db 0x05, 0x33, 0x20, 0x64, 0x69, 0x66, 0x66, 0x65   ; e210 : .3 diffe
	db 0x72, 0x65, 0x6e, 0x74, 0x20, 0x63, 0x6f, 0x6c   ; e218 : rent col
	db 0x6f, 0x72, 0x73, 0x20, 0x6f, 0x66, 0x20, 0x77   ; e220 : ors of w
	db 0x6f, 0x72, 0x64, 0x73, 0x20, 0x6f, 0x6e, 0x20   ; e228 : ords on 
	db 0x6b, 0x65, 0x79, 0x73, 0x2e, 0x05, 0x09, 0x09   ; e230 : keys....
	db 0x57, 0x68, 0x69, 0x74, 0x65, 0x20, 0x3d, 0x20   ; e238 : White = 
	db 0x6b, 0x65, 0x79, 0x20, 0x6f, 0x70, 0x65, 0x72   ; e240 : key oper
	db 0x61, 0x74, 0x65, 0x64, 0x20, 0x61, 0x6c, 0x6f   ; e248 : ated alo
	db 0x6e, 0x65, 0x03, 0x05, 0x09, 0x09, 0x59, 0x65   ; e250 : ne....Ye
	db 0x6c, 0x6c, 0x6f, 0x77, 0x20, 0x3d, 0x20, 0x73   ; e258 : llow = s
	db 0x68, 0x69, 0x66, 0x74, 0x2f, 0x6d, 0x75, 0x73   ; e260 : hift/mus
	db 0x74, 0x20, 0x62, 0x65, 0x20, 0x6f, 0x70, 0x65   ; e268 : t be ope
	db 0x72, 0x61, 0x74, 0x65, 0x64, 0x20, 0x77, 0x69   ; e270 : rated wi
	db 0x74, 0x68, 0x05, 0x03, 0x09, 0x09, 0x09, 0x09   ; e278 : th......
	db 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x73   ; e280 : .......s
	db 0x68, 0x69, 0x66, 0x74, 0x20, 0x6b, 0x65, 0x79   ; e288 : hift key
	db 0x20, 0x64, 0x6f, 0x77, 0x6e, 0x05, 0x09, 0x09   ; e290 :  down...
	db 0x4f, 0x72, 0x61, 0x6e, 0x67, 0x65, 0x20, 0x3d   ; e298 : Orange =
	db 0x20, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c   ; e2a0 :  control
	db 0x2f, 0x6d, 0x75, 0x73, 0x74, 0x20, 0x62, 0x65   ; e2a8 : /must be
	db 0x20, 0x6f, 0x70, 0x65, 0x72, 0x61, 0x74, 0x65   ; e2b0 :  operate
	db 0x64, 0x20, 0x77, 0x69, 0x74, 0x68, 0x09, 0x09   ; e2b8 : d with..
	db 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09   ; e2c0 : ........
	db 0x09, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c   ; e2c8 : .control
	db 0x20, 0x6b, 0x65, 0x79, 0x20, 0x64, 0x6f, 0x77   ; e2d0 :  key dow
	db 0x6e, 0xfd, 0x31, 0x34, 0x30, 0x0a, 0xf9, 0x43   ; e2d8 : n.140..C
	db 0x6f, 0x6c, 0x6f, 0x72, 0x73, 0x20, 0x61, 0x72   ; e2e0 : olors ar
	db 0x65, 0x20, 0x61, 0x73, 0x20, 0x65, 0x61, 0x73   ; e2e8 : e as eas
	db 0x79, 0x20, 0x74, 0x6f, 0x20, 0x75, 0x73, 0x65   ; e2f0 : y to use
	db 0x20, 0x61, 0x73, 0x20, 0x70, 0x72, 0x65, 0x73   ; e2f8 :  as pres
	db 0x73, 0x69, 0x6e, 0x67, 0x03, 0x05, 0x74, 0x68   ; e300 : sing..th
	db 0x65, 0x20, 0x61, 0x70, 0x70, 0x72, 0x6f, 0x70   ; e308 : e approp
	db 0x72, 0x69, 0x61, 0x74, 0x65, 0x20, 0x63, 0x6f   ; e310 : riate co
	db 0x6c, 0x6f, 0x72, 0x20, 0x6b, 0x65, 0x79, 0x2e   ; e318 : lor key.
	db 0x20, 0x57, 0x69, 0x74, 0x68, 0x20, 0x74, 0x68   ; e320 :  With th
	db 0x65, 0x20, 0x05, 0x4c, 0x4e, 0x2f, 0x4d, 0x4f   ; e328 : e .LN/MO
	db 0x44, 0x45, 0x2f, 0x50, 0x47, 0x20, 0x6b, 0x65   ; e330 : DE/PG ke
	db 0x79, 0x20, 0x79, 0x6f, 0x75, 0x20, 0x63, 0x61   ; e338 : y you ca
	db 0x6e, 0x20, 0x73, 0x65, 0x6c, 0x65, 0x63, 0x74   ; e340 : n select
	db 0x20, 0x65, 0x69, 0x74, 0x68, 0x65, 0x72, 0x05   ; e348 :  either.
	db 0x6c, 0x69, 0x6e, 0x65, 0x2d, 0x62, 0x79, 0x2d   ; e350 : line-by-
	db 0x6c, 0x69, 0x6e, 0x65, 0x20, 0x6f, 0x72, 0x20   ; e358 : line or 
	db 0x70, 0x61, 0x67, 0x65, 0x2e, 0x28, 0x74, 0x68   ; e360 : page.(th
	db 0x69, 0x73, 0x20, 0x6b, 0x65, 0x79, 0x20, 0x77   ; e368 : is key w
	db 0x6f, 0x72, 0x6b, 0x73, 0x03, 0x05, 0x77, 0x69   ; e370 : orks..wi
	db 0x74, 0x68, 0x20, 0x61, 0x6c, 0x6c, 0x20, 0x65   ; e378 : th all e
	db 0x64, 0x69, 0x74, 0x20, 0x66, 0x75, 0x6e, 0x63   ; e380 : dit func
	db 0x74, 0x69, 0x6f, 0x6e, 0x73, 0x20, 0x73, 0x75   ; e388 : tions su
	db 0x63, 0x68, 0x20, 0x61, 0x73, 0x20, 0x48, 0x47   ; e390 : ch as HG
	db 0x48, 0x54, 0x3c, 0x08, 0x2c, 0x05, 0x57, 0x44   ; e398 : HT<.,.WD
	db 0x48, 0x2c, 0x20, 0x4c, 0x49, 0x4e, 0x45, 0x20   ; e3a0 : H, LINE 
	db 0x53, 0x45, 0x50, 0x20, 0x41, 0x4e, 0x44, 0x20   ; e3a8 : SEP AND 
	db 0x53, 0x4c, 0x4c, 0x20, 0x57, 0x4f, 0x52, 0x44   ; e3b0 : SLL WORD
	db 0x20, 0x50, 0x52, 0x4f, 0x43, 0x45, 0x53, 0x53   ; e3b8 :  PROCESS
	db 0x4f, 0x52, 0x20, 0x4b, 0x45, 0x59, 0x0c, 0x09   ; e3c0 : OR KEY..
	db 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09   ; e3c8 : ........
	db 0x09, 0x09, 0x09, 0x09, 0x09, 0x61, 0x6e, 0x64   ; e3d0 : .....and
	db 0x20, 0x61, 0x6c, 0x6c, 0x20, 0x73, 0x6f, 0x72   ; e3d8 :  all sor
	db 0x6b, 0x08, 0x08, 0x08, 0x08, 0x77, 0x6f, 0x72   ; e3e0 : k....wor
	db 0x64, 0x20, 0x70, 0x72, 0x6f, 0x63, 0x65, 0x73   ; e3e8 : d proces
	db 0x73, 0x6f, 0x72, 0x20, 0x6b, 0x65, 0x79, 0x08   ; e3f0 : sor key.
	db 0x08, 0x08, 0x08, 0x03, 0x05, 0x6b, 0x65, 0x79   ; e3f8 : .....key
	db 0x73, 0x3b, 0x20, 0x72, 0x69, 0x67, 0x68, 0x74   ; e400 : s; right
	db 0x20, 0x6b, 0x65, 0x79, 0x70, 0x61, 0x64, 0x2e   ; e408 :  keypad.
	db 0x03, 0xfd, 0x31, 0x34, 0x31, 0x0a, 0xf9, 0x43   ; e410 : ..141..C
	db 0x72, 0x65, 0x61, 0x74, 0x65, 0x20, 0x70, 0x61   ; e418 : reate pa
	db 0x67, 0x65, 0x73, 0x20, 0x75, 0x73, 0x69, 0x6e   ; e420 : ges usin
	db 0x67, 0x20, 0x61, 0x6c, 0x6c, 0x20, 0x66, 0x75   ; e428 : g all fu
	db 0x6e, 0x63, 0x74, 0x69, 0x6f, 0x6e, 0x73, 0x20   ; e430 : nctions 
	db 0x6f, 0x6e, 0x20, 0x74, 0x68, 0x65, 0x05, 0x4c   ; e438 : on the.L
	db 0x41, 0x53, 0x54, 0x20, 0x50, 0x41, 0x47, 0x45   ; e440 : AST PAGE
	db 0x2c, 0x20, 0x69, 0x6e, 0x63, 0x6c, 0x75, 0x64   ; e448 : , includ
	db 0x69, 0x6e, 0x67, 0x20, 0x47, 0x52, 0x41, 0x50   ; e450 : ing GRAP
	db 0x48, 0x49, 0x43, 0x53, 0x20, 0x62, 0x79, 0x20   ; e458 : HICS by 
	db 0x70, 0x75, 0x73, 0x68, 0x2d, 0x05, 0x69, 0x6e   ; e460 : push-.in
	db 0x67, 0x20, 0x74, 0x68, 0x65, 0x20, 0x22, 0x52   ; e468 : g the "R
	db 0x08, 0x47, 0x52, 0x41, 0x50, 0x48, 0x49, 0x43   ; e470 : .GRAPHIC
	db 0x53, 0x22, 0x20, 0x6b, 0x65, 0x79, 0x20, 0x64   ; e478 : S" key d
	db 0x6f, 0x77, 0x6e, 0x2e, 0x20, 0x54, 0x6f, 0x20   ; e480 : own. To 
	db 0x72, 0x65, 0x74, 0x75, 0x72, 0x6e, 0x05, 0x66   ; e488 : return.f
	db 0x72, 0x6f, 0x6d, 0x20, 0x74, 0x68, 0x65, 0x20   ; e490 : rom the 
	db 0x47, 0x52, 0x41, 0x50, 0x48, 0x49, 0x43, 0x53   ; e498 : GRAPHICS
	db 0x20, 0x6d, 0x6f, 0x64, 0x65, 0x20, 0x73, 0x69   ; e4a0 :  mode si
	db 0x6d, 0x70, 0x6c, 0x79, 0x20, 0x70, 0x72, 0x65   ; e4a8 : mply pre
	db 0x73, 0x73, 0x20, 0x61, 0x6e, 0x64, 0x05, 0x72   ; e4b0 : ss and.r
	db 0x65, 0x6c, 0x65, 0x61, 0x73, 0x65, 0x20, 0x74   ; e4b8 : elease t
	db 0x68, 0x65, 0x20, 0x22, 0x47, 0x52, 0x41, 0x50   ; e4c0 : he "GRAP
	db 0x48, 0x49, 0x43, 0x53, 0x22, 0x20, 0x6b, 0x65   ; e4c8 : HICS" ke
	db 0x79, 0x2e, 0x03, 0x05, 0x03, 0x05, 0x03, 0xfd   ; e4d0 : y.......
	db 0x31, 0x34, 0x32, 0x0a, 0xf9, 0x41, 0x66, 0x74   ; e4d8 : 142..Aft
	db 0x65, 0x72, 0x20, 0x65, 0x64, 0x69, 0x74, 0x69   ; e4e0 : er editi
	db 0x6e, 0x67, 0x20, 0x61, 0x20, 0x70, 0x61, 0x67   ; e4e8 : ng a pag
	db 0x65, 0x20, 0x69, 0x74, 0x20, 0x69, 0x73, 0x20   ; e4f0 : e it is 
	db 0x69, 0x6e, 0x63, 0x6c, 0x75, 0x64, 0x65, 0x64   ; e4f8 : included
	db 0x20, 0x69, 0x6e, 0x03, 0x05, 0x73, 0x65, 0x71   ; e500 :  in..seq
	db 0x75, 0x65, 0x6e, 0x63, 0x65, 0x20, 0x66, 0x69   ; e508 : uence fi
	db 0x6c, 0x65, 0x20, 0x66, 0x6f, 0x72, 0x20, 0x64   ; e510 : le for d
	db 0x69, 0x73, 0x70, 0x6c, 0x61, 0x79, 0x2e, 0x03   ; e518 : isplay..
	db 0x05, 0x54, 0x68, 0x61, 0x74, 0x27, 0x73, 0x20   ; e520 : .That's 
	db 0x61, 0x6c, 0x6c, 0x20, 0x74, 0x68, 0x65, 0x72   ; e528 : all ther
	db 0x65, 0x20, 0x69, 0x73, 0x20, 0x74, 0x6f, 0x20   ; e530 : e is to 
	db 0x69, 0x74, 0x21, 0x03, 0x05, 0x57, 0x68, 0x61   ; e538 : it!..Wha
	db 0x74, 0x20, 0x77, 0x65, 0x20, 0x6c, 0x69, 0x6b   ; e540 : t we lik
	db 0x65, 0x20, 0x69, 0x73, 0x20, 0x73, 0x69, 0x6d   ; e548 : e is sim
	db 0x70, 0x6c, 0x69, 0x63, 0x69, 0x74, 0x79, 0x20   ; e550 : plicity 
	db 0x61, 0x6e, 0x64, 0x20, 0x74, 0x68, 0x65, 0x03   ; e558 : and the.
	db 0x05, 0x53, 0x50, 0x45, 0x43, 0x54, 0x52, 0x41   ; e560 : .SPECTRA
	db 0x47, 0x45, 0x4e, 0x20, 0x68, 0x61, 0x73, 0x20   ; e568 : GEN has 
	db 0x69, 0x74, 0x20, 0x61, 0x6c, 0x6c, 0x22, 0x22   ; e570 : it all""
	db 0x08, 0x08, 0x21, 0x21, 0x21, 0x03, 0xb1, 0x84   ; e578 : ..!!!...
	db 0xa1, 0xfd, 0x31, 0x34, 0x33, 0x0a, 0xf9, 0x1e   ; e580 : ..143...
	db 0x1e, 0x1e, 0x1e, 0x1e, 0x1e, 0x1e, 0xb1, 0x1e   ; e588 : ........
	db 0x1e, 0x1e, 0x1e, 0x1e, 0x1e, 0x1e, 0x1e, 0x03   ; e590 : ........
	db 0x53, 0x49, 0x4d, 0x50, 0x4c, 0x49, 0x46, 0x49   ; e598 : SIMPLIFI
	db 0x45, 0x44, 0x20, 0x4f, 0x50, 0x45, 0x52, 0x41   ; e5a0 : ED OPERA
	db 0x54, 0x49, 0x4e, 0x47, 0x20, 0x47, 0x55, 0x49   ; e5a8 : TING GUI
	db 0x44, 0x45, 0x05, 0xc2, 0x08, 0xe2, 0x52, 0x45   ; e5b0 : DE....RE
	db 0x41, 0x44, 0x20, 0x54, 0x48, 0x45, 0x20, 0x57   ; e5b8 : AD THE W
	db 0x48, 0x4f, 0x4c, 0x45, 0x20, 0x47, 0x55, 0x49   ; e5c0 : HOLE GUI
	db 0x44, 0x45, 0x20, 0x42, 0x45, 0x46, 0x4f, 0x52   ; e5c8 : DE BEFOR
	db 0x45, 0x20, 0x50, 0x45, 0x52, 0x46, 0x4f, 0x52   ; e5d0 : E PERFOR
	db 0x4d, 0x49, 0x4e, 0x47, 0x05, 0x03, 0x05, 0x53   ; e5d8 : MING...S
	db 0x54, 0x45, 0x50, 0x20, 0x23, 0x31, 0x2e, 0x49   ; e5e0 : TEP #1.I
	db 0x6e, 0x73, 0x75, 0x72, 0x65, 0x20, 0x22, 0x4b   ; e5e8 : nsure "K
	db 0x45, 0x59, 0x42, 0x4f, 0x41, 0x52, 0x44, 0x20   ; e5f0 : EYBOARD 
	db 0x4c, 0x4f, 0x43, 0x4b, 0x22, 0x20, 0x6b, 0x65   ; e5f8 : LOCK" ke
	db 0x79, 0x20, 0x69, 0x66, 0x20, 0x08, 0x08, 0x73   ; e600 : y if ..s
	db 0x20, 0x75, 0x70, 0x03, 0x05, 0x09, 0x09, 0x09   ; e608 :  up.....
	db 0x09, 0x09, 0x09, 0x32, 0x2e, 0x50, 0x72, 0x65   ; e610 : ...2.Pre
	db 0x73, 0x73, 0x20, 0x22, 0x53, 0x45, 0x54, 0x20   ; e618 : ss "SET 
	db 0x43, 0x4c, 0x4b, 0x22, 0x20, 0x6b, 0x65, 0x79   ; e620 : CLK" key
	db 0x20, 0x28, 0x74, 0x68, 0x69, 0x73, 0x20, 0x62   ; e628 :  (this b
	db 0x72, 0x69, 0x6e, 0x67, 0x73, 0x09, 0x09, 0x09   ; e630 : rings...
	db 0x09, 0x09, 0x09, 0x09, 0x09, 0x75, 0x70, 0x20   ; e638 : .....up 
	db 0x74, 0x68, 0x65, 0x20, 0x63, 0x6c, 0x6f, 0x63   ; e640 : the cloc
	db 0x6b, 0x20, 0x6d, 0x65, 0x6e, 0x75, 0x29, 0x05   ; e648 : k menu).
	db 0x81, 0x81, 0x81, 0x8e, 0x8e, 0x11, 0xa1, 0x0b   ; e650 : ........
	db 0x14, 0x0c, 0x81, 0x81, 0x81, 0x81, 0x81, 0x81   ; e658 : ........
	db 0x81, 0x81, 0x81, 0x81, 0x81, 0x81, 0x81, 0x81   ; e660 : ........
	db 0x81, 0x81, 0x81, 0x09, 0x09, 0x09, 0x09, 0x09   ; e668 : ........
	db 0x09, 0x0b, 0x33, 0x2e, 0x53, 0x65, 0x74, 0x20   ; e670 : ..3.Set 
	db 0x63, 0x75, 0x72, 0x72, 0x65, 0x6e, 0x74, 0x20   ; e678 : current 
	db 0x64, 0x61, 0x74, 0x65, 0x20, 0x61, 0x6e, 0x64   ; e680 : date and
	db 0x20, 0x74, 0x69, 0x6d, 0x65, 0x20, 0x62, 0x79   ; e688 :  time by
	db 0x05, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09   ; e690 : ........
	db 0x09, 0x75, 0x73, 0x69, 0x6e, 0x67, 0x20, 0x22   ; e698 : .using "
	db 0x53, 0x50, 0x41, 0x43, 0x45, 0x20, 0x42, 0x41   ; e6a0 : SPACE BA
	db 0x52, 0x22, 0x20, 0x26, 0x20, 0x22, 0x45, 0x4e   ; e6a8 : R" & "EN
	db 0x54, 0x45, 0x52, 0x22, 0x20, 0x6b, 0x65, 0x79   ; e6b0 : TER" key
	db 0x73, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09   ; e6b8 : s.......
	db 0x09, 0x43, 0x6f, 0x6e, 0x74, 0x69, 0x6e, 0x75   ; e6c0 : .Continu
	db 0x65, 0x20, 0x70, 0x72, 0x65, 0x73, 0x73, 0x69   ; e6c8 : e pressi
	db 0x6e, 0x67, 0x20, 0x22, 0x45, 0x4e, 0x54, 0x45   ; e6d0 : ng "ENTE
	db 0x52, 0x22, 0x20, 0x75, 0x6e, 0x74, 0x69, 0x6c   ; e6d8 : R" until
	db 0x05, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09   ; e6e0 : ........
	db 0x09, 0x6d, 0x75, 0x08, 0x65, 0x6e, 0x75, 0x20   ; e6e8 : .mu.enu 
	db 0x64, 0x69, 0x73, 0x61, 0x70, 0x70, 0x65, 0x72   ; e6f0 : disapper
	db 0x08, 0x61, 0x72, 0x73, 0x2e, 0x05, 0x05, 0x09   ; e6f8 : .ars....
	db 0x09, 0x09, 0x09, 0x09, 0x09, 0x34, 0x2e, 0x50   ; e700 : .....4.P
	db 0x72, 0x65, 0x73, 0x73, 0x20, 0x22, 0x52, 0x45   ; e708 : ress "RE
	db 0x43, 0x41, 0x4c, 0x4c, 0x22, 0x20, 0x6b, 0x65   ; e710 : CALL" ke
	db 0x79, 0x2e, 0x20, 0x08, 0x08, 0x2c, 0x20, 0x54   ; e718 : y. .., T
	db 0x08, 0x74, 0x79, 0x70, 0x65, 0x20, 0x69, 0x6e   ; e720 : .type in
	db 0x20, 0x70, 0x61, 0x67, 0x65, 0x09, 0x09, 0x09   ; e728 :  page...
	db 0x09, 0x09, 0x09, 0x09, 0x09, 0x31, 0x20, 0x74   ; e730 : .....1 t
	db 0x68, 0x65, 0x6e, 0x20, 0x08, 0x08, 0x08, 0x08   ; e738 : hen ....
	db 0x08, 0x08, 0x08, 0x32, 0x31, 0x8f, 0x09, 0x09   ; e740 : ...21...
	db 0x09, 0x09, 0x09, 0x20, 0x70, 0x72, 0x65, 0x73   ; e748 : ... pres
	db 0x73, 0x20, 0x22, 0x45, 0x4e, 0x54, 0x45, 0x52   ; e750 : s "ENTER
	db 0x22, 0x20, 0x6b, 0x65, 0x79, 0x2e, 0x05, 0x05   ; e758 : " key...
	db 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x35, 0x2e   ; e760 : ......5.
	db 0x45, 0x6e, 0x74, 0x65, 0x72, 0x20, 0x74, 0x65   ; e768 : Enter te
	db 0x78, 0x74, 0x2c, 0x20, 0x75, 0x73, 0x65, 0x20   ; e770 : xt, use 
	db 0x70, 0x61, 0x67, 0x65, 0x20, 0x63, 0x72, 0x65   ; e778 : page cre
	db 0x61, 0x74, 0x69, 0x6f, 0x6e, 0x05, 0x09, 0x09   ; e780 : ation...
	db 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x6b, 0x65   ; e788 : ......ke
	db 0x79, 0x73, 0x20, 0x6f, 0x6e, 0x20, 0x74, 0x68   ; e790 : ys on th
	db 0x65, 0x20, 0x6c, 0x65, 0x66, 0x74, 0x20, 0x6b   ; e798 : e left k
	db 0x65, 0x79, 0x70, 0x61, 0x64, 0x20, 0x74, 0x6f   ; e7a0 : eypad to
	db 0x20, 0x05, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09   ; e7a8 :  .......
	db 0x09, 0x09, 0x64, 0x65, 0x73, 0x69, 0x67, 0x6e   ; e7b0 : ..design
	db 0x20, 0x61, 0x6e, 0x64, 0x20, 0x63, 0x6f, 0x6c   ; e7b8 :  and col
	db 0x6f, 0x72, 0x20, 0x70, 0x61, 0x67, 0x65, 0x73   ; e7c0 : or pages
	db 0x2e, 0x05, 0x05, 0x09, 0x09, 0x09, 0x09, 0x09   ; e7c8 : ........
	db 0x09, 0x36, 0x2e, 0x54, 0x6f, 0x20, 0x73, 0x74   ; e7d0 : .6.To st
	db 0x6f, 0x72, 0x65, 0x20, 0x74, 0x68, 0x65, 0x20   ; e7d8 : ore the 
	db 0x70, 0x61, 0x67, 0x65, 0x20, 0x70, 0x72, 0x65   ; e7e0 : page pre
	db 0x73, 0x73, 0x20, 0x22, 0x53, 0x54, 0x4f, 0x52   ; e7e8 : ss "STOR
	db 0x45, 0x22, 0x05, 0x09, 0x09, 0x09, 0x09, 0x09   ; e7f0 : E"......
	db 0x09, 0x09, 0x09, 0x6b, 0x65, 0x79, 0x20, 0x74   ; e7f8 : ...key t
	db 0x68, 0x65, 0x6e, 0x20, 0x22, 0x45, 0x4e, 0x54   ; e800 : hen "ENT
	db 0x45, 0x52, 0x22, 0x20, 0x6b, 0x65, 0x79, 0x2e   ; e808 : ER" key.
	db 0x05, 0x05, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09   ; e810 : ........
	db 0x37, 0x2e, 0x50, 0x72, 0x65, 0x73, 0x73, 0x20   ; e818 : 7.Press 
	db 0x22, 0x4e, 0x45, 0x58, 0x54, 0x20, 0x50, 0x41   ; e820 : "NEXT PA
	db 0x47, 0x45, 0x22, 0x20, 0x6b, 0x65, 0x79, 0x2e   ; e828 : GE" key.
	db 0x05, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09   ; e830 : ........
	db 0x09, 0x52, 0x65, 0x70, 0x65, 0x61, 0x74, 0x20   ; e838 : .Repeat 
	db 0x73, 0x74, 0x65, 0x70, 0x73, 0x20, 0x35, 0x20   ; e840 : steps 5 
	db 0x74, 0x68, 0x72, 0x6f, 0x75, 0x67, 0x68, 0x20   ; e848 : through 
	db 0x37, 0x2e, 0xfd, 0x31, 0x34, 0x34, 0x0a, 0xfb   ; e850 : 7..144..
	db 0x0a, 0xb1, 0xa1, 0x84, 0xfd, 0x0a, 0xfc, 0xfb   ; e858 : ........
	db 0x0a, 0xfb, 0x31, 0x34, 0x34, 0x0a, 0x09, 0x09   ; e860 : ..144...
	db 0x09, 0x09, 0x09, 0x09, 0x09, 0x20, 0x57, 0x68   ; e868 : ..... Wh
	db 0x65, 0x6e, 0x20, 0x79, 0x6f, 0x75, 0x20, 0x61   ; e870 : en you a
	db 0x72, 0x65, 0x20, 0x64, 0x6f, 0x6e, 0x65, 0x2c   ; e878 : re done,
	db 0x20, 0x67, 0x6f, 0x20, 0x74, 0x6f, 0x20, 0x73   ; e880 :  go to s
	db 0x74, 0x65, 0x70, 0x20, 0x38, 0x05, 0x03, 0x09   ; e888 : tep 8...
	db 0x09, 0x09, 0x09, 0x09, 0x09, 0x38, 0x2e, 0x50   ; e890 : .....8.P
	db 0x72, 0x65, 0x73, 0x73, 0x20, 0x22, 0x53, 0x45   ; e898 : ress "SE
	db 0x51, 0x22, 0x20, 0x6b, 0x65, 0x79, 0x2c, 0x20   ; e8a0 : Q" key, 
	db 0x74, 0x79, 0x70, 0x65, 0x20, 0x69, 0x6e, 0x20   ; e8a8 : type in 
	db 0x72, 0x65, 0x67, 0x69, 0x6f, 0x6e, 0x05, 0x09   ; e8b0 : region..
	db 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x33   ; e8b8 : .......3
	db 0x2c, 0x20, 0x74, 0x68, 0x65, 0x6e, 0x20, 0x70   ; e8c0 : , then p
	db 0x72, 0x65, 0x73, 0x73, 0x20, 0x22, 0x45, 0x4e   ; e8c8 : ress "EN
	db 0x54, 0x45, 0x52, 0x22, 0x20, 0x6b, 0x65, 0x79   ; e8d0 : TER" key
	db 0x2e, 0x20, 0x54, 0x79, 0x70, 0x65, 0x05, 0x03   ; e8d8 : . Type..
	db 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09   ; e8e0 : ........
	db 0x69, 0x6e, 0x20, 0x73, 0x74, 0x61, 0x72, 0x74   ; e8e8 : in start
	db 0x20, 0x70, 0x61, 0x67, 0x65, 0x20, 0x61, 0x6e   ; e8f0 :  page an
	db 0x64, 0x20, 0x73, 0x74, 0x6f, 0x70, 0x20, 0x70   ; e8f8 : d stop p
	db 0x61, 0x67, 0x65, 0x20, 0x66, 0x6f, 0x72, 0x20   ; e900 : age for 
	db 0x74, 0x68, 0x08, 0x08, 0x20, 0x20, 0x09, 0x09   ; e908 : th..  ..
	db 0x09, 0x09, 0x09, 0x09, 0x09, 0x74, 0x68, 0x65   ; e910 : .....the
	db 0x20, 0x70, 0x61, 0x67, 0x65, 0x73, 0x20, 0x6a   ; e918 :  pages j
	db 0x75, 0x73, 0x74, 0x20, 0x63, 0x72, 0x65, 0x61   ; e920 : ust crea
	db 0x64, 0x08, 0x74, 0x65, 0x64, 0x2e, 0x20, 0x45   ; e928 : d.ted. E
	db 0x6e, 0x74, 0x65, 0x72, 0x05, 0x09, 0x09, 0x09   ; e930 : nter....
	db 0x09, 0x09, 0x20, 0x20, 0x20, 0x74, 0x6f, 0x74   ; e938 : ..   tot
	db 0x61, 0x6c, 0x20, 0x69, 0x6e, 0x20, 0x63, 0x68   ; e940 : al in ch
	db 0x61, 0x6e, 0x67, 0x65, 0x20, 0x66, 0x69, 0x6c   ; e948 : ange fil
	db 0x65, 0x20, 0x70, 0x6f, 0x72, 0x74, 0x69, 0x6f   ; e950 : e portio
	db 0x6e, 0x20, 0x03, 0x05, 0x09, 0x09, 0x09, 0x09   ; e958 : n ......
	db 0x09, 0x09, 0x09, 0x09, 0x6f, 0x66, 0x20, 0x74   ; e960 : ....of t
	db 0x68, 0x65, 0x20, 0x6d, 0x65, 0x6e, 0x75, 0x2d   ; e968 : he menu-
	db 0x4e, 0x4f, 0x54, 0x45, 0x3a, 0x52, 0x65, 0x67   ; e970 : NOTE:Reg
	db 0x69, 0x6f, 0x6e, 0x20, 0x31, 0x3d, 0x54, 0x49   ; e978 : ion 1=TI
	db 0x54, 0x4c, 0x45, 0x05, 0x09, 0x09, 0x09, 0x09   ; e980 : TLE.....
	db 0x09, 0x09, 0x09, 0x09, 0x72, 0x65, 0x67, 0x69   ; e988 : ....regi
	db 0x6f, 0x6e, 0x20, 0x32, 0x3d, 0x43, 0x4c, 0x4f   ; e990 : on 2=CLO
	db 0x43, 0x4b, 0x2c, 0x20, 0x52, 0x08, 0x72, 0x65   ; e998 : CK, R.re
	db 0x67, 0x69, 0x6f, 0x6e, 0x20, 0x34, 0x3d, 0x63   ; e9a0 : gion 4=c
	db 0x72, 0x61, 0x77, 0x6c, 0x2e, 0x08, 0x08, 0x08   ; e9a8 : rawl....
	db 0x08, 0x08, 0x08, 0x43, 0x52, 0x41, 0x57, 0x4c   ; e9b0 : ...CRAWL
	db 0x05, 0x09, 0x09, 0x09, 0x09, 0x09, 0x20, 0x20   ; e9b8 : ......  
	db 0x20, 0x52, 0x65, 0x70, 0x65, 0x61, 0x74, 0x20   ; e9c0 :  Repeat 
	db 0x73, 0x74, 0x65, 0x70, 0x73, 0x20, 0x35, 0x2d   ; e9c8 : steps 5-
	db 0x38, 0x20, 0x66, 0x6f, 0x72, 0x20, 0x6f, 0x74   ; e9d0 : 8 for ot
	db 0x68, 0x65, 0x72, 0x03, 0x05, 0x09, 0x09, 0x09   ; e9d8 : her.....
	db 0x09, 0x09, 0x09, 0x09, 0x09, 0x72, 0x65, 0x67   ; e9e0 : .....reg
	db 0x69, 0x6f, 0x6e, 0x73, 0x2e, 0x20, 0x54, 0x69   ; e9e8 : ions. Ti
	db 0x74, 0x6c, 0x65, 0x3d, 0x70, 0x67, 0x73, 0x20   ; e9f0 : tle=pgs 
	db 0x08, 0x08, 0x08, 0x61, 0x67, 0x65, 0x73, 0x20   ; e9f8 : ...ages 
	db 0x30, 0x2d, 0x31, 0x2c, 0x20, 0x63, 0x6c, 0x6f   ; ea00 : 0-1, clo
	db 0x63, 0x6b, 0x3d, 0x09, 0x09, 0x09, 0x09, 0x09   ; ea08 : ck=.....
	db 0x09, 0x09, 0x09, 0x70, 0x61, 0x67, 0x65, 0x20   ; ea10 : ...page 
	db 0x32, 0x2c, 0x20, 0x63, 0x72, 0x61, 0x77, 0x6c   ; ea18 : 2, crawl
	db 0x3d, 0x70, 0x61, 0x67, 0x65, 0x73, 0x20, 0x33   ; ea20 : =pages 3
	db 0x2d, 0x31, 0x30, 0x2c, 0x20, 0x72, 0x6f, 0x6c   ; ea28 : -10, rol
	db 0x6c, 0x3d, 0x05, 0x09, 0x09, 0x09, 0x09, 0x09   ; ea30 : l=......
	db 0x09, 0x09, 0x09, 0x31, 0x31, 0x2d, 0x32, 0x30   ; ea38 : ...11-20
	db 0x2e, 0x20, 0x28, 0x6d, 0x61, 0x69, 0x6e, 0x20   ; ea40 : . (main 
	db 0x70, 0x61, 0x67, 0x65, 0x73, 0x20, 0x61, 0x72   ; ea48 : pages ar
	db 0x65, 0x20, 0x32, 0x31, 0x2d, 0x31, 0x33, 0x37   ; ea50 : e 21-137
	db 0x2e, 0x08, 0x29, 0x05, 0x09, 0x09, 0x09, 0x09   ; ea58 : ..).....
	db 0x09, 0x09, 0x39, 0x2e, 0x50, 0x72, 0x65, 0x73   ; ea60 : ..9.Pres
	db 0x73, 0x20, 0x22, 0x52, 0x45, 0x53, 0x55, 0x4d   ; ea68 : s "RESUM
	db 0x45, 0x22, 0x20, 0x6b, 0x65, 0x79, 0x20, 0x28   ; ea70 : E" key (
	db 0x74, 0x68, 0x69, 0x73, 0x20, 0x70, 0x75, 0x74   ; ea78 : this put
	db 0x73, 0x05, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09   ; ea80 : s.......
	db 0x03, 0x09, 0x09, 0x74, 0x68, 0x65, 0x20, 0x6d   ; ea88 : ...the m
	db 0x61, 0x63, 0x68, 0x69, 0x6e, 0x65, 0x20, 0x69   ; ea90 : achine i
	db 0x6e, 0x20, 0x74, 0x68, 0x65, 0x20, 0x64, 0x69   ; ea98 : n the di
	db 0x73, 0x70, 0x6c, 0x61, 0x79, 0x20, 0x6d, 0x69   ; eaa0 : splay mi
	db 0x64, 0x65, 0x29, 0x08, 0x08, 0x08, 0x08, 0x6f   ; eaa8 : de)....o
	db 0x05, 0x09, 0x09, 0x09, 0x09, 0x08, 0x08, 0x08   ; eab0 : ........
	db 0x08, 0x08, 0x09, 0x10, 0x0b, 0x10, 0x0b, 0x10   ; eab8 : ........
	db 0x0b, 0x10, 0x0b, 0x10, 0x0b, 0x10, 0x0b, 0x10   ; eac0 : ........
	db 0x0b, 0x10, 0x0b, 0x10, 0x0b, 0x10, 0x0b, 0x10   ; eac8 : ........
	db 0x0b, 0x10, 0x11, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c   ; ead0 : ........
	db 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x50, 0x6c   ; ead8 : ......Pl
	db 0x65, 0x61, 0x73, 0x65, 0x20, 0x63, 0x6f, 0x6e   ; eae0 : ease con
	db 0x73, 0x75, 0x6c, 0x74, 0x20, 0x74, 0x68, 0x65   ; eae8 : sult the
	db 0x20, 0x6f, 0x70, 0x65, 0x72, 0x61, 0x74, 0x69   ; eaf0 :  operati
	db 0x6e, 0x67, 0x20, 0x6d, 0x61, 0x6e, 0x75, 0x61   ; eaf8 : ng manua
	db 0x6c, 0x20, 0x66, 0x6f, 0x72, 0x05, 0x66, 0x75   ; eb00 : l for.fu
	db 0x72, 0x74, 0x68, 0x65, 0x72, 0x20, 0x69, 0x6e   ; eb08 : rther in
	db 0x73, 0x08, 0x09, 0x74, 0x72, 0x75, 0x63, 0x74   ; eb10 : s..truct
	db 0x69, 0x6f, 0x6e, 0x73, 0x2e, 0x20, 0x41, 0x73   ; eb18 : ions. As
	db 0x20, 0x79, 0x6f, 0x75, 0x20, 0x65, 0x6e, 0x63   ; eb20 :  you enc
	db 0x6f, 0x75, 0x6e, 0x74, 0x65, 0x72, 0x05, 0x61   ; eb28 : ounter.a
	db 0x6e, 0x20, 0x75, 0x6e, 0x66, 0x61, 0x6d, 0x69   ; eb30 : n unfami
	db 0x6c, 0x69, 0x61, 0x72, 0x20, 0x6b, 0x65, 0x79   ; eb38 : liar key
	db 0x20, 0x6c, 0x6f, 0x6f, 0x6b, 0x20, 0x69, 0x74   ; eb40 :  look it
	db 0x20, 0x75, 0x70, 0x20, 0x69, 0x6e, 0x20, 0x74   ; eb48 :  up in t
	db 0x68, 0x65, 0x20, 0x64, 0x08, 0x6b, 0x65, 0x79   ; eb50 : he d.key
	db 0x05, 0x64, 0x65, 0x73, 0x63, 0x72, 0x69, 0x70   ; eb58 : .descrip
	db 0x74, 0x69, 0x6f, 0x6e, 0x20, 0x73, 0x65, 0x63   ; eb60 : tion sec
	db 0x74, 0x69, 0x6f, 0x6e, 0x20, 0x6f, 0x66, 0x20   ; eb68 : tion of 
	db 0x74, 0x68, 0x65, 0x20, 0x6d, 0x61, 0x6e, 0x75   ; eb70 : the manu
	db 0x61, 0x6c, 0x2e, 0x05, 0x4e, 0x4f, 0x54, 0x45   ; eb78 : al..NOTE
	db 0x3a, 0x20, 0x41, 0x6c, 0x6c, 0x20, 0x6d, 0x65   ; eb80 : : All me
	db 0x6e, 0x75, 0x65, 0x08, 0x73, 0x20, 0x6d, 0x75   ; eb88 : nue.s mu
	db 0x73, 0x74, 0x20, 0x62, 0x65, 0x20, 0x65, 0x6e   ; eb90 : st be en
	db 0x74, 0x65, 0x72, 0x65, 0x64, 0x20, 0x61, 0x6c   ; eb98 : tered al
	db 0x6c, 0x20, 0x74, 0x68, 0x65, 0x20, 0x77, 0x61   ; eba0 : l the wa
	db 0x79, 0x20, 0x74, 0x68, 0x72, 0x6f, 0x75, 0x67   ; eba8 : y throug
	db 0x68, 0x20, 0x74, 0x6f, 0x20, 0x74, 0x61, 0x6b   ; ebb0 : h to tak
	db 0x65, 0x20, 0x65, 0x66, 0x66, 0x65, 0x63, 0x74   ; ebb8 : e effect
	db 0x2e, 0x05, 0x49, 0x66, 0x20, 0x79, 0x6f, 0x75   ; ebc0 : ..If you
	db 0x20, 0x73, 0x68, 0x6f, 0x75, 0x6c, 0x64, 0x20   ; ebc8 :  should 
	db 0x6c, 0x69, 0x6b, 0x65, 0x20, 0x74, 0x6f, 0x20   ; ebd0 : like to 
	db 0x72, 0x75, 0x6e, 0x20, 0x74, 0x68, 0x72, 0x6f   ; ebd8 : run thro
	db 0x75, 0x67, 0x68, 0x20, 0x74, 0x68, 0x69, 0x73   ; ebe0 : ugh this
	db 0x20, 0x05, 0x68, 0x65, 0x6c, 0x70, 0x20, 0x73   ; ebe8 :  .help s
	db 0x65, 0x73, 0x73, 0x69, 0x6f, 0x6e, 0x20, 0x61   ; ebf0 : ession a
	db 0x67, 0x61, 0x69, 0x6e, 0x2c, 0x20, 0x70, 0x6c   ; ebf8 : gain, pl
	db 0x65, 0x61, 0x73, 0x65, 0x20, 0x70, 0x72, 0x65   ; ec00 : ease pre
	db 0x73, 0x73, 0x20, 0x52, 0x45, 0x43, 0x41, 0x4c   ; ec08 : ss RECAL
	db 0x4c, 0x05, 0x70, 0x61, 0x67, 0x65, 0x20, 0x31   ; ec10 : L.page 1
	db 0x33, 0x38, 0x20, 0x61, 0x6e, 0x64, 0x20, 0x74   ; ec18 : 38 and t
	db 0x68, 0x65, 0x6e, 0x20, 0x70, 0x72, 0x65, 0x73   ; ec20 : hen pres
	db 0x73, 0x20, 0x74, 0x68, 0x65, 0x20, 0x45, 0x4e   ; ec28 : s the EN
	db 0x54, 0x45, 0x52, 0x20, 0x6b, 0x65, 0x79, 0x2e   ; ec30 : TER key.
	db 0x05, 0x02, 0x54, 0x48, 0x41, 0x4e, 0x4b, 0x59   ; ec38 : ..THANKY
	db 0x4f, 0x55, 0x08, 0x08, 0x08, 0x8f, 0x84, 0x09   ; ec40 : OU......
	db 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09   ; ec48 : ........
	db 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09   ; ec50 : ........
	db 0x09, 0x09, 0x09, 0x2e, 0xfd, 0x31, 0x34, 0x38   ; ec58 : .....148
	db 0x0a, 0xfb, 0x0a, 0xdc, 0x87, 0x02, 0xb1, 0x98   ; ec60 : ........
	db 0x64, 0x0a, 0x33, 0x0a, 0x32, 0x0a, 0x31, 0x37   ; ec68 : d.3.2.17
	db 0x0a, 0x34, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x98   ; ec70 : .4......
	db 0xf9, 0x9a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a   ; ec78 : ........
	db 0x0a, 0x0a, 0x32, 0x0a, 0x32, 0x0a, 0x12, 0x74   ; ec80 : ..2.2..t
	db 0x04, 0x54, 0x49, 0x54, 0x4c, 0x45, 0x53, 0x84   ; ec88 : .TITLES.
	db 0xe4, 0x20, 0x20, 0x20, 0x20, 0x0a, 0x0a, 0x31   ; ec90 : .    ..1
	db 0x30, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a   ; ec98 : 0.......
	db 0x0a, 0x0a, 0x0a, 0xfd, 0x30, 0x0a, 0xf9, 0x56   ; eca0 : ....0..V
	db 0x41, 0x52, 0x49, 0x41, 0x42, 0x4c, 0x45, 0x86   ; eca8 : ARIABLE.
	db 0x86, 0x86, 0x86, 0x84, 0xfd, 0x31, 0x0a, 0xfb   ; ecb0 : .....1..
	db 0x32, 0x0a, 0x16, 0xe4, 0x0a, 0x0a, 0x30, 0x0a   ; ecb8 : 2.....0.
	db 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a   ; ecc0 : ........
	db 0x0a, 0xfd, 0x32, 0x0a, 0xf9, 0x13, 0x02, 0x4b   ; ecc8 : ..2....K
	db 0x45, 0x59, 0x42, 0x4f, 0x41, 0x52, 0x44, 0x20   ; ecd0 : EYBOARD 
	db 0x43, 0x52, 0x41, 0x57, 0x4c, 0xe4, 0x20, 0x20   ; ecd8 : CRAWL.  
	db 0x0a, 0x0a, 0x31, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a   ; ece0 : ..1.....
	db 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x96, 0x33, 0x0a   ; ece8 : ......3.
	db 0x31, 0x30, 0x0a, 0xf9, 0x11, 0x11, 0x52, 0x4f   ; ecf0 : 10....RO
	db 0x4c, 0x4c, 0x03, 0x05, 0x32, 0x05, 0x33, 0x05   ; ecf8 : LL..2.3.
	db 0x34, 0x05, 0x35, 0x05, 0x36, 0x05, 0x37, 0x05   ; ed00 : 4.5.6.7.
	db 0x38, 0x84, 0xe4, 0x20, 0x0a, 0x0a, 0x0a, 0x0a   ; ed08 : 8.. ....
	db 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a   ; ed10 : ........
	db 0x96, 0x31, 0x31, 0x0a, 0x32, 0x30, 0x0a, 0xf9   ; ed18 : .11.20..
	db 0x11, 0x03, 0x4d, 0x45, 0x4d, 0x4f, 0x52, 0x59   ; ed20 : ..MEMORY
	db 0x05, 0x05, 0x05, 0x05, 0x05, 0x05, 0x05, 0x03   ; ed28 : ........
	db 0x28, 0x08, 0x50, 0x4c, 0x45, 0x41, 0x53, 0x45   ; ed30 : (.PLEASE
	db 0x20, 0x50, 0x52, 0x45, 0x53, 0x53, 0x20, 0x22   ; ed38 :  PRESS "
	db 0x45, 0x44, 0x49, 0x54, 0x22, 0x05, 0x0c, 0x09   ; ed40 : EDIT"...
	db 0x6c, 0x65, 0x61, 0x73, 0x65, 0x20, 0x70, 0x72   ; ed48 : lease pr
	db 0x65, 0x73, 0x73, 0x04, 0x09, 0x09, 0x09, 0x09   ; ed50 : ess.....
	db 0x09, 0x09, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08   ; ed58 : ........
	db 0x09, 0x09, 0x09, 0x09, 0x09, 0x08, 0x08, 0x08   ; ed60 : ........
	db 0x08, 0x08, 0x6d, 0x61, 0x69, 0x6e, 0x20, 0x04   ; ed68 : ..main .
	db 0x4d, 0x41, 0x49, 0x4e, 0x20, 0x42, 0x4f, 0x44   ; ed70 : MAIN BOD
	db 0x59, 0x20, 0x54, 0x45, 0x58, 0x54, 0x20, 0x28   ; ed78 : Y TEXT (
	db 0x52, 0x45, 0x47, 0x49, 0x4f, 0x4e, 0x20, 0x33   ; ed80 : REGION 3
	db 0x29, 0x84, 0x96, 0x32, 0x31, 0x0a, 0x31, 0x33   ; ed88 : )..21.13
	db 0x37, 0x0a, 0xf9, 0xe4, 0x20, 0x20, 0x20, 0x0a   ; ed90 : 7...   .
	db 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a   ; ed98 : ........
	db 0x0a, 0x0a, 0x0a, 0x96, 0x32, 0x31, 0x0a, 0x31   ; eda0 : ....21.1
	db 0x33, 0x37, 0x0a, 0xfb, 0x31, 0x0a, 0xdc, 0x03   ; eda8 : 37..1...
	db 0x54, 0x49, 0x54, 0x4c, 0x45, 0x53, 0x20, 0x28   ; edb0 : TITLES (
	db 0x52, 0x45, 0x47, 0x49, 0x4f, 0x4e, 0x20, 0x31   ; edb8 : REGION 1
	db 0x29, 0x84, 0xfd, 0x0a, 0xfb, 0x33, 0x0a, 0x09   ; edc0 : )....3..
	db 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09   ; edc8 : ........
	db 0x09, 0x09, 0x09, 0x09, 0x09, 0x20, 0x28, 0x52   ; edd0 : ..... (R
	db 0x45, 0x47, 0x49, 0x4f, 0x4e, 0x20, 0x34, 0x29   ; edd8 : EGION 4)
	db 0x96, 0x33, 0x0a, 0x31, 0x30, 0x0a, 0xf9, 0xf1   ; ede0 : .3.10...
	db 0x31, 0x0a, 0x0a, 0x31, 0x0a, 0x31, 0x0a, 0x0a   ; ede8 : 1..1.1..
	db 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a   ; edf0 : ........
	db 0xf1, 0x32, 0x0a, 0x32, 0x0a, 0x32, 0x0a, 0x31   ; edf8 : .2.2.2.1
	db 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a   ; ee00 : ........
	db 0x0a, 0x0a, 0xf1, 0x33, 0x0a, 0x32, 0x31, 0x0a   ; ee08 : ...3.21.
	db 0x31, 0x33, 0x37, 0x0a, 0x31, 0x0a, 0x0a, 0x0a   ; ee10 : 137.1...
	db 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0xf1   ; ee18 : ........
	db 0x34, 0x0a, 0x33, 0x0a, 0x31, 0x30, 0x0a, 0x31   ; ee20 : 4.3.10.1
	db 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a   ; ee28 : ........
	db 0x0a, 0x0a, 0xfb, 0x31, 0x33, 0x38, 0x0a, 0xf8   ; ee30 : ...138..
	db 0xf9, 0xfb, 0x30, 0x0a, 0x1e, 0xfd, 0x0a, 0xfc   ; ee38 : ..0.....
	db 0x1e, 0xfd, 0x0a, 0xfb, 0x32, 0x31, 0x0a, 0xe4   ; ee40 : ....21..
	db 0x0a, 0x0a, 0x31, 0x35, 0x0a, 0x0a, 0x0a, 0x0a   ; ee48 : ..15....
	db 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x96, 0x32   ; ee50 : .......2
	db 0x31, 0x0a, 0x31, 0x33, 0x37, 0x0a, 0xf8, 0xf9   ; ee58 : 1.137...
	db 0xfb, 0x33, 0x0a, 0x1e, 0x96, 0x33, 0x0a, 0x31   ; ee60 : .3...3.1
	db 0x30, 0x0a, 0xf8, 0xf9, 0x86, 0x06, 0x06, 0xf8   ; ee68 : 0.......
	db 0xf9, 0xfb, 0x31, 0x33, 0x38, 0x0a, 0xf8, 0xff   ; ee70 : ..138...

	;	Fills with 0xff
	ds 0x10000-$, 0xff
