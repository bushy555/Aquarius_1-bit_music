

;Simple Z80 speech synthesizer
;by utz 08'13
;in: bc - address of text to speak
;uses/destroys: af,af',bc,hl

	aquarius_soundbit_high 	equ	01
	zx_soundbit_high 	equ	16
	vz_soundbit_high 	equ	32
	microbee_soundbit_high  equ	64


;	out 	($fc),a					;11		; Aquarius
;	out 	($fe),a					;11		; ZX
;	AND	$21							; VZ
;	ld	($6800), a						; VZ
;	out 	(2),a					;11		; MICROBEE



;	org	$4000		; Aquarius 4k cassette/cartridge
	org	$c000		; Aquarius lower 8k cartridge
;	org	$e000		; Aquarius upper 8k cartridge
;	org	$100		; Microbee
;	org	$8000		; VZ
; 	org	$4000		; ZX Spectrum

	
	defb    $53,$43,$30,$38,$4B,$9C,$B5,$B0,$A8,$6C,$AC,$64,$CC,$A8,$06,$70





begin
	ld	hl, msg0
	ld	de, $3000
	ld	bc, 40
	ldir

	ld	bc, msg1
	di
	call 	speak
	ld 	a, aquarius_soundbit_high

	out 	($fc),a					;11		; Aquarius
;	out 	($fe),a					;11		; ZX
;	AND	$21							; VZ
;	ld	($6800), a						; VZ
;	out 	(2),a					;11		; MICROBEE


	ei
	ret

speak	ld 	a, $07		;revert potential code modification
	ld 	(sval), a
next	ld 	a, (bc)		;load character code
	or 	a			;if it is 0,  end of message reached
	ret 	z
	push 	bc			;preserve msg pointer
	ld 	hl, table		;point to jump table
	cp 	97
	jr 	nc, ofs
	ld 	(sval), a
	jr 	skip
ofs	sub 	97			;subtract ascii offset
	add 	a, a			;calculate table offset
	ld 	c, a
	xor 	a
	ld 	b, a
	add 	hl, bc		;add offset to table pointer
	ld 	c, (hl)		;load sample address to bc
	inc 	hl
	ld 	b, (hl)
	push 	bc
	pop 	hl			;put sample address in hl
	ld 	a, aquarius_soundbit_high
	call 	rdata		;output speech
skip	pop 	bc			;restore & increase msg pointer
	inc 	bc
	jr 	next
rdata	ex 	af, af'
	ld 	b, (hl)		;read sample data
	xor 	a
	cp 	b
	jr 	z, pdone		;if it is 0,  end of sample reached
	ex 	af, af'

	out 	($fc),a					;11		; Aquarius
;	out 	($fe),a					;11		; ZX
;	AND	$21							; VZ
;	ld	($6800), a						; VZ
;	out 	(2),a					;11		; MICROBEE


waitlp	push 	hl
sval 	EQU 	$+1
	ld 	l, $1a		;self-modifying speed adjustment
ilp	dec 	l
	jr 	nz, ilp
	pop 	hl
	djnz 	waitlp
	inc 	hl
	xor 	aquarius_soundbit_high
	jr 	rdata
pdone	ex 	af, af'
	ret
	

msg0	db	$0a,$0a,$0a," WELCOME TO THE AQUARIUS COMPUTER ",$0a,$0a,$0a,0,0

msg1	db 	7,"welkum{{",7,"tuu{",7,"{ja{"
	db 	7,"{{{ack{rar{ius{{{{" 
	db 	7,"kom{putar{{{{{",0,0

table	dw aa,bb,cc,dd,ee,ff,gg,hh
	dw ii,jj,kk,ll,mm,nn,oo,pp
	dw qq,rrr,ss,tt,uu,vv,ww,xx,yy,zz,gap	

aa	db $08,$07,$0A,$08,$07,$07,$07
	db $09,$02,$04,$08,$06,$0B,$08,$07,$07,$07,$09,$02,$04,$08,$06,$0B
	db $07,$08,$08,$06,$09,$03,$03,$08,$07,$0A,$07,$08,$08,$07,$09,$02
	db $04,$08,$06,$0B,$07,$08,$08,$06,$09,$03,$03,$08,$07,$0B,$07,$07
	db $09,$06,$09,$03,$03,$08,$07,$0A,$08,$07,$09,$06,$09,$03,$03,$08
	db $07,$0A,$08,$08,$08,$06,$09,$03,$03,$08,$07,$0B,$07,$08,$08,$07
	db $09,$02,$04,$08,$06,$0B,$07,$08,$08,$07,$09,$02,$04,$08,$07,$0A
	db $07,$08,$09,$06,$09,$03,$03,$08,$07,$0B,$07,$08,$08,$07,$09,$02
	db $04,$08,$07,$0A,$07,$08,$09,$06,$0A,$02,$04,$07,$07,$0B,$07,$08
	db $09,$06,$09,$03,$04,$07,$07,$0B,$07,$08,$09,$06,$09,$03,$04,$08
	db $06,$0B,$07,$08,$09,$07,$09,$02,$04,$08,$07,$0B,$06,$09,$09,$06
	db $09,$03,$04,$07,$07,$0B,$07,$08,$09,$07,$09,$02,$04
	db 0
bb
	db $2B,$20,$26,$22,$2C,$1A,$01,$03,$11,$02,$05,$06,$05,$02,$09
	db $15,$02,$03,$16,$04,$02,$09,$02,$04,$03,$15,$02,$02,$15,$10,$09
	db $14,$02,$03,$14,$0D,$ff
	db 0
cc
	db $0F,$04,$05,$05,$08,$04,$05,$12,$03,$10,$04,$04,$04,$0A,$0A
	db $10,$04,$04,$05,$1B,$04,$10,$05,$18,$19,$04,$08,$04,$05,$05,$19
	db $10,$06,$03,$06,$05,$32,$04,$03,$04,$04,$65,$36,$0D,$04,$12,$04
	db $10,$03,$24,$03,$25,$04,$0E,$12,$05,$04,$04,$06,$04,$06,$05,$05
	db $06,$52,$10,$10,$04,$1D,$0B,$1A,$06,$2A,$06,$04,$10,$06,$05,$05
	db $05,$2D,$04,$09,$04,$07,$03,$11,$05,$05,$3C,$37,$04,$03,$03,$03
	db $04,$08,$04,$04,$0A,$10,$2A,$2A
	db 0
dd
	db $26,$28,$1D,$02,$04,$07,$04,$20,$1D,$04,$0F,$1E,$18,$04,$0D
	db $21,$2D,$18,$02,$02,$ff
	db 0
ee
	db $02,$02,$11,$2A,$06,$0E,$01,$02,$12,$0A,$15,$0A,$06,$0E,$01
	db $02,$0F,$0D,$11,$11,$03,$0D,$02,$02,$0E,$0E,$10,$0B,$09,$0D,$02
	db $02,$0E,$0F,$0E,$0C,$09,$0E,$02,$02,$0E,$0E,$10,$0C,$09,$0E,$02
	db $02,$0D,$0F,$11,$0C,$09,$0E,$02,$02,$0E,$2D,$09,$0D,$02,$02,$0E
	db $45,$02,$02,$4A,$0E
	db 0
ff
	db $23,$23,$04,$34,$06,$03,$06,$09,$02,$07,$08,$03,$22,$02,$16
	db $0F,$04,$08,$08,$2D,$06,$07,$05,$07,$04,$09,$02,$21,$0B,$06,$0D
	db $07,$1A,$08,$07,$1B,$01,$0E,$06,$0E,$07,$14,$04,$19,$02,$04,$06
	db $09,$04,$05,$05,$0B,$06,$06,$02,$0E,$06,$02,$0A,$06,$07,$1B,$05
	db $03,$02,$0A,$13,$11,$01,$0E,$04,$19,$0C,$06,$13,$01,$13,$14,$0D
	db $06,$01,$0C,$05
	db 0
gg
	db $05,$02,$29,$28,$30,$21,$1B,$02,$13,$2C,$21,$2D,$36,$21,$ff
	db 0
hh
	db $15,$4B,$08,$09,$02,$09,$1A,$09,$25,$0E,$12,$18,$03,$07,$08
	db $19,$08,$1A,$23,$19,$0B,$03,$07,$04,$12,$08,$06,$07,$05,$08,$09
	db $08,$0A,$07,$0F,$07,$09,$08,$08,$0A,$15,$02,$02,$02,$0C,$08,$06
	db $0F,$06,$0E,$07,$06,$05,$07,$07,$07,$08,$08,$0A,$08,$08,$08,$06
	db $06,$09,$04,$01,$08,$07,$07,$09,$08,$08,$09,$14,$01,$06,$0B,$07
	db $0E
	db 0
ii
	db $3D,$10,$02,$02,$3D,$11,$02,$02,$39,$15,$02,$02,$39
	db $15,$02,$02,$39,$15,$02,$02,$39,$15,$02,$02,$39,$15,$02,$02,$39
	db $15,$02,$02,$39,$15,$02,$02,$3A,$15,$02,$02,$39,$15,$02,$02,$3B
	db $15,$02,$02,$3A,$15,$02,$02,$3B,$15,$02,$02,$3B,$15,$02,$02
	db 0
jj
	db $06,$0D,$09,$01,$04,$0A,$01,$02,$12,$0C,$01,$04,$03,$01,$04
	db $01,$08,$01,$01,$02,$01,$02,$01,$02,$01,$01,$06,$0D,$01,$07,$08
	db $01,$06,$06,$03,$02,$01,$06,$0E,$01,$05,$0C,$02,$04,$01,$02,$01
	db $08,$01,$07,$35,$08,$04,$01,$02,$01,$01,$0B,$01,$04,$08,$15,$01
	db $08,$01,$01,$04,$18,$04,$05,$01,$04,$08,$01,$06,$01,$01,$02,$01
	db $0A,$07,$0D,$03,$04,$02,$07,$02,$01,$04,$01,$05,$04,$01,$08,$0A
	db $01,$04,$0D,$01,$04,$04,$02,$01,$02,$04,$01,$08,$01,$01,$02,$01
	db $12,$02,$01,$02,$01,$0B,$1A,$01,$02,$01,$01,$02,$07,$04,$04,$04
	db $01,$08,$01,$01,$05,$01,$01,$02,$01,$01,$03,$09,$01,$03,$02,$01
	db $05,$02,$01,$01,$04,$08,$02,$01,$04,$08,$06,$08,$04,$02,$0D,$0D
	db $07,$01,$01,$01,$02,$02,$04,$01,$04,$02,$01,$10,$0E,$04,$08,$01
	db 0
kk
	db 255
	db $02,$05,$02,$05,$02,$05,$02,$02,$02,$05,$02,$12,$02,$04,$03
	db $04,$03,$04,$02,$04,$04,$03,$03,$0A,$03,$04,$03,$04,$03,$18,$04
	db $03,$03,$04,$02,$07,$03,$02,$03,$03,$04,$02,$02,$04,$04,$03,$03
	db $07,$02,$39,$09,$09,$02,$02,$0B,$04,$02,$03,$01,$06,$01,$04,$0B
	db $05,$02,$0E,$02,$04,$02,$05,$02,$09,$03,$02,$03,$03,$06,$05,$02
	db $04,$04,$02,$04,$02,$03,$03,$01,$02,$03,$04,$01,$03,$02,$02,$02
	db $0B,$02,$05,$03,$05,$01,$05,$02,$03,$03,$03,$04,$01,$05,$0C,$02
	db $05,$01,$04,$07,$02,$02,$17,$08,$10,$0B,$02,$02,$0C,$02,$07,$03
	db $02,$05,$02,$02,$13,$01,$02,$02,$24,$04,$03,$01
	db 0
ll
	db $0C,$08,$08,$13,$13,$21,$09,$11,$02,$01,$16,$1A,$0D,$12,$02
	db $01,$19,$16,$0E,$12,$02,$02,$18,$0E,$14,$15,$02,$01,$15,$14,$12
	db $15,$01,$02,$15,$0D,$19,$15,$01,$02,$15,$1D,$09,$14,$02,$02,$15
	db 0
mm
	db $3F,$15,$3F,$14,$3F,$15,$3E,$15,$3F,$15,$E8,$14,$3F,$15,$3F
	db $16,$40,$16
	db 0
nn
	db $3F,$15,$40,$15,$41,$14,$41,$15,$41,$14,$41,$15,$42,$14,$42
	db $16,$42,$15,$42,$15,$43,$14,$44,$14,$43,$19,$41
	db 0
oo
	db $0A,$08,$09,$08,$07,$09,$10,$0F,$09,$09,$08,$08,$08,$09,$10,$0E
	db $09,$09,$09,$08,$07,$09,$11,$0E,$09,$09,$08,$09,$07,$09,$11,$0E
	db $09,$09,$08,$09,$07,$09,$11,$0E,$09,$09,$08,$09,$07,$09,$11,$0E
	db $09,$0A,$08,$08,$08,$09,$11,$0E,$09,$09,$09,$08,$08,$09,$10,$0F
	db $09,$09,$09,$08,$08,$09,$10,$0F,$09,$09,$08,$09,$08,$09,$10,$0F
	db 0
pp
	db $06,$1A,$14,$CA,$0A,$0C,$01,$25,$01,$0F,$01,$0F,$0A,$02,$02
	db $03,$10,$2A,$02,$01,$27,$34,$01,$04,$03,$02,$06,$02,$03,$01,$02
	db $04
	db 255,0
qq
	db $23,$05,$13,$11,$23,$05,$0F,$02,$02,$12,$22,$05,$10,$02
	db $02,$11,$23,$05,$10,$02,$02,$11,$24,$05,$0F,$02,$02,$12,$24,$05
	db $0F,$02,$02,$11,$25,$05,$0F,$02,$02,$12
	db 0
rrr
	db $0D,$0D,$0B,$0C,$0A,$10,$03,$05,$10,$0A,$0D,$0B,$0C,$0D,$0A
	db $10,$03,$04,$11,$0B,$0C,$0C,$0B,$0E,$0A,$10,$03,$05,$10,$0C,$0E
	db $0B,$0A,$0E,$0A,$10,$03,$05,$11,$0B,$0E,$0D,$0A,$0F,$0A,$10,$03
	db $05,$10,$0C,$0E,$0C,$0B,$0F,$08,$12,$03,$05,$11,$0C,$0E,$0D,$0B
	db $0F,$0A,$10,$03,$05,$11,$0E,$0E,$0C,$0A,$0F,$08,$12,$03,$06,$10
	db $0D,$0F,$0C,$0C,$0E,$0A,$10,$03,$06,$10,$0E,$25,$0F,$09,$11,$03
	db $06,$10,$0D,$0E
	db 0
ss
	db $02,$01,$01,$02,$01,$02,$01,$02,$01,$02,$01,$02,$01,$02
	db $01,$02,$01,$02,$02,$01,$02,$02,$02,$02,$0E,$01,$02,$06,$01,$08
	db $02,$01,$03,$02,$01,$06,$01,$01,$02,$01,$05,$02,$01,$01,$02,$01
	db $02,$01,$02,$02,$02,$01,$01,$02,$02,$01,$05,$02,$02,$01,$02,$02
	db $04,$02,$01,$02,$07,$02,$01,$02,$02,$01,$02,$05,$01,$04,$04,$02
	db $01,$02,$08,$06,$02,$02,$01,$02,$0D,$01,$01,$02,$01,$01,$02,$02
	db $01,$02,$04,$09,$02,$05,$04,$01,$08,$01,$02,$02,$01,$01,$02,$01
	db $02,$01,$01,$04,$02,$01,$05,$01,$06,$01,$02,$01,$04,$04,$01,$06
	db $01,$03,$05,$06,$01,$04,$01,$06,$04,$02,$01,$02,$01,$03,$01,$02
	db $03,$08,$01,$08,$01,$08,$01,$06,$01,$01,$02,$05,$04,$05,$01,$02
	db $01,$05,$01,$02,$05,$01,$02,$01,$02,$01,$02,$01,$01,$05,$01,$02
	db $02,$01,$02,$01,$02,$02,$01,$02,$02,$01,$02,$05,$01,$04,$06,$02
	db 255,0
tt
	db $02,$20,$02,$02,$01,$03,$01,$0C,$05,$30,$01,$3B,$01,$03,$02
	db $01,$01,$02,$08,$01,$06,$0F,$01,$0C,$01,$0C,$01,$0A,$01,$16,$02
	db $11,$01,$01,$01,$01,$01,$03,$02,$01,$03,$01,$03,$02,$01,$02,$02
	db $0A,$01,$02,$02,$01,$02,$01,$01,$02,$01,$0A,$02,$03,$02,$01,$02
	db $01,$01,$05,$02,$03,$01,$03,$01,$02,$01,$03,$01,$02,$01,$01,$04
	db $01,$01,$03,$03,$02,$01,$01,$01,$02,$02,$04,$02,$01,$05,$0A,$01
	db $01,$01,$07,$01,$02,$02,$01,$01,$08,$01,$01,$02,$09,$01,$02,$01
	db $01,$02,$04,$02,$01,$02,$01,$02,$01,$01,$06,$01,$01,$01,$04,$01
	db $01,$02,$05,$02,$04,$01,$02,$02,$07,$05,$02,$06,$01,$03,$0D,$03
	db $0A,$01,$0A,$01,$06,$02,$02,$01,$0A,$04,$04,$04,$0C,$04,$0D,$03
	db $0E
	db 255,0
uu
	db $37,$11,$37,$12,$38,$12,$38,$13,$38,$12,$1D
	db $0C,$10,$12,$39,$13,$1D,$2E,$1D,$09,$12,$13,$1D,$0B,$11,$13,$1D
	db $0B,$10,$13,$1D,$0B,$10,$13,$1D,$0B,$11,$12,$1D,$0B,$11,$13,$1D
	db $0A,$12,$12,$39,$13
	db 0
vv
	db $39,$13,$39,$14,$38,$14,$38,$14,$38,$15,$38,$14,$38,$11,$02
	db $02,$36,$17,$35,$15,$02,$02,$35,$14,$02,$02,$34,$16,$02,$02,$35
	db $15,$02,$02,$34,$15,$02,$02,$35,$15,$02,$02,$35,$15,$02,$01,$36
	db $14,$02,$02,$35,$15,$02,$02
	db 0
ww
	db $FF,$12,$3F,$17,$3D,$16,$3F,$16,$3D,$18,$3D,$17,$3D,$17,$3C
	db $16,$3C,$16,$3C,$15,$3D,$14,$3A,$19,$3A
	db 0
xx
	db $07,$1C,$72,$06,$0C,$5C,$50,$18,$1C,$0A,$08,$0A,$06,$0B,$0A
	db $0A,$0A,$05,$48,$19,$08,$08,$0B,$08,$0A,$09,$0B,$04,$2A,$0A,$1A
	db $08,$0C,$0A,$60,$0B,$05,$08,$0D,$07,$08,$0A,$0A,$09,$4F,$0A,$0A
	db $04,$09,$0C,$05,$0A,$08,$0A,$14,$2B,$07,$0A,$0A,$07,$08,$09,$0A
	db $2E,$0B,$26,$13,$1D,$33,$05,$0A,$0E,$1C,$08
	db 0
yy
	db $18,$1C,$0D
	db $0D,$02,$02,$18,$1C,$0D,$0D,$02,$02,$13,$22,$0C,$0E,$02,$02,$13
	db $21,$0B,$10,$02,$02,$12,$22,$0B,$10,$02,$02,$12,$22,$0B,$10,$02
	db $02,$12,$22,$0B,$10,$02,$02,$12,$22,$0B,$10,$02,$02,$13,$22,$0B
	db $0F,$02,$02,$13,$23,$0B,$0F,$02,$02,$13,$23,$0B,$10,$02,$02,$12
	db $24,$0B,$10,$02,$02,$12,$25,$0A,$10,$02,$02,$13,$25,$0D,$0D,$02
	db $02,$13,$24,$0E,$0C,$03,$02
	db 0
zz
	db $35,$2C,$09,$2C,$32,$48,$16,$01,$0A,$15,$01,$40,$02,$10,$02
	db $14,$04,$1A,$08,$03,$08,$18,$48,$03,$45,$04,$02,$33,$02,$02,$02
	db $04,$0E,$08,$02,$04,$07,$03,$02,$03,$03,$02,$04,$02,$05,$02,$01
	db $13,$10,$01,$03,$04,$02,$0A,$02,$09,$01,$08,$03,$03,$43,$04,$02
	db $0F,$03,$06,$02,$04,$09,$02,$05,$01,$05,$01,$03,$0A,$02,$03,$03
	db $02,$03,$0A,$01,$04,$0B,$05,$01,$02,$09,$02,$07,$03,$1B,$0D,$13
	db $02,$04,$08,$08,$02,$50
	db 0
gap
	db 255,255,255,0


end
