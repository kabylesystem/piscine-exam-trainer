#include <stdlib.h>

char	*ft_itoa_base(int value, int base)
{
	char			*digits = "0123456789ABCDEF";
	char			buf[64];
	int				i;
	int				j;
	int				neg;
	unsigned int	v;
	char			*res;

	if (base < 2 || base > 16)
		return (0);
	i = 0;
	neg = 0;
	if (base == 10 && value < 0)
	{
		neg = 1;
		v = (unsigned int)(-(long)value);
	}
	else
		v = (unsigned int)value;
	if (v == 0)
		buf[i++] = '0';
	while (v)
	{
		buf[i++] = digits[v % (unsigned int)base];
		v /= (unsigned int)base;
	}
	if (neg)
		buf[i++] = '-';
	res = malloc(i + 1);
	if (!res)
		return (0);
	j = 0;
	while (i > 0)
		res[j++] = buf[--i];
	res[j] = '\0';
	return (res);
}
