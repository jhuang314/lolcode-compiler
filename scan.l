%{
#include <string.h>
#include "attr.h"
#include "parse.tab.h"
#define YY_SKIP_YYWRAP
%}
	extern YYSTYPE yylval;
        extern int yywrap() {return 1;};
	extern int isatty();
	int lines = 1;

D       [0-9]
id	[A-Za-z][A-Za-z0-9]*
%x LOL_COMMENT
%s expect

%%
expect-floats        BEGIN(expect);

<expect>[0-9]+"."[0-9]+   {ECHO;
     yylval.token.f = atof(yytext);
     return(FCONST);}
<expect>\n  {BEGIN(INITIAL);}

{D}+		{ECHO;
		yylval.token.num = atoi(yytext);
		return(ICONST);}

\"[^\"]*\"	{
			yylval.token.str = malloc(strlen(yytext) * sizeof(char));
			strncpy(yylval.token.str, yytext+1,strlen(yytext)-2);
      fprintf(yyout, "%s", yytext);
			return(YARN);
		}

"I HAS A"     {ECHO;return(VAR);}
"IS NOW A"    {ECHO;return(SETTYPE);}
"ITZ"         {ECHO;return(ITZ);}
"R"           {ECHO;return(ASG);}
"MAEK"        {ECHO;return(MAKE);}
"O RLY?"      {ECHO;return(COND);}
"YA RLY"      {ECHO;return(TRUEBRANCH);}
"NO WAI"      {ECHO;return(FALSEBRANCH);}
"MEBBE"       {ECHO;return(CONDEXP);}
"OIC"         {ECHO;return(ENDCOND);}
"WTF?"        {ECHO;return(SWITCH);}
"OMG"         {ECHO;return(CASE);}
"OMGWTF"      {ECHO;return(DEFAULT);}
"GTFO"        {ECHO;return(BREAK);}
"IM IN YR"    {ECHO;return(BEGINLOOP);}
"YR"          {ECHO;return(YR);}
"TIL"         {ECHO;return(UNTIL);}
"WILE"        {ECHO;return(WHILE);}
"IM OUTTA YR" {ECHO;return(ENDLOOP);}
"HOW IZ I"    {ECHO;return(FUNC);}
"I IZ"        {ECHO;return(CALL);}
"IF U SAY SO" {ECHO;return(ENDFUNC);}
"FOUND YR"    {ECHO;return(RETURN);}
"PRODUKT OF"  {ECHO;return(MULT);}
"QUOSHUNT OF" {ECHO;return(DIV);}
"MOD OF"      {ECHO;return(MOD);}
"BIGGR OF"    {ECHO;return(MAX);}
"SMALLR OF"   {ECHO;return(MIN);}
"BOTH OF"     {ECHO;return(AND);}
"EITHER OF"   {ECHO;return(OR);}
"WON OF"      {ECHO;return(XOR);}
"SUM OF"      {ECHO;return(SUM);}
"DIFF OF"     {ECHO;return(DIFF);}
"ALL OF"      {ECHO;return(ANDI);}
"ANY OF"      {ECHO;return(ORI);}
"BOTH SAEM"   {ECHO;return(EQ);}
"DIFFRINT"    {ECHO;return(NEQ);}


"/*"		{
     int c1 = 0; int c2 = input();
     ECHO;
     for(;;) {
          if (c2 == EOF) {
               printf("ERROR: EOF detected in comment\n");
               yyterminate();
          }
          fprintf(yyout,"%c",c2);
          if (c1 == '*' && c2== '/') break;
          c1 = c2;
          c2 = input();
          if (c1 == '\n' && c2 != EOF)
          {lines++; fprintf(yyout,"%d\t",lines);}
     }
}
"OBTW"              { BEGIN(LOL_COMMENT); }
<LOL_COMMENT>"TLDR" { BEGIN(INITIAL); }
<LOL_COMMENT>.      { }
"BTW".*             { }

[\[\]*+(),:;=-]	{ECHO;return(yytext[0]);}
HAI     {ECHO;return(HAI);}
KTHXBYE {ECHO;return(KTHXBYE);}
NOOB    {ECHO;return(NONE);}
TROOF   {ECHO;return(BOOL);}
NUMBR   {ECHO;return(INT);}
NUMBAR  {ECHO;return(FLOAT);}
YARN    {ECHO;return(STRING);}
BUKKIT  {ECHO;return(ARRAY);}
NOT     {ECHO;return(NOT);}
SMOOSH  {ECHO;return(SMOOSH);}
MKAY    {ECHO;return(MKAY);}
AN      {ECHO;return(AN);}
WIN     {ECHO;return(TRUE);}
FAIL    {ECHO;return(FALSE);}
VISIBLE {ECHO;return(PRINT);}
GIMMEH  {ECHO;return(READ);}
UPPIN   {ECHO;return(INC);}
NERFIN  {ECHO;return(DEC);}
IT      {ECHO;return(IT);}
A    {ECHO;return(A);}


{id}		{ECHO;
		yylval.token.str = (char *) malloc(strlen(yytext)+1);
		strcpy(yylval.token.str,yytext);
		return(ID);
		}
\n		{int c;
		ECHO;
		c = input();
		if (c != EOF) {unput(c); lines++; fprintf(yyout,"%d\t",lines);}
		else yyterminate();
		}
[ \t]		{ECHO;}
[!@#$%^&|?]	{ECHO;
		printf("\nERROR: %c is an illegal character\n",yytext[0]);
		}
%%
