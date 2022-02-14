/*
  Caio Roberto Ramos da Silva - 00279459
  Compiladores - 2021.2 - Marcelo Johann
*/

#include <stdio.h>

int main(int argc, char **argv)
{

  extern int yy_flex_debug;

  int token;

  if (argc < 2)
  {
    fprintf(stderr, "Call ./a.out file_name\n");
    exit(1);
  }

  yyin = fopen(argv[1], "r");

  hashInit();

  yy_flex_debug = 1;
  yyparse();

  hashPrint();

  fprintf(stderr, "Compilation successful!\n");

  exit(0);
}