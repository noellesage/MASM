TITLE Number Sum     (number_sum.asm)

; Author: Amy Sage
; Course / Project ID: CS 271, Program 3                 Date: 2/7/18
; Description: A program which takes numeric input from the user in the range -1 to -100.
; When a positive number is entered, the program calculates the sum of the previous numbers,
; and their rounded average.


INCLUDE Irvine32.inc

.data
welcome						BYTE		"Welcome to the Integer Accumulator by Amy Sage",0
name_prompt   		BYTE		"What is your name? ",0
hello							BYTE		"Hello, ",0
number_prompt     BYTE		"Please enter numbers in [-100, -1]",0
number_prompt_2		BYTE		"Enter a non-negative number when you are finished to see results.",0
enter_prompt			BYTE		"Enter number: ",0
valid_num_prompt	BYTE		"You entered, ",0
valid_num_prompt2 BYTE    " valid numbers.",0
sum_output				BYTE		"The sum of your valid numbers is ",0
average_output		BYTE		"The rounded average is ",0
bye								BYTE		"Thank you for playing Integer Accumulator! It has been a pleasure to meet you, ",0
buffer    				BYTE 		21 DUP(0) ;input buffer
byteCount       	DWORD 		? ;holds counter
number						DWORD		?
number_count			DWORD		?
increase					DWORD		1
sum								DWORD		?
rounded_average   DWORD       0
average						DWORD		?
upper_limit 			DWORD		-1
lower_limit = -100

.code
main PROC

; Introduction
mov edx, OFFSET welcome
call WriteString ;welcome
call CrLf
mov edx, OFFSET name_prompt
call WriteString ;what's your name

;intake name
mov edx, OFFSET buffer ;point to buffer
mov ecx, SIZEOF buffer ;specify max char
call ReadString ;user input name
mov byteCount, eax;
mov edx, OFFSET hello
call WriteString ;hello displayed
mov edx, OFFSET buffer
call WriteString ;their name displayed
call CrLf ;skip line

; Number portion
mov edx, OFFSET number_prompt
call WriteString ;Please enter numbers
call CrLf
mov edx, OFFSET number_prompt_2
call WriteString ;enter non-negative..
call CrLf

; begin number input
numLoop:
		mov edx, OFFSET enter_prompt
		call WriteString ;enter number:
		call ReadInt
		mov number, eax ; move intake number into eax

		;validate input
		cmp eax, lower_limit
		jl Goodbye ;if lower than lower limit say Goodbye
		cmp eax, upper_limit
		jg Calculate ;if positive number, finish calculating, and exit

		;add
		add sum, eax; add number to sum
		mov eax, number_count ;if number in range added increase number count
		add eax, increase
		mov number_count, eax ;store new number count
		loop numLoop ;repeat


Calculate: ;display, calculate average
	mov edx, OFFSET valid_num_prompt
	call WriteString ;"you entered"
	mov eax, number_count
	call WriteInt ; display number
	mov edx, OFFSET valid_num_prompt2
	call WriteString ;"valid numbers"
	call CrLf
	mov edx, OFFSET sum_output
	call WriteString ;"The sum of your.."
	mov eax, sum
	call WriteInt ;display sum
	call CrLf

	;calculate
	mov edx, OFFSET average_output
	call WriteString ;"The rounded average is..."
	mov eax, sum ;move dividend
	cdq
	mov ebx, number_count
	idiv ebx ;divide sum by count
	call WriteInt ;write average to screen
	call CrLf

Goodbye:
 mov edx, OFFSET bye
 call WriteString
 mov edx, OFFSET buffer
 call WriteString ;username
 call CrLf
	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
