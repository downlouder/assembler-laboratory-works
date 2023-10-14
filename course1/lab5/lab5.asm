;Nazarenko Yurii Laboratorna robota 5
.486 ;sets the CPU to 80486 instruction set mode
.model flat, stdcall ;sets the memory model to flat and the calling convention to stdcall
option casemap :none ;sets the case sensitivity option for symbols to none 
include \masm32\include\windows.inc ; connecting the windows.inc program file
include \masm32\macros\macros.asm ; MASM support macros
include \masm32\include\masm32.inc ; connecting the program file masm.inc
include \masm32\include\gdi32.inc ; connecting the program file gdi32.inc
include \masm32\include\fpu.inc ; connecting the program file fpu.inc
include \masm32\include\user32.inc ; connecting the user32.inc program file
include \masm32\include\kernel32.inc ; connecting the program file kernel32.inc
include c:\masm32\include\msvcrt.inc ; connecting the msvcrt.inc program file               
includelib c:\masm32\lib\msvcrt.lib ; connecting the msvcrt.lib library
includelib c:\masm32\lib\fpu.lib ; connecting the fpu.lib library
includelib \masm32\lib\masm32.lib ; connecting the masm32.lib library
includelib \masm32\lib\gdi32.lib ; connecting the gdi32.lib library
includelib \masm32\lib\user32.lib ; connecting the user32.lib library
includelib \masm32\lib\kernel32.lib ; connecting the kernel32.lib library
uselib masm32, comctl32, ws2_32 

.data ; data definition directive
_const_1 DWORD 1.0 ;declaration of the constant
_const_6 DWORD 6.0 ;declaration of the constant
_result DWORD 0.0 ;declaration the result
_k dd 4 ; declaration of a variable with the first number
_endVal dd 9 ; declaration of a variable with the second number
_k1 DWORD 4.0 ; declaration of a variable with the first number to work with stacks
_title db "Laboratorna robota 5",0 ; set the title for the message box
strbuf dw ?,0 ; define a buffer for the message box output
_text db "Nazarenko Yurii Student of KNEU IITE",10,
	"Output result by MessageBox:",10, 
	"S = m E(i=k) (i + 1)^3 / (i^2 - i - 6)",10,
	"Result: " ; set the message box output text
_res1 db 14 DUP(0),10,13 ; Define a string with a length of 14 characters filled with 0s, and line feed and carriage return at the end

.code ; Command segment start directive
start: ; Program start mark with the name _start
	mov edx, 1 ;writing 1 to the edx register
	mov ebx, _endVal ;setting the value of the second number to the ebx register
	mov ecx, _k ;setting the value of the first number to the ecx register
	finit ;initialization of coprocessor

	.WHILE edx == 1 ; setting the condition for starting the cycle

	.IF ecx == 3 ; the condition under which the numbers at which division by zero occurs will be bypassed	
	loop m1 
	.ENDIF ; the end of condition IF
	fld _k1 ;load k1 to the top of the stack
	fadd _const_1 ; i+1 
	fld st(0) ; load i+1 to the top of the stack
	fld st(0) ; load i+1 to the top of the stack
	fmul ; (i+1)^2
	fmul ; (i+1)^3
	fld _k1 ; load k1 to the top of the stack
	fmul _k1 ; i^2
	fsub _k1 ; i^2 - i
	fsub _const_6 ; i^2 - i - 6
	fdiv ; (i + 1)^3 / (i^2 - i - 6)
	fld _result ; load _result to the top of the stack
	fadd ; result += (i + 1)^3 / (i^2 - i - 6)
	fstp _result ; save value in variable _result
	
	m1: ;operations with values to perform the next iteration
	add ecx,1
	add _k,1
	fld1
	fld _k1                  
	fadd             
	fstp _k1

	.IF ecx > ebx ;condition for exiting the loop
	fld _result                  
	.BREAK
	.ENDIF
	.ENDW

	invoke FpuFLtoA, 0, 10, ADDR _res1, SRC1_FPU or SRC2_DIMM
	invoke MessageBox, 0, offset _text, offset _title, MB_ICONINFORMATION
	invoke ExitProcess, 0 ; exit the program
 
end start ; End of the program