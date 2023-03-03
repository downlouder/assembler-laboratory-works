;Nazarenko Yurii Laboratorna robota 2
.486 ; create 32 bit code
.model flat, stdcall ; 32 bit memory model
option casemap :none ; case sensitive
include \masm32\include\windows.inc ; always first
include \masm32\macros\macros.asm ; MASM support macros
; include files that have MASM format prototypes for function calls
include \masm32\include\masm32.inc
include \masm32\include\gdi32.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\msvcrt.inc
includelib \masm32\lib\msvcrt.lib
; Library files that have definitions for function
; exports and tested reliable prebuilt code.
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\gdi32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
.data	; data definition directive
_temp1 dd ?,0 ; define a temporary variable 1 with initial value 0
_temp2 dd ?,0 ; define a temporary variable 2 with initial value 0
_const1 dd 4 ; define constant 4
_const2 dd 24 ; define constant 24
_const3 dd 8 ; define constant 8
_const4 dd 25 ; define constant 25
_title db "Laboratorna robota 2. Compare operations",0 ; set the title for the message box
strbuf dw ?,0 ; define a buffer for the message box output
_text db "masm32.  Output result by MessageBox:",0ah,
"y=d/4a-24d/c    a > c",0ah,
"y=e/8b+25ac    a <= c",0ah,
"Result: %d - whole part",0ah, 0ah,
"Nazarenko Yurii Student of KNEU IITE",0 ; set the message box output text
MsgBoxCaption db "Example message window",0 ; Defines a string that will be used as the caption for the message box.
MsgBoxText_1 db "Condition  a > c",0 ; Defines a string that will be used as the message for the message box if the condition a > c is true.
MsgBoxText_2 db "Condition  a <= c",0 ; Defines a string that will be used as the message for the message box if the condition a > c is false. 

.const 
   NULL equ  0 ; define a constant symbol named NULL and sets its value to 0.
   MB_OK equ  0 ; define a constant symbol named MB_OK and sets its value to 0. 

.code ; Command segment start directive
_start:	; Program start mark with the name _start
 
main proc 
LOCAL _a: DWORD ; declare a local variable named _a
LOCAL _b: DWORD ; declare a local variable named _b
LOCAL _c: DWORD ; declare a local variable named _c
LOCAL _d: DWORD ; declare a local variable named _d
LOCAL _e: DWORD ; declare a local variable named _e

mov _a, sval(input("Enter a = ")) ; store answer in the local variable _a
mov _b, sval(input("Enter b = ")) ; store answer in the local variable _b
mov _c, sval(input("Enter c = ")) ; store answer in the local variable _c
mov _d, sval(input("Enter d = ")) ; store answer in the local variable _d
mov _e, sval(input("Enter e = ")) ; store answer in the local variable _e
 
mov ebx, _a ; Write the number _a to the ebx register
mov eax, _c ; Write the number _c to the eax register
sub ebx, eax   ; Compare  _a<=_c
   
jle zero

; Switching to zero,
; If the ZF flag is set.
; If false, the execution will continue
; y=d/4a-24d/c    a > c    d=1,a=4,c=3
mov eax, _const1 ; 4
mul _a ; 4*a
mov ebx, eax ; save eax in ebx
mov eax, _d ; d
div ebx ;d/(4*a)
mov _temp1, eax ; save eax in temp1
mov eax, _const2 ; 24
mul _d ; 24*d
div _c ;24*d/c
sub _temp1, eax ; d/4a-24d/c

invoke MessageBoxA, NULL, ADDR MsgBoxText_1, ADDR MsgBoxCaption, MB_OK ; display a message box
invoke wsprintf, ADDR strbuf, ADDR _text, _temp1 ; format a string 
invoke MessageBox, NULL, ADDR strbuf, ADDR _title, MB_ICONINFORMATION ; display a message box
invoke ExitProcess, 0 ; exit the program

jmp lexit ; Go to exit marker (GOTO exit)
zero:
; y=e/8b+25ac    a <= c    e=8,b=1,a=1,c=2
mov eax, _const3 ;8
mul _b ; 8*b
mov ebx, eax ;save eax in ebx
mov eax, _e ;e
div ebx ;e/8b
mov _temp2, eax ;save eax in temp2
mov eax, _const4 ; 25
mul _a ;25*a
mul _c ;25*a*c
sub _temp2, eax ; e/8b+25ac


invoke MessageBoxA, NULL, ADDR MsgBoxText_2, ADDR MsgBoxCaption, MB_OK ; display a message box
invoke wsprintf, ADDR strbuf, ADDR _text, _temp2 ; format a string
invoke MessageBox, NULL, ADDR strbuf, ADDR _title, MB_ICONINFORMATION ; display a message box
invoke ExitProcess, 0 ; exit the program

lexit:
 ret
main endp ; end of the function code
 ret ; OS control return
end _start ; End of the program