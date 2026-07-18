#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>

static int	err(void)
{
	write(1, "Error\n", 6);
	return (0);
}

int	main(int ac, char **av)
{
	long	stack[100000];
	int		top;
	char	*s;
	int		i;
	long	a;
	long	b;
	char	op;

	if (ac != 2)
		return (err());
	top = 0;
	s = av[1];
	i = 0;
	while (s[i])
	{
		while (s[i] == ' ')
			i++;
		if (!s[i])
			break ;
		if ((s[i] == '+' || s[i] == '-' || s[i] == '*' || s[i] == '/'
				|| s[i] == '%') && (s[i + 1] == ' ' || s[i + 1] == '\0'))
		{
			op = s[i];
			if (top < 2)
				return (err());
			b = stack[--top];
			a = stack[--top];
			if ((op == '/' || op == '%') && b == 0)
				return (err());
			if (op == '+')
				stack[top++] = a + b;
			else if (op == '-')
				stack[top++] = a - b;
			else if (op == '*')
				stack[top++] = a * b;
			else if (op == '/')
				stack[top++] = a / b;
			else
				stack[top++] = a % b;
			i++;
		}
		else if (s[i] == '-' || (s[i] >= '0' && s[i] <= '9'))
		{
			stack[top++] = atoi(s + i);
			if (s[i] == '-')
				i++;
			while (s[i] >= '0' && s[i] <= '9')
				i++;
		}
		else
			return (err());
	}
	if (top != 1)
		return (err());
	printf("%ld\n", stack[0]);
	return (0);
}
