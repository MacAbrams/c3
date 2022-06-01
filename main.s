section .data
	x dq 354234
	y dq 1
	n db 10
  c db 10,0
  s db "how is this being printed",0

section .text
global _start

_start:
  mov rax, [x]
  mov r8, 10
  mov rcx, 0
  loop:
    xor rdx, rdx
    div r8
    push rax
    add rdx, 48
    mov byte [c], dl
    mov rsi, c
    call print
    pop rax
    cmp rax, 0
    jne loop
    


    


  
  jmp ending


print:
	mov rax, 1
	mov rdi, 1
	mov rdx, 1
	syscall
  add rsi, 1
  cmp byte [rsi], 0
	jne print
  ret
println:
	mov rax, 1
	mov rdi, 1
	mov rdx, 1
	syscall
  add rsi, 1
  cmp byte [rsi], 0
	jne println
  mov rsi, n
  syscall
  ret
iterate:
  push rax 
  mov rax, [x]
  add rax, [y]
  mov r8, [y]
  mov qword [x], r8
  mov qword [y], rax
  pop rax
  ret

ending:
  pop r10
	xor rdi, rdi
	mov rax, 60
	syscall