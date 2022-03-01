// AST - Abstract Syntax Tree
// Baseado em código do professor Marcelo Johann - aula 10 - 2021/2

#include "hash.h"

#ifndef AST_HEADER
#define AST_HEADER

#define MAX_CHILDREN 4

#define AST_SYMBOL 1
// lista de expressões da linguagem (parser)
#define AST_ADD 2
#define AST_SUB 3

typedef struct astnode
{
  int type;
  HASH_NODE *symbol;
  struct astnode *child[MAX_CHILDREN];
} AST;

AST *astCreate(int type, HASH_NODE *symbol,
               AST *c0, AST *c1, AST *c2, AST *c3);

void *astPrint(AST *node, int level);

#endif

// END OF FILE
