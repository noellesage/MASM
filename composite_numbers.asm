TITLE Composite Numbers     (composite_numbers.asm)

; Author: Amy Sage
; 271 / Program 4                Date: 2/13/2018
; Description: A program to calculate composite numbers.

INCLUDE Irvine32.inc

LOWERLIMIT = 1
UPPERLIMIT = 400

.data

header 					BYTE "Composite Numbers. Programmed by Amy Sage.", 0
introduction1 	BYTE "Enter the number of composite numbers you would like to see. I will accept orders for up to 400 composites: ", 0
prompt					BYTE "Enter the number of composities to display [1 .. 400]: ",0
error 					BYTE "Out of range. Try again.", 0
space 	        BYTE " ", 0
number 				  DWORD ?
composite 			DWORD 4
bool_value 			DWORD ?
total 				  DWORD 0
divisor 		    DWORD ?
goodbye1 		    BYTE "Results verified by Amy Sage. Goodbye.", 0

.code

main PROC
call introduction
call getUserData
call results
call goodbye
exit

main ENDP

introduction PROC

; introductionduction
mov edx, OFFSET header;
call WriteString
call CrLf
ret
introduction ENDP

getUserData PROC

; introduction
mov edx, OFFSET introduction1
call WriteString
call ReadInt
mov number, eax
call validate
ret

getUserData ENDP

validate PROC

; Validate
mov eax, number
cmp eax, LOWERLIMIT
jl isFalse
cmp eax, UPPERLIMIT
jg isFalse
jmp endBlock

isFalse:
call CrLf
mov edx, OFFSET error
call WriteString
call CrLf
call getUserData

endBlock :
ret

validate ENDP

results PROC
call CrLf
mov ecx, number

bool_loop:
mov bool_value, 0
call isComposite
cmp bool_value, 1
je showComposites
inc composite

showComposites:
inc total ;numbers printed counter
mov eax, 0
mov eax, composite
call WriteDec ;print number
mov edx, 00000000h
mov edx, OFFSET space
call WriteString
inc composite ;increment
mov divisor, ebx
mov edx, 00000000h
mov eax, total
mov ebx, 10 ;set divisor to 10
div ebx
mov ebx, divisor ;change divisor back
cmp edx, 0
jne skip_line
call CrLf

skip_line:

loop bool_loop
call CrLf
ret

results ENDP

isComposite PROC
mov edx, 00000000h
mov eax, composite
mov ebx, 2 ;set divisor 2
div ebx
cmp edx, 0 ;if remainder is 0, then it's composite
je calc_comp
inc ebx ;if not increment divisor

divide:

cmp ebx, composite
je no_comp ;same = prime
mov eax, composite
div ebx
cmp edx, 0
je calc_comp
add ebx, 2
jmp divide ;Repeat

calc_comp:

mov bool_value, 1
jmp the_end ;finished if true

no_comp:

mov bool_value, 0 ;if not composite

the_end:
ret
isComposite ENDP
goodbye PROC

call CrLf;
call CrLf;
mov edx, OFFSET goodbye1 ;goodbye
call Writestring;
call CrLf
ret

goodbye ENDP

END main
