#include <string.h>

char * strpbrk(pat1, pat2)

    register char *pat1;    /* target patterno */   
    char *pat2;             /* list of characters to search for */
{

    register char *cp1, *cp2;

    cp1 = pat2;

    while (*cp1 != '\0') {
       if ((cp2 = index(pat1, *cp1)) != (char *) 0)
           return(cp2); 
       cp1++;
    }

    return((char *) 0);
}

