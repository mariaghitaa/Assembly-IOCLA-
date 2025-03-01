; Interpret as 64 bits code
[bits 64]

; nu uitati sa scrieti in feedback ca voiati
; assembly pe 64 de biti

section .text
global map
global reduce
map:
    ; look at these fancy registers
    push rbp
    mov rbp, rsp

    ; sa-nceapa turneu'
    ; rdi dest
    ; rsi src
    ; rdx size
    ; rcx to_apply 
    ; indice contor
    xor rbx, rbx 

map_loop:
    ; daca indicele a depasit dim array-ului se termina loop-ul
    cmp rbx, rdx 
    jge map_end

    ; iterez prin elementele array-ului sursa
    mov r8, [rsi + rbx * 0x8]

    push rdi
    mov rdi, r8
    ; aplic functia to_apply pe elementul i al array-ului sursa
    call rcx
    pop rdi
    ; copiez valoarea in array-ul destinatie de la indicele curent
    mov [rdi + rbx * 0x8], rax 
    ; cresc contorul
    inc rbx
    ; fac bucla pana cand indicele depaseste dim array-ului
    jmp map_loop

map_end:

    leave
    ret


; int reduce(int *dst, int *src, int n, int acc_init, int(*f)(int, int));
; int f(int acc, int curr_elem);
reduce:
    ; look at these fancy registers
    push rbp
    mov rbp, rsp

    ; sa-nceapa festivalu'
    ; rdi - dest (nu se foloseste)
    ; rsi - src
    ; rdx - size
    ; rcx - accumulator
    ; r8 - to_apply 
    ; r10 va stoca accumulatorul initial
    mov r10, rcx
    ; indice contor
    xor rbx, rbx

reduce_loop:
    ; daca indicele a depasit dim array-ului se termina loop-ul
    cmp rbx, rdx
    jge reduce_end

    ; iterez prin elementele array-ului sursa
    mov r9, [rsi + rbx * 0x8]

    xor rax, rax
    push rdi
    push rsi
    ; pun in rdi accumulatorul
    mov rdi, r10
    mov rsi, r9
    push rdx
    ; aplic functia to_apply
    call r8
    pop rdx
    pop rsi
    pop rdi

    ; se acctualizeaza valoarea accumulatorului
    mov r10, rax
    ; cresc contorul
    inc rbx
    jmp reduce_loop 
reduce_end:
    ; valoarea finala a accumulatorului
    mov rax, r10

    leave
    ret
