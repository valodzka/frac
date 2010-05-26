require 'test/unit'
require File.join(File.dirname(__FILE__), %w{.. lib frac})

class TC_Frac < Test::Unit::TestCase
  def test_frac
    [[ 0.333, 1,   3, 0x100],
     [ 0.77, 77, 100, 0x100],
     [ 0.2,   1,   5, 0x100],
     [ 2,     2,   1, 0x100],
     [-0.5,  -1,   2, 0x100],
     [ 0,     0,   1, 0x100],
     ["0.85",17,  20, 0x100],
     [ 0.5,   1,   2, '1000'],
     [ 0.001, 0,   1, 2]
    ].each{|float, num, den, prec|
      assert_equal Rational(num, den), Math.frac(float, prec), "#{float.inspect} -> #{num} / #{den}"
    }
  end
	
  def test_access
    assert_raise NoMethodError do
      Math.find_fracs 0.1, 0x100
    end
  end
	
  def test_validation
    [[1.1, ''], [nil, 0x100], [1.1, 0], [1.5, -100]].each{|params|
      assert_raise ArgumentError, TypeError do
        Math.frac(*params)
      end
    }
  end
end
