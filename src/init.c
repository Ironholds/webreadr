#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* FIXME: 
Check these declarations against the C/Fortran source code.
*/

/* .Call calls */
extern SEXP webreadr_internal_split_clf(SEXP);
extern SEXP webreadr_internal_split_squid(SEXP);

static const R_CallMethodDef CallEntries[] = {
  {"webreadr_internal_split_clf",   (DL_FUNC) &webreadr_internal_split_clf,   1},
  {"webreadr_internal_split_squid", (DL_FUNC) &webreadr_internal_split_squid, 1},
  {NULL, NULL, 0}
};

void R_init_webreadr(DllInfo *dll)
{
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}
