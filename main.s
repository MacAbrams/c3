section .data
	x dq 0
	y dq 1
	n db 10
  s db "how is this being printed",0
section .bss
  c resb 20
section .text
global _start

_start:
  mov rcx, 200
  loop:
  push rcx
  mov rsi, x
  call printn
  call iterate
  pop rcx
  dec rcx
  cmp rcx, 0
  ja loop



    


  
  jmp ending


printn:
  mov rax, [rsi]
  mov r8, 10
  mov r9, 1
  cmp rax, 10
  jb skip
  find:
    inc r9
    xor rdx, rdx
    div r8
    cmp rax, 10
    ja find
  skip:
  mov rax, [rsi]
  mov rcx, r9
  loopthroughdigits:
    xor rdx, rdx
    div r8
    push rax
    add rdx, 48
    dec rcx
    mov byte [c+rcx], dl
    pop rax
    cmp rax, 0
    jne loopthroughdigits
    mov byte [c+r9], 0
    mov rsi, c
    call println
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
  push r8
  mov rax, [x]
  add rax, [y]
  mov r8, [y]
  mov qword [x], r8
  mov qword [y], rax
  pop rax
  pop r8
  ret

ending:
  pop r10
	xor rdi, rdi
	mov rax, 60
	syscall