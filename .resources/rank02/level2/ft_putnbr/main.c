#include <unistd.h>

void	ft_putnbr(int nb);

int	main(void)
{
	int	a[] = {0, 42, -42, 2147483647, -2147483648, 100, -1};
	int	i;

	i = 0;
	while (i < 7)
	{
		ft_putnbr(a[i++]);
		write(1, "\n", 1);
	}
	return (0);
}
