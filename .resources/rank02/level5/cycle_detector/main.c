#include <stdlib.h>
#include <stdio.h>
#include "list.h"

int	cycle_detector(const t_list *list);

static t_list	*node(int d, t_list *next)
{
	t_list	*n;

	n = malloc(sizeof(t_list));
	n->data = d;
	n->next = next;
	return (n);
}

int	main(void)
{
	t_list	*c = node(3, NULL);
	t_list	*b = node(2, c);
	t_list	*a = node(1, b);
	t_list	*z = node(30, NULL);
	t_list	*y = node(20, z);
	t_list	*x = node(10, y);

	printf("%d\n", cycle_detector(a));
	printf("%d\n", cycle_detector(NULL));
	printf("%d\n", cycle_detector(c));
	z->next = x;
	printf("%d\n", cycle_detector(x));
	return (0);
}
