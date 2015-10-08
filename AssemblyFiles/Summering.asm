; Inndata Programmet leser inn to sifre skilt med ett eler flere mellomrom
; Udata Programmet skriver ut summen av de to sifrene,
; forutsatt at summen er mindre enn 10.

; Konstanter 
	cr equ 13 ; Vognretur
	lf equ 10 ; Linjeskift
	SYS_EXIT	equ 1
	SYS_READ	equ 3
	SYS_WRITE	equ 4
	STDIN		equ 0
	STDOUT		equ 1
	STDERR		equ 2

; Datasegment
section .bss
	siffer resb 4

; Datasegment
section .data
	meld db "Skriv to ensifrede tall skilt med mellomrom.",cr,lf
	meldlen equ $ - meld
	feilmeld db cr,lf, "Skriv kun sifre!",cr,lf
	feillen equ $ - feilmeld
	crlf db cr,lf,"$"
	crlflen equ $ - crlf
	sum db "  "
	sumMeld db "Summen er:", cr,lf
	sumMeldLen equ $ - sumMeld
	mellomrom db "     ",cr,lf
	mellomromLen equ $ - mellomrom

; Kodesegment med program
section .text

global _start
_start:
	mov edx, meldlen
	mov ecx, meld
	mov ebx, STDOUT
	mov eax, SYS_WRITE
	int 80h

	; Les tall, innlest tall returneres i ecx
	; Vellykket retur dersom edx = 0
	call lessiffer
	cmp edx, 0 	 ; Test om vellykket innlesning
	jne Slutt 	 ; Hopp til avslutning ved feil i innlesning
	mov al, cl 	 ; Første tall/siffer lagres i reg al

	call lessiffer
	; Les andre tall/siffer
	; Vellykket: edx = 0, tall i ecx
	cmp edx, 0 	 ; Test om vellykket innlesning
	jne Slutt
	mov bl, cl	 ; Andre tall/siffer lagres i reg cl

	call nylinje
	add al, bl	 ;Adderer sifferet i bl til sifferet i al
	aaa
	or ax, 3030h
	mov [sum], ah
	mov [sum + 1], al
	
	call skrivsiffer ; Skriv ut verdi i ecx som ensifret tall

Slutt:
	mov eax, SYS_EXIT
	mov ebx, 0
	int 80h

;---------------------------------------------------
skrivsiffer:
	; Skriver ut sifferet lagret i sum

	mov edx, sumMeldLen
	mov ecx, sumMeld
	mov ebx, STDOUT
	mov eax, SYS_WRITE
	int 80h

	mov edx, 2
	mov ecx, sum
	mov ebx, STDOUT
	mov eax, SYS_WRITE
	int 80h

	mov edx, mellomromLen
	mov ecx, mellomrom
	mov ebx, STDOUT
	mov eax, SYS_WRITE
	int 80h
	ret

;---------------------------------------------------
lessiffer:
	; Leter forbi alle blanke til neste ikke-blank
	; Neste ikke-blank returneres i ecx
	push eax
	push ebx
Lokke:
	; Leser et tegn fra tastaturet
	mov eax, SYS_READ
	mov ebx, STDIN
	mov ecx, siffer
	mov edx, 1
	int 80h
	mov ecx, [siffer]
	cmp ecx, " "
	je Lokke
	cmp ecx, "0" ; Sjekk at tast er i område 0-9
	jb Feil
	cmp ecx, "9"
	ja Feil
	mov edx, 0   ; Signaliser vellykket innlesning
	pop ebx
	pop eax
	ret          ; Vellykket retur
Feil:
	mov edx, feillen
	mov ecx, feilmeld
	mov ebx, STDERR
	mov eax, SYS_WRITE
	int 80h
	mov edx, 1   ; Signaliser mislykket innlesning av tall
	pop ebx
	pop eax
	ret          ; Mislykket retur

;---------------------------------------------
; Flytt markør helt til venstre på neste linje
nylinje:
	push eax
	push ebx
	push ecx
	push edx
	mov edx, crlflen
	mov ecx, crlf
	mov ebx, STDOUT
	mov eax, SYS_WRITE
	int 80h
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret

; End _start		
