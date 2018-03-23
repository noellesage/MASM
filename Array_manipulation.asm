TITLE Array_manipulation    (array_manipulation_prog6.asm)

; Author: Amy Sage
; Email address: sageam@oregonstate.edu
; Class: CS271-400
; Project 6, Option A
; Due: 3/18/2018
; Description: A program which takes string input from a user, converts it to a number,
; then converts that number back to a string, and displays the output. It stores these values
; in an array, which is then summed, averaged, and printed

INCLUDE Irvine32.inc

number_of_loops = 10   ;numer of inputs to loop
max_string_size = 20   ;max size of input strings

.data
array           DWORD   number_of_loops DUP(?)
loop_counter    DWORD   0
total           DWORD   0  ;sum
my_title        BYTE   "PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures",0
extra_credit    BYTE   "**EC: 1 point: number each line of user input and display a running subtotal of the user numbers.",0
extra_credit2   BYTE   "**EC: 3 points: make your ReadVal and WriteVal procedures recursive.",0
my_name         BYTE   "Written by: Amy Sage",0
intro1          BYTE   "Please provide 10 unsigned decimal integers.",0
intro2          BYTE   "After you have finished inputting the raw numbers I will display",0
intro3          BYTE   "a list of the integers, their sum, and their average value. ",0
info1           BYTE   "The largest unsigned 32 bit int is ",0
info2           BYTE   "Meaning that every integer and their sum must be less than it.",0
prompt          BYTE   "Please enter an unsigned number: ",0
total_print     BYTE   " values entered. Running total: ",0
invalid_entry   BYTE   "ERROR: Invalid entry.",0
large           BYTE   "ERROR: Number too large. Please use smaller numbers",0
large2          BYTE   "ERROR: Sum too large. Please use smaller numbers",0
print_numbers   BYTE   "The numbers are: ",0
print_sum       BYTE   "The sum of the numbers is: ",0
print_average   BYTE   "The average is: ",0
goodbye         BYTE   "Thanks for playing!",0
space           BYTE   ", ",0

getString MACRO my_input, my_string
; Displays a string prompt, read in string
; Receives string variable to store string,
; address of prompt

   push   edx
   push   ecx
   displayString OFFSET my_string
   mov    edx, my_input
   mov    ecx, max_string_size - 1
   call   ReadString
   pop    ecx
   pop    edx
ENDM

displayString MACRO my_input
; Displays string
; Receives address of string
   push   edx
   mov    edx, my_input
   call   WriteString
   pop    edx
ENDM

.code

main PROC
   displayString OFFSET my_title
   call   Crlf
   displayString OFFSET my_name
   call   Crlf
   call   Crlf
   displayString OFFSET extra_credit
   call Crlf
   displayString OFFSET extra_credit2
   call Crlf
   displayString OFFSET intro1
   call   Crlf
   displayString OFFSET intro2
   call   Crlf
   displayString OFFSET intro3
   call   Crlf
   call   Crlf
   displayString OFFSET info1
   push   0FFFFFFFFh
   call   WriteVal
   call   Crlf
   displayString OFFSET info2
   call   Crlf
   call   Crlf
   mov    ecx, number_of_loops
   mov    edi, OFFSET array
num_loop:
   mov    eax, loop_counter
   call   WriteDec
   displayString OFFSET total_print
   mov    eax, total
   call   WriteDec
   call   Crlf
   push   edi ;array
   call   ReadVal
   call   Crlf
   inc    loop_counter
   mov    eax, [edi]
   add    edi, 4 ;change array position
   mov    ebx, total
   add    eax, ebx
   jc     too_large
   mov    total, eax
   loop   num_loop
   jmp    the_end
too_large:
   displayString OFFSET large2
   call  Crlf
the_end:
   push   number_of_loops
   push   OFFSET array
   call   Array_results
   call   Crlf
   displayString OFFSET goodbye
   call   Crlf
   exit   ; exit to operating system
main ENDP

ReadVal PROC
; ***************************************************************
; Procedure to convert a string input by the user into an integer.
; receives: address of an integer
; returns: integer based on user input (put into address)
; preconditions:
; registers changed: eax, ebx, edx, esi
; ***************************************************************
   push  ebp
   mov   ebp, esp
   jmp   print_prompt
invalid:
   displayString OFFSET invalid_entry
   call   Crlf
   jmp    print_prompt
num_too_large:
   displayString OFFSET large
   pop   eax
   call  Crlf
print_prompt:
   mov       esi, [ebp+8]
   getString esi, prompt
   mov       eax, 0
   push      eax
read_value:
   mov    eax, 0
   lodsb
   cmp    al, 0
   je     finish_read
   pop    ebx
   push   eax ;save char
   mov    eax, ebx
   mov    ebx, 10
   mul    ebx
   jc     num_too_large
   mov    edx, eax
   pop    eax ;char
   cmp    al, 48 ; if <0
   jl     invalid
   cmp    al, 57 ; if >9
   jg     invalid
   mov    ah, 48
   sub    al, ah ;char -> num
   mov    ah, 0
   add    eax, edx
   jc     num_too_large
   push   eax
   jmp    read_value
finish_read:
   pop    eax
   mov    esi, [ebp+8]
   mov    [esi], eax
   pop    ebp
   ret    4
ReadVal ENDP

WriteVal PROC
; ***************************************************************
; Procedure to convert a number to a string and display
; receives: address of integer
; returns: prints to screen
; preconditions: number from user is input, and validated
; registers changed: eax, edx, edi
; ***************************************************************
   push    ebp
   mov     ebp, esp
   pushad
   sub     esp, 2
   mov     eax, [ebp+8]
   lea     edi, [ebp-2]
   mov     ebx, 10
   mov     edx, 0
   div     ebx
   cmp     eax, 0
   jle     finish_write ;when eax = 0
   push    eax
   call    WriteVal
finish_write:
   mov     eax, edx
   add     eax, 48  ;convert to char
   stosb            ;char->edi
   mov     eax, 0
   stosb
   sub     edi, 2
   displayString edi
   add     esp, 2
   popad
   pop     ebp
   ret     4
WriteVal ENDP

Array_results PROC
; ***************************************************************
; Procedure to calculate sum, average of integers in an array
; receives: array address, array size
; returns: prints sum and average of integers
; preconditions: array of integers initialized
; registers changed: esi, ecx, edx, ebx, eax
; ***************************************************************
   push   ebp
   mov    ebp, esp
   mov    esi, [ebp+8]
   mov    ecx, [ebp+12]
   sub    esp, 4
   mov    edx, 0
   displayString OFFSET print_numbers
   call   Crlf
   jmp    array_end
array_loop:
   displayString OFFSET space
array_end:
   push   [esi]
   call   WriteVal
   mov    ebx, [esi]
   add    edx, ebx
   add    esi, 4
   loop   array_loop
   call   Crlf
   displayString OFFSET print_sum
   push   edx
   call   WriteVal
   call   Crlf
   displayString OFFSET print_average
   mov    eax, edx
   mov    edx, 0
   mov    ebx, [ebp+12]
   div    ebx
   push   eax
   call   WriteVal
   call   Crlf
   add    esp, 4
   pop    ebp
   ret    8
Array_results ENDP

END main
