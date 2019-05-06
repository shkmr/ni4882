/*
 * ni4882.c
 */

#include "ni4882.h"

/*
 * The following function is a dummy one; replace it for
 * your C function definitions.
 */

ScmObj test_ni4882(void)
{
    return SCM_MAKE_STR("ni4882 is working");
}

/*
 * Module initialization function.
 */
extern void Scm_Init_ni4882lib(ScmModule*);

void Scm_Init_ni4882(void)
{
    ScmModule *mod;

    /* Register this DSO to Gauche */
    SCM_INIT_EXTENSION(ni4882);

    /* Create the module if it doesn't exist yet. */
    mod = SCM_MODULE(SCM_FIND_MODULE("ni4882", TRUE));

    /* Register stub-generated procedures */
    Scm_Init_ni4882lib(mod);
}
