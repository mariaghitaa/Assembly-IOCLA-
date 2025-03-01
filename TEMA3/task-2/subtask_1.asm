; subtask 1 - qsort

section .text
    global quick_sort
    ;; no extern functions allowed

quick_sort:
    ;; create the new stack frame
    enter 0, 0
    ;; save the preserved registers
    push ebx
    push esi
    push edi
    ; buff
    mov eax, [ebp + 8] 
    ; start 
    mov ebx, [ebp + 0xc] 
    ; end
    mov ecx, [ebp + 16] 
    ; compar start si end
    cmp ebx, ecx         
    jge end_quick_sort
    push ecx            
    push ebx            
    push eax            
    call pivot           
    add esp, 0xc        
    mov edx, eax        
    push edx
    ; pt partea stanga de la start la pivot - 1 
    dec edx 
    push edx            
    push ebx                      
    push dword [ebp + 0x8]   
    call quick_sort
    add esp, 0xc
    pop edx
    ; pt partea dreapta pivot + 1 pana la end
    push dword [ebp + 16] 
    inc edx             
    push edx        
    push dword [ebp + 0x8]   
    call quick_sort
    add esp, 0xc
end_quick_sort:
    pop edi
    pop esi
    pop ebx

    leave
    ret

pivot:
    ;; create the new stack frame
    enter 0, 0

    ;; save the preserved registers
    push ebx
    push esi
    push edi
    ; buff
    mov eax, [ebp + 0x8]
    ; start (i)
    mov ebx, [ebp + 0xc]
    ; end (j)
    mov ecx, [ebp + 16]
    ; indici pentru swap
    xor edx, edx
    mov esi, 0x1

loop_start:
    ; daca start >= end
    cmp ebx, ecx
    jge loop_end
    ; edi = buff[i]
    mov edi, dword [eax + 0x4 * ebx]
    ; compare valoarea de la start cu cea de la final (buff[i] cu buff[j])
    cmp edi, dword [eax + 0x4 * ecx]
    jg swap_function

continue:
    ; actualizez indicii de start si end bazat pe swapp-ul facut
    add ebx, edx  
    sub ecx, esi
    jmp loop_start

swap_function:
    ; se face swapp-ul buff[i] cu buff[j]
    push dword [eax + 0x4 * ebx]
    push dword [eax + 0x4 * ecx]
    pop dword [eax + 0x4 * ebx]
    pop dword [eax + 0x4 * ecx]
    ; actualizez edx si esi pentru un alt swap
    mov edi, 0x1
    sub edi, edx
    mov edx, edi
    mov edi, 0x1
    sub edi, esi
    mov esi, edi
    jmp continue

loop_end:
    ; indexul pivotului final
    mov eax, ecx
    pop edi
    pop esi
    pop ebx
    leave
    ret