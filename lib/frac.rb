require 'rational'
require File.join(File.dirname(__FILE__), %w{.. lib frac_ext})

# Rational approximation to given real number.
module Math

  class << self

    def frac(float, maxden)
      arr = find_fracs(float, maxden)
      arr[2].abs > arr[5].abs ? Rational(arr[3], arr[4]) : Rational(arr[0], arr[1])
    end

    if RUBY_PLATFORM =~ /java/
      require 'jruby'
      private
        def find_fracs(float, maxden)
          begin
            com.github.valodzka.frac.frac_ext.find_fracs Float(float), Integer(maxden)
          rescue Java::JavaLang::IllegalArgumentException => e
            raise ArgumentError, e.message
          end
        end
    else
      private :find_fracs
    end

  end

  class Fraction

    def initialize(float, maxden = 0x100)
      if float.is_a?(String)
        @r = 0
        sign = 1
        float.split(' ', 2).each do |part|
          if (part.include?("/"))
            @r += sign * Rational(*(part.split('/', 2).map(&method(:Integer))))
          else
            @r += Math.frac(part, maxden)
            sign = @r >= 0 ? 1 : -1
          end
        end
      else
        @r = Math.frac(float, maxden)
      end
    end

    def to_a
      i = @r.to_i
      sign = i >= 0 ? 1 : -1
      [ i, (@r.numerator - i * @r.denominator) * sign, @r.denominator ]
    end

    def to_r
      @r
    end

    def to_f
      @r.to_f
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

