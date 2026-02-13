; ssize_t ft_read(int fd, void *buf, size_t count)
;	fd			->	rdi
;	*buf		->	rsi
;	count		->	rdx
;	return val	->	rax

global ft_read
extern __errno_location

section .text
ft_read:
	mov rax, 0				; syscall number for read
							; rdi already has fd (1st param)
							; rsi already has buf (2nd param)
							; rdx already has count (3rd param)
	syscall
	cmp rax, 0
	jl .error
	ret

.error:
	mov rdx, rax			; save kernel error code (negative) in rdx
	neg rdx					; negate it → make it positive
	call __errno_location wrt ..plt	; get pointer to errno
	mov [rax], rdx			; store error code into errno
	mov rax, -1				; rax = -1 → return value for C
	ret
