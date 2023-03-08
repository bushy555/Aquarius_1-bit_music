	; Aquarius 'CAQ' Cassette Header for self-loading/self-installing of 
	; a BASIC loader for assembly binary programs.
	; Add this header, and it *should* auto create its own BASIC loader ,so 
	; that upon CLOADing your program in, you can then just type RUN to 
	; execute your binary program on the Aquarius computer.
	; This is found within the VirtualAquarius emulator's cassette directory - 
	; All credits go to James Tamer, creator of this emulator.

	; Use SJASMplus assembler.


	output "filename.caq"		; Assembler: SJASM

	.org $38E1
	.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	.byte $00

	; cassette tape file name, displays on screen during CLOADing, 6 characters.
	.byte " name "
	; end name

	.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

	; $3900
	.byte $00
	; line link, line number
	.byte $25,$39,$0a,$00
	; rem
	.byte $8e
	.byte " for Aquarius S2 (do not edit)"
	.byte 00
	; line link, line number
	.byte $2d, $39, $14, $00
	; B=0
	.byte $42, $B0, $30
	.byte 00
	; line link, line number
	.byte $49, $39, $1e, $00
	; poke 14340,nnn:poke 14341,mmm
	.byte $94, $20, "14340", $2C, "088"
	.byte $3A
	.byte $94, $20, "14341", $2C, "057"
	.byte 00
	; line link, line number
	.byte (MLEND & 255)
	.byte (MLEND >> 8)
	.byte $28, $00
	; B=USR(0):END
	.byte $42, $B0,$B5,$28,$30,$29,$3A,$80
	.byte $00
	.byte $00,$00
MLSTART


	<asm goes here>


MLEND
end
