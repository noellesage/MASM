TITLE Program Template     (template.asm)

; Author: Amy Sage
; CS 271 / Fibonacci Numbers                 Date: 1/24/18
; Description: Program which asks user how many Fibonacci terms they'd like to display then displays them

INCLUDE Irvine32.inc

.data
title						BYTE		"Fibonacci Numbers",0
name						BYTE		"Programmed by Amy Sage",0
name_prompt 		BYTE		"What is your name?",0
hello       		BYTE		"Hello ",0
buffer    			BYTE 		21 DUP(0) ;input buffer
byteCount       DWORD 	? ;holds counter
number_prompt 	BYTE 		"Enter the number of Fibonacci terms to be displayed. "
								BYTE   	"Give the number as an integer in the range [1 .. 46].",0
how_many				BYTE		"How many Fibonacci terms do you want?",0
out_of_range		BYTE		"Out of range. Enter a number in [1 .. 46]",0
certified				BYTE  	"Results certified by Amy Sage",0
bye							BYTE  	"Goodbye, "0
one_term				BYTE    "1",0
two_terms				BYTE    "1 1",0
space           BYTE  	" ",0
five						DWORD   5
num_terms				DWORD 	? ;number of fib terms
prev_term     	DWORD 	?
curr_term				DWORD 	?
temp						DWORD		?
upper_limit	= 46 ;upper validation
lower_limit = 1 ;lower validation



.code
main PROC
; introduction
		mov edx, OFFSET title_name
		call WriteString ;display title
		call CrLf; skip line
		mov edx, OFFSET name
		call WriteString ;display name
		call CrLf ;skip line
		mov edx, OFFSET name_prompt
		call WriteString ;display ask for name
		mov edx, OFFSET buffer ;point to buffer
		mov ecx, SIZEOF buffer ;specify max char
		call ReadString ;user input name
		mov byteCount, eax;
		mov edx, OFFSET hello
		call WriteString ;hello
		mov edx, OFFSET buffer
		call WriteString ;their name displayed
		call CrLf

; user instructions
		mov edx, OFFSET number_prompt
		call WriteString ;display number prompt

; get user data
Beginning:
		mov edx, OFFSET how_many
		call WriteString ;display how many prompt
		call CrLf
		call ReadInt
		mov num_terms, eax ;intake number of terms

;validate input
		cmp eax, upper_limit
		jg  Invalid
		cmp  eax, lower_limit
		jl Invalid
		je Only_one ;if one term
		cmp eax, 2 ;if 2 terms
		je Only_two

; display results
; initialize with first term, second term, and number of terms
	mov ecx, num_terms
	sub ecx, 3 ;first 2 terms already finished
	mov eax, 1
	call WriteInt
	mov edx, OFFSET space
	call WriteString
	call WriteInt
	mov edx, OFFSET space
	call WriteString
	mov curr_term, eax
	mov eax, 2
	call WriteInt
	mov edx, OFFSET space
	call WriteString
	mov prev_term, eax

	FibLoop: 					;adds rest of terms
							add eax, curr_term
							call WriteInt
							mov edx, OFFSET space
							call WriteString
							mov temp, eax
							mov eax, prev_term
							mov curr_term, eax
							mov eax, temp
							mov prev_term, eax
							mov edx, ecx
							cdq
							div five
							cmp edx, 0
							jne skip
							call CrLf
						skip:
						 mov eax, temp
						 loop FibLoop
						 jmp End

Invalid:
	mov edx, OFFSET edx;
	call WriteString ;display error message
	jmp Beginning;go back to number prompt
Only_one:
	mov		edx, OFFSET one_term ; move first term to eax
	call WriteString ; display first term 1
	jmp End
Only_two:
	mov		edx, OFFSET two_terms
	call WriteString
	jmp End

; goodbye
End:
	call CrLf
	mov edx, OFFSET certified
	call WriteString ;results certified by...
	call CrLf ;line jump
	mov edx, OFFSET bye
	call WriteString ;goodbye
	edx, OFFSET buffer
	call WriteString ;username

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
