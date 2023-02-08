# Aquarius_1-bit_music
Aquarius Z80 computer 1-bit music/tunes. Ported from ZX Spectrum 1-bit sources.

Aquarius uses port $FC for audio. Spit out a 1 or a 0 to this port.

out 	  ($fc), a					

The cassette port is also active - plug in a recording device to record the audio. Or plug in amplified speakers.
  
Most 1-bit music players have been assembled to $E000.
Tested in 'Virtual Aquarius' emulator: 
Load the .BIN music player to $E000 with the usr address set to $0000.
Then within BASIC, run :   X=USR(0)  to run the music player.
Some can be loaded as a cartridge and perform a soft reset.
For whatever reason some refuse to work as a cartridge (even with the correct CRC header)

I can't MAME working, but this is the command line:
mame aquariusp -bp . -cart1 [filename].bin






