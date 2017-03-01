%{
  #include <stdio.h>
  #include <stdlib.h>

  /**
   * Mini projet de compilation S6.
   * Groupe de Chupin Guillaume et Pilleux Julien.
   **/
%}

%start C

%%

E : E Pl T
  | E Mo T
  | T

T : T Mu F
  | F

F : '(' E ')'
  | I
  | V

C : V Af E
  | Sk
  | '(' C ')'
  | If E Th C El C
  | Wh E Do C
  | C Se C

%%

int main (int argc, char* argv [])
{
  return 0;
}
