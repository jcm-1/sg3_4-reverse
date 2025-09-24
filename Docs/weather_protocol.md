# Packet

Field	Name	Value	How to Calculate
0	magic	FF	Magic number. Must be FF.
1	magic	FA	Magic number. Must be FA.
2	magic	F5	Magic Number. Must be F5

3 - Temperature, 0-254

## Converting real-world temp to input

x = (Celcius*10+550)/10
x = (Farhenheit*10+670)/18

x>=0 and x<0xff

## Converting input byte to displayed temp:

Celcius:    (x*10-550)/10
Farhenheit: (x*18-670)/10


4 - Wind direction: 1 byte, lower nibble:
|  Digit  | Value |
| :-----: | :---: |
|    5    |  NE   |
|    6    |  NW   |
|    7    |  N    |
|    9    |  SE   |
|    A    |  SW   |
|    B    |  S    |
|    D    |  E    |
|    E    |  W    |
high nibble ignored

5	Humidity	0-99	Literal percentage value. Values higher than 99 ignored.

6	Wind Speed	0-254	For MPH, multiply current wind by 2. So for a wind of 25mph, send decimal 50.
			For KPH, convert from MPH and round up greedily. So 25mph, despite being 40.2336 kph will read 41 KPH
			
7	Barometer	0-254	Displays "literal" pressure in inches.
			For Inches values between 29.00 and 29.99, send the literal value of the last two digits. For values 30.00 and above, send literal 100 to 254.
			For kilopascals, convert from inches and round up greedily. So, 29.00", despite 98.2053 kpa will read 98.3.

Will only update if changes value/8

8	Rain?	0-254	This is an incrementing value. Does not take literals.
			First packet at startup must be 00. If you are ever unsure. Start by sending 00 twice, then incrementing from there.
			Can only increment by 0.01 inches per packet, or 0.1CM per packet. 
			Each increment must be sent a value exactly 1 more than the previous increment, or it won't work.
			So, 0, then 1, then 2, then 3, etc.
			
9	Footer	00	Must Be 00
A	Footer	00	Must Be 00

