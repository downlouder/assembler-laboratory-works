;Laboratorna robota 6 Nazarenko Yurii
.686 ; create 32 bit code
.model flat, stdcall ; 32 bit memory model 
option casemap :none ; case sensitive 
include \masm32\include\windows.inc ; always first
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
x DWORD 0.0 ; variable x
xnow DWORD 0.0 ; variable xnow
rootx DWORD 0.0 ; variable rootx
denominator DWORD 3.0 ; variable denominator
eps DWORD 0.0001 ; variable eps
one DWORD 1.0 ; variable one
two DWORD 2.0 ; variable two 
zero DWORD 0.0 ; variable zero 
_title db "Laboratorna robota 6",0 ; string variable _title
_textln db "Nazarenko Yurii Student of KNEU IITE",10,
	"Output result: (1/2)*ln((1+x)/(1-x)):",10,
	"ln cannot be negative",0 ; string variable _textln
_textdiv db "Nazarenko Yurii Student of KNEU IITE",10,
	"Output result: (1/2)*ln((1+x)/(1-x)):",10,
	"Division by zero",0 ; string variable _textdiv
strbuf dw ?,0 ; string buffer
_text db "Nazarenko Yurii Student of KNEU IITE",10,
"Output result: (1/2)*ln((1+x)/(1-x)):",10,13 ; string variable _text
_result dt 0.0 ; floating-point 
sum DWORD 0.0 ; variable sum 
n DWORD 1.0 ; variable n
n1 DWORD 0.0 ; variable n1

.const ; const definition directive
NULL equ 0
MB_OK equ 0

include \masm32\include\masm32rt.inc ; MASM32 runtime library includes
include \masm32\include\dialogs.inc ; includes dialog-related definitions

dlgproc PROTO :DWORD,:DWORD,:DWORD,:DWORD ; prototype for the dialog procedure
GetTextDialog PROTO :DWORD,:DWORD,:DWORD ; prototype for the GetTextDialog function

.data? ; directive to define data segment
hInstance dd ? ; uninitialized variable hInstance

.code ; code definition directive 
start: ; Program start mark with the name start
mov hInstance, rv(GetModuleHandle,NULL) 
call main ; call the main procedure
invoke ExitProcess,eax
 
main proc ; start of the main procedure
LOCAL hIcon :DWORD ; define a local variable hIcon

invoke InitCommonControls ; initialize common controls
mov hIcon, rv(LoadIcon,hInstance,10) ; load an icon with ID 10 using the module handle hInstance and store the handle in hIcon

mov x, rv(GetTextDialog," Laboratorna 6 (Iteration)"," Enter x: ",hIcon) ; invoke the GetTextDialog function with the specified parameters and store the result in x
mov eax, sval(x) ;convert the string value of x to a numeric value and store it in eax
mov x, eax ; move the value of eax to x

.if x == 0 ; if x is equal to 0, execute the following block of code
fld sum ; load the value of sum onto the FPU stack
invoke FpuFLtoA, 0, 10, ADDR _result, SRC1_FPU or SRC2_DIMM ; convert the FPU stack value to ASCII and store it in _result
invoke MessageBox, 0, offset _text, offset _title, MB_ICONINFORMATION ; display a message box with the specified parameters
jmp b ; jump to label b


.elseif x == 1 || x == -1 ; if x equal 1, execute the following block of code
invoke MessageBox, 0, offset _textdiv, offset _title, MB_ICONINFORMATION ; display a message box with the specified parameters
jmp b ; jump to label b

.elseif x > 1 || x<-1 ; if x more than 1 or less than -1, execute the following block of code
invoke MessageBox, 0, offset _textln, offset _title, MB_ICONINFORMATION ; display a message box with the specified parameters
jmp b ; jump to label b

.endif ; end of if instruction

finit ; initialize coprocessor
fild x ;st = int x
fstp x ;x = st

fld rootx ; load rootx to the top of the stack
fadd x ;x 
fmul x ;x^2
fmul x ;x^3
fstp rootx ; update value of rootx

fld rootx ; x^3
fdiv denominator ; x^3/3
fstp xnow ;xnow = x^3/3

fld xnow ; x^3/3
fstp n1 ;n1 = x^3/3

fld sum ;st = 0
fadd x ; 0 + x
fadd xnow ;st = 0 + x + x^3/3
fstp sum ;sum = x + x^3/3
 
a:
fld xnow ;st = x^3/3
fstp n ;n = x^3/3

fld rootx ; x^3
fmul x ; x^4
fmul x ; x^5
fstp rootx ;save new value

fld denominator ; 3
fld1 ; 1
fld1 ; 1
fadd ; 3+1 ...
fadd ; 4+1 ...
fstp denominator ; denominator = 5

fld rootx ; x^5
fdiv denominator ; x^5/5
fstp xnow ; xnow = x^5/5

fld xnow ;st = x^5/5
fstp n1 ;n1 = x^5/5

fld sum ; sum(1) = (x + x^3/3)
fld xnow ; x^5/5, x + x^3/3
fadd ; x + x^3/3 + x^5/5
fstp sum ; sum = x + x^3/3 + x^5/5

fld n ;st = U(n-1)
fsub n1 ;U(n)
fsub eps ;st = x^3/3 - x^5/5 - 0.0001
fabs ;st = |x^3/3 - x^5/5 - 0.0001|
fcomp eps ;0.0001
fstsw ax ;stores the FPU status word into the ax register.
sahf
jae a

fld sum	;output result
invoke FpuFLtoA, 0, 10, ADDR _result, SRC1_FPU or SRC2_DIMM 
invoke MessageBox, 0, offset _text, offset _title, MB_ICONINFORMATION
b: ;marker b
ret ;return from the current procedure
ret ;return from the current procedure
ret ;return from the current procedure
main endp ; end of the main procedure

GetTextDialog proc dgltxt:DWORD,grptxt:DWORD,iconID:DWORD ; defines a procedure named GetTextDialog
LOCAL arg1[4]:DWORD ; local variable
LOCAL parg :DWORD ; local variable

lea eax, arg1 
mov parg, eax

;  	
; load the array with the stack arguments
;	
 mov ecx, dgltxt
mov [eax], ecx 
mov ecx, grptxt 
mov [eax+4], ecx 
mov ecx, iconID 
mov [eax+8], ecx

Dialog "Get User Text", \ ; caption 
"Arial",8, \ ; font,pointsize 
WS_OVERLAPPED or \ ; styles for
WS_SYSMENU or DS_CENTER, \ ; dialog window 
5, \ ; number of controls
50,50,292,80, \ ; x y co-ordinates 
4096 ; memory buffer size

DlgIcon 0,250,12,299
DlgGroup 0,8,4,231,31,300
DlgEdit ES_LEFT or WS_BORDER or WS_TABSTOP,17,16,212,11,301 
DlgButton "OK",WS_TABSTOP,172,42,50,13,IDOK
DlgButton "Cancel",WS_TABSTOP,225,42,50,13,IDCANCEL

CallModalDialog hInstance,0,dlgproc,parg 
ret ;return from the current procedure
GetTextDialog endp ; end of the GetTextDialog procedure

dlgproc proc hWin:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD ; start of dlgproc procedure
LOCAL tlen :DWORD ; local variable 
LOCAL hMem :DWORD ; local variable
LOCAL hIcon :DWORD ; local variable

switch uMsg
case WM_INITDIALOG
;  	
; get the arguments from the array passed in lParam
;	 
push esi
mov esi, lParam
fn SetWindowText,hWin,[esi] ; title text address
fn SetWindowText,rv(GetDlgItem,hWin,300),[esi+4] ; groupbox text address
mov eax, [esi+8] ; icon handle
.if eax == 0 ; start of if condition
mov hIcon, rv(LoadIcon,NULL,IDI_ASTERISK) ; use default system icon
.else ; start of else condition
mov hIcon, eax ; load user icon
.endif ; end of if condition
pop esi

fn SendMessage,hWin,WM_SETICON,1,hIcon
invoke SendMessage,rv(GetDlgItem,hWin,299),STM_SETIMAGE,IMAGE_ICON,hIcon
xor eax, eax
ret ;return from the current procedure

case WM_COMMAND
switch wParam
case IDOK
mov tlen, rv(GetWindowTextLength,rv(GetDlgItem,hWin,301)) ; save in tlen 
.if tlen == 0 ; start of if condition
invoke SetFocus,rv(GetDlgItem,hWin,301)
ret ;return from the current procedure
.endif
add tlen, 1 ; add 1 to tlen
mov hMem, alloc(tlen) ; save in hMem 
fn GetWindowText,rv(GetDlgItem,hWin,301),hMem,tlen
invoke EndDialog,hWin,hMem ; end dialog
case IDCANCEL
invoke EndDialog,hWin,0 ; end dialog
invoke ExitProcess, 0 ; exit the program
endsw
case WM_CLOSE
invoke EndDialog,hWin,0 ; end dialog
endsw

xor eax, eax
ret ;return from the current procedure
dlgproc endp ; end of the dlgproc procedure
end start ; end of the program