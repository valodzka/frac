package com.github.valodzka.frac;

import java.io.IOException;
import java.lang.IllegalArgumentException;

import org.jruby.Ruby;
import org.jruby.anno.JRubyMethod;

public class frac_ext {

  @JRubyMethod
  public static double[] find_fracs(double rv, long dv)
  {
    long m[][] = new long[2][2];
    long ai;
    long maxden = dv;
    double startx = rv;
    double x = rv;

    int sign = 1;

    if (maxden <= 0) {
      throw new IllegalArgumentException("maximum denominator should be > 0");
    }

    if (x < 0) {
      sign = -1;
      x = -x;
    }

    startx = x;

    /* initialize matrix */
    m[0][0] = m[1][1] = 1;
    m[0][1] = m[1][0] = 0;

    /* loop finding terms until denom gets too big */
    while (m[1][0] *  ( ai = (long) x ) + m[1][1] <= maxden) {
      long t;
      t = m[0][0] * ai + m[0][1];
      m[0][1] = m[0][0];
      m[0][0] = t;
      t = m[1][0] * ai + m[1][1];
      m[1][1] = m[1][0];
      m[1][0] = t;
      if(x == (long) ai) break;     // AF: division by zero
      x = 1/(x - ai);
      if(x > (double) 0x7FFFFFFF) break;  // AF: representation failure
    }

    {
      /* now remaining x is between 0 and 1/ai */
      /* approx as either 0 or 1/m where m is max that will fit in maxden */
      /* first try zero */
      double num1 = sign*m[0][0];
      double den1 = m[1][0];
      double err1 = startx - (m[0][0] / m[1][0]);

      /* now try other possibility */
      ai = (maxden - m[1][1]) / m[1][0];
      m[0][0] = m[0][0] * ai + m[0][1];
      m[1][0] = m[1][0] * ai + m[1][1];

      double num2 = sign*m[0][0];
      double den2 = m[1][0];
      double err2 = startx - (m[0][0] / m[1][0]);

      return new double[]{ num1, den1, err1, num2, den2, err2 };
    }

  }

};
