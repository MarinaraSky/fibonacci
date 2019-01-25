.intel_syntax noprefix

.section	.rodata
first:
		.asciz	"0x%.lx%.lx%.lx%.lx\n"
second:
		.asciz	"0x%.lx%.lx%.lx%lx\n"
third:
		.asciz	"0x%.lx%.lx%lx%016lx\n"
fourth:
		.asciz	"0x%.lx%lx%016lx%016lx\n"
fifth:
		.asciz	"0x%lx%016lx%016lx%016lx\n"

.data
index:		.quad 0

.section	.text
.type	fibonacci, @function
fibonacci:
	call atoi	# Takes argv[1] and sends it to atoi
	mov rcx, rax
	cmp rcx, 0 	# Checks if 0 was on command line
	je .2
	mov rdx, 0
	mov rax, 1
	xor r8, r8
	xor r9, r9
	xor r10, r10
	xor r11, r11
	xor r12, r12
	xor r15, r15
.start_loop:
	clc
	xadd rax, rdx
	adc r8, 0
	xadd r15, r8
	adc	r9, 0	
	xadd r10, r9
	adc	r11, 0	
	xadd r12, r11

.reloop:
	dec rcx
	cmp rcx, 0
	jne .start_loop
	jmp .end

	
.no_count:
	ret

.end:
	mov rsi, r11
	mov rcx, r8
	mov rax, rdx
	mov rdx, r9
	mov r8, rax
	cmp r8, 0
	je .1
	cmp rcx, 0
	je .2
	cmp rdx, 0
	je .3
	cmp rsi, 0
	je .4
	jmp .5
.1:
	mov rdi, OFFSET first # Preps format string
	jmp .print
.2:
	mov rdi, OFFSET second	# Preps format string
	jmp .print
.3:
	mov rdi, OFFSET third	# Preps format string
	jmp .print
.4:
	mov rdi, OFFSET fourth	# Preps format string
	jmp .print
.5:
	mov rdi, OFFSET fifth


.print:
	mov rax, 0	# Needed for printf
	call printf
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
	mov rdi, [rsi]
	call fibonacci

	mov rbx, [rbp-0x18]
	add rsp, 0x30
	pop rbp

	ret
