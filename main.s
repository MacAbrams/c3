section .data
	x dq 354234000
	y dq 1
	n db 10
  c db 10,0
  s db "how is this being printed",0

section .text
global _start

_start:
  mov r8, 1


  loop:
    mov rax, [x]
    xor rdx, rdx
    div r8
    push rax
    push r8
    call mod

    pop r8
    mov rax, r8
    mov r8, 10
    mul r8
    mov r8, rax
    pop rax
    push r8
    mov r8, 10
    div r8
    pop r8
    cmp rax, 0
    jne loop
    


    


  
  jmp ending


mod:
  xor rdx, rdx
  mov r9, rax
  mov r8, 0xa
  div r8
  add rdx, 48
  mov byte [c], dl
  mov rax, 1
	mov rdi, 1
	mov rdx, 1
  mov rsi, c
  syscall
  ret


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