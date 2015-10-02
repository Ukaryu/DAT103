; Mystery for-loop

; Datasegment
section .bss
	number resb 1

section .text

global _start
_start:
	mov ax, 0
	mov cx, 0
	
start_for: 		;For-loop
	cmp cx, 20
	jge slutt_for

	cmp cx, 10	; IF-condition
	jl if
	jge else
if:
	inc ax
	inc cx
	jmp start_for

else:
	dec ax
	inc cx
	jmp start_for

slutt_for:

	; Writing out result of loop
	 	
	mov eax, 4
	mov ebx, 1
	add ax, "0"
	mov edx, 1
	int 80h
	
	
