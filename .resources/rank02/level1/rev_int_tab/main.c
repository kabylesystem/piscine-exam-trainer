#include <stdio.h>

void	rev_int_tab(int *tab, int size);

int	main(void)
{
	int	tab[] = {1, 2, 3, 4, 5, 6, 7};
	int	t2[] = {-3, 0, 9, 100};
	int	i;

	rev_int_tab(tab, 7);
	i = 0;
	while (i < 7)
		printf("%d ", tab[i++]);
	printf("\n");
	rev_int_tab(t2, 4);
	i = 0;
	while (i < 4)
		printf("%d ", t2[i++]);
	printf("\n");
	return (0);
}
