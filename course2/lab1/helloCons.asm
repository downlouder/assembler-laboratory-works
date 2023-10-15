.386                  ; Set the target processor to 80386 or higher.
.model flat, stdcall  ; Use flat memory model and standard calling convention.
option casemap :none  ; Specify that case sensitivity is turned off.

include \masm32\include\windows.inc   ; Include the Windows API header file.
include \masm32\include\kernel32.inc  ; Include the kernel32 API header file.
include \masm32\include\masm32.inc    ; Include the MASM32 API header file.

includelib \masm32\lib\kernel32.lib  ; Include the kernel32 library.
includelib \masm32\lib\masm32.lib    ; Include the MASM32 library.

.data
	HelloWorld db "Hello, World!", 0   ; Define a null-terminated string "Hello, World!" in the data section.

.code
start:                                ; Define the entry point of the program.
	invoke StdOut, addr HelloWorld     ; Call the StdOut function to print the message to the console.
	invoke ExitProcess, 0              ; Call the ExitProcess function to exit the program with a return code of 0.

end start                             ; End of the program's main code.
