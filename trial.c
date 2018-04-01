#include <stdio.h>

int main()
{
	writeLine("this is a line");
}
int writeLine(char s[])
{
   char sentence[1000];
   FILE *fptr;

   fptr = fopen("program.txt", "a");
   if(fptr == NULL)
   {
      printf("Error opening output file");
      return 0;
   }

   fprintf(fptr,"%s\n", s);
   fclose(fptr);

   return 1;
}
