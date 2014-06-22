%{
#include <stdio.h>
#include "attr.h"
int yylex();
void yyerror(char * s);
#include "symtab.h"
%}

%union {
     tokentype token;
     type_t type;
     char *sconst;
     float fconst;
     int iconst;
       }

%token VAR SETTYPE ITZ ASG MAKE COND TRUEBRANCH FALSEBRANCH CONDEXP ENDCOND SWITCH CASE DEFAULT BREAK BEGINLOOP YR UNTIL WHILE ENDLOOP FUNC CALL ENDFUNC RETURN MULT DIV MOD MAX MIN AND OR XOR SUM DIFF ANDI ORI EQ NEQ NONE BOOL INT FLOAT STRING ARRAY NOT SMOOSH MKAY AN TRUE FALSE PRINT READ INC DEC IT HAI KTHXBYE A
%token <token> ID ICONST FCONST YARN


%type  <sconst> string
%type  <fconst> float_constant
%type  <iconst> integer_constant

%start program

%nonassoc EQ NEQ 
%right NOT


%%
program : HAI version ',' statements ',' KTHXBYE ','
{ printf("\n\n     Done with compiling program \n"); }
        ;

version : FCONST
| ;

statements : statements ',' statement
| statement
;

statement : print
| read
| vardecl
| varassign
| conditional
| loop
| cast
| function
| return
| call
| switch
| BREAK
;

print : PRINT expr
| PRINT expr '!'
;

read : READ ID
;

vardecl : VAR ID
| VAR ID ITZ expr
;

varassign : ID ASG expr
;

conditional : expr ',' COND ',' TRUEBRANCH ',' statements ',' maybes falsebranch ENDCOND
;

maybes : CONDEXP expr ',' statements ',' maybes ','
| CONDEXP expr ',' statements ','
| ;


falsebranch : FALSEBRANCH ',' statements ','
| ;

loop : BEGINLOOP ID operation YR ID update ',' statements ',' ENDLOOP ID
;

operation : INC
| DEC
;

update : UNTIL expr
| WHILE expr
| 
;

cast : MAKE expr A type
| expr SETTYPE type
;

type : INT
| STRING
| BOOL
| FLOAT
| ARRAY
| NONE
;


math : SUM expr AN expr
| DIFF expr AN expr
| MULT expr AN expr
| DIV expr AN expr
| MOD expr AN expr
| MAX expr AN expr
| MIN expr AN expr
;

function : FUNC ID farguments ',' statements ',' ENDFUNC
;

return : RETURN expr
;

call : CALL ID arguments MKAY
;

arguments : /* empty */
| YR expr extra_arguments
;

extra_arguments : extra_arguments AN YR expr
| ;

farguments : /* empty */
| YR ID extra_farguments
;

extra_farguments: extra_farguments AN YR ID
| ;



expr : math
| smoosh
| boolean
| ID
| constant
;


boolean : EQ expr AN expr
| NEQ expr AN expr
| AND expr AN expr
| OR expr AN expr
| XOR expr AN expr
| NOT expr
;



smoosh : SMOOSH YARN others MKAY
;

others: others AN YARN 
| AN YARN
;

constant : string
| float_constant
| integer_constant
| boolean_constant
| IT
;

switch: expr ',' SWITCH ',' CASE string ',' statements ','  default ENDCOND
;



default : DEFAULT ',' statements ','
| ;


string : YARN { $$ = $1.str;}
;
float_constant : FCONST { $$ = $1.f;}
;
integer_constant : ICONST {$$ = $1.num;}
;
boolean_constant : TRUE
                 | FALSE
                 ;

%%

void yyerror(char* s) {
        fprintf(stderr,"%s\n",s);
}

int
main() {
  printf("1\t");
  yyparse();
  return 1;
}

