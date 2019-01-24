.intel_syntax noprefix

.section	.data


.section	.rodata
FORMAT:
		.asciz	"0x%llx\n"

n1:		.long	0
n2:		.long 	1

.section	.text
.type	fibonacci, @function
fibonacci:
	call atoi	# Takes argv[1] and sends it to atoi
	mov r9, rax	# Saves return of atoi to rsi to prep for printf
	cmp rax, 0
	je .no_count
	mov	r10, n1
	mov r11, n2
.start_loop:
	xadd r11, r10
	dec rax
	cmp rax, 0
	jne .start_loop
	jmp .end

	
.no_count:
	mov rsi, 0
	ret

.end:
	mov rsi, r11
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
	mov rdi, [rsi]
	call fibonacci
	mov rdi, OFFSET FORMAT	# Preps format string
	mov rax, 0	# Needed for printf
	call printf

	mov rbx, [rbp-0x18]
	add rsp, 0x30
	pop rbp

	ret
