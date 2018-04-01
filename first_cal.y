%{

void yyerror (char *s);

#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>

int symbols[52];
int index = 0;
int line =1;
char temp = 'A';


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

%union {int num; char id; int cond; struct incod codes}         /* Yacc definitions */
%start line

%token print
%token exit_command
%token <num> number
%token <id> identifier

%token lt
%token gt
%token eq
%token lteq
%token gteq

%token while_statement
%token if_statement
%token else_statement

%type <num> line exp term
%type <id> assignment
%type <codes> condition

%%

line	        : assignment ';'      	{;}
				| line assignment ';'	{;}     
				| exit_command ';'      {printf("no errors encountered\n");}
				| print exp ';'         {;}
				| line exit_command ';' {printf("no errors encountered\n");}
				| line print exp ';'	{;}
				| while_command			{;}
				| line while_command	{;}
				| if_construct			{;}
				| line if_construct		{;}
				;

while_command	: while_statement '(' condition ')'
					'{' line '}'					{;}
				;

if_construct	: if_statement '(' condition ')'
					'{' line '}'					{;}
				| if_statement '(' condition ')'
					'{' line '}'
					else_statement '{' line '}'		{;}
				;

condition		: exp lt exp		{;}
				| exp gt exp		{;}
				| exp eq exp		{;}
				| exp lteq exp		{;}
				| exp gteq exp		{;}
				;



assignment  	: identifier '=' exp	{;}
				;

exp     		: term                  {;}
				| exp '+' term          {;}
				| exp '-' term          {;}
				;


term	    	: number                {;}
				| identifier            {;}
				;

%%                     /* C code */

struct incod code[20];

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

int addToTable(char operand, char operator1, char operator2)
{
	printf("operand =%c operator 1 =%c operator 2 =%c\n", operand, operator1, operator2);
	code[index].operator_1 = operator1;
	code[index].operator_2 = operator2;
	code[index].operand_ =  operand;
	index++;
	return index;

}

void tripleCode()
{
	int count = 0;
	printf("operand\toperator-1\toperator-2\n");
	while(count<index)
	{
		printf("%c\t", code[count].operand_);
		printf("%c\t\t", code[count].operator_1);
		printf("%c\n", code[count].operator_2);
		count++;
	}
}

int main (void)
{
	/* init symbol table */
	int i;
	for(i=0; i<52; i++) {
		symbols[i] = 0;
	}
	yyparse();


	//tripleCode();
}

void yyerror (char *s) {fprintf (stderr, "%s at line %d\n", s, line);}