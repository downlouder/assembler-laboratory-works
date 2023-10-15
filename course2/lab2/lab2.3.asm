.386
.model flat, stdcall
.code
start:
mov al, -120; al = 88h
mov bl, -127; bl = 81h
add al, bl; al = 09h O = 1 C = 1 S = 0
; То ж складання,
; Але в регістрах AX, BX
mov ax, -120; al = 8816
mov bh, 255; bx = ff8116 = -127
add ax, bx; ax = ff0916 = -247 O = 0 S = 1

ret

end start
