#include <stdio.h>
#include <stdlib.h>  /* For exit() function */

#define SIZE 200 
char s[SIZE];   

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

   fprintf(fptr,"%s", sentence);
   fclose(fptr);
   printf("File written successfully\n");

   return 1;
}
