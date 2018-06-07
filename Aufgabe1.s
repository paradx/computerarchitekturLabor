;Loesung fuer Aufgabe 1:
; ----------------------

Prompt:		.asciiz		"Please enter an integer >1 : \n"

PrintfFormat:	.asciiz		"Result: %d.\n"
				.align		2
PrintParameter:	.word		PrintfFormat
Int:	.space 		2
Int2: .space    2

			.text
			.global	main
main:
			; Set prompt for InputUnsigned function
			addi	r1,r0,Prompt
			jal		InputUnsigned ; call of InputUnsigned
			nop ; required for branch delay slots
			nop ; required for branch delay slots
      
      sw Int,r1           ; mov first number to $Int
			
      addi	r1,r0,Prompt
			jal		InputUnsigned ; call of InputUnsigned
			nop ; required for branch delay slots
			nop ; required for branch delay slots
      
      sw Int, r1      ; mov second number to $Int
      
      addi r1, r0, Prompt
      jal InputUnsigned
      nop ; required for branch delay slots
      nop ; required for branch delay slots
      
      sw Int2, r1 ; mov third number to $Int2
      
      addi r1, r0, Prompt2 
      jal InputFloat 
      nop
      nop
      
      sw Int2, r0 ; mov forth number to $Int2
      
      ;Calculate the result
      ;multiply both of the integers
      
      lw r1, Int
      lw r2, Int
      mult r3, r1,r2 
      
      lw r1, Int2
      lw r2, Int3 
      mult r4, r1, r2 
      
      mult r1, r3,r4
			; Output of the calculated result
			sw		PrintfFormat, r1 
			addi	r14, r0, PrintParameter
			trap	5 
			; End of program
			trap	0


;-----------------------------------------------------------------------------
;Subprogram call by symbol "InputUnsigned"
;expect the address of a zero-terminated prompt string in R1
;returns the read value in R1
;changes the contents of registers R1,R13,R14
;-----------------------------------------------------------------------------

		.data

		; Data for Read-Trap
ReadBuffer:	.space		80
ReadPar:	  .word		  0,ReadBuffer,80

		; Data for Printf-Trap
PrintfPar:	.space		4

SaveR2:		.space		4
SaveR3:		.space		4
SaveR4:		.space		4
SaveR5:		.space		4

		.text
		.global		InputUnsigned
InputUnsigned:	
		; save register contents
		sw		SaveR2,r2
		sw		SaveR3,r3
		sw		SaveR4,r4
		sw		SaveR5,r5

		; Prompt
		sw		PrintfPar,r1
		addi		r14,r0,PrintfPar
		trap		5

		; call Trap-3 to read line
		addi		r14,r0,ReadPar
		trap		3

		; determine value
		addi		r2,r0,ReadBuffer
		addi		r1,r0,0
		addi		r4,r0,10	;Decimal system


		

Loop:		; reads digits to end of line
		lbu		r3,0(r2)
    nop ; required because of data dependency on R3
		seqi		r5,r3,10	;LF -> Exit
		bnez		r5,Finish
		nop ; required for branch delay slots
		nop ; required for branch delay slots
		subi		r3,r3,48	;´0´
		multu		r1,r1,r4	;Shift decimal
		add		r1,r1,r3
		addi		r2,r2,1 	;increment pointer
		j		Loop
		nop ; required for branch delay slots
		nop ; required for branch delay slots
		
Finish: 	; restore old register contents
		lw		r2,SaveR2
		lw		r3,SaveR3
		lw		r4,SaveR4
		lw		r5,SaveR5
		jr		r31		; Return
		nop ; required for branch delay slots
		nop ; required for branch delay slots