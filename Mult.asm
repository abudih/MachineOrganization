;Thuan Lam
;Andrew Budihardja
;
;
;Load 2 variable named FACT1 and FACT2, call MUL() to multiply those numbers and store the result into variable named PRODUCT
;using recursive 
;
;R0: Base of stack
;
	.ORIG x3000 
MAIN	ST R0, TEMP	;Save R0
	LEA R0, STACK	;Base R0 = STACK
	
	STR R1, R0, #0	;PUSH R1
	ADD R0, R0, #1	
	STR R2, R0, #0	;PUSH R2
	ADD R0, R0, #1

	LD R1, FACT1	;Load FACT1 into R1
	LD R2, FACT2	;Load FACT2 into R2
	JSR MULT	;Call MULT function, which returns the value of MUL(R1, R1) into R3
	
	ST R3, PRODUCT	;Restore result into PRODUCT

	ADD R0, R0, #-1
	LDR R2, R0, #0	;POP R2
	ADD R0, R0, #-1
	LDR R1, R0, #0	;POP R1	
	LD R0, TEMP	;Restore R0

	HALT		;Halt

FACT1	.FILL x0003	;Variable
FACT2	.FILL x0008	;Variable
PRODUCT	.FILL x0000	;Variable
TEMP	.FILL x0000	;Variable for R0
STACK	.BLKW 100	;Stack with 100 elements

;---------------------------------------------------
; MULT() function
;
; multiply 2 given numbers
;
; Input: R1 and R2
; Output: R3
;
MULT	STR R7, R0, #0	;PUSH R7 for returning address
	ADD R0, R0, #1	
	STR R4, R0, #0	;PUSH R4
	ADD R0, R0, #1
	STR R5, R0, #0	;PUSH R5
	ADD R0, R0, #1

	AND R3, R3, #0	;Clear R3

	ADD R4, R1, #-1	;If R1 = 1 
	BRZ RET_R2	;Goto RET_R2
	ADD R4, R2, #-1	;If R2 = 1
	BRZ RET_R1	;Goto RET_R1	

	;Return MUL(R1-1, R2-1) + R1 + R2 - 1
	;using R5 like a temporary variable
	AND R5, R5, #0	;R5 = 0
	ADD R5, R5, R1	;R5 = R1
	ADD R5, R5, R2	;R5 = R1 + R2
	ADD R5, R5, #-1	;R5 = R1 + R2 - 1

	ADD R1, R1, #-1
	ADD R2, R2, #-1
	JSR MULT	;Call MULT(R1-1, R2-1), returns value will be stored in R3
	ADD R3, R3, R5	;R3 = R3 + R5
	BR EXIT

RET_R1	ADD R3, R3, R1	;R3 = R1
	BRNZ EXIT	;Goto Exit

RET_R2	ADD R3, R3, R2	;R3 = R2

EXIT	ADD R0, R0, #-1
	LDR R5, R0, #0	;POP R5
	ADD R0, R0, #-1
	LDR R4, R0, #0	;POP R4
	ADD R0, R0, #-1
	LDR R7, R0, #0	;POP R7
	RET

; End of MULT()
;---------------------------------------------------

	.END
