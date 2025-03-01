%include "../include/io.mac"

extern ant_permissions

extern printf
global check_permission

section .text

check_permission:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     eax, [ebp + 8]  ; id and permission
    mov     ebx, [ebp + 12] ; address to return the result
    ;; DO NOT MODIFY
   
    ;; Your code starts here
    
    mov ecx, eax 
    shr ecx, 24    ;ecx va contine id-ul   
    movzx eax, ax  ;extinde val din registrul ax la eax lasand ceilalti biti zero 
    mov edx, [ant_permissions + 4 * ecx]  ;ia permisiunile

    and edx, eax         
    cmp edx, eax  ;verifica daca permisiunile sunt egale cu 'masca' facuta       
    jz  good  ;daca sunt egale se va pune 1   
    mov dword [ebx], 0 ;altfel 0 
    jmp end

good:
    mov dword [ebx], 1

end:

    ;; Your code ends here
    
    ;; DO NOT MODIFY

    popa
    leave
    ret
    
    ;; DO NOT MODIFY

