# Aquarius_1-bit_music
Aquarius Z80 computer 1-bit music/tunes. Ported from ZX Spectrum 1-bit sources.

Aquarius uses port $FC for audio. Spit out a 1 or a 0 to this port.

out 	  ($fc), a					

All(?) 1-bit music players have been assembled to $E000 giving them an 8K cartridge-area binary.

Virtual Aquarius:   Has only has been Tested in James' "Virtual Aquarius" emulator.
Load the .BIN music player to $E000 with the usr address set to $0000.
Then within BASIC, run :   X=USR(0)  to run the music player.
Some can be loaded as a cartridge and perform a soft reset. These do not require writing back to current memory (which will be in ROM at the time of execution). Those that refuse to work, will probably be trying to write back to ROM locations. Clearly these require a move to lower RAM --- this is a one-of-these-days things to do.


VirutalAquarius emulator Download : http://www.oocities.org/emucompboy/



MESS & MAME: Refuse to work at $4000, $C000, or $E000.

command line for cartridges ($C000 or $E000):     mame aquariusp -bp . -cart1 [filename].bin




