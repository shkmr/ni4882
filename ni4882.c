/*
 * ni4882.c
 */

#include "ni4882.h"

extern void Scm_Init_ni4882lib(ScmModule*);

void Scm_Init_ni4882(void)
{
    ScmModule *mod;
    SCM_INIT_EXTENSION(ni4882);
    mod = SCM_MODULE(SCM_FIND_MODULE("ni4882", TRUE));
    Scm_Init_ni4882lib(mod);
}
