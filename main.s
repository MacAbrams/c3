section .data
  s db "Hello, I'm Mac",10,0
  input dd 5; 01111101
  ;output db "00000000000000000000000000"
  switchTest db "01234567",10,0
  n db 10,0
  minus db 45,0

;;;;;;;;;;;;;;;;
;;  XORSHIFT  ;;
;;;;;;;;;;;;;;;;
  state dd 5  ;;
;;;;;;;;;;;;;;;;

section .bss
  c resb 256
  output resb 66

section .text
global _start
_start:

  xor rcx,rcx
  loop:
    call xorShift

    mov dword [input], eax
    lea rsi, input
    lea rdi, output
    mov rbx, 2
    call intToString  
    lea rsi, output
    call printS
    lea rsi, n
    call printS



    inc rcx
    cmp rcx, 100
    ja ending
    jmp loop






jmp ending









xorShift:
  push rcx
  mov eax, [state]
  shl ecx, 13 
  xor eax, ecx;
  shr ecx, 17 
  xor eax, ecx;
  shl ecx, 5 
  xor eax, ecx;
  mov dword [state], eax;
  pop rcx
ret







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;         ZERO             ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;rdi holds Efective adress    ;;
;rax holds length             ;;
zeroMem:                      ;;
  push rcx                    ;;
  xor rcx, rcx                ;;
  zeroMemLoop:                ;;
    mov byte [rdi+rcx], 48    ;;
    inc rcx                   ;;
    cmp rcx, rax              ;;
    jb zeroMemLoop            ;;
                              ;;
pop rcx                       ;;
ret                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


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
  ;;zero output(128 bytes)                        ;;
  mov rax, 66                                     ;;
  call zeroMem                                    ;;  
;;;;;;;;;;;;;;;;;;;;;;;;;                         ;;
;;; INT SIZE CONTROLL ;;;                         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;                         ;;
  mov eax, [rsi]      ;;;                         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;                         ;;
                                                  ;;
  xor rcx,rcx                                     ;;
  xor rdx,rdx                                     ;;
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
  intToStringfindStart:                           ;;
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;takes int in memory and stores a string          ;;
;returns memory address                           ;;
; src in rsi                                      ;;
; base in rbx                                     ;;
; dest in rdi                                     ;;
iIntToString:                                     ;;
  push rax                                        ;;
  push rcx                                        ;;
  ;;zero output(128 bytes)                        ;;
  mov rax, 66                                     ;;
  call zeroMem                                    ;;  
;;;;;;;;;;;;;;;;;;;;;;;;;                         ;;
;;; INT SIZE CONTROLL ;;;                         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;                         ;;
  mov eax, [rsi]      ;;;                         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;                         ;;
                                                  ;;
  cmp eax, -2147483648                            ;;
  jnb iIntToStringNegative                        ;;
  jmp iIntToStringContinue                        ;;
  iIntToStringNegative:                           ;;
    mov byte [rdi], 45                            ;;
    inc rdi                                       ;;
    dec eax                                       ;;
    not eax                                       ;;
    jmp iIntToStringContinue                      ;;
                                                  ;;
  iIntToStringContinue:                           ;;
  xor rcx,rcx                                     ;;
  xor rdx,rdx                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;          ;;
  iIntToStringLoop:                               ;;
    div rbx                                       ;;
    add dl, 48                                    ;;
    mov byte [rdi+rcx], dl                        ;;
    inc rcx                                       ;;
    xor rdx,rdx                                   ;;
                                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;          ;;
    cmp al, 0                                     ;;
    ja iIntToStringLoop                           ;;
;;;;;;;;;;;;;;;;;;;;                              ;;
;; reverse string ;;                              ;;
;;;;;;;;;;;;;;;;;;;;                              ;;
                                                  ;;
  iIntToStringfindStart:                          ;;
    cmp rcx, 0                                    ;;
    je iIntToStringIsZero                         ;;
    cmp byte [rdi+rcx],48                         ;;
    jne iIntToStringSwitchArea                    ;;
    dec rcx                                       ;;
    jmp iIntToStringfindStart                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;          ;;
iIntToStringSwitchArea:                           ;;
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
iIntToStringIsZero:                               ;;
  mov byte [rdi+1], 0                             ;;
  jmp iIntToStringEnd                             ;;
                                                  ;;
iIntToStringEnd:                                  ;;
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