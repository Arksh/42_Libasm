; int ft_list_size(t_list *begin_list)
;	*begin_lst	->	rdi
;	return val	->	rax

;	typedef struct s_list {
;		void			*data;
;		struct s_list	*next;
;	}	t_list;

;	sizeof(void*)	= 8
;	sizeof(t_list*)	= 8
;	sizeof(t_list)	= 16

global ft_list_size

%define LIST_DATA 0
%define LIST_NEXT 8
%define LIST_SIZE 16

section .text
ft_list_size:
	xor rax, rax

.loop:
	test rdi, rdi	; Check if current node is NULL (sets ZF if rdi == 0)
	jz .done		; Checks if ZF == 1

	mov rdi, [rdi + LIST_NEXT]
	inc rax
	jmp .loop

.done:
	ret