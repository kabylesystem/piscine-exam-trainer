#include <stdio.h>
#include <stdlib.h>

char	*ft_itoa_base(int value, int base);

int	main(void)
{
	int		tv[] = {0, 42, -42, 255, 2147483647, -2147483648, 16};
	int		tb[] = {10, 10, 10, 16, 16, 10, 2};
	int		i;
	char	*s;

	i = 0;
	while (i < 7)
	{
		s = ft_itoa_base(tv[i], tb[i]);
		printf("%s\n", s ? s : "(null)");
		free(s);
		i++;
	}
	return (0);
}
