; Беззнаковое сложение в шестнадцатеричной системе

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
        ; проверка на корректность ввода.
		mov al, [si]
        cmp al, '0'
        jb IncorrectInputCrash
        cmp al, '9'
        jbe validDecimal
        cmp al, 'A'
        jb IncorrectInputCrash
        cmp al, 'F'
        jbe validHex

    IncorrectInputCrash:
        mov ah, 4ch
		int 21h  
   

    validHex:
        sub al, 'A' ; Корректировка для 'A' - 'F'
        add al, 10
        jmp convertToNumber

    validDecimal:
        sub al, '0' ; Корректировка для '0' - '9'
        jmp convertToNumber

     

    convertToNumber:
				
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
	mov dl, 16
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
        cmp ah, 10
        jb isDecimal
        
        add ah, 'A'
        sub ah, 10
        jmp endDetermination

        isDecimal:
		add ah, '0'

        endDetermination:
		mov bx, si
		mov si, cx
		dec si
		mov res[si], ah

		mov si, bx
		xor bx, bx
		xor ah, ah

		cmp cl, 2
		jg sum
	
    cmp al, 10
    jb isDecimalEND
        add al, 'A'
        jmp endDeterminationEND
    isDecimalEND:
        add al, '0'
    endDeterminationEND:
	
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