;Thuan Lam
;Andrew Budihardja
;
;
;Calculates Greatest Common Divisor GCD of 2 variable N1 and N2, and write the result into R3
;Using a subfunction to calculate Modulo of 2 numbers
;
;Given numbers are N1 = 20 and N2 = 50, so after running, R3 value should be 10 = xA, and all other Registers won't be changed
;

	.ORIG x3000 
MAIN
	ST R1, SAVE1	;Save R1 before we change its value
	ST R2, SAVE2	;Save R2

	LD R1, N1	;Load N1 into R1
	LD R2, N2	;Load N2 into R2
	JSR GCD		;Call GCD function, which returns the value of GCD(R1, R2) into R3
	
	LD R1, SAVE1	;Restore R1's value
	LD R2, SAVE2	;Restore R2's value
	HALT		;Halt

SAVE1	.FILL x0000	;Variable to store R1 temporarily
SAVE2	.FILL x0000	;Variable to store R2 temporarily
N1	.FILL x0014	;Variable N1, set its value to 20
N2	.FILL x0032	;Variable N2, set its value to 50

;---------------------------------------------------
; GCD() function
;
; Calculate the Greatest Common Divisor of 2 numbers
;
; Input: R1 and R2
; Output: R3
;
GCD	ST R7, GCD_TMP7	;PUSH R7 for returning address
	ST R4, GCD_TMP4	;PUSH R4
	JSR MIN		;R3 = MIN(R1, R2) // R3 is the lesser
LOOP	
	;R4 = R1 Mod R3, so we need to set R2 = R3
	ST R2, GCD_TMP	;PUSH R2
	AND R2, R2, #0
	ADD R2, R3, #0	;Set R2 = R3
	JSR MOD		;MOD (R1, R2) = MOD(R1, R3)			
	LD R2, GCD_TMP	;POP R2
	ADD R4, R4, #0	;Do nothing, just set R4 to check flags
	BRP DECREASE	;If Not OK, do the next loop

	;R4 = R2 Mod R3, so we need to set R1 = R3
	ST R1, GCD_TMP	;PUSH R1
	AND R1, R1, #0
	ADD R1, R3, #0	;Set R1 = R3
	JSR MOD		;MOD (R1, R2) = MOD(R3, R2)				
	LD R1, GCD_TMP	;POP R1
	ADD R4, R4, #0	;Do nothing, just set R4 to check flags
	BRP DECREASE	;If Not OK, do the next loop

	LD R4, GCD_TMP4	;POP R4
	LD R7, GCD_TMP7	;POP R7
	RET

DECREASE
	ADD R3, R3, #-1	;Decrease lesser R3	
	BR LOOP		;Loop again

	LD R4, GCD_TMP4	;POP R4
	RET
GCD_TMP		.BLKW 1	;Local variable
GCD_TMP4	.BLKW 1	;Local variable
GCD_TMP7	.BLKW 1	;Local variable

; End of GCD()
;---------------------------------------------------
;---------------------------------------------------
; MIN() function
;
; Given 2 numbers, returns the smaller number
;
; Input: R1, R2
; Output: R3
;
MIN	NOT R3, R2
	ADD R3, R3, #1	;R3 = -R2
	
	ADD R3, R1, R3	;R3 = R1 + R3 = R1 - R2
	BRN LESS	;Jump if R1 < R2
	AND R3, R3, #0	;Else set R3 = R2
	ADD R3, R2, #0
	RET
LESS	AND R3, R3, #0	;set R3 = R1 for returning
	ADD R3, R1, #0				
	RET
;
; End of MIN()
;---------------------------------------------------
;---------------------------------------------------
; MAX() function
;
; Given 2 numbers, returns the bigger number
;
; Input: R1, R2
; Output: R3
;
MAX	NOT R3, R2
	ADD R3, R3, #1	;R3 = -R2
	
	ADD R3, R1, R3	;R3 = R1 + R3 = R1 - R2
	BRn LESS1	;Jump if R1 < R2
	AND R3, R3, #0	;Else set R3 = R1
	ADD R3, R1, #0
	RET
LESS1	AND R3, R3, #0	;set R3 = R2 for returning
	ADD R3, R2, #0				
	RET
;
; End of MAX()
;---------------------------------------------------
;---------------------------------------------------
; MOD() function
;
; Given 2 numbers, returns the modulo of those 2 numbers
; 
; Input R1, R2
; Output R4
;
MOD	ST R7, MOD_TMP7	;Push R7 - return address
	ST R1, MOD_TMP1	;Push R1
	ST R2, MOD_TMP2	;Push R2
	ST R3, MOD_TMP3	;Push R3

	JSR MAX		;R3 = MAX(R1, R2)
	AND R4, R4, #0	;Clears R4
	ADD R4, R3, #0	;R4 = R3 -> Now R4 holds the MAX(R1, R2)
	JSR MIN		;R3 = MIN(R1, R2)
	
	AND R1, R1, #0	;Clear R1
	ADD R1, R4, #0	;Set R1 = R3 = the bigger number	
	AND R2, R2, #0	;Clear R2
	ADD R2, R3, #0	;Set R2 = R4 = the smaller number

	NOT R3, R2	;Set R3 = -R2 = negation of the smaller number
	ADD R3, R3, #1	;

AGAIN	ADD R1, R1, R3	;R1 = R+ R3 = R1 - R2

	;check if R1 < R2
	ADD R4, R1, R3	;R4 = R1 + R3 = R1 - R2
	BRZP AGAIN	;if R4 >= 0 (means R1 >= R2) then loop again
			;else R4 < 0 (means R1 is the result)
	AND R4, R4, #0	
	ADD R4, R1, #0	;Set R4 = R1 for returning

	LD R3, MOD_TMP3	;POP R3
	LD R2, MOD_TMP2	;POP R2
	LD R1, MOD_TMP1	;POP R1
	LD R7, MOD_TMP7	;POP R7
	RET

MOD_TMP1	.BLKW 1	;Local variable
MOD_TMP2	.BLKW 1	;Local varibale	
MOD_TMP3	.BLKW 1	;Local varibale
MOD_TMP7	.BLKW 1	;Local varibale

; End of MOD()
;---------------------------------------------------

	.END
