.include "m328pdef.inc"
.def btn_in = r16
.def buzz_out = r17
.def cntr_L = r18

.cseg
.org 0x0000
	rjmp SETUP
SETUP:
	ldi buzz_out, $FF
	out DDRB, buzz_out
	ldi btn_in, $00
	out DDRD, btn_in
	

BTN_CHECK: 
	;ldi btn_in, $80
	in btn_in,PIND
	;ldi buzz_out,0
	andi btn_in, $80 //filter the input
	cpi btn_in, 0
	breq SILENT
	ldi buzz_out, $FF
	out PORTB,buzz_out
	;call MAKE_WAVE
	rjmp BTN_CHECK

SILENT:
	ldi buzz_out,0
	out PORTB,buzz_out
	rjmp SETUP

MAKE_WAVE:
	call COUNTER_LOW
	cpi buzz_out,0
	breq LOW_OUT
	rjmp HIGH_OUT

COUNTER_LOW:
	inc cntr_L
	call DELAY
	brne COUNTER_LOW
	ret

DELAY:   
	ldi  r19, 20
    ldi  r20, 189
L1: dec  r20
    brne L1
    dec  r19
    brne L1
	ret


LOW_OUT:
	ldi buzz_out,0b00000010
	rjmp BUZZOUT

HIGH_OUT:
	ldi buzz_out, 0
	rjmp BUZZOUT

BUZZOUT:
	out PORTD,buzz_out
	ret