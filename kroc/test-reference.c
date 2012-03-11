/* This program is for showing the correctness of the occam adder by showing
 * that both this implementation and the occam implementation generate the same
 * output when given the same input.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#undef TRUE
#undef FALSE

#define TRUE  1
#define FALSE 0

#define LENGTH 4 /* # of bits */

/*#define SHOW_INPUT 1*/

int not(int x)        { return x==TRUE ? FALSE : TRUE; }
int and(int a, int b) { return (a==TRUE && b==TRUE) ? TRUE : FALSE; }
int or(int a, int b)  { return (a==TRUE || b==TRUE) ? TRUE : FALSE; }
int xor(int a, int b) { return ((a==TRUE && b==FALSE) || (a==FALSE && b==TRUE)) ? TRUE : FALSE; }

typedef struct {
	int sum;
	int carry;
} sum_carry;

sum_carry fulladder(int a, int b, int cin) {
   int x0, x1, a0, a1, o0;
   sum_carry sc;

   x0 = xor(a, b);
   x1 = xor(x0, cin);
   a0 = and(cin, x0);
   a1 = and(a,b);
   o0 = or(a0, a1);

   sc.sum = x1;
   sc.carry = o0;
   return sc;
}

int a3to1multiplexer(int i0, int i1, int i2, int s0, int s1) {
	int a0, a1, a2, a3, a4, a5, o0, o1, nots0, nots1;

	nots0 = not(s0);
	nots1 = not(s1);

	a0 = and(i0, nots0);
	a1 = and(a0, nots1);
	
	a2 = and(i1, s0);
	a3 = and(nots1, a2);

	a4 = and(i2, nots0);
	a5 = and(s1, a4);

	o0 = or(a3, a5);
	o1 = or(a1, o0);

#ifdef SHOW_INPUT
	printf("%d%d%d%d%d ", i0, i1, i2, s0, s1);
#endif
	printf("%d\n", o1);

	return o1;
}


void put_ints(char *c, int *aa, int *ab) {
	int *a=aa, *b=ab;
	while (*c && *c != ' ') {
		if (*c == '1')
			*a++ = 1;
		else
			*a++ = 0;
		c++;
	}

	c++;

	while (*c && isdigit(*c)) {
		if (*c == '1')
			*b++ = 1;
		else
			*b++ = 0;
		c++;
	}
}


/*
 * prints two columns: result and carry out.
 */
void ripple_carry_adder(const int a[LENGTH], const int b[LENGTH], int cin) {
	sum_carry sc;
	int i;
    int sum[LENGTH];

	sc = fulladder(a[0], b[0], cin);
    sum[0] = sc.sum;

	for (i=1; i<LENGTH; i++) {
		sc = fulladder(a[i], b[i], sc.carry);
		sum[i] = sc.sum;
	}

#ifdef SHOW_INPUT
	for (i=0; i<LENGTH; i++)
		printf("%d", a[i]);
	
	printf(" ");

	for (i=0; i<LENGTH; i++)
		printf("%d", b[i]);

	printf(" ");
#endif

	for (i=0; i<LENGTH; i++)
		printf("%d", sum[i]);
	
	printf("\n");
}

int main(int argc, char** argv) {

	char *line, buf[100];
	int a[LENGTH], b[LENGTH]; 
    FILE *data;

	if (argc!=3) {
		printf("arguments: <filename> <add|mux>\n");
		exit(1);
	}

    if ((data=fopen(argv[1], "r")) == NULL) {
		printf("Error opening file '%s'", argv[1]);
		exit(1);
	}

	if (strcmp(argv[2], "add")==0) 
		while ((line=fgets(buf, 99, data)) != NULL) {
			put_ints(line, a, b);
			ripple_carry_adder(a, b, 0);
		}
	else
		while ((line=fgets(buf, 99, data)) != NULL) {
			put_ints(line, a, b);
			a3to1multiplexer(a[0], a[1], a[2], a[3], a[4]);
		}

	return 0;
}
/* $Id$ */
