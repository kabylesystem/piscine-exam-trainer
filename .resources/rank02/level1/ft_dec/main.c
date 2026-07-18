#include <stdio.h>

void	ft_dec(int *nbr);

int	main(void)
{
	int	v[] = {5, 0, -3, 100};
	int	i = 0;

	while (i < 4)
	{
		ft_dec(&v[i]);
		printf("%d\n", v[i]);
		i++;
	}
	return (0);
}
