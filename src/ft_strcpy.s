; char *ft_strcpy(char *dst, const *char src)
;	*dst		->	rdi
;	*src		->	rsi
;	return val	->	rax

global ft_strcpy

section .text
ft_strcpy:
	mov rax, rdi			; Save destination pointer to return it

.loop:
	mov bl, byte [rsi]		; Load byte from source
	mov byte [rdi], bl		; Copy byte to destination
	cmp bl, 0				; Check if it's null terminator
	je .done				; If null, we're done
	inc rsi					; Move to next source byte
	inc rdi					; Move to next destination byte
	jmp .loop				; Continue loop

.done:
	ret