%{
	#include "ast.h"
	#include <stdio.h>
	#include <string.h>
	#include <stdlib.h>
	#include "parser.tab.h"
	void yyerror(char*);
	
%}

MultilineComment	    "/*"([^\*]|(\*)*[^\*/])*(\*)*"*/"
SingleLineComment	    "//"[^\n]+
IDENTIFIER [a-zA-Z_][a-zA-Z0-9_]*
INTEGER [1-9][0-9]*
FLOATINGNUMBER ^(-?\d+)(\.\d+)?$
%%

{SingleLineComment} { }
{MultilineComment}  { }
"\n" { }
[ \t] { }
"int" { return INT; }
"float" { return FLOAT; }
"void" { return VOID; }
"return" { return RETURN; }
"if" { return IF; }
"else" { return ELSE; }
"(" { return LP; }
")" { return RP; }
"[" { return LB; }
"]" { return RB; }
"{" { return LC; }
"}" { return RC; }
"," { return COMMA; }
";" { return SEMICOLON; }
"+" { return PLUS; }
"-" { return MINUS; }
"!" { return NOT; }
"=" { return ASSIGN; }
"*" { return MUL; }
"/" { return DIV; }
"%" { return MOD; }
"==" { return EQ; }
"!=" { return NE; }
"<" { return LT; }
"<=" { return LE; }
">" { return GT; }
">=" { return GE; }
{INTEGER}          {yylval.int_val=atoi(yytext);return INT_LIT;}
{IDENTIFIER}       {yylval.symbol_val = (char *)malloc(strlen(yytext) + 1);
    				strcpy(yylval.symbol_val, yytext);
    				yylval.symbol_val[strlen(yytext)] = '\0';
   					 return ID; }
{FLOATINGNUMBER}  {yylval.float_val=atof(yytext);return FLOAT_LIT;}

%%