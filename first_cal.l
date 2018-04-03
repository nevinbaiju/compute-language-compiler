%{
#include "y.tab.h"
%}
%%
"print"				   {return print;}
"exit"				   {return exit_command;}
"while"				   {return while_statement;}
"if"				   {return if_statement;}
"else"				   {return else_statement;}
"True"				   {return _true_;}
"False"				   {return _false_;}

"<"					   {return lt;}
">"					   {return gt;}
"=="				   {return eq; printf("equal to statement found");}
"<="				   {return lteq;}
">="				   {return gteq;}

[a-zA-Z]			   {yylval.id = yytext[0]; return identifier;}
[0-9]+                 {yylval.num = atoi(yytext); return number;}
[ \t\n]                ;
[-+=;*/(){}]           {return yytext[0];}
.                      {ECHO; yyerror ("unexpected character");}

%%
int yywrap (void) {return 1;}
