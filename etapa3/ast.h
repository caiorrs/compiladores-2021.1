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
#define AST_ATTR 4
#define AST_CMDLIST 5
#define AST_MULT 6
#define AST_DIV 7
#define AST_GREAT 8
#define AST_LESS 9
#define AST_EQ 10
#define AST_GE 11
#define AST_LE 12
#define AST_DIF 13
#define AST_CMDBLOCK 14
#define AST_ATTR_ARR 15
#define AST_PRINT 16
#define AST_RETURN 17
#define AST_IF 18
#define AST_IF_ELSE 19
#define AST_WHILE 20
#define AST_GOTO 21
#define AST_DECLIST 22
#define AST_TYPE_CHAR 23
#define AST_TYPE_INT 24
#define AST_TYPE_FLOAT 25
#define AST_DEC 26
#define AST_FUNC_DEC 27
#define AST_GLOBAL_VAR_DEC 28
#define AST_VAR_DEC 29
#define AST_FLOAT_DEC 30
#define AST_INITIALIZED_ARRAY 31
#define AST_READ 32
#define AST_GLOBAL_VAR_FLOAT_DEC 33
#define AST_GLOBAL_VAR_ARR_DEC 34
#define AST_GLOBAL_VAR_INITIALIZED_ARR_DEC 35
#define AST_FLOAT_VALUE 36
#define AST_FUNC_PARAMS 37
#define AST_FUNC_MORE_PARAMS 38

typedef struct astnode
{
  int type;
  HASH_NODE *symbol;
  struct astnode *child[MAX_CHILDREN];
} AST;

AST *astCreate(int type, HASH_NODE *symbol,
               AST *c0, AST *c1, AST *c2, AST *c3);

void astPrint(AST *node, int level);

void decompileAndSave(AST *node, FILE *file);

#endif

// END OF FILE
