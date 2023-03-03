;Nazarenko Yurii Laboratorna robota 1
;Application 1.2. solution expression (8d)/b - (19d)/c on masm32:
.686 ; version of the x86 instruction
.model flat, stdcall ; directives that specify the memory model and calling convention
option casemap:none ; directive in MASM32 for case-sensitive
include \masm32\include\windows.inc 
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
firstfunc PROTO _const1:DWORD,_d1:DWORD,_b1:DWORD,_const2:DWORD, _d2:DWORD, _c1:DWORD
.data   ;8d/b - 19d/c
const1 dd 8 ; define constant 8
d1 dd 2 ; define variable d1 with initial value 2
b1 dd 4 ; define variable b1 with initial value 4
const2 dd 19 ; define constant 19
d2 dd 10 ; define variable d2 with initial value 10
c1 dd 19 ; define variable c1 with initial value 19
_temp1 dd ?,0 ; define a temporary variable with initial value 0
_title db "Laboratorna robota 1. Arifm. operations",0 ; set the title for the message box
strbuf dw ?,0 ; define a buffer for the message box output
_text db "masm32. Output result 8d/b - 19d/c by MessageBox:", 0ah, "const1*d1/b1-const2*d2/c1", 0ah, "8*2/4-19*10/19", 0ah, "Result: %d - whole part",0ah, 0ah,
"Nazarenko Yurii Student of KNEU IITE",0 ; set the message box output text
.code ; Define the code for the function to calculate the expression (8d)/b - (19d)/c
firstfunc proc _const1:DWORD, _d1:DWORD, _b1:DWORD, _const2:DWORD, _d2:DWORD, _c1:DWORD
    mov eax, _const1 ; 8
    mul _d1 ; 8 * d1
    mov ebx, _b1 ; b1
    div ebx ; (8*d1)/b1
    mov _temp1, eax ; save result in temp1
    mov eax, _const2 ; 19
    mul _d2 ; 19*d2
    mov ebx, _c1 ; c1
    div ebx ; (19*d2)/c1
    sub _temp1, eax ; (8*d1)/b1-(19*d2)/c1
    ret ; return from the function
firstfunc endp ; end of the function code

start:
invoke firstfunc, const1,d1,b1,const2,d2,c1 ; call the function firstfunc with the necessary parameters
invoke wsprintf, ADDR strbuf, ADDR _text, _temp1 ; format the message box output using wsprintf
invoke MessageBox, NULL, addr strbuf, addr _title, MB_ICONINFORMATION ; display the message box with the output
invoke ExitProcess, 0 ; exit the program
END start ; end of the program