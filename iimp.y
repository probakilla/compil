%{
   /**
   * Mini projet de compilation S6.
   * Groupe de Chupin Guillaume et Pilleux Julien.
   **/
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include "environ.h"
  #include "bilquad.h"
  #include "nodeType.h"

  #define BUF_LENGTH 20
  #define TAB_LENGTH 10
  
  int yylex();
  char* ic3a(nodeType *n, BILQUAD bil);
  char* buf_alloc ();
  void ajouter(char** tab, int* valTab, int taille, int nbElem, char* varId, int varVal);
  int cpt, taille, nbElem;
  char **tab;
  int *valTab;
%}

%union {
    int value;
    char *ident;
    struct nodeTypeTag *ptr;
 };

%token <value> I
%token <ident> V
%token AF SK SE IF TH EL WH DO PL MO MU
%type <ptr> E T F C A
%nonassoc TH EL DO

%start S

%%

S : C              {BILQUAD bil = bilquad_vide(); ic3a($1, bil);}
  ;

E : E PL T         {$$ = opr(Pl, 2, $1, $3);}
  | E MO T         {$$ = opr(Mo, 2, $1, $3);}
  | T              {$$ = $1;}
  ;

T : T MU F         {$$ = opr(Mu, 2, $1, $3);}
  | F              {$$ = $1;}
  ;

F : '(' E ')'      {$$ = $2;}
  | I              {$$ = con($1);}
  | V              {$$ = id($1);}
  ;

C : A SE C         {$$ = opr(Se, 2, $1, $3);}
  | A              {$$ = $1;}
  ;

A : V AF E         {$$ = opr(Af, 2, id($1), $3);}
  | SK             {$$ = opr(Sk, 0, NULL, NULL);}
  | '(' C ')'      {$$ = $2;}
  | WH E DO A      {$$ = opr(Wh, 2, $2, $4);}
  | IF E TH C EL A {$$ = opr(If, 3, $2, $4, $6);}
  ;

%%

char*ic3a(nodeType *n, BILQUAD bil)
{
    if (!n)
	return NULL;
    char *etiq = buf_alloc();
    char* arg1 = buf_alloc();
    char* arg2 = buf_alloc();
    char* res = buf_alloc();
    switch(n->type)
    { 
    case typeCon:
	sprintf (etiq,"ET%d", cpt++);
	sprintf (res, "CT%d", cpt++);
	sprintf (arg1, "%d", n->con.value);
	bil = concatq(bil, creer_bilquad(creer_quad (etiq, Afc, arg1, arg2, res)));
	ecrire_bilquad(bil);
	return res;
    case typeId:
	sprintf (etiq,"ET%d", cpt++);

	sprintf (res, "%s", n->id.i);
	bil = concatq(bil, creer_bilquad(creer_quad (etiq, Sk, arg1, arg2, res)));
	ecrire_bilquad(bil);
	return res;
    case typeOpr:
	switch(n->opr.oper)
	{
	case Af:
	    sprintf (etiq,"ET%d", cpt++);
	    arg1 = ic3a(n->opr.op[0], bil);
	    arg2 =  ic3a(n->opr.op[1], bil);
	    bil = concatq(bil, creer_bilquad(creer_quad (etiq, Af, arg1, arg2, NULL)));
	    free(etiq);
	    free(arg1);
	    free(arg2);
	    free(res);
	    ecrire_bilquad(bil);
	    return res;
	case Sk:
	    sprintf (etiq,"ET%d", cpt++);
	    bil = concatq(bil, creer_bilquad(creer_quad (etiq, Sk, NULL, NULL, NULL)));
	    ecrire_bilquad(bil);
	case Se:
	    ic3a(n->opr.op[0], bil);
	    ic3a(n->opr.op[1], bil);
	case If:
	    sprintf (etiq,"ET%d", cpt++);
	    res = ic3a(n->opr.op[0], bil);
	    bil = concatq(bil, creer_bilquad(creer_quad (etiq, Sk, NULL, NULL, res)));
	    char *arg1DebutIf = res;
	    BILQUAD then = bilquad_vide();
	    ic3a(n->opr.op[1], then);
	    BILQUAD els =  bilquad_vide();
	    ic3a(n->opr.op[2], els);	  
	    sprintf (res,"ET%d", cpt);
	    then = concatq(then, creer_bilquad(creer_quad (etiq, Jp, NULL, NULL, res)));
	    els = concatq(els, creer_bilquad(creer_quad (etiq, Sk, NULL, NULL, NULL)));
	    res = els.debut->ETIQ;
	    sprintf (etiq,"ET%d", cpt++);
	    bil = concatq(bil, creer_bilquad(creer_quad (etiq, Jz, arg1DebutIf, NULL, res)));
	    bil = concatq(bil, then);
	    bil = concatq(bil, els);
	    ecrire_bilquad(bil);
	case Wh:
	    sprintf (etiq,"ET%d", cpt++);
	    res = ic3a(n->opr.op[0], bil);
	    BILQUAD debutWhile = creer_bilquad(creer_quad (etiq, Sk, NULL, NULL, res));
	    char* etiqDebutWhile = debutWhile.debut->ETIQ;
	    bil = concatq(bil, debutWhile);
	    char *arg1DebutWhile = res;	
	    BILQUAD Do = bilquad_vide();
	    ic3a(n->opr.op[1], Do);
	    sprintf (etiq,"ET%d", cpt++);
	    Do = concatq(Do, creer_bilquad(creer_quad (etiq, Jp, NULL, NULL, etiqDebutWhile)));
	    sprintf (res,"ET%d", cpt + 1);
	    bil = concatq(bil, creer_bilquad(creer_quad (etiq, Jz, arg1DebutWhile, NULL, res)));
	    bil = concatq(bil, Do);
	    sprintf (etiq,"ET%d", cpt++);
	    bil = concatq(bil, creer_bilquad(creer_quad (etiq, Sk, NULL, NULL, NULL)));
	    ecrire_bilquad(bil);
	case Pl:
	    sprintf (etiq,"ET%d", cpt++);
	    arg1 = ic3a(n->opr.op[0], bil);
	    arg2 =  ic3a(n->opr.op[1], bil);
	    sprintf (res, "VA%d", cpt++);
	    bil = concatq(bil, creer_bilquad(creer_quad (etiq, Pl, arg1, arg2, res)));
	    ecrire_bilquad(bil);
	    return res;
	case Mo:
	    sprintf (etiq,"ET%d", cpt++);
	    arg1 = ic3a(n->opr.op[0], bil);
	    arg2 =  ic3a(n->opr.op[1], bil);
	    sprintf (res, "VA%d", cpt++);
	    bil = concatq(bil, creer_bilquad(creer_quad (etiq, Mo, arg1, arg2, res)));
	    ecrire_bilquad(bil);
	    return res;
	case Mu:
	    sprintf (etiq,"ET%d", cpt++);
	    arg1 = ic3a(n->opr.op[0], bil);
	    arg2 =  ic3a(n->opr.op[1], bil);
	    sprintf (res, "VA%d", cpt++);
	    bil = concatq(bil, creer_bilquad(creer_quad (etiq, Mu, arg1, arg2, res)));
	    ecrire_bilquad(bil);
	    return res;	    
	}
    }
    sprintf (etiq,"ET%d", cpt++);
    bil = concatq(bil, creer_bilquad(creer_quad (etiq, St, NULL, NULL, NULL)));
    ecrire_bilquad(bil);
    free(etiq);
    free(arg1);
    free(arg2);
    free(res);
}

char* buf_alloc ()
{
  char* buf = malloc (BUF_LENGTH * sizeof(*buf));
  buf [0] = '\0';
  return buf;
}

void ajouter (char** tab, int* valTab, int taille, int nbElem, char* varId, int varVal)
{
  if (nbElem == taille)
    {
      tab = realloc (tab, (taille*2) * sizeof (char*));
      valTab = realloc (valTab, (taille*2) * sizeof (int));
      taille = taille << 1;
      ajouter (tab, valTab, taille, nbElem, varId, varVal);
    }
  tab [nbElem] = strdup (varId);
  valTab [nbElem] = varVal;
  ++nbElem;
}
	
int main (int argc, char* argv [])
{
  taille = TAB_LENGTH;
  nbElem = 0;
  tab = malloc (TAB_LENGTH * sizeof (int));
  valTab = malloc (TAB_LENGTH * sizeof (char*));
  cpt = 0;
  yyparse();
  return 0;

}
