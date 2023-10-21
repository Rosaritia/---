%{
	#include "ast.h"
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>   
	void yyerror(char*);
	int yylex(void);
	ASTNode *root;
	
	extern FILE *yyin;
	
%}

%union {
    int int_val;
    float float_val;
    char* symbol_val;
    struct ASTNode *node_val;
}

%type <node_val> CompUnit Decl  VarDef InitVal FuncDef FuncFParams FuncFParam  Block BlockItem Stmt Exp Cond LVal PrimaryExp UnaryExp  FuncRParams MulExp AddExp  RelExp EqExp ConstExp Root  ExpArray CondStmt VarDefGroup  IDArray

%token <symbol_val> ID
%token <int_val> INT_LIT
%token <float_val> FLOAT_LIT

%token <int_val> INT FLOAT VOID RETURN IF ELSE LP RP LB RB LC RC COMMA SEMICOLON IFELSE
%token <int_val> MINUS NOT ASSIGN PLUS MUL DIV MOD EQ NE LT LE GT GE

%nonassoc ELSE
%nonassoc UMINUS
%start Root

%%

Root: 
	CompUnit { root = new_node("Root", NULL, $1,0, 0, NULL,NULL); }
	;
CompUnit: 
        Decl { $$ = new_node("CompUnit", NULL, $1, 0, 0, NULL,NULL); }
        | FuncDef { $$ = new_node("CompUnit", NULL, $1, 0, 0, NULL,NULL); }
        | CompUnit  Decl{ $$ = new_node("CompUnit", $1, $2, 0, 0, NULL,NULL); }
        | CompUnit FuncDef{ $$ = new_node("CompUnit", $1, $2, 0, 0, NULL,NULL); }
        ;

Decl:
	 INT VarDefGroup SEMICOLON{ $$ = new_node("Decl", NULL,$2, 0, 0,NULL,"INT"); }
    | FLOAT VarDefGroup SEMICOLON { $$ = new_node("Decl", NULL,$2, 0, 0,NULL,"INT"); }
	;

VarDefGroup:   
	VarDef { $$ = new_node("VarDefGroup",NULL, $1, 0, 0, NULL,NULL);} 
	|VarDefGroup SEMICOLON VarDef{ $$ = new_node("VarDefGroup",$1, $3, 0, 0, NULL,NULL);}
	;
VarDef: 
	 ID {$$ = new_node("VarDef", NULL, NULL, 0,0,$1,NULL); }
	|IDArray{$$ = new_node("VarDef", NULL, $1, 0,0,NULL,NULL); }
	|ID ASSIGN InitVal{$$ = new_node("VarDef", NULL, $3, 0,0,$1,"ASSIGN"); }
	|IDArray ASSIGN InitVal {$$ = new_node("VarDef", $1, $3, 0,0,NULL,"ASSIGN"); }
	;

IDArray:
	ID LB ConstExp RB{$$ = new_node("IDArray", NULL, $3, 0,0,$1,NULL); }
	|IDArray LB ConstExp RB{$$ = new_node("IDArray", $1, $3, 0,0,NULL,NULL); }
	;


InitVal:
	Exp{ $$ = new_node("InitVal", NULL, $1,0, 0, NULL,NULL); }
	;
FuncDef: 
	   INT ID LP RP Block { $$ = new_node("FuncDef", NULL, $5,  0, 0, $2,"INT"); }
       | FLOAT ID LP RP Block{ $$ = new_node("FuncDef", NULL, $5, 0, 0, $2,"FLOAT"); }
       | VOID ID LP RP Block { $$ = new_node("FuncDef", NULL, $5, 0, 0, $2,"VOID"); }
       | INT ID LP FuncFParams RP Block { $$ = new_node("FuncDef",  $4, $6,0, 0, $2,"INT"); }
       | FLOAT ID LP FuncFParams RP Block { $$ = new_node("FuncDef",  $4, $6, 0, 0, $2,"FLOAT"); }
       | VOID ID LP FuncFParams RP Block{ $$ = new_node("FuncDef",  $4, $6,0, 0, $2,"VOID"); }
	;
FuncFParams:
	FuncFParam{ $$ = new_node("FuncFParams", NULL, $1, 0, 0, NULL,NULL); }
	|FuncFParams COMMA FuncFParam  { $$ = new_node("FuncFParams", $1, $3, 0, 0, NULL,NULL); }
	;
FuncFParam:
	INT ID { $$ = new_node("FuncFParam",  NULL, NULL, 0, 0, $2,"INT"); }
    | FLOAT ID  { $$ = new_node("FuncFParam", NULL, NULL, 0, 0, $2,"FLOAT"); }
	| VOID ID  { $$ = new_node("FuncFParam", NULL, NULL, 0, 0, $2,"VOID"); }
    | INT  ExpArray { $$ = new_node("FuncFParam", NULL, $2, 0, 0, NULL,"INT"); }
	| FLOAT ExpArray  { $$ = new_node("FuncFParam", NULL, $2, 0, 0, NULL,"FLOAT"); }
	| VOID  ExpArray  { $$ = new_node("FuncFParam", NULL, $2, 0, 0, NULL,"VOID"); }
    ;

ExpArray:
	 ID LB RB { $$ = new_node("ExpArray", NULL, NULL, 0, 0, $1,NULL); }
	|ExpArray LB Exp RB  { $$ = new_node("ExpArray", $1, $3, 0, 0, NULL,NULL); }
	;

Block: 
	LC RC{ $$ = NULL; }
	|LC BlockItem RC { $$ = new_node("Block", NULL, $2, 0, 0, NULL,NULL); }
	;
BlockItem: 
     Decl { $$ = new_node("BlockItem", NULL,  $1, 0, 0, NULL,NULL); }
	| Stmt { $$ = new_node("BlockItem", NULL,  $1, 0, 0, NULL,NULL); }
	|Decl BlockItem { $$ = new_node("BlockItem",   $1,$2, 0, 0, NULL,NULL); }
	| Stmt BlockItem{ $$ = new_node("BlockItem",   $1,$2, 0, 0, NULL,NULL); }
	;
Stmt: LVal ASSIGN Exp SEMICOLON { $$ = new_node("Stmt", $1, $3,0, 0, NULL,"ASSIGN"); }
	| Exp SEMICOLON { $$ = new_node("Stmt",  NULL, $1,0, 0, NULL,NULL); }
	| SEMICOLON { $$ = NULL;}
	| Block{ $$ = new_node("Stmt", NULL,  $1, 0, 0, NULL,NULL); }
	| IF CondStmt ELSE Stmt %prec UMINUS{ $$ = new_node("Stmt", $2, $4,0, 0, NULL,"IFELSE"); }
	| IF CondStmt { $$ = new_node("Stmt",NULL, $2, 0, 0, NULL,"IF"); }
	| RETURN Exp SEMICOLON  { $$ = new_node("Stmt", NULL, $2,0, 0, NULL,"RETURN"); }
	| RETURN SEMICOLON{ $$ = new_node("Stmt", NULL, NULL, 0, 0, NULL,"RETURN"); }
	;
CondStmt:
	LP Cond RB Stmt{ $$ = new_node("CondStmt", $2, $4, 0, 0, NULL,NULL); }
	;


Exp:
	AddExp { $$ = new_node("Exp", NULL,  $1, 0, 0, NULL,NULL);}
	;
Cond:
	EqExp { $$ = new_node("Cond", NULL,  $1, 0, 0, NULL,NULL);}
	;
LVal:
	ID ExpArray  { $$ = new_node("LVal", NULL, $2, 0, 0, $1,NULL);}
	;

PrimaryExp: 
	LP Exp RP { $$ = new_node("PrimaryExp", NULL, $2, 0, 0, NULL,NULL); }
        | LVal { $$ = new_node("PrimaryExp", NULL, $1,  0, 0, NULL,NULL); }
        | INT_LIT { $$ = new_node("PrimaryExp", NULL, NULL, $1, 0, NULL,NULL); }
        | FLOAT_LIT { $$ = new_node("PrimaryExp", NULL, NULL, 0, $1, NULL,NULL); }
	;
UnaryExp: 
	PrimaryExp { $$ = new_node("UnaryExp", NULL,  $1, 0, 0, NULL,NULL); }
    | ID LP RP { $$ = new_node("UnaryExp", NULL, NULL, 0, 0, $1,NULL); }
	| ID LP FuncRParams RP { $$ = new_node("UnaryExp", NULL, $3, 0, 0, $1,NULL); }
    | PLUS UnaryExp { $$ = new_node("UnaryExp", NULL, $2, 0, 0, NULL,"PLIS"); }
	| MINUS UnaryExp { $$ = new_node("UnaryExp", NULL, $2,0, 0, NULL,"MINUS"); }
	;

FuncRParams: 
	Exp { $$ = new_node("FuncRParams", NULL, $1, 0, 0, NULL,NULL); }
    | FuncRParams COMMA Exp{ $$ = new_node("FuncRParams",$1, $3, 0, 0, NULL,NULL); }
	;
AddExp: 
	MulExp { $$ = new_node("AddExp", NULL, $1, 0, 0, NULL,NULL); }
	| AddExp PLUS MulExp { $$ = new_node("AddExp", $1,  $3, 0, 0, NULL,"PLUS"); }
    | AddExp MINUS MulExp { $$ = new_node("AddExp", $1, $3, 0, 0, NULL,"MINUS"); }
	;
MulExp: 
	UnaryExp { $$ = new_node("MulExp", NULL, $1, 0, 0, NULL,NULL); }
      | MulExp MUL UnaryExp { $$ = new_node("MulExp", $1, $3, 0, 0, NULL,"MUL"); }
      | MulExp DIV UnaryExp{ $$ = new_node("MulExp", $1, $3, 0, 0, NULL,"DIV"); }
      | MulExp MOD UnaryExp { $$ = new_node("MulExp", $1, $3, 0, 0, NULL,"MOD"); }
	;
RelExp: 
	AddExp { $$ = new_node("RelExp", NULL, $1, 0, 0, NULL,NULL); }	
      | RelExp LT AddExp { $$ = new_node("RelExp", $1,  $3, 0, 0, NULL ,"LT"); }
      | RelExp GT AddExp { $$ = new_node("RelExp", $1,  $3, 0, 0, NULL ,"GT"); }
      | RelExp LE AddExp  { $$ = new_node("RelExp", $1,  $3, 0, 0, NULL,"LE" ); }
      | RelExp GE AddExp { $$ = new_node("RelExp", $1,  $3, 0, 0, NULL ,"GE"); }
	;
EqExp: 
	RelExp { $$ = new_node("EqExp", NULL, $1, 0, 0, NULL,NULL ); }
	|EqExp EQ RelExp { $$ = new_node("EqExp",$1, $3, 0, 0, NULL,"EQ" ); }
	|EqExp NE RelExp { $$ = new_node("EqExp",$1, $3, 0, 0, NULL,"NE" ); }
	;
ConstExp:
	AddExp { $$ = new_node("ConstExp", NULL, $1, 0, 0, NULL,NULL ); }
	;

%%


void yyerror(char* str)
{
    fprintf(stderr, "error:%s\n", str);
}
int yywrap(){
	return 1;}
int main(int argc, char **argv)
{
	
	if(argc > 2 )
	{
		printf("argcs too many!.\n");
		return 0;
	}
	if(argc == 2)
	{
		yyin = fopen(argv[1],"r");
	}
	else
	{
		printf("no file input!\n");
   		return 1;
	}

	yyparse();
	display(root);

	return 0;

}