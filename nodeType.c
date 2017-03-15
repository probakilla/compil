#include <stdio.h>
#include <stdlib.h> 
#include <stdarg.h>
#include "nodeType.h"

#define SIZEOF_NODETYPE ((char *)&p->con - (char *)p)

nodeType *con(int value)
{ 
  nodeType *p; 
  /* allocate node */ 
  if ((p = malloc(sizeof(nodeType))) == NULL) 
    yyerror("out of memory"); 
  /* copy information */ 
  p->type = typeCon; 
  p->con.value = value; 
  return p; 
}

nodeType *id(char *i)
{ 
  nodeType *p; 
  /* allocate node */ 
  if ((p = malloc(sizeof(nodeType))) == NULL) 
    yyerror("out of memory"); 
  /* copy information */ 
  p->type = typeId; 
  p->id.i = i; 
  return p; 
} 

nodeType *opr(int oper, int nops, ...)
{
  va_list ap; 
  nodeType *p; 
  int i; 
  /* allocate node, extending op array */
  if ((p = malloc(sizeof(nodeType) + (nops-1) * sizeof(nodeType *))) == NULL)
    yyerror("out of memory"); 
  /* copy information */ 
  p->type = typeOpr;
  p->opr.oper = oper; 
  p->opr.nops = nops; 
  va_start(ap, nops); 
  for (i = 0; i < nops; i++) 
    p->opr.op[i] = va_arg(ap, nodeType*); 
  va_end(ap); 
  return p; 
}

void freeNode(nodeType *p)
{ 
  int i; 
  if (!p) return; 
  if (p->type == typeOpr)
    { 
      for (i = 0; i < p->opr.nops; i++) 
	freeNode(p->opr.op[i]); 
    }
  free (p); 
}


int yyerror(char* s){
    fprintf(stderr, "*** ERROR: %s\n", s);
    return 0;
}
