#ifndef NODETYPE_H
#define NODETYPE_H

typedef enum { typeCon, typeId, typeOpr } nodeEnum; 

typedef struct { 
    int value;                 
} conNodeType; 

typedef struct { 
    char *i;                      
} idNodeType; 

typedef struct { 
    int oper;                   
    int nops;                  
    struct nodeTypeTag *op[1];  
				 
} oprNodeType; 
typedef struct nodeTypeTag { 
    nodeEnum type;              
    union { 
        conNodeType con;        
        idNodeType id;          
        oprNodeType opr;       
    }; 
} nodeType;

nodeType *opr(int oper, int nops, ...); 
nodeType *id(char *i); 
nodeType *con(int value); 
void freeNode(nodeType *p);
int yyerror(char *s);
#endif
