; Знаковое сложение в десятичной
assume cs: code, ds: data

data segment
dummy db 0Dh, 0Ah, '$'
str1 db 17, 18 dup ('$')
str2 db 17, 18 dup ('$')

num1 db 17 dup (0)
num2 db 17 dup (0)


res db 33, 34 dup ('$')

data ends

code segment 

proc toNumArray

	push bp
	mov bp, sp
	
	xor si, si
	xor di, di
	
	mov si, [bp + 4] ; str
	mov di, [bp + 6] ; num

    inc si
	
	xor bx, bx
	mov bl, [si] ; len
	
	
	inc si
	
	xor ax, ax
	
	xor cx, cx 
    
    mov al, [si]
    mov cl, 1
    mov [di], cl
    add si, bx
    cmp al, '-'
    jne getSignEnd
    mov cl, -1
    mov [di], cl
    dec bl
    
    getSignEnd:
    
    
    dec si
    xor cx, cx ; counter
    inc di
    

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

proc signedSum


	xor si, si
	xor di, di
	xor cx, cx

	mov al, str1[1] ; len1
	mov ah, str2[1] ; len2
	
    mov cl, num1[0]

    cmp cl, -1
    je skipMinus1 
    inc al
    skipMinus1:

    mov cl, num2[0]
    cmp cl, -1
    je skipMinus2
    inc ah
    skipMinus2:
    
    xor cl, cl
	cmp al, ah
	jge fisrtLonger

	secondLonger: 

	mov cl, ah ; len(str2) > len(str1) -> counter = len(str2)


	jmp endcmp

	fisrtLonger:
	
	mov cl, al ; len(str1) >= len(str2) -> counter = len(str1)


	endcmp:
    inc cl
	xor ax, ax ; carry = 0
	mov dl, 10
	xor bx, bx
    inc si
    inc di

	sum:
		
        dec cl
		
		mov bl, num1[si]
		cmp bl, '#'
		je skip1
		inc si
        mov bh, num1[si]
        cmp bh, '#'
        je skip1next
        
        dec num1[si]
        add bl, 10
        
        skip1next:
        
        cmp num1[0], 0
        jge endNegCheck1
        neg bl
        endNegCheck1:
        
        add al, bl
		
        skip1:
		
        mov bl, num2[di]
		cmp bl, '#'
		je skip2
		inc di

        mov bh, num2[di]
        cmp bh, '#'
        je skip2next

        dec num2[di]
        add bl, 10

        skip2next:

        cmp num2[0], 0
        jge endNegCheck2
        neg bl

        endNegCheck2:

		add al, bl

		skip2:
		
        cmp al, 0
        jg positiveCarry
        je endCarryCheck
        neg al
        div dl
        mov dh, '-'
        neg al
        jmp endCarryCheck
        positiveCarry:
        mov dh, '+'
		div dl
        endCarryCheck:

        add ah, '0'
		mov bx, si
		mov si, cx
		mov res[si], ah

		mov si, bx
		xor bx, bx
		xor ah, ah

		cmp cl, 2
		jg sum
	
    mov res[0], dh

    cmp al, 0
    jge finalAbs
    neg al
    finalAbs:
    add al, '0'
    mov res[1], al

	xor ax, ax
	ret
signedSum endp

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
	
	call signedSum
	
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