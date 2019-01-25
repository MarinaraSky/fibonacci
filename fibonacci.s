.intel_syntax noprefix

.section	.rodata
NUM1:
		.asciz	"NUM1: 0x%lx%lx\n"
NUM2:
		.asciz	"NUM2: 0x%lx\n"

.data
index:		.quad 0

.section	.text
.type	fibonacci, @function
fibonacci:
	call atoi	# Takes argv[1] and sends it to atoi
	mov rcx, rax
	cmp rcx, 0 	# Checks if 0 was on command line
	je .no_count
	mov rdx, 0
	mov rax, 1
	mov r10, 0
	xor r15, r15
	xor r8, r8
.start_loop:
	clc
	xadd rax, rdx
	adc r8, 0
	xadd r15, r8

.reloop:
	dec rcx
	cmp rcx, 0
	jne .start_loop
	jmp .end

	
.no_count:
	ret

.end:
	
	ret

.globl	main
.type	main, @function
main:
	push rbp
	mov rbp, rsp
	sub rsp, 0x30
	mov [rsp-8], edi
	mov [rsp-0x10], rsi
	mov [rsp-0x18], rbx

	add rsi, 0x8
	mov rdi, 1
	#mov [n2], rdi
	mov rdi, [rsi]
	call fibonacci
	mov rsi, r8

	mov rdi, OFFSET NUM1	# Preps format string
	mov rax, 0	# Needed for printf
	call printf

	mov rsi, r8
	mov rdi, OFFSET NUM2	# Preps format string
	mov rax, 0	# Needed for printf
	call printf


	mov rbx, [rbp-0x18]
	add rsp, 0x30
	pop rbp

	ret
