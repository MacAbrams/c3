section .data
  s db "Hello, I'm Mac",10,0
  input dd 5; 01111101
  ;output db "00000000000000000000000000"
  switchTest db "01234567",10,0
  n db 10,0
  t db 9,0
  minus db 45,0

;;;;;;;;;;;;;;;;
;;  XORSHIFT  ;;
;;;;;;;;;;;;;;;;
  state dd 2  ;;
;;;;;;;;;;;;;;;;

section .bss
  c resb 256
  output resb 66

section .text
global _start
_start:

  mov rcx,-10
  loop:
    ;call xorShift

    mov dword [input], ecx
    lea rsi, input
    lea rdi, output
    mov rbx, 10
    call floatToString 
    lea rsi, output
    call printS

    lea rsi, t
    call printS

    mov rax, rcx
    call printF

    lea rsi, n
    call printS



    inc rcx
    cmp rcx, 10
    je ending
    jmp loop






jmp ending

; float 32 bit 
;   0|00000000|00000000000000000000000
;takes rax value
printF:
  push rdx
  mov rdx, rax
  shr rdx, 31
  cmp rdx, 1
  ja negative
    mov rdx, rax
    shl rdx, 9
    shr rdx, 9
    mov dword [input], edx
    push rsi
    push rbx
    push rdi
    lea rsi, input
    lea rdi, output
    mov rbx, 10
    call intToString
    lea rsi, output
    call printS
    pop rsi
    pop rbx
    pop rdi
  contNeg:

  

  jmp end
negative:
  mov rdx, rax
  shl rdx, 9
  shr rdx, 9
    mov dword [input], edx
    push rsi
    push rbx
    push rdi
    lea rsi, input
    lea rdi, output
    mov rbx, 10
    call iIntToString
    lea rsi, output
    call printS
    pop rsi
    pop rbx
    pop rdi
  

  jmp contNeg
end:
pop rdx
ret
  


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;takes int in memory and stores a string          ;;
;returns memory address                           ;;
; src in rsi                                      ;;
; base in rbx                                     ;;
; dest in rdi                                     ;;
floatToString:                                     ;;
  push rax                                        ;;
  push rcx    
  push r10
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
  jnb floatToStringNegative                        ;;
  jmp floatToStringContinue                        ;;
  floatToStringNegative:                           ;;
    mov byte [rdi], 45                            ;;
    inc rdi                                       ;;
    dec eax                                       ;;
    not eax                                       ;;
    jmp floatToStringContinue                      ;;
                                                  ;;
  floatToStringContinue:                           ;;
 ; mov r9d, eax;
  xor rcx,rcx                                     ;;
  xor rdx,rdx                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;          ;;
  floatToStringLoop:                               ;;
    div rbx                                       ;;
    add dl, 48                                    ;;
    mov byte [rdi+rcx], dl                        ;;
    inc rcx                                       ;;
    xor rdx,rdx                                   ;;
                                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;          ;;
    cmp al, 0                                     ;;
    ja floatToStringLoop                           ;;
;;;;;;;;;;;;;;;;;;;;                              ;;
;; reverse string ;;                              ;;
;;;;;;;;;;;;;;;;;;;;                              ;;
      pop r10                                            ;;
  floatToStringfindStart:                          ;;
    cmp rcx, 0                                    ;;
    je iIntToStringIsZero                         ;;
    cmp byte [rdi+rcx],48                         ;;
    jne floatToStringSwitchArea                    ;;
    dec rcx                                       ;;
    jmp floatToStringfindStart                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;          ;;
floatToStringSwitchArea:  
;;
  ;set null after rcx+1                           ;;
  inc rcx                                         ;;
  mov byte [rdi+rcx], 0                           ;;
  dec rcx                                         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;          ;;
  mov rax, rdi                                    ;;
  add rdi, rcx                                    ;;
  call switch                                     ;;
                                                  ;;
  jmp floatToStringEnd                              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;          ;;
floatToStringIsZero:                               ;;
  mov byte [rdi+1], 0                             ;;
  jmp floatToStringEnd                             ;;
                                                  ;;
floatToStringEnd:   
                                            ;;
  pop rcx                                         ;;
  pop rax                                         ;;
ret                                               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;










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