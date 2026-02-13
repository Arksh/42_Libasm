; size_t ft_strlen(const *char s)
;	*s			->	rdi
;	return val	->	rax

global ft_strlen

section .text
ft_strlen:
	xor rax, rax       	; Clear rax to use it as a counter

.loop:
	cmp byte [rdi], 0	; Substract 0 to byte at rdi, don't store the result and set flags
						; ZF (ZeroFlag) result == 0 | SF (SignFlag) result < 0 | CF (CarryFlag) unsigned overflow
	je .done			; Jump if equal (ZF == 1) to .done
	inc rax				; simple, add 1 ro rax, yet without updating CF
	inc rdi				; increment rdi pointer to next position
	jmp .loop			; Blind jump, set the rip (instruction pointer) to .loop no flag needed or conditions

.done:
	ret					; returns rax value if rsp(stack pointer) has a valid return address