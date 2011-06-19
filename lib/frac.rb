require File.join(File.dirname(__FILE__), %w{.. lib frac_ext})

# Rational approximation to given real number.
module Math

  class << self
    private :find_fracs
    
    def frac(float, maxden)
      arr = find_fracs(float ? float.abs : nil, maxden)
      sign = float >= 0 ? 1 : -1
      arr[2].abs > arr[5].abs ? Rational(sign * arr[3], arr[4]) : Rational(sign * arr[0], arr[1])
    end
  end
  
  class Fraction

    def initialize(float, maxden = 0x100)
      @r = Math.frac(float, maxden)
    end
    
    def to_a
      i = @r.to_i
      sign = i >= 0 ? 1 : -1
      [ i, (@r.numerator - i * @r.denominator) * sign, @r.denominator ]
    end
    
    def to_r
      @r
    end

    def to_s
      n = to_a
      if n[1] == 0
        n[0].to_s
      elsif n[0] == 0
        "#{n[1]}/#{n[2]}"
      else
        "#{n[0]} #{n[1]}/#{n[2]}"
      end    
    end  
    
  end
end

