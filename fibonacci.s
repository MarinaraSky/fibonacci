.intel_syntax noprefix

.section	.rodata
#	Section is used to create printf strings as well as error message
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
errormsg:
		.asciz "Usage: ./fibonacci <0-300>"

.section .data
#	Section used to store the endp of argv
endp:		.quad 0

.section	.text
.type	fibonacci, @function
fibonacci:
	mov rdx, 0	# Setting base for strtol
	mov rsi, OFFSET endp	# Passing in char ** for strtol
	call strtol
	lea rsi, endp	# Getting the char** back into register
	mov rsi, [rsi]	
	mov r15b, [rsi] # Grabbing the first character of endp
	cmp r15b, 0	# Checking that it's null
	jne .error	# Did not reach the end of the string
	mov rcx, rax	# Number of loops
	cmp rcx, 300	# Checking max bounds
	ja .error
	cmp rcx, 0 	# Checks if 0 
	je .zero
	mov rdx, 0	# First Fibonacci number
	mov rax, 1	# Second Fibonacci number
	xor r8, r8
	xor r9, r9
	xor r10, r10
	xor r11, r11
	xor r12, r12
	xor r15, r15
.start_loop:
# Loop to calculate and store fibonacci numbers
	xadd rax, rdx
	adc r8, 0
	xadd r15, r8
	adc	r9, 0	
	xadd r10, r9
	adc	r11, 0	
	xadd r12, r11

.reloop:
	dec rcx	# Rcx is the end condition
	cmp rcx, 0
	jne .start_loop
	jmp .end

.end:
#	Prepping for printf, moving fibonacci number into proper registers
	mov rsi, r11
	mov rcx, r8
	mov rax, rdx
	mov rdx, r9
	mov r8, rax
#	Block of compares for proper printf string to pass
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
	jmp	.print

.zero:
	mov rsi, 0
	mov rdi, OFFSET second	# Preps format string

.print:
	mov rax, 0	# Needed for printf
	call printf
	mov rax, 0	# Successfull fibonacci
	ret

.globl	main
.type	main, @function
main:
	# Initial setup as in instructor example
	push rbp
	mov rbp, rsp
	sub rsp, 0x30
	mov [rsp-8], edi
	mov [rsp-0x10], rsi
	mov [rsp-0x18], rbx

	add rsi, 0x8	# moving pointer to argv[1]
	mov rdi, [rsi]	# Getting the pointer of argv[1]
	cmp rdi, 0	# Making sure argv is pointing to a string
	je .error
	call fibonacci
.exit:
#	Cleaning up my mess and resetting stack and base pointers
	mov rbx, [rbp-0x18]
	add rsp, 0x30
	pop rbp
	ret

.error:
#	Prints error message
	mov rdi, OFFSET errormsg
	call puts
	mov rdi, 1
	call exit
