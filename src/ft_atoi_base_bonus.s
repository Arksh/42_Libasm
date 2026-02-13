; int ft_atoi_base(char *str, char *base);
;	*str		->	rdi
;	*base		->	rsi
;	return val	-.	rax


%macro check_forbidden 1
	cmp byte [%1], '+'					; if *base == '+'
	je .error							; goto error
	cmp byte [%1], '-'					; if *base == '-'
	je .error							; goto error
	cmp byte [%1], 9					; if *base == '\t'
	je .error							; goto error
	cmp byte [%1], 10					; if *base == '\n'
	je .error							; goto error
	cmp byte [%1], 11					; if *base == '\v'
	je .error							; goto error
	cmp byte [%1], 12					; if *base == '\f'
	je .error							; goto error
	cmp byte [%1], 13					; if *base == '\r'
	je .error							; goto error
	cmp byte [%1], ' '					; if *base == ' '
	je .error							; goto error
%endmacro

%macro check_ws 1
	cmp byte [%1], 9					; if *str == '\t'
	je .next_space						; goto inc_str
	cmp byte [%1], 10					; if *str == '\n'
	je .next_space						; goto inc_str
	cmp byte [%1], 11					; if *str == '\v'
	je .next_space						; goto inc_str
	cmp byte [%1], 12					; if *str == '\f'
	je .next_space						; goto inc_str
	cmp byte [%1], 13					; if *str == '\r'
	je .next_space						; goto inc_str
	cmp byte [%1], ' '					; if *str == ' '
	je .next_space						; goto inc_str
%endmacro


global ft_atoi_base

section .text
ft_atoi_base:
	xor rax, rax
	; Analising base string

.count_base_len:
	cmp byte [rsi+rax], 0
	je .base_len_done
	lea rdx, [rsi+rax]
	check_forbidden rdx
	inc rax
	jmp .count_base_len

.base_len_done:
	cmp rax, 2
	jl .error

	mov rbx, rax		; save base_len in rbx
	xor rcx, rcx

.check_dup_outer:
	lea rax, [rbx - 1]
	cmp rcx, rax
	jge .base_valid
	
	mov rdx, rcx
	inc rdx

.check_dup_inner:
	cmp rdx, rbx
	jge .next_char_dup
	push rdi				; save rdi
	mov al, byte [rsi + rcx]
	mov dil, byte [rsi + rdx]
	cmp al, dil
	pop rdi					; restore rdi
	je .error
	inc rdx
	jmp .check_dup_inner

.next_char_dup:
	inc rcx
	jmp .check_dup_outer

	; Analising number string
.base_valid:
	mov rax, rbx		; restore base_len to rax for later use
	mov rbx, 1 			; rbx = sign (positive)

.skip_spaces:
    check_ws rdi
    jmp .spaces_done

.next_space:
    inc rdi
    jmp .skip_spaces

.spaces_done:
	cmp byte [rdi], '+'
	je .skip_plus
	cmp byte [rdi], '-'
	je .skip_minus
	jmp .start_convert

.skip_plus:
	inc rdi
	jmp .start_convert

.skip_minus:
	neg rbx				; rbx = -1 (negative)
	inc rdi

.start_convert:
	push rbx			; save sign on stack
	xor rbx, rbx		; rbx = result

.convert_loop:
	movzx rcx, byte [rdi]	; load current char
	test rcx, rcx			; check if null terminator
	jz .apply_sign

	xor rdx, rdx			; rdx = index in base

.find_in_base:
	cmp rdx, rax			; if index >= base_len
	jge .apply_sign			; char not in base, stop conversion

	cmp cl, byte [rsi + rdx]	; compare characters
	je .found_digit

	inc rdx
	jmp .find_in_base

.found_digit:
	imul rbx, rax			; result *= base_len
	add rbx, rdx			; result += index (digit value)
	inc rdi					; move to next char
	jmp .convert_loop
	
.apply_sign:
	pop rax					; get sign from stack
	imul rbx, rax			; apply sign
	mov rax, rbx
	ret

.error:
	xor rax, rax
	ret