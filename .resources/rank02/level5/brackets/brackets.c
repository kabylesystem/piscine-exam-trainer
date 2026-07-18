#include <unistd.h>

static int	is_balanced(char *s)
{
	char	stack[100000];
	int		top;
	int		i;

	top = 0;
	i = 0;
	while (s[i])
	{
		if (s[i] == '(' || s[i] == '[' || s[i] == '{')
			stack[top++] = s[i];
		else if (s[i] == ')' || s[i] == ']' || s[i] == '}')
		{
			if (top == 0)
				return (0);
			top--;
			if ((s[i] == ')' && stack[top] != '(')
				|| (s[i] == ']' && stack[top] != '[')
				|| (s[i] == '}' && stack[top] != '{'))
				return (0);
		}
		i++;
	}
	return (top == 0);
}

int	main(int ac, char **av)
{
	int	i;

	if (ac < 2)
		return (write(1, "\n", 1), 0);
	i = 1;
	while (i < ac)
	{
		if (is_balanced(av[i]))
			write(1, "OK\n", 3);
		else
			write(1, "Error\n", 6);
		i++;
	}
	return (0);
}
