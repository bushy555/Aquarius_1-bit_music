;ntropic
;;converted over to Aquarius by Bushy.
;Assembled to $e000 with Pasmo Assembler.
;
;
;Load in Binary file : "ntropic.bin"
;at memory $E000
;usr Execution at $0000
;
;Then back at basic, run   X=USR(0)





;	org	$4000		; Aquarius 4k cassette/cartridge
;	org	$c000		; Aquarius lower 8k cartridge
	org	$e000		; Aquarius upper 8k cartridge
;	org	$100		; Microbee
;	org	$8000		; VZ
; 	org	$4000		; ZX Spectrum


     db  98, 117, 115, 104
     db  121, 156, 50, 176
     db  48, 108, 50, 100
     db  50, 168, 183, 112



;	out 	($fc),a					;11		; Aquarius
;	out 	($fe),a					;11		; ZX
;	AND	$21							; VZ
;	ld	($6800), a						; VZ
;	out 	(2),a					;11		; MICROBEE



;ntropic
;beeper routine by utz 01'14 (irrlichtproject.de)
;2ch tone, 1ch noise, click drum, size 151 bytes
;uses ROM data in range $0000-$3800
;this code is public domain

;1tracker version by Shiru, 2014



start:

begin:
	ld	hl,musicData

ntropic:
	di
	ld a,(hl)
	ld (speed + 1),a	;?
	inc hl

lpt:
	ld e,(hl)		;read pattern pointer
	inc hl
	ld d,(hl)
	xor a
	or d
	;begin
	jr z,begin
	;jr z,ntropic	;if d=0, loop to start
;	jr z,exit		;or exit
	inc hl
	push hl			;preserve pattern pointer
	ex de,hl		;put data pointer in hl

	call main

	pop hl
	jr z,lpt		;if no key has been pressed, read next pattern

exit:
	ld hl,$7ae9		;restore hl' for return to BASIC
	exx
	;jr $			;prevent exit and interrupts because it glitches out the sound in the editor
	ei
	ret

;****************************************************************************************
main:
	push hl			;preserve data pointer

rdata:
	ld a,255
	ld (m1 + 1),a	;?
	ld (m2 + 1),a	;?

speed:	;defc speed = 1	;speed=$+1	?
	ld a,0
	ld b,a			;timer
	;ld c,b
	pop hl			;restore data pointer

	ld a,(hl)		;read drum byte
	inc a			;and exit if it was $ff
	ret z

	dec a
	call nz,drum

	inc hl

;	in a,($fe)		;read keyboard
;	cpl
;	and $1f
;	ret nz

	ld a,(hl)		;read counter ch1

	or a			;mute switch ch1
	jr nz,rsk1
	ld (m1 + 1),a	;?

rsk1:
	ld d,a
	ld e,a

	inc hl

	push hl			;read counter ch2
	exx
	pop hl
	ld a,(hl)

	or a			;mute switch ch2
	jr nz,rsk2
	ld (m2 + 1),a

rsk2:
	ld d,a
	ld e,d
	exx

	inc hl
	ld a,(hl)		;read noise length val
	inc hl
	push hl			;preserve data pointer
	ld h,a			;setup ROM pointer for noise, length to h
	xor a			;mask for ch1
	ld l,a			;and part 2 of ROM pointer setup
	ex af,af'
	xor a
	push af			;mask for ch2

;****************************************************************************************
sndlp:
	ex af,af'
	dec d			;decrement counter ch1
	jr nz,skip1		;if counter=0

m1:		;defc m1 = 1		;m1=$+1	?

	xor 1		;flip output mask and reset counter
	ld d,e
	
skip1:

	out 	($fc),a					;11		; Aquarius
;	out 	($fe),a					;11		; ZX
;	AND	$21							; VZ
;	ld	($6800), a						; VZ
;	out 	(2),a					;11		; MICROBEE
	ex af,af'
	exx
	pop af			;load output mask ch2
	dec d			;decrement counter ch2
	jr nz,skip2		;if counter=0

m2:		;defc m2 = 1		;	m2=$+1	?
	xor 1			;flip output mask and reset counter
	ld d,e
	
skip2:
	

	out 	($fc),a					;11		; Aquarius
;	out 	($fe),a					;11		; ZX
;	AND	$21							; VZ
;	ld	($6800), a						; VZ
;	out 	(2),a					;11		; MICROBEE
	push af			;preserve output mask ch2
	exx


noise:
	ld a,(hl)		;read byte from ROM


	out 	($fc),a					;11		; Aquarius
;	out 	($fe),a					;11		; ZX
;	AND	$21							; VZ
;	ld	($6800), a						; VZ
;	out 	(2),a					;11		; MICROBEE

	bit 7,h			;check if ROM pointer has rolled over to $ffxx
	jp nz,dtim		;1 byte more, but will make the noise quieter

	dec hl			;decrement ROM pointer

dtim:
	dec bc			;decrement timer
	ld a,b
	or c
	jr nz,sndlp		;repeat sound loop until bc=0

	pop af			;clean stack
	jr rdata		;read next note

;****************************************************************************************
drum:
	push hl			;preserve data pointer
	push bc			;preserve timer
	ld hl,$500		;setup ROM pointer - change val for different drum sounds
	ld de,$0809		;loopldiloop
	ld b,72

dlp3:
	ld a,(hl)		;read byte from ROM

	out 	($fc),a					;11		; Aquarius
;	out 	($fe),a					;11		; ZX
;	AND	$21							; VZ
;	ld	($6800), a						; VZ
;	out 	(2),a					;11		; MICROBEE

	;dec hl			;decrement ROM pointer $2b/$23 (inc hl)
	inc hl			;use this instead for quieter click drum
	dec bc			;decrement timer

dlp4:
	dec d
	jr nz,dlp4

	ld d,e
	inc e
	djnz dlp3

	pop bc			;restore timer
	pop hl
	dec b			;adjust timing
	ret






;patterns can be any length
;pattern tab must end with defb $00
;format: drum ,ch1,ch2,noise[,end]
;values: drum: $00 - off, $ff - pattern end, any other value - drum on
;        ch1/2: $00 - off, $01-$fe - tones
;        noise: $00-$38 - length, $fe - off

;compiled music data



musicData:
	defb 2
;	defw ptn,0
	defw ptn0
	defw ptn0
	defw ptn1
	defw ptn1,0	
	
ptn0:
	defb 1,77,38,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,69,34,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,77,38,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,58,29,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 1,43,21,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,69,29,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,38,19,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,43,21,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 1,34,17,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,38,19,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,43,21,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,21,21,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 1,51,25,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,69,34,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,87,43,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,77,38,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 1,77,21,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,69,34,254
	defb 0,69,34,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,77,25,254
	defb 0,77,25,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,58,58,254
	defb 0,58,58,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 1,43,19,254
	defb 0,43,19,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,34,69,254
	defb 0,34,69,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,38,29,254
	defb 0,38,38,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,43,87,254
	defb 0,43,87,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 1,69,34,254
	defb 0,69,34,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,77,77,254
	defb 0,77,77,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,87,29,254
	defb 0,87,29,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,25,51,254
	defb 0,25,25,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 1,51,103,254
	defb 0,51,103,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,116,21,254
	defb 0,116,21,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 1,116,34,254
	defb 0,116,34,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 1,116,21,254
	defb 0,116,21,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 255
	
ptn1:
	defb 1,43,77,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,38,69,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,34,77,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,29,58,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 1,34,43,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,38,69,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,43,38,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,51,43,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 1,43,34,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,51,38,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,29,43,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,43,87,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 1,34,51,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,38,69,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,29,87,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,43,77,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 1,38,87,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,34,77,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,38,69,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,29,58,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 1,21,69,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,29,77,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,19,87,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,21,103,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 1,17,87,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,19,103,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,21,138,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,21,87,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 1,25,69,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,34,87,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 1,43,138,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 1,38,69,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 0,0,0,254
	defb 255



end
