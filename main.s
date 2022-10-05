section .data
  s db "Hello, I'm Mac",10,0
  input dd 5; 01111101
  output db "00000000000000000000000000000000"
  switchTest db "01234567",10,0
  n db 5
;;;;;;;;;;;;;;;;
;;  XORSHIFT  ;;
;;;;;;;;;;;;;;;;
  state dd 1  ;;
;;;;;;;;;;;;;;;;

section .bss
  c resb 256

section .text
global _start
_start:
 ; xor rax, rax
  ;call xorShift
  ;mov [input], eax


  lea rsi, input
  lea rdi, output
  mov rbx, 10
  call intToString


  lea rsi, output
  call printS
  jmp ending



xorShift:
  push rax
  push rbx
  mov eax, [state]
  mov ebx, eax
  shr ebx, 12
pop rbx
ret





















;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;       SWITCH             ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;rax is start index           ;;
;rdi is end value             ;;
switch:                       ;;
  push rsi                    ;;
  push rbx                    ;;
  switchloop:                 ;;
    xor rsi,rsi               ;;
    xor rbx,rbx               ;;
    mov rsi, [rax]            ;;
    mov rbx, [rdi]            ;;
    mov byte[rax], bl         ;;
    mov byte[rdi], sil        ;;
    inc rax                   ;;
    dec rdi                   ;;
    cmp rax, rdi              ;;
    jb switchloop             ;;
pop rsi                       ;;
pop rbx                       ;;
ret                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;takes int in memory and stores a string          ;;
;returns memory address                           ;;
; src in rsi                                      ;;
; base in rbx                                     ;;
; dest in rdi                                     ;;
intToString:                                      ;;
  push rax                                        ;;
  push rcx                                        ;;
                                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;                         ;;
;;; INT SIZE CONTROLL ;;;                         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;                         ;;
  mov eax, [rsi]      ;;;                         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;                         ;;
                                                  ;;
  xor rcx,rcx                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;          ;;
  intToStringLoop:                                ;;
    div rbx                                       ;;
    add dl, 48                                    ;;
    mov byte [rdi+rcx], dl                        ;;
    inc rcx                                       ;;
    xor rdx,rdx                                   ;;
                                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;          ;;
    cmp al, 0                                     ;;
    ja intToStringLoop                            ;;
;;;;;;;;;;;;;;;;;;;;                              ;;
;; reverse string ;;                              ;;
;;;;;;;;;;;;;;;;;;;;                              ;;
                                                  ;;
  intToStringfindStart:                        ;;
    cmp rcx, 0                                    ;;
    je intToStringIsZero                          ;;
    cmp byte [rdi+rcx],48                         ;;
    jne intToStringSwitchArea                     ;;
    dec rcx                                       ;;
    jmp intToStringfindStart                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;          ;;
intToStringSwitchArea:                            ;;
  ;set null after rcx+1                           ;;
  inc rcx                                         ;;
  mov byte [rdi+rcx], 0                           ;;
  dec rcx                                         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;          ;;
  mov rax, rdi                                    ;;
  add rdi, rcx                                    ;;
  call switch                                     ;;
                                                  ;;
  jmp intToStringEnd                              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;          ;;
intToStringIsZero:                                ;;
  mov byte [rdi+1], 0                             ;;
  jmp intToStringEnd                              ;;
                                                  ;;
intToStringEnd:                                   ;;
  pop rcx                                         ;;
  pop rax                                         ;;
ret                                               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;       PRINT STRING         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;rsi holds location to memory   ;;
;prints string                  ;;
printS:                         ;;
  push rax                      ;;
  push rcx                      ;;
  push rdi                      ;;
  xor rcx, rcx                  ;;
  xor rax,rax                   ;;
  printSCheckLoop:              ;;
    mov al, [rsi+rcx]           ;;
    cmp rax, 0                  ;;
    je printSCheckLoopEnd       ;;
    inc rcx                     ;;
    jmp printSCheckLoop         ;;
  printSCheckLoopEnd:           ;;
    mov rax, 1                  ;;
    mov rdx, rcx                ;;
    mov rdi, 0                  ;;
    syscall                     ;;
  pop rax                       ;;
  pop rcx                       ;;
  pop rdi                       ;;
  ret                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  


ending:
  xor rdi, rdi
  mov rax, 60
  syscall