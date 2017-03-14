%{
  #include <stdio.h>
  #include <stdlib.h>
  #include "environ.h"
    
  int yyerror(char *s);

  /**
   * Mini projet de compilation S6.
   * Groupe de Chupin Guillaume et Pilleux Julien.
   **/
%}

%union {
    int value;
    char *ident;
    struct cellenv *ptr;
 };
%token <value> I
%token <ident> V
%token AF SK SE IF TH EL WH DO PL MO MU
%type <ptr> E T F C A

%start C

%%

E : E PL T  {$$->VAL = eval(Pl, $1->VAL, $3->VAL);initenv(&$$, $$->ID);affect($$, $$->ID, $$->VAL);}
  | E MO T  {$$->VAL = eval(Mo, $1->VAL, $3->VAL);initenv(&$$, $$->ID);affect($$, $$->ID, $$->VAL);}
  | T  {$$ = $1;}
;
T : T MU F  {$$->VAL = eval(Mu, $1->VAL, $3->VAL);initenv(&$$, $1->ID);affect($$, $$->ID, $$->VAL);}
  | F  {$$ = $1;}
;
F : '(' E ')'  {$$ = $2;}
  | I  {$$->VAL = $1;}
  | V  {$$->ID = $1;}
;
C : A SE C {$$ = $1; $$ = $3;}
  | A  {$$ = $1;}
;
A : V AF E  {$$->VAL = $3->VAL; initenv(&$$, $1); affect($$, $1, $3->VAL);}
  | SK      {;}
  | '(' C ')'  {$$ = $2;}
  | WH E DO A  {while ($2){$$ = $4;}}
  | IF E TH C EL A {if ($2){$$ = $4;}else{$$ = $6;}}
;
%%

int yyerror(char* s){
    fprintf(stderr, "*** ERROR: %s\n", s);
    return 0;
}
	 
int main (int argc, char* argv [])
{
  //ENV env = Envalloc();
    yyparse();
    // ecrire_env(env);
    return 0;
}
