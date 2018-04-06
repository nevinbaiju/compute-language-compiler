# compute-language-compiler

#### This is a language developed for compiler design assignment.

#### Has basic functionalities for number manipulation and boolean operation.

##### Main arithmetic operations.
> The main arithmetic operations available are +, -, *, /, %. 

##### Variables.
> The variables can be assigned from [a-z] and [A-Z]. The symbol table implementation involves
a simple symbol table of 52 rows. And a simple hashing algorithm to fill in according to the 
ascending value of the variables is used. There is only one data type, i.e integer.

##### Conditional statements.
> This programming language supports various conditional operations like <, >, ==. <=, >=.
It also supports assigning direct boolean values in the form of keywords 'True' and 'False'.

##### Printing the result.
> The results can be print using the 'print' statement followed by an expression or an identifier.

##### Three address code generation.
> The three address code generation is maintained by using the following structure,
'''
struct threeADD
{
	char result[10];
	char operand_1[10];
	char operand_2[10];
	char operator[10];
}quadrple[50];
int index;
'''
This is updated with every valid line encountered and the represented as the result with a prefix _k and numbered from 0.
