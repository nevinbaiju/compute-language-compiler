%{

void yyerror (char *s);

#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include "writefile.h"

int symbols[52];
int index = 0;
int line =1;
char temp = 'A';
char lineW[100];


int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);
int addToTable(char operand, char operator1, char operator2);
void tripleCode();

%}
%code requires {
	struct incod
	{
		char operator_1;
		char operator_2;
		char operand_;
	};
}

%union {int num; char id; int cond; struct incod codes; char symbol[10]}         /* Yacc definitions */
%start line

%token print
%token exit_command
%token <num> number
%token <id> identifier
%token <num> _true_
%token <num> _false_

%token lt
%token gt
%token eq
%token lteq
%token gteq

%token while_statement
%token if_statement
%token else_statement

%type <num> line 
%type <symbol> exp term ending_term //condition
%type <id> assignment

%left '+' '-'
%left '*' '/' '%'

%%

line	        : assignment ';'      	{;}
				| line assignment ';'	{;}     
				| exit_command ';'      {printf("no errors encountered\n");}
				| print exp ';'         {;}
				| line exit_command ';' {printf("no errors encountered\n");}
				| line print exp ';'	{printf("%s\n", $3);}
				//| while_command			{;}
				//| line while_command	{;}
				//| if_construct			{;}
				//| line if_construct		{;}
				;
/*

while_command	: while_statement '(' condition ')'
					'{' line '}'					{;}
				;

if_construct	: if_statement '(' condition ')'
					'{' line '}'					{printf("Label L0:");}
				| if_statement '(' condition ')'
					'{' line '}'
					else_statement '{' line '}'		{;}
				;
condition		: exp lt exp				{$$ = ($1<$3)? "1":"0";}
				| exp gt exp				{$$ = ($1>$3)? "1":"0";}
				| exp eq exp				{$$ = ($1==$3)? "1":"0";}
				| exp lteq exp				{$$ = ($1<=$3)? "1":"0";}
				| exp gteq exp				{$$ = ($1>=$3)? "1":"0";}
				| _true_					{$$ = 1;}
				| _false_					{$$ = 0;}
				| identifier				{$$ = (symbolVal($1)==1)? "1":"0";}
				;
*/


assignment  	: identifier '=' exp	{updateSymbolVal($1, $3);}
				;

exp     		: term                  		{
													sprintf($$, "_k%d", index);
													sprintf(lineW, "_k%d := %s", index, $1);
													writeLine(lineW);
													index++;
												}
				| exp '+' term          		{
													sprintf($$, "_k%d", index);
													sprintf(lineW, "_k%d := %s + %s", index, $1, $3);
													writeLine(lineW);
													index++;
												}
				| exp '-' term          		{
													sprintf($$, "_k%d", index);
													sprintf(lineW, "_k%d := %s - %s", index, $1, $3);
													writeLine(lineW);
													index++;
												}

term			: ending_term
				| term '*' ending_term          {
													sprintf($$, "_k%d", index);
													sprintf(lineW, "_k%d := %s * %s", index, $1, $3);
													writeLine(lineW);
													index++;
												}
				| term '/' ending_term          {
													sprintf($$, "_k%d", index);
													sprintf(lineW, "_k%d := %s / %s", index, $1, $3);
													writeLine(lineW);
													index++;
												}
				| term '%' ending_term          {
													sprintf($$, "_k%d", index);
													sprintf(lineW, "_k%d := %s % %s", index, $1, $3);
													writeLine(lineW);
													index++;
												}
				;

ending_term	    : number                		{sprintf($$, "%d", $1); }
				| identifier            		{
													int value = symbolVal($1);
													if(value == NULL)
														yyerror("Variable not initialized");
													else
														sprintf($$, "%d", value);
												}
				;

%%                     /* C code */

int computeSymbolIndex(char token)
{
	int idx = -1;
	if(islower(token)) {
		idx = token - 'a' + 26;
	} else if(isupper(token)) {
		idx = token - 'A';
	}
	return idx;
}

/* returns the value of a given symbol */
int symbolVal(char symbol)
{
	int bucket = computeSymbolIndex(symbol);
	return symbols[bucket];
}

/* updates the value of a given symbol */
void updateSymbolVal(char symbol, int val)
{
	int bucket = computeSymbolIndex(symbol);
	symbols[bucket] = val;
}

int main (void)
{
	/* init symbol table */
	/*
	int i;
	for(i=0; i<52; i++) {
		symbols[i] = 0;
	}*/
	yyparse();


	//tripleCode();
}

void yyerror (char *s) {fprintf (stderr, "%s at line %d\n", s, line);}