#include <stdio.h>

#include "bootstrap.h"

/* @opam//install -- pkg */
int main(int argc, char *argv[]) // , char **envp)
{
    return opam_main(argc, argv);
}
