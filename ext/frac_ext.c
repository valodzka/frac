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
#include <ruby.h>

#ifndef RFLOAT_VALUE
#  define RFLOAT_VALUE(v) RFLOAT(rb_Float(v))->value
#endif

static VALUE find_fracs(VALUE mod, VALUE rv, VALUE dv) 
{
  VALUE ret;
  long m[2][2];
  double startx, x = RFLOAT_VALUE(rb_Float(rv));
  long ai, maxden = NUM2LONG(rb_Integer(dv));

  if (maxden <= 0)
    rb_raise(rb_eArgError, "maximum denominator should be > 0");

  startx = x;

  /* initialize matrix */
  m[0][0] = m[1][1] = 1;
  m[0][1] = m[1][0] = 0;

  /* loop finding terms until denom gets too big */
  while (m[1][0] *  ( ai = (long)x ) + m[1][1] <= maxden) {
    long t;
    t = m[0][0] * ai + m[0][1];
    m[0][1] = m[0][0];
    m[0][0] = t;
    t = m[1][0] * ai + m[1][1];
    m[1][1] = m[1][0];
    m[1][0] = t;
    if(x==(double)ai) break;     // AF: division by zero
    x = 1/(x - (double) ai);
    if(x>(double)0x7FFFFFFF) break;  // AF: representation failure
  } 

  {
    /* now remaining x is between 0 and 1/ai */
    /* approx as either 0 or 1/m where m is max that will fit in maxden */
    /* first try zero */
    VALUE num1, den1, err1, num2, den2, err2;

    num1 = LONG2NUM(m[0][0]);
    den1 = LONG2NUM(m[1][0]);
    err1 = rb_float_new(startx - ((double) m[0][0] / (double) m[1][0]));

    /* now try other possibility */
    ai = (maxden - m[1][1]) / m[1][0];
    m[0][0] = m[0][0] * ai + m[0][1];
    m[1][0] = m[1][0] * ai + m[1][1];

    num2 = LONG2NUM(m[0][0]);
    den2 = LONG2NUM(m[1][0]);
    err2 = rb_float_new(startx - ((double) m[0][0] / (double) m[1][0]));

    return rb_ary_new3(6, num1, den1, err1, num2, den2, err2);
  }
}

void Init_frac_ext() 
{
  rb_define_module_function(rb_mMath, "find_fracs", find_fracs, 2);
}
