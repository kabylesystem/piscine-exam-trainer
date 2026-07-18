#include <stdio.h>

int	ft_add(int a, int b);

int	main(void)
{
	int	p[][2] = {{3,4},{-5,2},{0,0},{100,-7},{-8,-8}};
	int	i = 0;

	while (i < 5)
	{
		printf("%d\n", ft_add(p[i][0], p[i][1]));
		i++;
	}
	return (0);
}
