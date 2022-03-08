/*
  Caio Roberto Ramos da Silva - 00279459
  Compiladores - 2021.2 - Marcelo Johann
*/

#include <stdio.h>
#include <stdlib.h>
#include "hash.h"
#include "ast.h"

extern FILE *yyin;
int yyparse();
AST *getASTRoot();
FILE *output;

int main(int argc, char **argv)
{

  extern int yy_flex_debug;

  int token;

  if (argc < 3)
  {
    fprintf(stderr, "Call ./etapa3 in_file_name out_file_name\n");
    exit(1);
  }

  yyin = fopen(argv[1], "r");

  if (!(output = fopen(argv[2], "w+")))
  {
    fprintf(stderr, "Cannot open file %s\n", argv[2]);
    return 2;
  }

  hashInit();

  yy_flex_debug = 1;
  yyparse();

  hashPrint();

  astPrint(getASTRoot(), 0);

  fprintf(stderr, "Compilation successful!\n");

  decompileAndSave(getASTRoot(), output);

  exit(0);
}