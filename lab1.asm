
assume CS:code,DS:data
; 4 * a + b * d + c
data segment
a db 1
b db 2
c db 4
d db 5
res10 db "   ", 13, 10, "$"
res16 db "   $"
data ends

code segment
start:
mov AX, data
mov DS, AX

;xor AX, AX
mov DL, a
mov CL, 2
shl DL, CL

mov AL, b
mul d

add AL, DL
add AL, c


mov CX, AX

mov BL, 100
div BL
add AL, '0'
mov [res10 + si], AL
inc si

mov AX, CX

mov BL, 10
div BL
add AL, '0'
mov [res10 + si], AL
inc si

add ah, '0'
mov [res10 + si], AH


mov ah, 09h
mov DX, offset res10
int 21h

mov si, 0
mov AX, CX


mov BL, 16
div BL

cmp AL, 9
jle label1
sub AL, 10
add AL, 'A'
jmp label2
label1:
add AL, '0'
label2:

mov [res16 + si], AL
inc si

cmp AH, 9
jle label3
sub AH, 10
add AH, 'A'
jmp label4
label3:
add AH, '0'
label4:

mov [res16 + si], AH

mov ah, 09h
mov DX, offset res16
int 21h

mov AX,4C00h; exit(0)
int 21h
code ends
end start