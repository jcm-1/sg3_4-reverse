import re

# create python program that reads a 65536 bytes binary file (named "rom-57.bin") into a 65536 element array. it then reads a text file named "rom-57.asm" line after line, and write the lines in a new file name "rom-57-commented.asm" For each line read from the file, if it starts with a tab followed by "M_OUT_MSG" and a space, then call a function "comment_out_msg", passing the line. This function just returns the line.

def get_string(binary_data, adrs, len):
	if adrs>=0x4000 and adrs<0x8000:
		return "*** RAM data ***"

	# Extract the relevant bytes from binary_data
	bytes = binary_data[adrs:adrs+len]

	# Convert the bytes to a formatted string
	formatted_string = ''
	quotes = False
	for byte in bytes:
		if 0x20 <= byte <= 0x7E:
			if not quotes:
				formatted_string += '"'
				quotes = True
			formatted_string += chr(byte)
		else:
			if quotes:
				formatted_string += '" '
				quotes = False
			if byte == 0x05:
				formatted_string += "CRLF "
			elif byte == 0x09:
				formatted_string += "RIGHT "
			else:
				formatted_string += f"{byte:02X} "
	if quotes:
		formatted_string += '"'

	return formatted_string

def comment_out_msg(binary_data, line):
	# Skip the tab and "M_OUT_MSG", and extract the 16-bit and 8-bit numbers
	match = re.search(r'\tM_OUT_MSG (0x[0-9a-fA-F]{4}), (0x[0-9a-fA-F]{2})', line)
	if match:
		adrs = int(match.group(1), 16)
		len = int(match.group(2), 16)
		line = f"\tM_OUT_MSG {adrs:#06x}, {len:#04x} ; {get_string(binary_data, adrs,len)}\n"
	return line

def process_files():
	# Read binary file into array
	with open('/home/fred/Development/sg4b-reverse/rom-57.bin', 'rb') as f:
		binary_data = list(f.read())

	# Process assembly file
	with open('/home/fred/Development/sg4b-reverse/rom-57.asm', 'r') as infile, open('/home/fred/Development/sg4b-reverse/rom-57-commented.asm', 'w') as outfile:
		for line in infile:
			if line.startswith('\tM_OUT_MSG '):
				line = comment_out_msg(binary_data, line)
			outfile.write(line)

process_files()
