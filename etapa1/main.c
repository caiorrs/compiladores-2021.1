/*
  Caio Roberto Ramos da Silva - 00279459
  Compiladores - 2021.2 - Marcelo Johann
*/

#include <stdio.h>

int main(int argc, char **argv)
{

  int token;

  if (argc < 2)
  {
    fprintf(stderr, "Call ./a.out file_name\n");
    exit(1);
  }

  yyin = fopen(argv[1], "r");

  hashInit();

  while (running)
  {
    token = yylex();
    if (!running)
      break;

    switch (token)
    {
    case KW_CHAR:
      printf("CHAR\n");
      break;
    case KW_INT:
      printf("INT\n");
      break;
    case KW_FLOAT:
      printf("FLOAT\n");
      break;
    case KW_IF:
      printf("IF\n");
      break;
    case KW_THEN:
      printf("THEN\n");
      break;
    case KW_ELSE:
      printf("ELSE\n");
      break;
    case KW_WHILE:
      printf("WHILE\n");
      break;
    case KW_GOTO:
      printf("GOTO\n");
      break;
    case KW_READ:
      printf("READ\n");
      break;
    case KW_PRINT:
      printf("PRINT\n");
      break;
    case KW_RETURN:
      printf("RETURN\n");
      break;
    case OPERATOR_LE:
      printf("OPERATOR_LE\n");
      break;
    case OPERATOR_GE:
      printf("OPERATOR_GE\n");
      break;
    case OPERATOR_EQ:
      printf("OPERATOR_EQ\n");
      break;
    case OPERATOR_DIF:
      printf("OPERATOR_DIF\n");
      break;
    case TK_IDENTIFIER:
      printf("TK_IDENTIFIER\n");
      break;
    case LIT_INTEGER:
      printf("LIT_INTEGER\n");
      break;
    case LIT_CHAR:
      printf("LIT_CHAR\n");
      break;
    case LIT_STRING:
      printf("LIT_STRING\n");
      break;
    case TOKEN_ERROR:
      printf("TOKEN_ERROR\n");
      break;
    default:
      printf("FOUND: %c\n", token);
      break;
    }
  }
  printf("File has %d lines\n", lineNumber);
  hashPrint();
  exit(0);
}