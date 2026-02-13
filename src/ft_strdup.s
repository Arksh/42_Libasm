; char *ft_strdup(const char *s);
;	*s			->	rdi
;	return val	->	rax

global ft_strdup
extern ft_strlen
extern ft_strcpy
extern malloc
extern __errno_location

section .text
ft_strdup:
	; rdi = original string
	push rdi				; save original string pointer
	; Step 1: get length
	call ft_strlen

	; Step 2: malloc(len + 1)
	inc rax
	mov rdi, rax
	call malloc wrt ..plt
	cmp rax, 0
	je .error

	; Step 3: copy string
	pop rsi					; restore original string to rsi (src)
	mov rdi, rax			; malloc'd pointer to rdi (dst)
	push rdi				; save malloc'd pointer
	call ft_strcpy

	; Step 4: return pointer
	pop rax					; return malloc'd pointer
	ret

.error:
	pop rdi					; clean stack
	call __errno_location wrt ..plt	; rax = errno location
	mov dword [rax], 12		; *rax = 12 (ENOMEM = 12)
	xor rax, rax			; rax = 0
	ret						; return rax (NULL)
