assume CS:code,DS:data
data segment

array dw 1, 2, -3, 4, -5, 6, 7, 8, -9, 10
len EQU $-array

posCount db 0
negCount db 0

posString db "Number of positive elements: $"
negString db "Number of negative elements: $"
newline db 13, 10, "$"

res db "   $"

data ends
code segment

proc printNum
	
	mov si, 2
	mov bl, 10
	
	
	div bl
	add ah, '0'
	mov res[2], ah
	dec si
		
	xor ax, ax
	mov dx, offset res
	mov ah, 09h
	int 21h
	xor ax, ax
	ret

printNum endp

start:

mov AX, data
mov DS, AX

mov cx, len
shr cx, 1

xor bx, bx
xor dx, dx
find:

	mov si, cx
	sub si, 1
	shl si, 1
	
	mov ax, array[si]
	cmp ax, 0
	jg positive
	jl negative
	je zero

	positive: 
	inc dl
	jmp zero

	negative:
	inc bl
	jmp zero
	
	zero:
	loop find


mov posCount, dl
mov negCount, bl

xor ax, ax

mov ah, 09h
mov dx, offset posString
int 21h

xor ax, ax
mov al, posCount

call printNum

mov ah, 09h
mov dx, offset newline
int 21h
mov dx, offset negString
int 21h

xor ax, ax
mov al, negCount
call printNum


mov AX,4C00h; exit(0)
int 21h
code ends
end start