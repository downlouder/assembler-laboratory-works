.386
.model flat, stdcall
includelib \masm32\lib\kernel32.lib
ExitProcess proto: DWORD
.code
start:
mov eax, 2
add eax, 3
ret
end start