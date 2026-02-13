#include <stdio.h>
#include "libasm.h"

void print_list(t_list *list)
{
	int i = 0;
	while (list)
	{
		printf("  [%d] %s\n", i++, (char *)list->data);
		list = list->next;
	}
}

int ft_list_size_c(t_list *begin_list)
{
    int count = 0;

    while (begin_list)
    {
        count++;
        begin_list = begin_list->next;
    }

    return count;
}

void *ft_list_push_front_c(t_list **begin_list, void *data)
{
	t_list *new_node = malloc(sizeof(t_list));
	if (!new_node)
		return NULL;

	new_node->data = data;
	new_node->next = *begin_list;   // link old head
	*begin_list = new_node;         // update head
	return new_node;
}

void ft_list_sort_c(t_list **begin_list, int (*cmp)(void *, void *))
{
    t_list *i;
    t_list *j;
    void *tmp;

    if (!begin_list || !*begin_list)
        return;

    i = *begin_list;
    while (i) {
        j = i->next;
        while (j) {
            if (cmp(i->data, j->data) > 0) {
                tmp = i->data;
                i->data = j->data;
                j->data = tmp;
            }
            j = j->next;
        }
        i = i->next;
    }
}


void test_ft_atoi_base()
{
	printf("\n=== ft_atoi_base tests ===\n\n");

	int result;
	// Binary
	result = ft_atoi_base("101010", "01");
	printf("Binary \"101010\" = %d (expected 42)\n", result);

	// Hexadecimal
	result = ft_atoi_base("2A", "0123456789ABCDEF");
	printf("Hex \"2A\" = %d (expected 42)\n", result);

	// Octal
	result = ft_atoi_base("52", "01234567");
	printf("Octal \"52\" = %d (expected 42)\n", result);

	// Decimal
	result = ft_atoi_base("42", "0123456789");
	printf("Decimal \"42\" = %d (expected 42)\n", result);

	// With spaces and sign
	result = ft_atoi_base("  +42", "0123456789");
	printf("\"  +42\" = %d (expected 42)\n", result);

	// Negative
	result = ft_atoi_base("  -2A", "0123456789ABCDEF");
	printf("Negative hex \"  -2A\" = %d (expected -42)\n", result);

	// Custom base
	result = ft_atoi_base("101", "01234");
	printf("Custom base \"101\" in \"01234\" = %d (expected 26)\n\n", result);

	printf("=== Invalid base tests (should return 0) ===\n\n");

	result = ft_atoi_base("42", "");
	printf("Empty base: %d (expected 0)\n", result);

	result = ft_atoi_base("42", "0");
	printf("Base length 1: %d (expected 0)\n", result);

	result = ft_atoi_base("42", "0123456789+");
	printf("Base with '+': %d (expected 0)\n", result);

	result = ft_atoi_base("42", "0123456789A0");
	printf("Base with duplicate: %d (expected 0)\n\n", result);
}

void test_ft_list_size()
{
	printf("\n=== ft_list_size tests ===\n\n");

	int result_asm, result_c;

	// Test with NULL list
	result_asm = ft_list_size(NULL);
	result_c = ft_list_size_c(NULL);
	printf("NULL list: ASM=%d, C=%d\n", result_asm, result_c);

	// Test with single element
	t_list node1 = {.data = "Node 1", .next = NULL};
	result_asm = ft_list_size(&node1);
	result_c = ft_list_size_c(&node1);
	printf("Single element: ASM=%d, C=%d\n", result_asm, result_c);

	// Test with multiple elements
	t_list node3 = {.data = "Node 3", .next = NULL};
	t_list node2 = {.data = "Node 2", .next = &node3};
	node1.next = &node2;
	result_asm = ft_list_size(&node1);
	result_c = ft_list_size_c(&node1);
	printf("Three elements: ASM=%d, C=%d\n", result_asm, result_c);

	// Test with five elements
	t_list node5 = {.data = "Node 5", .next = NULL};
	t_list node4 = {.data = "Node 4", .next = &node5};
	node3.next = &node4;
	result_asm = ft_list_size(&node1);
	result_c = ft_list_size_c(&node1);
	printf("Five elements: ASM=%d, C=%d\n\n", result_asm, result_c);
}
void test_ft_list_push_front()
{
	printf("\n=== ft_list_push_front tests ===\n\n");
	
	// Test ASM version
	t_list *list_asm = NULL;
	ft_list_push_front(&list_asm, "Third");
	ft_list_push_front(&list_asm, "Second");
	ft_list_push_front(&list_asm, "First");
	printf("ASM version (size=%d):\n", ft_list_size(list_asm));
	print_list(list_asm);

	
	// Test C version
	t_list *list_c = NULL;
	ft_list_push_front_c(&list_c, "Third");
	ft_list_push_front_c(&list_c, "Second");
	ft_list_push_front_c(&list_c, "First");
	printf("\nC version (size=%d):\n", ft_list_size_c(list_c));
	print_list(list_c);
}

int main(void)
{
	test_ft_atoi_base();
	test_ft_list_size();
	test_ft_list_push_front();

	return (0);
}