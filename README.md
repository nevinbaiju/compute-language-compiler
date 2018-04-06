# compute-language-compiler

## This is a language developed for compiler design assignment.



#### Has basic functionalities for number manipulation and boolean operation.

##### Main arithmetic operations.
> The main arithmetic operations available are +, -, *, /, %. 


##### Conditional statements.
> This programming language supports various conditional operations like <, >, ==. <=, >=.
It also supports assigning direct boolean values in the form of keywords 'True' and 'False'.

##### Variables.
> The variables can be assigned from [a-z] and [A-Z]. The symbol table implementation involves
a simple symbol table of 52 rows. And a simple hashing algorithm to fill in according to the 
ascending value of the variables is used. There is only one data type, i.e integer.
The result of a conditional statement can also be stored inside a variable.

##### Printing the result.
> The results can be print using the 'print' statement followed by an expression or an identifier.

##### Instructions.
> Basically there are two scripts included remove.sh and complie.sh.
They contain the necessary codes for cleaning up and compiling the codes respectively.
The output or the intermediate code representation is generated to the file program.txt
and the result can be seen in the command line itself.

```
./remove
./compile
./calc<input.in
```

##### Grammar

```
START			------>	LINE

LINE			------>	ASSIGNMENT 		| LINE ASSIGNMENT
					|	print EXP  		| LINE print EXP
					|	print CONDITION | LINE print CONDITION

condition 		------>	EXP lt EXP 		| EXP gt EXP
					|	EXP eq EXP 		| EXP lteq EXP
					| 	EXP gteq EXP 	| true
					| 	false

assignment 		------>	id = EXP 		| id = CONDITION

EXP 			------>	TERM 			| EXP + TERM          		
					| 	EXP - TERM

TERM			------>	ENDING_TERM 	| TERM * ENDING_TERM
					| 	TERM / ENDING TERM
					|	term % ENDING TERM

ENDING_TERM		------>	number 			| identifier

```

##### Three address code generation.
> The three address code generation is maintained by using the following structure,
```
struct threeADD
{
	char result[10];
	char operand_1[10];
	char operand_2[10];
	char operator[10];
} quadraple[50];
int index;
```
This is updated with every valid line encountered and it is represented as the result with a prefix _k and numbered from 0.
##### References
>	[Video Tutorial](https://www.youtube.com/watch?v=__-wUHG2rfM)
	[Github](https://github.com/jengelsma/yacc-tutorial)
