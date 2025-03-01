; Interpret as 32 bits code
[bits 32]

%include "../include/io.mac"

section .bss 
    par resd 0x1

section .data
    ; mi am declarat niste variabile pt fiecare paranteza deschisa
    open_round db '('
    open_square db '['
    open_brace db '{'

section .text
    extern printf

; int check_parantheses(char *str)
global check_parantheses
check_parantheses:
    push ebp
    mov ebp, esp

    ; Start the competition
    mov [par], ebx
    ; inceputul stringului
    mov eax, [ebp + 0x8] 
    ; contor
    xor edx, edx  
for_loop:
    ; compara caract cur cu 0 (sf stringului)
    cmp byte[eax + edx], 0 
    jz end_loop 

    xor ebx, ebx 
    ; caracterul curent din sir
    mov cl, byte[eax + edx]

    ; verifica ce fel de paranteza deschisa este si sare la functia care inchide paranteza
    cmp cl, [open_round] 
    jz close_round

    cmp cl, [open_square]
    jz close_square

    cmp cl, [open_brace]
    jz close_brace

    cmp esp, ebp
    jz inccorect

    ; caracterul din varful stivei
    xor ecx, ecx  
    pop ecx  
next:
    ; creste contorul
    add edx, 0x1 
    jmp for_loop

    ; pune pe stiva paranteza corespunzatoare de inchidere a celei deschise
close_round:
    push ebx
    jmp next

close_square:
    push ebx
    jmp next

close_brace:
    push ebx
    jmp next

inccorect:
    ; sirul nu este parantezat corect
    mov eax, 0x1 
    jmp end_function

end_loop:
    ; verif daca stiva e goala
    cmp esp, ebp
    ; daca nu e goala sare la functia inccorect 
    jnz inccorect
    ; sir valid (parantezat corect) 
    mov eax, 0 
end_function:
    mov ebx, [par]

    leave
    ret