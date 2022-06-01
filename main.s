section .data
	x dq 355564
	y dq 1
	n db 10
  c db 10,0
  s db "how is this being printed",0

section .text
global _start

_start:
  mov rsi, x
  call printn

    


  
  jmp ending


printn:
  mov rax, [rsi]
  mov r8, 10
  mov r9, 1
  find:
    inc r9
    xor rdx, rdx
    div r8
    cmp rax, 10
    ja find
  mov rax, [rsi]
  mov rcx, r9
  loop:
    xor rdx, rdx
    div r8
    push rax
    add rdx, 48
    dec rcx
    mov byte [c+rcx], dl
    pop rax
    cmp rax, 0
    jne loop
    mov byte [c+r9], 0
    mov rsi, c
    call print
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