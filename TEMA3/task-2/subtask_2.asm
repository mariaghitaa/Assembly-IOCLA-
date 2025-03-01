; subtask 2 - bsearch

section .text
    global binary_search

binary_search:
    ;; create the new stack frame
    enter 0, 0

    ;; save the preserved registers
    push ebx
    push esi
    push edi

    ; start
    mov edi, [ebp + 8]  
    ; end
    mov esi, [ebp + 0xc] 

    ; edi > esi
    cmp edi, esi 
    jg not_found
    mov ebx, edi
    ; start + end 
    add ebx, esi  
    ; (start + end)/2
    shr ebx, 0x1    
    ; daca needle e chiar mijlocul
    cmp edx, [ecx + 0x4 * ebx] 
    je found
    ; mijlocul
    cmp edx, [ecx + 0x4 * ebx]
    jl search_left

    ; daca needle > mijloc, cauta in dreapta
    ; creste pt a merge in drepta array-ului
    add ebx, 0x1 
    push esi 
    push ebx
    ; apelam recursiv
    call binary_search 
    add esp, 0x8
    jmp end_search

    ; altefl cauta in stanga
search_left:
    ; scade pt a intra in partea stanga array-ului
    sub ebx, 0x1 
    push ebx
    push edi
    ; apelam recursiv
    call binary_search 
    add esp, 0x8
    jmp end_search

found:
    ; needle a fost gasit
    mov eax, ebx 
    jmp end_search

not_found:
    ; nu s a gasit needle
    mov eax, -0x1 

end_search:
    pop edi
    pop esi
    pop ebx

    leave
    ret