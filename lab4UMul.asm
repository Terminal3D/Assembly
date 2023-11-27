; Беззнаковое умножение в десятичной системе

assume cs: code, ds: data

data segment
dummy db 0Dh, 0Ah, '$'
str1 db 16, 17 dup ('$')
str2 db 16, 17 dup ('$')

num1 db 16 dup (0)
num2 db 16 dup (0)

resNum db 32 dup (0)
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

	
	xor ax, ax
	mov dl, 10
	xor bx, bx

	mult:

		cmp num1[si], '#'
        je endMult
        mov cx, si
        mov bl, num1[si]
        xor di, di
        multloop1:
            xor ax, ax
            mov al, bl
            mul num2[di]
            div dl

            add resNum[si], ah
            inc si
            add resNum[si], al
            inc di
            xor ax, ax
            dec si
            mov al, resNum[si]
            div dl
            mov resNum[si], ah
            inc si
            add resNum[si], al
            cmp num2[di], '#'
            jne multloop1
        endloop1:

            
        mov bx, si            
        mov si, cx
        xor ax, ax
        xor cx, cx
        inc si
        jmp mult

    endMult:

	xor ax, ax
    xor di, di
    mov si, bx
    mov al, resNum[si]
    div dl

    mov resNum[si], ah

    cmp al, 0
    je isLessThan10
    inc si
    mov resNum[si], al
    isLessThan10:
    writeNum:
        
        cmp si, 0
        jl endWriteNum

        mov al, resNum[si]
        add al, '0'

        mov res[di], al
        inc di
        dec si
        jmp writeNum
    endWriteNum:


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