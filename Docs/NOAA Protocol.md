Notes about the NOAA system on the SpectraGen 3B/4B

Baud Rate
Because of the parsing engine on the unit, it is not fast enough to keep up with
baud rates higher than 2400.

Data Format
NOAA Messages are formatted as thus:
  - HEADER: the first four characters of your message must match the "OPEN CODE"
    you have set in the unit's NOAA settings
  - FOOTER: the last two characters of your message must be
    two dollar signs => $$
  - The included test script adds the header and footer, so you don't need to
    type these into the transcript field.
  - Any script you write should do sanity checking to ensure that $$ is somehow
    stripped or replaced before being sent, or the message will show truncated
    on your unit.
    
Newline Parsing
The parsing system doesn't understand what newlines are. Linefeed characters are
ignored. Carriage Return characters are replaced with a single space.

I believe that the designers intended NOAA feeds to be put on a side-scrolling
ticker, not an entire page. 

If you want your screens to have newlines, you'll need to format your data so
that lines wherever a newline would be are padded with spaces to match the 
characters-per-line setting of the desgination page on the Spectragen.

Example for a 32 character wide page with the following:
"LOW 30.
TOMORROW'S FORCAST FOR..."

would be "LOW 30.[25 spaces]TOMORROW'S FORCAST FOR..."

Dollar Sign Parsing
When sending single $ characters, the unit will always "eat" the one you send.
This is related to its parsing of the footer, as the $ is never expected to 
exist in an NOAA message other than in the footer.