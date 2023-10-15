.386                   
.model flat, stdcall  ; Use flat memory model and standard calling convention.
option casemap :none  ; Specify that case sensitivity is turned off.

include \masm32\include\windows.inc   ; Include the Windows API header file.
include \masm32\include\kernel32.inc  ; Include the kernel32 API header file. ExitProcess
include \masm32\include\user32.inc    ; Include the user32 API header file. MessageBox, MB_OK
includelib \masm32\lib\kernel32.lib  ; Include the kernel32 library.
includelib \masm32\lib\user32.lib    ; Include the user32 library.

.data
	HelloWorld db "Hello World!", 0

.code
start:                                ; Define the entry point of the program.
	invoke MessageBox, NULL, addr HelloWorld, addr HelloWorld, MB_OK
                                      ; Call the MessageBox function with the "Hello World!" message.
                                      ; NULL for the window handle, addr HelloWorld for the message text,
                                      ; addr HelloWorld for the message title, and MB_OK for the button style.

	invoke ExitProcess, 0              ; Call the ExitProcess function to exit the program with a return code of 0.

end start                             ; End of the program's main code.
