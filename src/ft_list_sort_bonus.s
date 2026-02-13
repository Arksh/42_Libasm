; void ft_list_sort(t_list **begin_list, int (*cmp)());
;	*begin_lst		->	rdi
;	int (*cmp)()	->	rsi

;	typedef struct s_list {
;		void			*data;
;		struct s_list	*next;
;	}	t_list;

;	sizeof(void*)	= 8
;	sizeof(t_list*)	= 8
;	sizeof(t_list)	= 16

; (*cmp)(list_ptr->data, list_other_ptr->data);
;	list_ptr->data			-> rdi
;	list_other_ptr->data	-> rsi
;	return val				-> rax

; rdi      pointer to current node (`t_list *`)       
; rsi      function pointer `cmp`                     
; rax      temporary (data pointer / cmp return value)
; rdx      temporary for swapping (or use stack)      
; rcx      swapped flag (0/1)                         


global ft_list_sort

section .text
ft_list_sort:
	test rdi, rdi
	jz .error
	mov rax, [rdi]
	test rax, rax
	jz .error
	move rax, [rax + LIST_NEXT]
	test rax, rax
	jz .error
	
	mov rcx, 1

.error:
	ret