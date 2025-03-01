%include "../include/io.mac"

; The `expand` function returns an address to the following type of data
; structure.
struc neighbours_t
    .num_neighs resd 1  ; The number of neighbours returned.
    .neighs resd 1      ; Address of the vector containing the `num_neighs` neighbours.
                        ; A neighbour is represented by an unsigned int (dword).
endstruc

section .bss
; Vector for keeping track of visited nodes.
visited resd 10000
global visited

section .data
; Format string for printf.
fmt_str db "%u", 10, 0

section .text
global dfs
extern printf

; C function signiture:
;   void dfs(uint32_t node, neighbours_t *(*expand)(uint32_t node))
; where:
; - node -> the id of the source node for dfs.
; - expand -> pointer to a function that takes a node id and returns a structure
; populated with the neighbours of the node (see struc neighbours_t above).
; 
; note: uint32_t is an unsigned int, stored on 0x4 bytes (dword).
dfs:
    push ebp
    mov ebp, esp

    ; TODO: Implement the depth first search algorith, using the `expand`
    ; function to get the neighbours. When a node is visited, print it by
    ; calling `printf` with the format string in section .data.
    pusha
    ; nodul
    mov ebx, [ebp + 0x8]
    ; functia expand
    mov esi, [ebp + 0xc]
    ; il marchez ca vizitat
    mov dword [visited + 0x4 * ebx], 1
    ; afisez nodul
    push ebx
    push fmt_str
    call printf
    add esp, 0x8
    ; vecinii nodului
    push ebx
    call esi
    add esp, 0x4
    ; iterez prin vecini
    mov ecx, dword [eax + 0x4]
    xor edx, edx

loop: 
    cmp edx, dword [eax]
    jge end_dfs
    ; vecinul curent
    mov ebx, [ecx + 0x4 * edx]
    ; verif daca e vizitat
    cmp dword [visited + 0x4 * ebx], 1
    je inc_edx
    push edx
    push esi
    push ebx
    call dfs
    add esp, 0x8  
    pop edx
inc_edx:
    inc edx
    jmp loop

end_dfs:
    popa
    leave
    ret
