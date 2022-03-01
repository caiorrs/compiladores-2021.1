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
void *astPrint(AST *node, int level)
{
  int i = 0;

  if (node == 0)
    return;

  for (i = 0; i < level; ++i)
    fprintf(stderr, "  ");

  fprintf(stderr, "ast(");
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

  default:
    fprintf(stderr, "AST_UNKNOWN");
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
