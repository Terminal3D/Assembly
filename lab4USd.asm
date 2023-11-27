; Беззнаковое сложение в десятичной системе

assume cs: code, ds: data

data segment
dummy db 0Dh, 0Ah, '$'
str1 db 16, 17 dup ('$')
str2 db 16, 17 dup ('$')

num1 db 16 dup (0)
num2 db 16 dup (0)


res db 32, 33 dup ('$')

data ends

code segment 

proc toNumArray

	push bp
	mov bp, sp
	
	xor si, si
	xor di, di
	
	mov si, [bp + 4] ; str
	mov di, [bp + 6] ; num

	
	xor bx, bx
	mov bl, [si + 1] ; len
	add si, bx
	inc si
	
	
	xor ax, ax
	
	xor cx, cx ; counter

	loop1:
		
		mov al, [si]
		sub al, '0'


		; проверка на корректность ввода.

		cmp al, 10
		jl skipIncorrectInputCrash

		mov ah, 4ch
		int 21h

		skipIncorrectInputCrash:

		mov [di], al

		inc cl
		inc di
		dec si
		cmp cl, bl
		jl loop1



	xor ax, ax
	mov al, '#'
	mov [di], ax
	mov sp, bp
	pop bp
ret

endp toNumArray

proc unsignedSum


	xor si, si
	xor di, di
	xor cx, cx

	mov al, str1[1] ; len1
	mov ah, str2[1] ; len2
	
	cmp al, ah
	jge fisrtLonger

	secondLonger: 

	mov cl, ah ; len(str2) > len(str1) -> counter = len(str2)


	jmp endcmp

	fisrtLonger:
	
	mov cl, al ; len(str1) >= len(str2) -> counter = len(str1)



	endcmp:
	inc cl
	inc cl
	xor ax, ax ; carry = 0
	mov dl, 10
	xor bx, bx

	sum:
		dec cl
		
		mov bl, num1[si]
		cmp bl, '#'
		je skip1
		inc si
		add al, bl

		skip1:
		mov bl, num2[di]
		cmp bl, '#'
		je skip2
		inc di
		add al, bl
		skip2:
		
		div dl
		add ah, '0'

		mov bx, si
		mov si, cx
		dec si
		mov res[si], ah

		mov si, bx
		xor bx, bx
		xor ah, ah

		cmp cl, 2
		jg sum
	
	add al, '0'
	mov res[0], al
	xor ax, ax
	ret
unsignedSum endp

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

	push offset num1
	push offset str1

	call toNumArray

	pop ax
	pop ax

	xor ax, ax

	push offset num2
	push offset str2

	call toNumArray
	
	call unsignedSum
	
	mov dx, offset dummy ; перевод строки
	mov ah, 09h
	int 21h
	


	mov dx, offset res ; вывод ответа
	mov ah, 09h
	int 21h
	

	mov ah, 4ch
	int 21h

code ends
end start