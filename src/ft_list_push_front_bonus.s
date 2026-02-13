; void ft_list_push_front(t_list **begin_list, void *data)
;	**begin_lst	->	rdi
;	*data		->	rsi
;	return val	->	rax

;	typedef struct s_list {
;		void			*data;
;		struct s_list	*next;
;	}	t_list;

;	sizeof(void*)	= 8
;	sizeof(t_list*)	= 8
;	sizeof(t_list)	= 16

global ft_list_push_front
extern malloc

%define LIST_DATA 0
%define LIST_NEXT 8
%define LIST_SIZE 16

section .text
ft_list_push_front:
	push rdi
	push rsi
	mov rdi, LIST_SIZE
	call malloc wrt ..plt
	pop rsi
	pop rdi
	
	test rax, rax
	jz .end

	mov [rax + LIST_DATA], rsi
	mov rcx, [rdi]
	mov [rax + LIST_NEXT], rcx
	mov [rdi], rax

.end:
	ret
