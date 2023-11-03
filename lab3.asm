assume cs: code, ds: data

data segment
dummy db 0Dh, 0Ah, '$'
str1 db 100, 101 dup (0)
str2 db 100, 101 dup (0)

res db "   $"

data ends

code segment 

proc printNum
	
	mov si, 2
	mov bl, 10
	mov cx, 0
	print:
		xor ah, ah
		div bl
		add ah, '0'
		mov res[si], ah
		dec si
		cmp si, cx
		jbe printEnd
		
		jmp print
	printEnd:
	
		
	xor ax, ax
	mov dx, offset res
	mov ah, 09h
	int 21h
	xor ax, ax
	ret

printNum endp


strcspn proc

	push bp
	mov bp, sp
	
	xor si, si
	xor di, di
	
	mov si, [bp + 4] ; string1
	mov di, [bp + 6] ; string2
	
	
	mov bl, [si + 1] ; len1
	mov bh, [di + 1] ; len2	
	
	
	add si, 2
	add di, 2
	
	xor ax, ax
	
	xor cx, cx ; counter
	loop1:
		
		
		
		cmp cl, bl
		je endloop1
		xor ch, ch
		loop2:
			
			
			cmp ch, bh
			je endloop2
			mov dl, [si]
			mov dh, [di]
			cmp dl, dh
			je endloop1
			
			inc di
			inc ch
			jmp loop2
			
		
		endloop2:
		xor di, di
		mov di, [bp + 6]
		add di, 2
		inc si
		inc cl
		jmp loop1
	endloop1:
	
	
	mov sp, bp
	pop bp
	pop bx
	xor ch, ch
	push cx
	push bx
ret
strcspn endp

start:	
	mov ax, data
	mov ds, ax
	mov dx, offset str1
	xor ax, ax
	mov ah, 0Ah
	int 21h
	
	mov dx, offset dummy ; перевод строки
	mov ah, 09h
	int 21h
	
	mov dx, offset str2
	xor ax, ax
	mov ah, 0Ah
	int 21h
	
	xor ax, ax
	push offset str2
	push offset str1
	
	call strcspn
	
	mov dx, offset dummy ; перевод строки
	mov ah, 09h
	int 21h
	
	pop ax
	call printNum

	mov ah, 4ch
	int 21h

code ends
end start