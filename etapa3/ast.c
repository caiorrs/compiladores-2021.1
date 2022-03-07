// AST - Abstract Syntax Tree
// Baseado em código do professor Marcelo Johann - aula 10 - 2021/2

#include <stdio.h>
#include <stdlib.h>
#include "ast.h"

AST *astCreate(int type, HASH_NODE *symbol,
               AST *c0, AST *c1, AST *c2, AST *c3)
{
  AST *newnode;
  newnode = (AST *)calloc(1, sizeof(AST));
  newnode->type = type;
  newnode->symbol = symbol;
  newnode->child[0] = c0;
  newnode->child[1] = c1;
  newnode->child[2] = c2;
  newnode->child[3] = c3;

  return newnode;
}
void astPrint(AST *node, int level)
{
  int i = 0;

  if (node == 0)
    return;

  for (i = 0; i <= level; ++i)
    fprintf(stderr, "  ");

  fprintf(stderr, "ast( ");
  // fprintf(stderr, "==%d==\n", node->type);
  switch (node->type)
  {
  case AST_SYMBOL:
    fprintf(stderr, "AST_SYMBOL");
    break;
  case AST_ADD:
    fprintf(stderr, "AST_ADD");
    break;
  case AST_SUB:
    fprintf(stderr, "AST_SUB");
    break;
  case AST_ATTR:
    fprintf(stderr, "AST_ATTR");
    break;
  case AST_ATTR_ARR:
    fprintf(stderr, "AST_ATTR_ARR");
    break;
  case AST_CMDLIST:
    fprintf(stderr, "AST_CMDLIST");
    break;
  case AST_CMDBLOCK:
    fprintf(stderr, "AST_CMDBLOCK");
    break;
  case AST_MULT:
    fprintf(stderr, "AST_MULT");
    break;
  case AST_DIV:
    fprintf(stderr, "AST_DIV");
    break;
  case AST_GREAT:
    fprintf(stderr, "AST_GREAT");
    break;
  case AST_LESS:
    fprintf(stderr, "AST_LESS");
    break;
  case AST_EQ:
    fprintf(stderr, "AST_EQ");
    break;
  case AST_GE:
    fprintf(stderr, "AST_GE");
    break;
  case AST_LE:
    fprintf(stderr, "AST_LE");
    break;
  case AST_DIF:
    fprintf(stderr, "AST_DIF");
    break;
  case AST_PRINT:
    fprintf(stderr, "AST_PRINT");
    break;
  case AST_RETURN:
    fprintf(stderr, "AST_RETURN");
    break;
  case AST_IF:
    fprintf(stderr, "AST_IF");
    break;
  case AST_IF_ELSE:
    fprintf(stderr, "AST_IF_ELSE");
    break;
  case AST_WHILE:
    fprintf(stderr, "AST_WHILE");
    break;
  case AST_GOTO:
    fprintf(stderr, "AST_GOTO");
    break;
  case AST_DECLIST:
    fprintf(stderr, "AST_DECLIST");
    break;
  case AST_TYPE_CHAR:
    fprintf(stderr, "AST_TYPE_CHAR");
    break;
  case AST_TYPE_INT:
    fprintf(stderr, "AST_TYPE_INT");
    break;
  case AST_TYPE_FLOAT:
    fprintf(stderr, "AST_TYPE_FLOAT");
    break;
  case AST_DEC:
    fprintf(stderr, "AST_DEC");
    break;
  case AST_FUNC_DEC:
    fprintf(stderr, "AST_FUNC_DEC");
    break;
  case AST_GLOBAL_VAR_DEC:
    fprintf(stderr, "AST_GLOBAL_VAR_DEC");
    break;
  case AST_VAR_DEC:
    fprintf(stderr, "AST_VAR_DEC");
    break;
  case AST_FLOAT_DEC:
    fprintf(stderr, "AST_FLOAT_DEC");
    break;
  case AST_INITIALIZED_ARRAY:
    fprintf(stderr, "AST_INITIALIZED_ARRAY");
    break;
  case AST_GLOBAL_VAR_FLOAT_DEC:
    fprintf(stderr, "AST_GLOBAL_VAR_FLOAT_DEC");
    break;
  case AST_GLOBAL_VAR_ARR_DEC:
    fprintf(stderr, "AST_GLOBAL_VAR_ARR_DEC");
    break;
  case AST_GLOBAL_VAR_INITIALIZED_ARR_DEC:
    fprintf(stderr, "AST_GLOBAL_VAR_INITIALIZED_ARR_DEC");
    break;

  default:
    fprintf(stderr, "AST_UNKNOWN - %d", node->type);
    break;
  }
  if (node->symbol != 0)
    fprintf(stderr, ",%s\n", node->symbol->text);
  else
    fprintf(stderr, ",0\n");
  for (i = 0; i < MAX_CHILDREN; ++i)
    astPrint(node->child[i], level + 1);

  // for (i = 0; i < level; ++i)
  //   fprintf(stderr, "  ");
  // fprintf(stderr, ")\n");
}

// END OF FILE
