%{
  #include <stdio.h>
  #include <stdlib.h>
  #include "iimp.tab.h"
  #include "environ.h"
%}

%option noyywrap

valeur [1-9][0-9]*
ident [a-zA-Z][0-9a-zA-Z]*

%%
{valeur}  {yylval.value = atoi(yytext); return I;}
:=        {return AF;}
"Skip"      {return SK;}
;         {return SE;}
"if"        {return IF;}
"then"      {return TH;}
"else"      {return EL;}
"while"     {return WH;}
"do"        {return DO;}
\+        {return PL;}
-         {return MO;}
\*        {return MU;}
{ident}   {yylval.ident = strdup(yytext); return V;}
[ \t]    ;
.          ;
\n return 0;
%% 

