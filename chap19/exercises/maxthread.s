	.file	"maxthread.c"
	.intel_syntax noprefix
	.text
	.section	.rodata
.LC0:
	.string	"Thread \n"
	.text
	.globl	thread
	.type	thread, @function
thread:
.LFB0:
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	rax, QWORD PTR stderr[rip]
	mov	rcx, rax
	mov	edx, 8
	mov	esi, 1
	lea	rax, .LC0[rip]
	mov	rdi, rax
	call	fwrite@PLT
	nop
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	thread, .-thread
	.globl	main
	.type	main, @function
main:
.LFB1:
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 48
	mov	DWORD PTR -36[rbp], edi
	mov	QWORD PTR -48[rbp], rsi
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR -8[rbp], rax
	xor	eax, eax
	lea	rax, -24[rbp]
	mov	ecx, 0
	lea	rdx, thread[rip]
	mov	esi, 0
	mov	rdi, rax
	call	pthread_create@PLT
	lea	rax, -16[rbp]
	mov	ecx, 0
	lea	rdx, thread[rip]
	mov	esi, 0
	mov	rdi, rax
	call	pthread_create@PLT
	mov	rax, QWORD PTR -24[rbp]
	mov	esi, 0
	mov	rdi, rax
	call	pthread_join@PLT
	mov	rax, QWORD PTR -16[rbp]
	mov	esi, 0
	mov	rdi, rax
	call	pthread_join@PLT
	mov	eax, 0
	mov	rdx, QWORD PTR -8[rbp]
	sub	rdx, QWORD PTR fs:40
	je	.L4
	call	__stack_chk_fail@PLT
.L4:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 13.2.0-23ubuntu4) 13.2.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
