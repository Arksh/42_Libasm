; int *ft_strcmp(const char *s1, const *char s2)
;	*s1			->	rdi
;	*s2			->	rsi
;	return val	->	rax

global ft_strcmp

section .text
ft_strcmp:
	xor rax, rax        	; Clear rax (will be used for return value)

.loop:
	mov al, byte [rdi]		; Load byte from first string (s1)
	mov bl, byte [rsi]		; Load byte from second string (s2)
	cmp al, bl				; Compare them
	jne .done				; If different, we're done
	cmp al, 0				; Check if we reached null terminator
	je .done				; If null, strings are equal
	inc rdi					; Move to next char in s1
	inc rsi					; Move to next char in s2
	jmp .loop				; Continue loop

.done:
	movzx eax, al			; Zero-extend s1 byte to 32-bit
	movzx ebx, bl			; Zero-extend s2 byte to 32-bit
	sub eax, ebx			; Return s1 - s2
	ret