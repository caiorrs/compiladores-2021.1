/*
  Caio Roberto Ramos da Silva - 00279459
  Compiladores - 2021.2 - Marcelo Johann
*/
// Código desenvolvido pelo Professor Marcelo Johann

#ifndef HASH_HEADER
#define HASH_HEADER

#include <stdio.h>

#define HASH_SIZE 997

typedef struct hash_node
{
  int type;
  char *text;
  struct hash_node *next;
} HASH_NODE;

void hashInit(void);
int hashAddress(char *text);
HASH_NODE *hashFind(char *text);
HASH_NODE *hashInsert(char *text, int type);
void hashPrint(void);

#endif