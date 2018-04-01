yacc -d first_cal.y
lex first_cal.l
gcc -g lex.yy.c y.tab.c -o calc
./calc<input.in 
