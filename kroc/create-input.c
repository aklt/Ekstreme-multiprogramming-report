/*  This program is for generating output for testing the occam and plain code adders.
 *
 *  It takes the number of bits as an argument and will produce one column of
 *  biary number or two columns if given a second argument.
 */

#include <stdio.h>
#include <stdlib.h>

void print_binary(int num, char *str, int len) {
	int i;
		for (i=0; i<len; i++)
			if (num & (1<<i))
				str[len - i - 1] = '1';
			else
				str[len - i - 1] = '0';
		printf("%s", str);
}

int main(int argc, char** argv) {

	int i, j, bits;
	char buf[128];

    if (!(argc >= 2)) {
		printf("Arguments : <bitsize> [two columns]\n");
		exit(1);
	}

	bits = strtol(argv[1], NULL, 10);

	buf[bits] = '\0';

	for (i=0; i< (1<<bits); i++) 
		for (j=0; j<(1<<bits); j++) {
			print_binary(i, buf, bits);
			printf(" ");
			if (argc>2)
				print_binary(j, buf, bits);
			else
				j = (1<<bits);
			printf("\n");
		}
	return 0;
}
/* $Id$ */
