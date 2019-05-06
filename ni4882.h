/*
 * ni4882.h
 */

/* Prologue */
#ifndef GAUCHE_NI4882_H
#define GAUCHE_NI4882_H

#include <gauche.h>
#include <gauche/extend.h>

#if __APPLE__
#include <NI4882/ni4882.h>
#else
#include \"ni4882.h\"
#endif

SCM_DECL_BEGIN



SCM_DECL_END

#endif  /* GAUCHE_NI4882_H */
