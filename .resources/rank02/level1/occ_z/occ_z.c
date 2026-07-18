#include <unistd.h>

void	putnbr(int n)
{
	char	c;

	if (n >= 10)
		putnbr(n / 10);
	c = n % 10 + 48;
	write(1, &c, 1);
}

int	main(int ac, char **av)
{
	int	i;
	int	count;

	i = 0;
	count = 0;
	if (ac != 2)
		return (write(1, "\n", 1), 0);
	while (av[1][i])
	{
		if (av[1][i] == 'z')
			count++;
		i++;
	}
	putnbr(count);
	write(1, "\n", 1);
	return (0);
}
