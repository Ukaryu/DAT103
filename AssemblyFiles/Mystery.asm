; Mystery for-loop

; Datasegment
section .bss
	number resb 4

section .text

global _start
_start:
	mov sp, 0
	mov ecx, 0

start_for: 		;For-loop
	cmp sp, 20
	jge end_for

	cmp sp, 10	; IF-condition
	jl if
	jge else
if:
	inc ecx
	inc sp
	jmp start_for

else:
	dec ecx
	inc sp
	jmp start_for

end_for:

	; Writing out result of loop
	push eax
	push ebx
	push ecx
	push edx
	add ecx, "0"  	; Converting number to ASCII
	mov dword [number], ecx
	mov ecx, number
	mov edx, 2
	mov ebx, 1
	mov eax, 4
	int 80h
	pop edx
	pop ecx
	pop ebx
	pop eax 	
	
end:
	mov eax, 1
	mov ebx, 0
	int 80h

	
