#include <unistd.h>

int	main(int ac, char **av)
{
	char	*s;
	int		n;
	int		c;
	int		l;
	int		r;
	int		len;
	int		bs;
	int		bl;

	if (ac != 2)
		return (write(1, "\n", 1), 0);
	s = av[1];
	n = 0;
	while (s[n])
		n++;
	bs = 0;
	bl = 0;
	c = 0;
	while (c < n)
	{
		l = c;
		r = c;
		while (l >= 0 && r < n && s[l] == s[r])
		{
			l--;
			r++;
		}
		len = r - l - 1;
		if (len >= bl)
		{
			bl = len;
			bs = l + 1;
		}
		l = c;
		r = c + 1;
		while (l >= 0 && r < n && s[l] == s[r])
		{
			l--;
			r++;
		}
		len = r - l - 1;
		if (len >= bl)
		{
			bl = len;
			bs = l + 1;
		}
		c++;
	}
	write(1, s + bs, bl);
	write(1, "\n", 1);
	return (0);
}
