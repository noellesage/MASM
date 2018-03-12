TITLE Elementary Arithmetic     (elementary_arithmetic.asm)

; Author: Amy Sage
; CS 271 / Programming Assignment #1                 Date: 1/18/2017
; Description: Calculates sum, difference, product, quotient, and remainder

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data
num_1					DWORD ?					;user input number 1
num_2					DWORD	?					;user input number 2
sum						DWORD	?					;sum of num1 and num2
difference		DWORD	?					;difference of num1 and num2
product				DWORD	?					;product of num1 and num2
quotient			DWORD	?					;quotient of num1 and num2
remainder			DWORD	?					;remainder of num1 and num2
title_name				BYTE	"Elementary Arithmetic, by Amy Sage",0
prompt						BYTE	"Enter 2 numbers, and Ill show you the sum, "
									BYTE	"difference, product, quotient, and remainder.",0
display_first			BYTE	"First number: ",0
display_second 		BYTE	"Second number: ",0
display_plus			BYTE " + ",0
display_minus			BYTE " - ",0
display_multiply	BYTE " x ",0
display_divide		BYTE " ÷ ",0
display_equals		BYTE " = ",0
display_remainder BYTE " remainder ",0
goodbye						BYTE	"Goodbye",0


.code
main PROC
;INTRO
;display title and name
				mov	edx, OFFSET title_name
				call WriteString
				call CrLf
;display prompt
				mov edx, OFFSET prompt
				call WriteString
				call CrLf

;GET DATA
;display first number prompt
				mov edx, OFFSET display_first
				call WriteString
;get first number
				call ReadInt
				mov num_1, eax
				call CrLf
;display second number prompt
				mov edx, OFFSET display_second
				call WriteString
;get second number
				call ReadInt
				mov num_2, eax
				call CrLf

;CALCULATE
;calculate sum
				mov eax, num_1
				add eax, num_2
				mov sum, eax
;calculate difference
				mov eax, num_1
				sub eax, num_2
				mov difference, eax
;calculate multiplication
				mov eax, num_1
				mov ebx, num_2
				mul ebx
				mov product, eax
;calculate quotient with remainder
				mov edx, 0
				mov eax, num_1
				mov ebx, num_2
				div ebx
				mov quotient, eax
				mov remainder, edx

;DISPLAY
;display sum
				mov eax, num_1
				call WriteInt		;display num1
				mov edx, OFFSET display_plus
				call WriteString	;display +
				mov eax, num_2
				call WriteInt	;display num2
				mov edx, OFFSET display_equals	;display =
				mov sum, eax
				call WriteInt	;sum
				call CrLf
;display difference
				mov eax, num_1
				call WriteInt	;display num1
				mov edx, OFFSET display_minus
				call WriteString	;display -
				mov eax, num_2
				call WriteInt	;display num2
				mov edx, OFFSET display_equals
				call WriteString	;display =
				mov eax, difference
				call WriteInt	;display difference
				call CrLf
;display product
				mov eax, num_1
				call WriteInt	;display num1
				mov edx, OFFSET display_multiply
				call WriteString	;display x
				mov eax, num_2
				call WriteInt	;display num2
				mov edx, OFFSET display_equals
				call WriteString	;display =
				mov eax, product
				call WriteInt	;display product
				call CrLf
;display quotient
				mov eax, num_1
				call WriteInt	;display num1
				mov edx, OFFSET display_divide
				call WriteString ;display ÷
				mov eax, num_2
				call WriteInt	;display num2
				mov edx, OFFSET display_equals
				call WriteString	;display =
				mov eax, quotient
				call WriteInt ;quotient
;display remainder
				mov edx, OFFSET display_remainder
				call WriteString ;display word remainder
				mov eax, remainder
				call WriteInt	;remainder
				call CrLf
;display goodbye message
				mov edx, OFFSET goodbye
				call WriteString
	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
