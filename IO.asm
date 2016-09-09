;Thuan Lam
;Andrew Budihardja
;
;
;Reads the contents of the Keyboard Data Register (KBDR) without checking the Keyboard Status Register (KBSR)

	.ORIG x3000 
LOOP
	STI R0, KBDR	;Load data from mem[KBDR] into R0
	PUTC		;Print R0
	BR LOOP		;Loop forever
KBDR	.FILL xFE02	;Address of KBDR	
	.END
