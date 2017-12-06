; Disassembly of Aleksi Eeben's FX Hammer SFX player

section	"FX Hammer RAM",wram0[$c7c0]

FXHammerRAM		ds	5

FXHammer_SFXCH2	equ	0
FXHammer_SFXCH4	equ	1
; these are only temporary names, I have no idea what they're actually for at the moment
FXHammer_RAM1	equ	2
FXHammer_RAM2	equ	3
FXHammer_RAM3	equ	4

FXHammerBank	equ	1

FXHammerData	equ	$4200

section	"FX Hammer",romx,bank[FXHammerBank]

SoundFX_Trig:
	jp	FXHammer_Trig	; $404a
SoundFX_Stop:
	jp	FXHammer_Stop	; $4073
SoundFX_Update:
	jp	FXHammer_Update	; $409c
	
; thumbprint (this could be removed to save space)
	db	"FX HAMMER Version 1.0 (c)2000 Aleksi Eeben (email:aleksi@cncd.fi)"
	
FXHammer_Trig:
	ld	e,a
	ld	d,high(FXHammerData)
	ld	hl,FXHammerRAM+FXHammer_RAM1
	ld	a,[de]
	cp	[hl]
	jr	z,.jmp_4055
	ret	c
.jmp_4055
	ld	[hl],a
	inc	d
	ld	a,[de]
	swap	a
	and	$f
	ld	l,low(FXHammerRAM+FXHammer_SFXCH2)
	or	[hl]
	ld	[hl],a
	ld	a,[de]
	and	$f
	ld	l,low(FXHammerRAM+FXHammer_SFXCH4)
	or	[hl]
	ld	[hl],a
	ld	l,low(FXHammerRAM+FXHammer_RAM2)
	ld	a,1
	ld	[hl+],a
	xor	a
	ld	[hl+],a
	ld	a,$44
	add	e
	ld	[hl],a
	ret
	
FXHammer_Stop:
	ld	hl,FXHammerRAM+FXHammer_SFXCH2
	bit	1,[hl]
	jr	z,.jmp_4084
	ld	a,$08
	ldh	[$ff17],a
	ld	a,$80
	ldh	[$ff19],a
	ld	[hl],1
.jmp_4084
	ld	l,low(FXHammerRAM+FXHammer_SFXCH4)
	set	0,[hl]
	bit	1,[hl]
	jr	z,.jmp_4096
	ld	a,$08
	ldh	[$ff21],a
	ld	a,$80
	ldh	[$ff23],a
	ld	[hl],1
.jmp_4096
	ld	l,low(FXHammerRAM+FXHammer_RAM1)
	xor	a
	ld	[hl+],a
	ld	[hl],a
	ret
	
FXHammer_Update:
	xor	a
	ld	hl,FXHammerRAM+FXHammer_RAM2
	or	[hl]
	ret	z
	dec	[hl]
	ret	nz
	inc	l
	ld	a,[hl+]
	ld	d,[hl]
	ld	e,a
	ld	a,[de]
	ld	l,low(FXHammerRAM+FXHammer_RAM2)
	ld	[hl-],a
	or	a
	jr	nz,.jmp_40b0
	ld	[hl],a
.jmp_40b0
	ld	l,low(FXHammerRAM+FXHammer_SFXCH2)
	bit	1,[hl]
	jr	z,.jmp_40e5
	inc	e
	ld	a,[de]
	or	a
	jr	nz,.jmp_40c7
	ld	[hl],1
	ld	a,$08
	ldh	[$ff17],a
	ld	a,$80
	ldh	[$ff19],a
	jr	.jmp_40e6
.jmp_40c7
	ld	b,a
	ldh	a,[$ff25]
	and	$dd
	or	b
	ldh	[$ff25],a
	inc	e
	ld	a,[de]
	ldh	[$ff17],a
	inc	e
	ld	a,[de]
	ldh	[$ff16],a
	inc	e
	ld	a,[de]
	ld	b,$42
	ld	c,a
	ld	a,[bc]
	ldh	[$ff18],a
	inc	c
	ld	a,[bc]
	ldh	[$ff19],a
	jr	.jmp_40e9
.jmp_40e5
	inc	e
.jmp_40e6
	inc	e
	inc	e
	inc	e
.jmp_40e9
	ld	l,low(FXHammerRAM+FXHammer_SFXCH4)
	bit	1,[hl]
	jr	z,.jmp_4119
	inc	e
	ld	a,[de]
	or	a
	jr	nz,.jmp_4100
	ld	[hl],1
	ld	a,$08
	ldh	[$ff21],a
	ld	a,$80
	ldh	[$ff23],a
	jr	.jmp_4119
.jmp_4100
	ld	b,a
	ldh	a,[$ff25]
	and	$77
	or	b
	ldh	[$ff25],a
	inc	e
	ld	a,[de]
	ldh	[$ff21],a
	inc	e
	ld	a,[de]
	ldh	[$ff22],a
	ld	a,$80
	ldh	[$ff23],a
	inc	e
	ld	l,low(FXHammerRAM+FXHammer_RAM3)
	ld	[hl],e
	ret
.jmp_4119
	ld	l,low(FXHammerRAM+FXHammer_RAM3)
	ld	a,8
	add	[hl]
	ld	[hl],a
	ret
	
section	"FXHammer data",romx[FXHammerData],bank[FXHammerBank]
	; To get sound data, open hammered.sav and copy everything from $200-$3FFF into SoundData.bin.
	incbin	"SoundData.bin"