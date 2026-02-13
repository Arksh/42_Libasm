; ssize_t ft_write(int fd, const void *buf, size_t count)
;	fd			->	rdi
;	*buf		->	rsi
;	count		->	rdx
;	return val	->	rax

global ft_write
extern __errno_location

section .text
ft_write:
	mov rax, 1				; syscall number for write
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
