SpectraGen Batch Transfer Protocols

Joe Strosnider
    started: September 4, 2025


When sending between units, it's more reliable to use the device CHANNEL NAME (SET CHN menu)
than the device system name (CPU board switches)


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
        [55 AA]		Magic Number: 2 Bytes
        [XX XX]		"SYSTEM NAME": 2 Bytes.
        [53]		Message Type: 1 byte. "S", probably meaning "SEND"
        [50]		Message Subtype: 1 Byte. "P", probably meaning "PAGE"

        [XX][XX]	Page Number, little endian: 2 bytes.
                        If a Fetch: This is the page number in the responder's memory that it is sending to the Initiator.
                        If a Send: This is the page number where the initiator wants the responder to store the page in the responder's memory.
        
        [XX] 		Checksum
                        xor first byte with 2nd byte, then xor result with 0x20, then xor result with B8
        
        [XX]		Page Skip/Page Link/Page Wait values: 1 Byte
        			Bit 7-3: unknown (always 0)
        			Bit 2: Page Wait
        			Bit 1: Page Link
        			Bit 0: Page Skip

        [XX]		DISPLAY TIME: 1 Byte
        			Bits 6-0: DISPLAY TIME value from 0x00 to 0x63 (zero to 99 in decimal)

        [xx xx]		Unknown: 2 Bytes. These two values change seemingly at random
            		Values seen: 10 02, 10 03, 20 04

        [XX..XX]    DISPLAY TIME WINDOW Field: 6 bytes
                    ... see field description below

        [XX]		"LINE LEVELS":  1 byte
                    ... see field description below

        [XX..XX]	Unknown: 5 bytes. Observed to always be 0x00

        [XX..XX]	LINE DISPLAY ATTRIBUTES: 32 bytes (eight fields).
                    ... see field description below

        [XX..XX]	PAGE DATA: 320 bytes
        		    ... all printable page data and inline control characters

        [XX]		Unknown: 1 byte. Observed to always be 0x00

        [XX]		Display Type and Speed - 1 byte
		            ... see field description below

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
LINE DISPLAY ATTRIBUTE FIELD description: 4 bytes.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	A standard blue page after ATTR ERASE is [80 01 C9 30]

	Byte 1- LINE COLOR     BACKGROUND   FOREGROUND
        			80 = 	BLUE		WHITE
        		    81 = 	RED         WHITE
        			82 = 	GREEN		WHITE
        			83 = 	WHITE		DK BLUE
        			84 = 	YELLOW		OLIVE
        			85 = 	OLIVE		YELLOW
        			86 =	VIOLET		WHITE
        			87 = 	BLACK		WHITE
        			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        			88 = 	BLUE		YELLOW
        		    89 = 	RED         YELLOW
        			8A = 	DK GREEN	YELLOW
        			8B = 	WHITE		LT BLUE
        			8C = 	YELLOW		DK GREEN
        			8D = 	BROWN		YELLOW
        			8E =	PINK		VIOLET
        			8F = 	BLACK		WHITE
        			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        			90 = 	WHITE		BLUE
        		    91 = 	WHITE		RED
        			92 = 	GREEN		RED
        			93 = 	LT BLUE		WHITE
        			94 = 	BLACK		YELLOW
        			95 = 	YELLOW		BLACK?
        			96 =	WHITE		VIOLET
        			97 = 	BLACK		WHITE
        			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        			98 = 	YELLOW		BLUE
        			99 = 	PINK		RED
        			9A = 	BUFF		GREEN
        			9B = 	MID BLUE	WHITE
        			9C = 	BLACK		YELLOW
        			9D = 	BRN         BLACK
        			9E = 	VIOLET		PINK
        			9F = 	BLACK		WHITE

	Byte 2: LINE SEPERATIONS, line heights
		Bit 7-6: Line Positions
			00......	No lines
			01......	Underline
			10......	Overline
			11......	Underline and Overline

		Bit 5-3: Line Color
			These color vary depending on the background color.
			The ones shown here are for a blue background.
			blue		..000...
			red		    ..001...
			green		..010...
			light blue	..011...
			yellow		..100...
			olive		..101...
			purple		..110...
			black      	..111...

		Bit 2-0: Line Height
			thinnest line height  .....000
			thickest line height  .....111

	Byte 3:	Font Styles and Character Widths
		Bits 7-5: Edge Thickness
			001.....	thickest edge
			011.....	thick edge
			101.....	thin edge
			110.....	no edge

		Bit 4: Font Type
			...0....	No Outline
			...1....	Outline

		Bit 3: Proportional Spacing?
			....0...	Prop Spacing
			....1...	Normal Spacing

		Bits 2-0: Character Width
			.....000	width 1	(40 char)
				-- thru --
			.....111	width 8 (8 char)

	Byte 4: Character Border, etc. (only on 4B?)
		Bit 7-6: Character border
			00......	no border
			01......	thin black border
			10......	char is outlined with its color, and inside is the background color
			11......	char is outlined with its color, and inside is black for dark colors, white for yellow and white

		Bits 5-0: Unknown. Observed to always be 0

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
			1 [...H...L]
			2 [..H...L.]
			3 [.H...L..]
			4 [H...L...]

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
DISPLAY TIME WINDOW Field: 6 bytes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        [XX]		FIRST DAY: 1 Byte
        			00 = IGNORE TIME
        			01-07 - SUN-SAT
        			08 - ALL DAYS
                    
        [XX]		FIRST DAY HOURS: 1 Byte
        			AM encoded as 1-12 with MSB unset
        			PM encoded as 1-12 with MSB set
                    
        [XX]		FIRST DAY MINS: 1 Byte.

        [XX]		LAST DAY: 1 Byte
        			00 = IGNORE TIME
        			01-07 - SUN-SAT
        			08 - ALL DAYS
                    
        [XX]		LAST DAY HOURS: 1 Byte
        			AM encoded as 1-12 with MSB unset
        			PM encoded as 1-12 with MSB set
                    
        [XX]		LAST DAY MINS: 1 Byte.
        
        
        
        
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Display Type and Speed field - 1 byte
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            The actual value of this byte is your desired value, XORd with "DISPLAY TIME"
  		    Values shown below are literals.

  			Bit 7-6:
  				always 00......
  				final value changed only by XOR with DISPLAY TIME

  			Bits 5-3: Display Speed
  				xx001xxx = slow speed
  				xx010xxx = medium speed
  				xx100xxx = high speed
   	
  			Bits 2-0: Display Type
  				xxxxx001 = BANG
  				xxxxx010 = SPLASH
  				xxxxx011 = CRAWL
  				xxxxx100 = ROLL	
  				xxxxx101 = PAGE PRINT