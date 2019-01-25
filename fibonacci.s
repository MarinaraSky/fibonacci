.intel_syntax noprefix

.section	.rodata
NUM1:
		.asciz	"NUM1: 0x%llu\n"
NUM2:
		.asciz	"NUM2: 0x%llu\n"

.data
n1: .space 64, 0
	#.d 	0
n2:	.space 64, 0	
	#.quad	0

.section	.text
.type	fibonacci, @function
fibonacci:
	call atoi	# Takes argv[1] and sends it to atoi
	cmp rax, 0 	# Checks if 0 was on command line
	je .no_count
.start_loop:
	# xadd rdx, rbx
	mov rdx, n2
	cmp rdx, n1 
	ja	.n2_first
	mov rbx, [n1]
	add [n2], rbx
	#mov rbx, [n1+4]
	#adc [n2+4], rbx
	mov rbx, [n2]
	cmp [n1], rbx
	mov rsi, [n1]
	clc
	#mov r10, [n1+4]
	jl .reloop
	mov rbx, [n2]
	mov [n1], rbx
	#mov rbx, [n2+4]
	#mov [n1+4], rbx
	jmp .reloop

.n2_first:
	mov rbx, [n2]
	add [n1], rbx
	#mov rbx, [n2+4]
	#adc [n1+4], rbx
	mov rbx, [n1]
	cmp [n2], rbx
	mov rsi, [n2]
	#mov r10, [n2+4]
	clc
	jl .reloop
	mov rbx, [n1]
	mov [n2], rbx
	#mov rbx, [n1+4]
	#mov [n2+4], rbx
	jmp .reloop

.reloop:
	dec rax
	cmp rax, 0
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
	mov [n1], rdi
	mov rdi, [rsi]
	call fibonacci
	mov rsi, [n1]
	mov rdi, OFFSET NUM1	# Preps format string
	mov rax, 0	# Needed for printf
	call printf
	#mov rsi, [n1+8]
	#mov rdi, OFFSET NUM1	# Preps format string
	#mov rax, 0	# Needed for printf
	#call printf
	mov rsi, [n2]
	mov rdi, OFFSET NUM2	# Preps format string
	mov rax, 0	# Needed for printf
	call printf
	#mov rsi, [n2+8]
	#mov rdi, OFFSET NUM2	# Preps format string
	#mov rax, 0	# Needed for printf
	#call printf


	mov rbx, [rbp-0x18]
	add rsp, 0x30
	pop rbp

	ret
