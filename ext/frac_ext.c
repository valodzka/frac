/*
** find rational approximation to given real number
** David Eppstein / UC Irvine / 8 Aug 1993
**
** With corrections from Arno Formella, May 2008
**
** usage: a.out r d
**   r is real number to approx
**   d is the maximum denominator allowed
**
** based on the theory of continued fractions
** if x = a1 + 1/(a2 + 1/(a3 + 1/(a4 + ...)))
** then best approximation is found by truncating this series
** (with some adjustments in the last term).
**
** Note the fraction can be recovered as the first column of the matrix
**  ( a1 1 ) ( a2 1 ) ( a3 1 ) ...
**  ( 1  0 ) ( 1  0 ) ( 1  0 )
** Instead of keeping the sequence of continued fraction terms,
** we just keep the last partial product of these matrices.
*/

#include <stdio.h>
#include <math.h>
#include <ruby.h>

#ifndef RFLOAT_VALUE
#  define RFLOAT_VALUE(v) RFLOAT(rb_Float(v))->value
#endif

/*
// #ifdef HAVE_LONG_LONG
// #  define N_TYPE LONG_LONG
// #  define R2N(x) NUM2LL(x)
// #  define N2R(x) LL2NUM(x)
// #else
// #define N_TYPE long
// #define R2N(x) NUM2LONG(x)
// #define N2R(x) LONG2NUM(x)
// #endif

// #define  N_TYPE int
// #define  R2N(x) NUM2INT(x)
// #define  N2R(x) INT2NUM(x)

*/

#define FIND_FRACS(fname, ltype, r2n, n2r)              \
static VALUE fname(VALUE mod, VALUE rv, VALUE dv)      \
{                                                      \
  ltype  m[2][2], ai, maxden = r2n(rb_Integer(dv));    \
  double startx, x = RFLOAT_VALUE(rb_Float(rv));       \
                                                       \
  if (maxden <= 0)                                     \
    rb_raise(rb_eArgError, "maximum denominator should be > 0"); \
                                                       \
  startx = x;                                          \
                                                       \
  /* initialize matrix */                              \
  m[0][0] = m[1][1] = 1;                               \
  m[0][1] = m[1][0] = 0;                               \
                                                       \
  /* loop finding terms until denom gets too big */    \
  while (m[1][0] *  ( ai = (ltype)x ) + m[1][1] <= maxden) { \
    ltype t;                                           \
    t = m[0][0] * ai + m[0][1];                        \
    m[0][1] = m[0][0];                                 \
    m[0][0] = t;                                       \
    t = m[1][0] * ai + m[1][1];                        \
    m[1][1] = m[1][0];                                 \
    m[1][0] = t;                                        \
    if(x==(double)ai) break;     /* AF: division by zero */      \
    x = 1/(x - (double) ai);    \
    if(x>(double)0x7FFFFFFF) break;  /* AF: representation failure */ \
  } \
    \
  { \
     /* now remaining x is between 0 and 1/ai */  \
     /* approx as either 0 or 1/m where m is max that will fit in maxden */ \
     /* first try zero */                         \
    double derr1, derr2;                          \
    ltype lnum1, lden1, lnum2, lden2;          \
                                              \
    lnum1 = m[0][0];                      \
    lden1 = m[1][0];                      \
    derr1 = startx - ((double) m[0][0] / (double) m[1][0]); \
                                              \
    /* now try other possibility */           \
    ai = (maxden - m[1][1]) / m[1][0];        \
    m[0][0] = m[0][0] * ai + m[0][1];         \
    m[1][0] = m[1][0] * ai + m[1][1];         \
                                              \
    lnum2 = n2r(m[0][0]);                      \
    lden2 = n2r(m[1][0]);                      \
    derr2 = rb_float_new(startx - ((double) m[0][0] / (double) m[1][0])); \
                                              \
    return fabs(derr1) < fabs(derr2) ? rb_Rational(n2r(lnum1), n2r(lden1)) : rb_Rational(n2r(lnum2), n2r(lden2)); \
  }                                           \
}                                             

FIND_FRACS(find_fracs_long, long, NUM2LONG, LONG2NUM)
FIND_FRACS(find_fracs_ll, LONG_LONG, NUM2LL, LL2NUM)
FIND_FRACS(find_fracs_int, int, NUM2INT, INT2NUM)

void Init_frac_ext() 
{
  rb_define_module_function(rb_mMath, "find_fracs_long", find_fracs_long, 2);
  rb_define_module_function(rb_mMath, "find_fracs_ll", find_fracs_ll, 2);
  rb_define_module_function(rb_mMath, "find_fracs_int", find_fracs_int, 2);
}
