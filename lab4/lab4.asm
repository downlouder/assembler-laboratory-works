;Nazarenko Yurii Laboratorna robota 4
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

.data ; data definition directive
	_r DWORD 0.0 ;declaration of the variable _r
	_const_e DWORD 2.71828 ;declaration of the constant
	_const0_2 DWORD 0.2 ;declaration of the constant
	_const0_13 DWORD 0.13 ;declaration of the constant
	_const0_6 DWORD 0.6 ;declaration of the constant
	borderLeft DWORD -3.0 ;declaration of the variable borderLeft
	borderRight DWORD 4.0 ;declaration of the variable borderRight
	_title db "Laboratorna robota 4",0 ; set the title for the message box
	strbuf dw ?,0 ; define a buffer for the message box output
	_text db "Nazarenko Yurii Student of KNEU IITE", 10,
		"Output result by MessageBox:", 10,
		"V = e*x + Sin(x)   x<-3.0", 10,
		"V = arcSin(0.2*x + 0.13)   -3.0<=x<=4.0", 10,
		"V = sqrt(x^2 + lg(x - 0.6))   4.0<x", 10,
		"Result: " ; set the message box output text
	_res db 10 DUP(0),10,13 ; Define a string with a length of 10 characters filled with 0s, and line feed and carriage return at the end
	MsgBoxCaption db "Result of comparison",0 ; Defines a string that will be used as the caption for the message box.
	MsgBoxText_1 db "x<-3.0",0 ; Defines a string that will be used as the message for the message box if the condition x<-3.0 is true.
	MsgBoxText_2 db "-3.0<=x<=4.0", 0 ; Defines a string that will be used as the message for the message box if the condition -3.0<=x<=4.0 is true.
	MsgBoxText_3 db "4.0<x", 0 ; Defines a string that will be used as the message for the message box if the condition x<4.0 is true.

.const 
	NULL equ 0 ; define a constant symbol named NULL and sets its value to 0.
	MB_OK equ 0 ; define a constant symbol named MB_OK and sets its value to 0. 

.code ; Command segment start directive
_start:	; Program start mark with the name _start	
	
	main proc 
	LOCAL _x: DWORD ; declare a local variable named _x
	mov _x, sval(input("Enter x: ")) ; store answer in the local variable _x

	finit ;initializing the coprocessor
	fild _x ;loading x to the top of the stack
	fstp _x ;saving x with pushing it off the stack
	fld borderLeft ;loading a variable to the top of the stack
	fld _x ;loading x to the top of the stack, shifting the variable to st(1)
	fcompp ;comparing the top of the stack with the operan
	fstsw ax ;writes the value of the fpu status word to the register
	sahf ;write the contents of the register to the processor flag register 
	jb first ; jump
	fld borderRight ;write the variable to the top of the stack
	fld _x ;write the variable x to the top of the stack, the previous variable is in st(1)
	fcompp ;comparing the top of the stack with the operand
	fstsw ax ;writes the value of the fpu status word to the register
	sahf ;write the contents of the register to the processor flag register
	jbe second ; jump
		;4.0<x
		;sqrt(x^2 + lg(x - 0.6)) 
		fld _x ;putting x to the top of the stack
		fsub _const0_6 ; x - 0.6
		fstp st(2) ;save result in st(2)
		fldlg2 ; lg 2
		fld st(2) ;load st(2) to the top of the stack
		fyl2x ; lg 2 * log2 (x-0.6)
		fld _x ; load x to the top of the stack
		fmul _x ;x^2
		fadd ; x^2 + lg(x-0.6)
		fsqrt ; sqrt(x^2 + lg(x-0.6))
		invoke MessageBoxA, NULL, ADDR MsgBoxText_3, ADDR MsgBoxCaption, MB_OK 
		invoke FpuFLtoA, 0, 10, ADDR _res, SRC1_FPU or SRC2_DIMM
		invoke MessageBox, 0, offset _text, offset _title, MB_ICONINFORMATION
		invoke ExitProcess, 0 ; exit the program
		jmp lexit ;go to the exit label (GOTO exit)
	
	first:
		;x<-3.0
		;e*x + Sin(x)
		fld _x ;putting x to the top of the stack
		fsin ; sin(x)
		fld _x ; load x to the top of the stack
		fmul _const_e ;e*x
		fadd ; e*x + sin(x)
		invoke MessageBoxA, NULL, ADDR MsgBoxText_1, ADDR MsgBoxCaption, MB_OK 
		invoke FpuFLtoA, 0, 10, ADDR _res, SRC1_FPU or SRC2_DIMM
		invoke MessageBox, 0, offset _text, offset _title, MB_ICONINFORMATION
		invoke ExitProcess, 0 ; exit the program
		jmp lexit ;go to the exit label (GOTO exit)

	second:
		;-3.0<=x<=4.0
		;arcSin(0.2*x + 0.13)
		fld _x ;putting x to the top of the stack
		fmul _const0_2 ;0.2*x
		fadd _const0_13 ; 0.2*x + 0.13
		fst st(0) ;save result in st(0)
		fld st(0) ;Duplicate the result on tos.
		fmul ;Compute (0.2*x+0.13)**2.
		fld st(0) ;Duplicate (0.2*x+0.13)**2 on tos.
		fld1 ;Compute 1-(0.2*x+0.13)**2.
		fsubr
		fdiv ;Compute (0.2*x+0.13)**2/(1-(0.2*x+0.13)**2).
		fsqrt ;Compute sqrt((0.2*x+0.13)**2/(1-(0.2*x+0.13)**2)).
		fld1 ;To compute full arctangent.
		fpatan
		invoke MessageBoxA, NULL, ADDR MsgBoxText_2, ADDR MsgBoxCaption, MB_OK 
		invoke FpuFLtoA, 0, 10, ADDR _res, SRC1_FPU or SRC2_DIMM
		invoke MessageBox, 0, offset _text, offset _title, MB_ICONINFORMATION
		invoke ExitProcess, 0 ; exit the program
		jmp lexit ;go to the exit label (GOTO exit)

	lexit:
		ret
		main endp ; end of the function code
		ret ; OS control return
	
end _start ; End of the program