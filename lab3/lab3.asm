;Nazarenko Yurii Laboratorna robota 3
;Find the first value of the argument of the function Y = 9(x^2 + 0.6)
;at which the lowest integer digits of the result of the function are 12
;(x varies from 3 in 5.5 steps).

.686
.model flat, stdcall
option casemap :none
include \masm32\include\windows.inc
include \masm32\macros\macros.asm
uselib kernel32,user32,fpu,masm32
includelib C:\masm32\lib\kernel32.lib ; Include kernel32 library
includelib C:\masm32\lib\user32.lib 
includelib C:\masm32\lib\fpu.lib ; Include FPU library

.data ; Define the data segment
CrLf equ 0A0Dh ; Define carriage return and line feed characters
;Numbers
x DWORD 3.0
step DWORD 5.5
min_digits DWORD 12.0
const1 DWORD 0.6
const2 DWORD 9.0
Y dq ?
;Text
no_res db "No results"
info db "Nazarenko Yurii Student of KNEU IITE",10,10,
"Find first value of the argument of function",10,10,
"Y = 9(x^2 + 0.6)",10,10,
"at which the lowest integer digits of the result of the function are 12",10,10,
"(x varies from 3 in 5.5 steps)",10,10,
"x = " ; Define a message string to be displayed with the result
_res1 db 14 DUP(0),10,13 ; Define a string with a length of 14 characters filled with 0s, and line feed and carriage return at the end
titl db "Built-in masm32 coprocessor functions",0 ; Defines a string that will be used as the caption for the message box.

.code
	start:
	finit
    fld x ; Load x onto the FPU stack
	fmul x ; x^2
    fadd const1; Compute x^2 + 0.6 using the FPU instruction fadd
    fmul const2; Compute 9(x^2 + 0.6) using the FPU instruction fmul
    fistp Y ; Convert the result to an integer and store it in Y
    fild Y ; Load the result back onto the FPU stack
    mov eax, dword ptr [Y+4] ; Load the lowest integer digit of Y into EAX
    cmp eax, min_digits ; Compare the lowest integer digit of Y with the threshold value
	fld x
	fadd step
	fistp x
    jne not_found ; Jump to not_found if the comparison fails
	jmp quit

	not_found:
	invoke FpuFLtoA,offset no_res,10,offset _res1,SRC1_REAL or SRC2_DIMM 
	mov word ptr _res1 + 14, CrLf ; Move the carriage return and line feed characters to the end of the string stored in _res1
	invoke MessageBox, 0, offset info, offset titl, MB_ICONINFORMATION ; Display the string stored in 'info' as a message box with the caption stored in 'ttl'
	invoke ExitProcess, 0 ; Terminate the program and exit to the operating system

	quit:
	invoke FpuFLtoA,offset x,10,offset _res1,SRC1_REAL or SRC2_DIMM 
	mov word ptr _res1 + 14, CrLf ; Move the carriage return and line feed characters to the end of the string stored in _res1
	invoke MessageBox, 0, offset info, offset titl, MB_ICONINFORMATION ; Display the string stored in 'info' as a message box with the caption stored in 'ttl'
	invoke ExitProcess, 0 ; Terminate the program and exit to the operating system
	
END start