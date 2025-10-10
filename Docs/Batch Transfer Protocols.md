SpectraGen Batch Transfer Protocols

Joe Strosnider
    started: September 4, 2025


When sending between units, it's more reliable to use the device CHANNEL NAME (SET CHN menu)
than the device system name (CPU board switches)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Known Message Types
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    K   Remote "KEYBOARD" command       8BE5 in rom
    E - Remote "Edit"                   8BE9 in rom
    
    B - "BATCH" Message                 8BED in rom
            "P" - Page
    
    C - [43]    "COMPLETE" Message      8BF1 in rom
                B - Batch
                G - Unknown
        
    Z - Explicit No-Access Response     8BF5 in rom
    
    F - "FETCH"
            P - Page
            A - Unknown
            I - Unknown
            E - Unknown
            
    S - "SEND"
            P - Page
            E - Unknown


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"E" Message Protocol
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~







~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Authorization Handshake for the BATCH command
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	Initiator Sends
		[55 AA]		Magic Number: 2 Bytes
		[XX XX]		"SYSTEM NAME": 2 Bytes.
		[42]		Message Type: 1 byte. "B", probably meaning "BATCH"
		[50] 		Message Subtype: 1 Byte. "P", probably meaning "PAGE"
        [00]        Unknown A: 1 Byte. Value always seems to be [00]
        [00]		Unknown B: 1 Byte. Value always seems to be [00]
		[XX]		SYSTEM NAME Checksummed
                      xor first byte with 2nd byte, then xor result with 0x20, then xor result with 0xDA
        
	If the receiver's SYSTEM NAME matches what is sent, the receiver will respond with:
		[AA AA AA AA AA]	Acknowledge - 5 Bytes

	If the receiver's SYSTEM NAME does not match what is sent, the receiver will not respond. The Initiator will try to initate four more times before giving up and printing "NO ACCESS" on the screen.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Description of a "SEND" request from the "BATCH" menu: from Initiator to Receiver
	this is the actual page data after the authorization handshake has completed
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
        After the Authorization Handshake, the Initiator will perform a standard page sequence as noted in "Page Data Format" below.

        At the end of the page, the responder acknowledges with:
		[55 AA]		Magic Number: 2 Bytes
		[XX XX]		"SYSTEM NAME": 2 Bytes.
        [43]		Message Type: 1 byte. "C", probably meaning "CLOSE COMMS"
        [47]		Message Subtype: 1 Byte. "P", probably meaning "PAGE"
        [00]        Unknown A: 1 Byte. Value always seems to be [00]
        [00]		Unknown B: 1 Byte. Value always seems to be [00] 
		[XX]		SYSTEM NAME Checksummed
                      xor first byte with 2nd byte, then xor result with 0x20, then xor result with 0xDB
                    
        This send and response loop will continue until all pages are sent.

        After the last page has been sent and acknowledged, the Initator will send the message closer.

        ~ Message Closer ~
        [99]		End of Process: 1 Byte. Always 0x99
        [55 AA]		Magic Number: 2 Bytes
        [BB BB]		"SYSTEM NAME" field, but always BB BB
        [43]		Message Type: 1 byte. "C", probably meaning "CLOSE COMMS"
        [47]		Message Subtype: 1 Byte. "P", probably meaning "PAGE"
        [00]        Unknown A: 1 Byte. Value always seems to be [00]
        [00]		Unknown B: 1 Byte. Value always seems to be [00]
        [XX]        SYSTEM NAME Checksummed
                        xor first byte with 2nd byte, then xor result with 0x20, then xor result with 0xD6
                        (although, it doesn't seem to matter what this byte is - the receiver doesn't seem to check it)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Description of a "FETCH" request from the "BATCH" menu: where the Initiator is making the FETCH request
	this is the actual page data after the authorization handshake has completed
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        This process only begins after the Authorization Handshake.
        
        Initiator Sends a Fetch Request:
    	[55 AA]		Magic Number: 2 Bytes
    	[XX XX]		"SYSTEM NAME": 2 Bytes.
    	[46]		Message Type: 1 byte. "F", probably meaning "FETCH"
    	[50]		Message Subtype: 1 Byte. "P", probably meaning "PAGE"
        [XX][XX]	Page Number, little endian: 2 bytes.
    	[XX]		Checksum of Page Number fetched: 1 Byte.
                        xor first byte with 2nd byte, then xor result with 0x20, then xor result with 0xAD

        Responder Sends:
        Responder will perform a standard page sequence as noted in "Page Data Format" below.
        If there are more pages to fetch, the Initiator sends another Fetch Request with the next needed page.

        If there are no more pages to fetch, the Initiator Closes With
        [99]		End of Process: 1 Byte. Always 0x99
        [55 AA]		Magic Number: 2 Bytes
        [BB BB]		"SYSTEM NAME" field, but always BB BB
        [53]		Message Type: 1 byte. "S", probably meaning "SEND"
        [50]		Message Subtype: 1 Byte. "P", probably meaning "PAGE"
        [00]        Unknown A: 1 Byte. Value always seems to be [00]
        [00]		Unknown B: 1 Byte. Value always seems to be [00]
        [XX]		Checksum: 1 Byte. Number of total pages sent XORd with 0xFF
                    (although, it doesn't seem to matter what this byte is - the receiver doesn't seem to check it)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Error Block: Fetching page that doesn't exist
This is what you will receive if you send a "properly formatted" request to a unit
but you requested a page beyond its maximum bounds
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        [55 AA]     Magic Number 2 Bytes
        [XX XX]		"SYSTEM NAME": 2 Bytes.
        [43]        Message Type: "C", probably meaning "CLOSE COMMS"
        [49]        Message Subtype: "I", probably meaning "INVALID"
        [XX][XX]	Page Number you tried to send, little endian: 2 bytes.
        [xx]        Checksum: unknown how calculated

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SYSTEM NAME format
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The SYSTEM NAME field is a two byte value that matches the "CHANNEL NAME" in the SET CHN menu
If the SYSTEM NAME is only one character long, the first byte of this field will be 0x20, and
the second byte will be that character.

Otherwise, it will be the two bytes shown on the SET CHN menu.

Be aware that your system may be named with the first character set, and the second one set
to a space. That is totally possible!

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Page Data Format
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Display Type and Speed is an unknown!

        Index 0     [55 AA]		Magic Number: 2 Bytes
        Index 2     [XX XX]		"SYSTEM NAME": 2 Bytes.
        Index 4     [53]		Message Type: 1 byte. "S", probably meaning "SEND"
              5     [50]		Message Subtype: 1 Byte. "P", probably meaning "PAGE"

              6     [XX][XX]	Page Number, little endian: 2 bytes.
                                    If a Fetch: This is the page number in the responder's memory that it is sending to the Initiator.
                                    If a Send: This is the page number where the initiator wants the responder to store the page in the responder's memory.
        
              8     [XX] 		Header Checksum
                                   xor first byte with 2nd byte, then xor result with 0x20, then xor result with B8
        
              9     [XX]		Page Skip/Page Link/Page Wait values: 1 Byte
        			            Bit 7-3: unknown (always 0)
        			            Bit 2: Page Wait
        			            Bit 1: Page Link
        			            Bit 0: Page Skip

             10     [XX]		DISPLAY TIME: 1 Byte
        			            Bits 6-0: DISPLAY TIME value from 0x00 to 0x63 (zero to 99 in decimal)

             11     [xx]        DISPLAY SPEED: 1 Byte.
                                ... see field description below
        
             12     [xx]		DISPLAY TYPE: 1 Byte.
                                ... see field description below

             13     [XX][XX][XX]    DISPLAY TIME WINDOW Field: 6 bytes  
             16     [XX][XX][XX]     ... see field description below

             19     [XX]		"LINE LEVELS":  1 byte
                                ... see field description below
                    
                    [XX]        Unknown: 1 byte. Observed to always be 0x00
        
                    [XX]        Tape Actions and Player Number: 1 Byte
                                ... see field description below
                    
                    [XX]          Unknown: 1 byte. Observed to always be 0x00
                    [XX]          Unknown: 1 byte. Observed to always be 0x00
                    [XX]          Unknown: 1 byte. Observed to always be 0x00

                    [XX..XX]	LINE DISPLAY ATTRIBUTES: 32 bytes (eight fields).
                                ... see field description below

                    [XX..XX]	PAGE DATA: 320 bytes
        		                ... all printable page data and inline control characters

                    [XX]		Unknown: 1 byte. Observed to always be 0x00

                    [XX]		Page Checksum: 1 byte
                                ... see field description below

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DISPLAY TIME WINDOW Field: 6 bytes [offset 13 bytes, if zero indexed]
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        [XX]		FIRST DAY: 1 Byte
        			00 = IGNORE TIME
        			01-07 - SUN-SAT
        			08 - ALL DAYS
                    
        [XX]		FIRST DAY HOURS: 1 Byte
                    all hours   00  00000000
                    all other real hours stored as the literal hour
                    
        			AM encoded as 1-12 with MSB unset: 1 is 01
        			PM encoded as 1-12 with MSB set: 1 is 81
                    
        [XX]		FIRST DAY MINS: 1 Byte.
                    all hours   00
                    Otherwise, minutes are stored as literal number from 0-59
                    

        ######################################################################
        [XX]		LAST DAY: 1 Byte
        			00 = IGNORE TIME
        			01-07 - SUN-SAT
        			08 - ALL DAYS
                    
        [XX]		LAST DAY HOURS: 1 Byte
                    all hours   00  00000000
                    all other real hours stored as the literal hour
                    
        			AM encoded as 1-12 with MSB unset: 1 is 01
        			PM encoded as 1-12 with MSB set: 1 is 81
                    
        [XX]		LAST DAY MINS: 1 Byte.
                    all hours   00
                    Otherwise, minutes are stored as literal number from 0-59
        
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DISPLAY SPEED field - 1 byte
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                    SLOW    08      00001 000
                    MEDIUM  10      00010 000
                    FAST    20      00100 000

It seems like DISPLAY SPEED and DISPLAY TYPE were supposed to be a single field, but
a programming error that made it into production made them seperate fields,
so CompuVid just kept it that way. I could be totally wrong.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DISPLAY TYPE field - 1 byte
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                    BANG        01  00000 001
                    SPLASH      02  00000 010
                    CRAWL       03  00000 011
                    ROLL        04  00000 100
                    PAGE PRINT  05  00000 101
                    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"LINE LEVELS" field - 1 byte, encoded oddly. Probably XOR'd with something.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			Numerical value of each possible setting
			    HL
			N = 00 (0x00)
			H = 01 (0x01)
			L = 10 (0x02)
			P = 11 (0x03)

			Locations of the required bits in this byte
			1 [...H ...L]
			2 [..H. ..L.]
			3 [.H.. .L..]
			4 [H... L...]

			Here are some examples.
			
			1234
			NNNN = 00 0000 0000
			PPPP = FF 1111 1111
			LLLL = F0 1111 0000
			HHHH = 0F 0000 1111

			1234
			NNNP = 88 1000 1000
			NNNL = 80 1000 0000
			NNNH = 08 0000 1000

			1234
			NNPN = 44 0100 0100
			NNLN = 40 0100 0000
			NNHN = 04 0000 0100

			1234
			NPNN = 22 0010 0010
			NLNN = 20 0010 0000
			NHNN = 02 0000 0010

			1234
			PNNN = 11 0001 0001
			LNNN = 10 0001 0000
			HNNN = 01 0000 0001

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Tape Actions and Player Number
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Bits 7-6:   Unknown
    
    Bits 5-4: Tape Actions
            ..00....    N=None
            ..01....    P=Play
            ..10....    S=Stop
            ..11....    R=Rewind
    

    Bits 3-0: Player Number
            ....0000    Video B
            ....0001    VTR 1
            ....0010    VTR 2
            ....0011    VTR 3
            ....0100    VTR 4
            ....0101    VTR 5
            ....0110    VTR 6
            ....0111    VTR 7
            ....1000    VTR 8
            ....1001    VTR 9
            ....1010    VTR 10 
            ....1011    VTR 11
            ....1100    VTR 12
            ....1101    VTR 13
            ....1110    VTR 14
            ....1111    Video A 
                      
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
LINE DISPLAY ATTRIBUTE FIELD description: 4 bytes.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	A standard blue page after ATTR ERASE is [80 01 C9 30]
                                             80 06 C9 30

	Byte 1: Line Fill Options
    
        Bit 7: EXT Video
            No External     0.......
            External        1.......

        Bits 6-5:   Unknown
        
        Bits 4-0: Background/Foreground Color Combo
    
                                        BACKGROUND   FOREGROUND
                    00      ...00000    BLUE		WHITE
        		    01      ...00001    RED         WHITE
        		    02      ...00010    GREEN		WHITE
        		    03      ...00011    WHITE		DK BLUE
        		    04      ...00100    YELLOW		OLIVE
        		    05      ...00101    OLIVE		YELLOW
        		    06      ...00110    VIOLET		WHITE
        		    07      ...00111    BLACK		WHITE
        			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        		    08      ...01000    BLUE		YELLOW
        		    09      ...01001    RED         YELLOW
        		    0A      ...01010    DK GREEN	YELLOW
        		    0B      ...01011    WHITE		LT BLUE
        		    0C      ...01100    YELLOW		DK GREEN
        		    0D      ...01101    BROWN		YELLOW
        		    0E      ...01110    PINK		VIOLET
        		    0F      ...01111    BLACK		WHITE
        			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                    10      ...10000    WHITE		BLUE
                    11      ...10001    WHITE		RED
                    12      ...10010    GREEN		RED
                    13      ...10011    LT BLUE		WHITE
                    14      ...10100    BLACK		YELLOW
                    15      ...10101    YELLOW		BLACK?
                    16      ...10110    WHITE		VIOLET
                    17      ...10111    BLACK		WHITE
        			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                    18      ...11000    YELLOW		BLUE
                    19      ...11001    PINK		RED
                    1A      ...11010    BUFF		GREEN
                    1B      ...11011    MID BLUE	WHITE
                    1C      ...11100    BLACK		YELLOW
                    1D      ...11101    BRN         BLACK
                    1E      ...11110    VIOLET		PINK
                    1F      ...11111    BLACK		WHITE

	Byte 2: LINE SEPERATIONS & CHARACTER HEIGHTS
		Bit 7-6: Seperator Type       
			None             00......	
			Underline        01......	
			Overline         10......	
			Both             11......	

		Bit 5-3: Seperator Color
			These color vary depending on the background color.
			The ones shown here are for a blue background.
			blue             ..000...
			red              ..001...
			green            ..010...
			white            ..011...
			yellow		     ..100...
			olive            ..101...
			purple		     ..110...
			black            ..111...

		Bit 2-0: Line Height
			Shortest Chars   .....000
			Tallest Chars    .....111

	Byte 3:	Font Styles and Character Widths
		Bits 7-5: Drop Shadow
			000.....	Largest Shadow
			111.....	no shadow

		Bit 4: Font Type
			...0....	Primary Font
			...1....	Alternate Font

		Bit 3: Proportional Spacing?
			....0...	Prop Spacing
			....1...	Normal Spacing

		Bits 2-0: Character Width
			.....000	width 1	(40 char)
				-- thru --
			.....111	width 8 (8 char)

	Byte 4: Character Border, etc. (only on 4B?)
		Bit 7-6: Character border
        30  00110000
        70  01110000
        B0  10110000
        F0  11110000
			00......	no border
			01......	thin black border
			10......	char is outlined with its color, and inside is the background color
			11......	char is outlined with its color, and inside is black for dark colors, white for yellow and white

        Bits 5-4: Unknown. Observed to always be 1
            ..11....
            
		Bits 3-0: Unknown. Observed to always be 0
            ....0000

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Page Checksum field - 1 byte
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
This is an XOR of the entire page data, starting from the byte immediately after
the header checksum, through the last byte in the page.

Python Code to explain how it works.
    def ChecksumPage(array,start,end):
        checksum=0
        for i in range(start,end):
            checksum = checksum ^ array[i]
        return checksum
    
    