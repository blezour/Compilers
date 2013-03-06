/* pas0.c */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern void _pmain();

static int save_argc;
static char **save_argv;
static FILE *infile;

int main(int argc, char **argv) {
     save_argc = argc;
     save_argv = argv;
     infile = stdin;
     _pmain();
     return 0;
}

int _argc(void) {
     return save_argc;
}

void _argv(int n, char *s) {
     strcpy(s, save_argv[n]);
}

void _print_string(char *s, int n) {
     printf("%.*s", n, s);
}

void _print_num(int n) {
     printf("%d", n);
}

void _print_char(int c) {
     printf("%c", c);
}

void _newline(void) {
     printf("\n");
}

void _read_char(char *c) {
     char c0 = fgetc(infile);
     *c = (c0 == EOF ? 127 : c0);
}

int _open_in(char *s) {
     FILE *f = fopen(s, "r");
     if (f == NULL) return 0;
     if (infile != stdin) fclose(infile);
     infile = f;
     return 1;
}

void _close_in(void) {
     if (infile == stdin) return;
     fclose(infile);
     infile = stdin;
}

void _check(int n) {
     fprintf(stderr, "Array bound error on line %d\n", n);
     exit(2);
}

void _nullcheck(int n) {
     fprintf(stderr, "Null pointer check on line %d\n", n);
     exit(2);
}

void _new(char **p, int n) {
     char *q = malloc(n);
     if (q == NULL) {
	  fprintf(stderr, "Out of memory space\n");
	  exit(2);
     }
     *p = q;
}

int _int_div(int a, int b) {
     int quo = a / b, rem = a % b;
     if (rem != 0 && (rem ^ b) < 0) quo--;
     return quo;
}

int _int_mod(int a, int b) {
     int rem = a % b;
     if (rem != 0 && (rem ^ b) < 0) rem += b;
     return rem;
}
