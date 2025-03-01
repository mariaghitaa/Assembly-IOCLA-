%include "../include/io.mac"

extern printf
extern position
global solve_labyrinth

; you can declare any helper variables in .data or .bss

section .text

; void solve_labyrinth(int *out_line, int *out_col, int m, int n, char **labyrinth);
solve_labyrinth:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha
    mov     eax, [ebp + 8]  ; unsigned int *out_line, pointer to structure containing exit position
    mov     ebx, [ebp + 12] ; unsigned int *out_col, pointer to structure containing exit position
    mov     ecx, [ebp + 16] ; unsigned int m, number of lines in the labyrinth
    mov     edx, [ebp + 20] ; unsigned int n, number of colons in the labyrinth
    mov     esi, [ebp + 24] ; char **a, matrix represantation of the labyrinth

    ;; DO NOT MODIFY

    ;; Freestyle starts here

    xor ecx, ecx
    xor edx, edx

add_ecx:  ;incrementeaza indexul liniei
    add ecx, 1
    jmp for

add_edx:  ;incrementeaza indexul coloanei
    add edx, 1
    jmp for

sub_ecx:  ;decrementeaza indexul liniei
    sub ecx, 1
    jmp for

sub_edx:  ;decrementeaza indexul coloanei
    sub edx, 1
    jmp for

for:
    mov edi, [esi + 4 * ecx] ;inceputul liniei
    mov byte [edi + edx], 1  ;pun 1 in pozitia curenta pt
                             ;a nu ma intoarce niciodata

    ;verific daca trebuie schimbata directia sau continui
    add ecx, 1
    add edx, 1
    cmp ecx, [ebp + 16] ;compar sa vad daca am atins limita nr de linii
    jge exit_for  ;si ies daca e afirmativ
    cmp edx, [ebp + 20] ;vad si pt coloane
    jge exit_for   
    sub ecx, 1
    sub edx, 1

    ;verific elementul de sub poz curente
    mov edi, [esi + 4 * ecx + 4]
    cmp byte [edi + edx], '0'
    je add_ecx

    ;verific elementul din dreapta poz curente
    mov edi, [esi + 4 * ecx]
    cmp byte [edi + edx + 1], '0'
    je add_edx

    ;verific elementul de deasupra poz curente
    mov edi, [esi + 4 *ecx - 4]
    cmp byte [edi + edx], '0'
    je sub_ecx

    ;verific elementul din stanga poz curente
    mov edi, [esi + 4 * ecx]
    cmp byte [edi + edx - 1], '0'
    je sub_edx

    jmp for

exit_for: ;pun valorile la adresele specificate
    sub ecx, 1
    sub edx, 1
    mov [eax], ecx
    mov [ebx], edx


    ;; Freestyle ends here
end:
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
