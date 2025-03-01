section .rodata
	global sbox
	global num_rounds
	sbox db 126, 3, 45, 32, 174, 104, 173, 250, 46, 141, 209, 96, 230, 155, 197, 56, 19, 88, 50, 137, 229, 38, 16, 76, 37, 89, 55, 51, 165, 213, 66, 225, 118, 58, 142, 184, 148, 102, 217, 119, 249, 133, 105, 99, 161, 160, 190, 208, 172, 131, 219, 181, 248, 242, 93, 18, 112, 150, 186, 90, 81, 82, 215, 83, 21, 162, 144, 24, 117, 17, 14, 10, 156, 63, 238, 54, 188, 77, 169, 49, 147, 218, 177, 239, 143, 92, 101, 187, 221, 247, 140, 108, 94, 211, 252, 36, 75, 103, 5, 65, 251, 115, 246, 200, 125, 13, 48, 62, 107, 171, 205, 124, 199, 214, 224, 22, 27, 210, 179, 132, 201, 28, 236, 41, 243, 233, 60, 39, 183, 127, 203, 153, 255, 222, 85, 35, 30, 151, 130, 78, 109, 253, 64, 34, 220, 240, 159, 170, 86, 91, 212, 52, 1, 180, 11, 228, 15, 157, 226, 84, 114, 2, 231, 106, 8, 43, 23, 68, 164, 12, 232, 204, 6, 198, 33, 152, 227, 136, 29, 4, 121, 139, 59, 31, 25, 53, 73, 175, 178, 110, 193, 216, 95, 245, 61, 97, 71, 158, 9, 72, 194, 196, 189, 195, 44, 129, 154, 168, 116, 135, 7, 69, 120, 166, 20, 244, 192, 235, 223, 128, 98, 146, 47, 134, 234, 100, 237, 74, 138, 206, 149, 26, 40, 113, 111, 79, 145, 42, 191, 87, 254, 163, 167, 207, 185, 67, 57, 202, 123, 182, 176, 70, 241, 80, 122, 0
	num_rounds dd 10

section .text
	global treyfer_crypt
	global treyfer_dcrypt

; void treyfer_crypt(char text[8], char key[8]);
treyfer_crypt:
	;; DO NOT MODIFY
	push ebp
	mov ebp, esp
	pusha

	mov esi, [ebp + 8] ; plaintext
	mov edi, [ebp + 12] ; key	
	;; DO NOT MODIFY
	;; FREESTYLE STARTS HERE
	;; TODO implement treyfer_crypt

	push 10 ;pun nr de randuri in stiva
	xor ebx, ebx ;index pt parcurgerea fiecarui byte 

rounds_for:
	mov ecx, [esp]
	test ecx, ecx ;testez daca s au parcurs toti bytes
	jz end
	xor ecx, ecx

byte_for: ;o bucla de iteratie prin bytes
	cmp ecx, 7  ;verif daca s au procesat toti octetii pana la ultimul
	jz byte_end

	mov bl, [edi] ;mut byte ul din key
	lea edi, [edi + 1] ;trece la urmatorul
	mov dl, [esi]
	add bl, dl

	mov al, [sbox + ebx]
	add al, [esi + 1]
	rol al, 1 ;rotatia la stanga
	mov [esi + 1], al

	lea esi, [esi + 1]
	lea ecx, [ecx + 1]

	jmp byte_for

byte_end: ;tratarea ultimului byte
	mov bl, [edi] ;byte ul coresp key
	lea edi, [edi + 1]
	mov dl, [esi] ;byte ul din text
	add bl, dl ;se aduna la t byte ul din text
	mov al, [sbox + ebx]

	mov esi, [ebp + 8]
	add al, [esi] ;byte ul urm se actualizeaza cu t
	rol al, 1 ;rotatia la stanga
	mov [esi], al

	mov edi, [ebp + 12]
	pop edx
	sub edx, 1

	push edx
	jmp rounds_for

end:
	add esp, 4

    	;; FREESTYLE ENDS HERE
	;; DO NOT MODIFY
	popa
	leave
	ret

; void treyfer_dcrypt(char text[8], char key[8]);
treyfer_dcrypt:
	;; DO NOT MODIFY
	push ebp
	mov ebp, esp
	pusha
	;; DO NOT MODIFY
	;; FREESTYLE STARTS HERE
	;; TODO implement treyfer_dcrypt

	mov esi, [ebp + 8] ;plaintext
    mov edi, [ebp + 12] ;key

    lea esi, [esi + 8] ;ultimul caracter
    lea edi, [edi + 8]

    xor ecx, ecx ;contor pt runde
    mov ecx, 10 ;nr de decriptari
    xor ebx, ebx

rounds_dfor:   ;bucla pt nr de runde
    test ecx, ecx
    jz end_d
    mov ebx, 8

byte_dfor: ;iterare prin fiecare byte
    test ebx, ebx
    jz round_dend

    cmp ebx, 8
    jz byte_dend
    xor eax, eax
    mov al, [edi - 1] ;ia byte-ul cheii
    add al, [esi - 1] ;adauga byte-ul textului
   	sub esi, 1
    sub edi, 1

    movzx eax, byte [sbox + eax]
    mov dl, [esi + 1]  ;ia byte-ul urmator
    ror dl, 1 ;roteste la dreapta
	sub dl, al ;scade valoarea calculata
    mov [esi + 1], dl ;stocheaza rezultatul

    sub ebx, 1
    jmp byte_dfor

round_dend:
    sub ecx, 1
    lea esi, [esi + 8] ;se muta pe primul caracter
    lea edi, [edi + 8]
    jmp rounds_dfor

byte_dend:  ; pentru ultimul byte
    xor eax, eax
    mov al, [edi - 1]
    sub edi, 1

    add al, [esi - 1]
    sub esi, 1
    movzx eax, byte [sbox + eax]
    mov dl, [esi - 7] ;primul caracter
    ror dl, 1
    sub dl, al
    mov [esi - 7], dl
	sub ebx, 1
    jmp byte_dfor

end_d:

	;; FREESTYLE ENDS HERE
	;; DO NOT MODIFY
	popa
	leave
	ret
