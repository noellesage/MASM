TITLE ArraySort_FindMedian     (ArraySort_FindMedian.asm)

; Author: Amy Sage
; CS 271 / Project 5                 Date: 3/2/2018
; Description: This program generates numbers in the range [100 .. 999],
; with the user designating how many numbers will be generated in the range
; of [10-200], displays the original list, sorts the list, and calculates,
; the median value. Finally, it displays the list sorted in,
; descending order.

INCLUDE Irvine32.inc
MAX_SIZE = 200 ;max array size
MIN_SIZE = 10 ;min array size
lo = 100 ;minium number generated
hi = 999 ;maximum number generated
.data
list 				    				DWORD 		MAX_SIZE 		DUP(?) ;array declaration
count   								DWORD     ? ;number of elements in array in use
num_range 			    		DWORD     ?  ;range of numbers
median_low_location     DWORD     ? ;median of even numbers, low number
median_low_value        DWORD     ?
median_high_value       DWORD     ?
median_high_location    DWORD     ?
ranNum  								DWORD     ? ;random number from user
per_line 								DWORD     1 ;numbers per line
space   								BYTE      "     ",0 ;array spacing
header  								BYTE      "Sorting Random Integers, by: Amy Sage",0
intro   								BYTE      "This program generates numbers in the range [100 .. 999], displays the original list, sorts the list, and calculates, the median value. Finally, it displays the list sorted in, descending order.",0
prompt1 								BYTE      "How many numbers should be generated? [10 .. 200]: ",0
list_output 		    		BYTE  		"The unsorted random numbers: ",0
median_output 	        BYTE 			"The median is ",0
sorted_output 	        BYTE 			"The sorted list: ",0
invalid_number      		BYTE 			"Invalid input",0

.code
main PROC
call Randomize ;randomize procedure for different sequences
call introduction

;set up for data input
push OFFSET prompt1 ;
push OFFSET invalid_number
push OFFSET ranNum
call get_data ;get user's number of array items

;fill array with numbers
push OFFSET num_range ;range of numbers
push ranNum ;user input random num
push OFFSET list ;array
push OFFSET count ;num elements in array
call fill_array ;fill array with random numbers

;display the array
push OFFSET list_output ;unsorted array prompt
push OFFSET list ;array
push count ;num array elements
call display_array ;display unsorted array

;sort the array
push OFFSET list ;array
push count ;num elements in array
call sort_list ;sorts list in descending order

;display sorted array
push OFFSET sorted_output ;"The sorted array is.."
push OFFSET list ;array
push count ;num array elements
call display_array ;display sorted array

;display median
push OFFSET median_high_value
push OFFSET median_high_location
push OFFSET median_low_value
push OFFSET median_low_location
push OFFSET median_output ;"the median is..."
push OFFSET list ;array
push count ;num elements in array
call display_median ;display, calculate median number
	exit	; exit to operating system
main ENDP

; ***************************************************************
; Procedure to display introduction. Note: input not validated.
; receives: address of header and introduction
; returns: nothing
; preconditions: none
; registers changed: edx
; ***************************************************************
introduction PROC
mov edx, OFFSET header
call WriteString ;"Programmed by.."
call CrLf
call CrLf
mov edx, OFFSET intro
call WriteString ;"This program generates.."
call CrLf
call CrLf
ret
introduction ENDP
; ***************************************************************
; Procedure to get the user's input. Note: input validated
; receives: address of prompt, minsize, maxsize, invalidprompt on system stack
; returns: user inputted randNum
; preconditions: none
; registers changed: eax, edx
; ***************************************************************
get_data PROC
push	ebp
mov	ebp,esp ;set up stack frame

input:
mov	edx, OFFSET prompt1
call	WriteString	 ;"How many numbers..?"
call	ReadInt			;get user's number
mov	[ebp+8], eax		;address of count
call CrLf

;validate
cmp eax, MIN_SIZE
jl invalid ;if  too small
cmp eax, MAX_SIZE
jg invalid ;if too large
jmp good  ;if in range

invalid:
mov edx, [ebp+12]
call WriteString ;"invalid input.."
call CrLf
jmp input ;get input again

good:
mov ranNum, eax ;store number input into ranNum
pop ebp ;old ebp
ret 12 ;pop ebp+8
 get_data ENDP
; ***************************************************************
; Procedure to put random numbers in the array.
; receives: address of array, value of count, range of numbers,
; and user input random number on system stack
; returns: first count elements of array contain consecutive squares
; preconditions: ranNum initialized in range 10-200
; registers changed: eax, ebx, ecx, esi
; ***************************************************************
fill_array PROC
push ebp
mov ebp, esp ;set up stack frame

;find range
mov eax, hi
sub eax, lo
inc eax ;add 1 to range
mov ebx, [ebp+20] ;range address
mov [ebx], eax    ;save range

;random numbers
mov ecx, [ebp+16] ;loop counter, based on user input
mov esi, [ebp+12] ;first element

fill_loop:
mov ebx, [ebp+20] ;range address
mov eax, [ebx]  ;range value
call RandomRange
add eax, lo    ;new min

;store number
mov [esi], eax
add esi, 4 ;increment array to next index

;increase array size
mov ebx, [ebp+8]
mov eax, 1
add [ebx], eax

loop fill_loop

pop ebp
ret 16
fill_array	ENDP
; ***************************************************************
; Procedure to display the array elements(used twice, for
; unsorted and sorted array)
; receives: either sorted/unsorted prompt, address of array
; and value of count on system stack
; returns: none
; preconditions: ranNum is initialized in range 10-200
; registers changed: eax, ebx, edx, esi
; ***************************************************************
display_array PROC
push ebp
mov ebp, esp ;set stack frame

mov edx, [ebp+16]  ;"The sorted.." OR "the unsorted.."
call WriteString
call Crlf

;array display
mov ecx, [ebp+8]   ;number of array elements
mov esi, [ebp+12]  ;show array

total:
mov eax, [esi]
call WriteDec ;show current array element
mov edx, OFFSET space
call WriteString ;put spaces between numbers
mov eax, per_line ;number of numbers per line
mov ebx, 10
mov edx, 0
div ebx
cmp edx, 0
jne continue_line
call Crlf

continue_line:
add esi, 4   ;next number
inc per_line
loop total   ;keep displaying

mov  per_line, 1 ;reset per line
call Crlf
pop ebp
ret 12
display_array ENDP
; ***************************************************************
; Procedure to sort the array elements.
; receives: address of array and value of count on system stack
; returns: array sorted in descending order
; preconditions: ranNum is initialized by user in range 10-200,
; array contains numbers(fill_array procedure executed)
; registers changed: eax, ebx, edx, esi, ecx
; ***************************************************************
sort_list PROC
push  ebp
mov  ebp, esp ;set stack frame
mov  ecx, [ebp+8]  ;array size

current:
 mov  esi, [ebp+12]
 mov  edx, ecx

swap:
 mov eax, [esi]
 mov ebx, [esi+4]
 cmp ebx, eax
 jle less_than ;curr < next
 mov [esi], ebx  ;curr > next
 mov [esi+4], eax

less_than:
 add esi, 4
 loop swap
 mov ecx, edx
 loop  current

 pop  ebp ;restore
 ret  8
sort_list ENDP
; ***************************************************************
; Procedure to calculate and display the median of the array
; elements - either of an even or odd number of elements.
; receives: median prompt, address of array, value of
; count on system stack, median high val, median low val, median high loc,
; and median low loc
; returns: median of array elements
; preconditions: ranNum in range 10-200, array elements initialized,
; array elements have been sorted
; registers changed: eax, ebx, edx, ecx
; ***************************************************************

display_median PROC

push  ebp
mov   ebp, esp ;set up stack]
mov   esi, [ebp+12] ;move list to esi

;even_num or odd num of elements?
mov   eax, [ebp + 8] ;SIZE
cdq
mov   ecx, 2
div   ecx   ;SIZE/2 stored in eax
cmp   edx, 0
mov   [ebp+28], eax ;for even number ;change med_high_location's value
je    even_num ;array size is even_num

;if size is odd, also begins even
mov    edx, 4
mul    edx ;stored in eax
mov    eax, [esi+[eax]] ;value at memory location
jmp  print

even_num:
mov     edx, 4
mul     edx ;stored in eax
mov     eax, [esi+[eax]] ;value at memory location
mov     [ebp+32], eax ;store median-high value's value

;inc eax to store new location
mov     eax, [ebp+28] ;put median high location's value in eax
dec     eax  ;change location-1
mov     [ebp+20], eax ;store low location

;same as with other number
mov     edx, 4
mul     edx ;stored in eax
mov     eax, [esi+[eax]] ;value at memory location
mov     [ebp+24], eax ;median low value

add     eax, [ebp+32] ;add median low and median high by adding med_high val to eax
mov     ecx, 2
div     ecx ;median ;divides by ecx and stores in eax
jmp print

print:
mov    edx, OFFSET median_output
call   WriteString ;"The median is.."
call   WriteDec ;median
call   CrLf
call   CrLf

pop  ebp ;old ebp restored
ret  32
display_median ENDP
END main
