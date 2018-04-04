%{

void yyerror (char *s);

#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <string.h>
#include "writefile.h"

int symbols[52];
int ind = 0;
int line =1;
char temp[10];
char lineW[100];

struct threeADD
{
	char result[10];
	char operand_1[10];
	char operand_2[10];
	char operator[10];
};

struct threeADD quadraple[20];
int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);
int addToTable(char operand, char operator1, char operator2);
void generateCode();

%}
%code requires {
	struct incod
	{
		char codeVariable[10];
		int val;
	};
}

%union {int num; char id; int cond; struct incod code;}         /* Yacc definitions */
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
%type <code> exp term ending_term //condition
%type <id> assignment

%left '+' '-'
%left '*' '/' '%'

%%

line	        : assignment ';'      	{;}
				| line assignment ';'	{;}     
				| exit_command ';'      {printf("no errors encountered\n");}
				| print exp ';'         {printf("%d\n", $2.val);}
				| line exit_command ';' {printf("no errors encountered\n");}
				| line print exp ';'	{printf("%d\n", $3.val);}
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


assignment  	: identifier '=' exp			{
													updateSymbolVal($1, $3.val);
													sprintf(temp, "%d", $3.val);
													sprintf(temp, "_k%d", ind);
													strcpy(quadraple[ind].result, temp);
													sprintf(temp, "%c", $1);
													strcpy(quadraple[ind].operand_1, temp);
													sprintf(temp, "%c", '=');
													strcpy(quadraple[ind].operator, temp);
													sprintf(temp, "%s", $3.codeVariable);
													strcpy(quadraple[ind].operand_2, temp);

													$$ = $3.val;
													ind++;

												}
				;

exp     		: term                  		{
													sprintf($$.codeVariable, "_k%d", ind);
													strcpy(quadraple[ind].result, $$.codeVariable);
													strcpy(quadraple[ind].operand_1, $1.codeVariable);
													$$.val = $1.val;
													ind++;
												}
				| exp '+' term          		{
													sprintf($$.codeVariable, "_k%d", ind);
													strcpy(quadraple[ind].result, $$.codeVariable);
													strcpy(quadraple[ind].operand_1, $1.codeVariable);
													strcpy(quadraple[ind].operand_2, $3.codeVariable);
													sprintf(temp, "%c", '+');
													strcpy(quadraple[ind].operator, temp);
													$$.val = $1.val+$3.val;
													ind++;
												}
				| exp '-' term          		{
													sprintf($$.codeVariable, "_k%d", ind);
													strcpy(quadraple[ind].result, $$.codeVariable);
													strcpy(quadraple[ind].operand_1, $1.codeVariable);
													strcpy(quadraple[ind].operand_2, $3.codeVariable);
													sprintf(temp, "%c", '-');
													strcpy(quadraple[ind].operator, temp);
													$$.val = $1.val-$3.val;
													ind++;
												}

term			: ending_term
				| term '*' ending_term          {
													sprintf($$.codeVariable, "_k%d", ind);
													strcpy(quadraple[ind].result, $$.codeVariable);
													strcpy(quadraple[ind].operand_1, $1.codeVariable);
													strcpy(quadraple[ind].operand_2, $3.codeVariable);
													sprintf(temp, "%c", '*');
													strcpy(quadraple[ind].operator, temp);
													$$.val = $1.val*$3.val;
													ind++;
												}
				| term '/' ending_term          {
													sprintf($$.codeVariable, "_k%d", ind);
													strcpy(quadraple[ind].result, $$.codeVariable);
													strcpy(quadraple[ind].operand_1, $1.codeVariable);
													strcpy(quadraple[ind].operand_2, $3.codeVariable);
													sprintf(temp, "%c", '/');
													strcpy(quadraple[ind].operator, temp);
													$$.val = $1.val/$3.val;
													ind++;
												}
				| term '%' ending_term          {
													sprintf($$.codeVariable, "_k%d", ind);
													strcpy(quadraple[ind].result, $$.codeVariable);
													strcpy(quadraple[ind].operand_1, $1.codeVariable);
													strcpy(quadraple[ind].operand_2, $3.codeVariable);
													sprintf(temp, "%c", '%');
													strcpy(quadraple[ind].operator, temp);
													$$.val = $1.val%$3.val;
													ind++;
												}
				;

ending_term	    : number                		{
													sprintf(temp, "%d", $1);
													sprintf($$.codeVariable, "_k%d", ind);
													strcpy(quadraple[ind].result, $$.codeVariable);
													strcpy(quadraple[ind].operand_1, temp);
													$$.val = $1;
													ind++;

												}
				| identifier            		{
													int value = symbolVal($1);
													if(value == NULL)
														yyerror("Variable not initialized");
													else
														{
															sprintf(temp, "%d", value);
															sprintf($$.codeVariable, "_k%d", ind);
															strcpy(quadraple[ind].result, $$.codeVariable);
															sprintf(temp, "%c", $1);
															strcpy(quadraple[ind].operand_1, temp);

															$$.val = value;
															ind++;
														}
												}
				;

%%                     /* C code */

int computeSymbolind(char token)
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
	int bucket = computeSymbolind(symbol);
	return symbols[bucket];
}

/* updates the value of a given symbol */
void updateSymbolVal(char symbol, int val)
{
	int bucket = computeSymbolind(symbol);
	symbols[bucket] = val;
}
void generateCode()
{
	int count = 0;
	char buffer[50];

	while(count < ind)
	{
		sprintf(buffer, "%s := %s %s %s", quadraple[count].result, quadraple[count].operand_1,
			quadraple[count].operator, quadraple[count].operand_2);
		writeLine(buffer);
		count++;
	}
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
	generateCode();


	//tripleCode();
}

void yyerror (char *s) {fprintf (stderr, "%s at line %d\n", s, line);}