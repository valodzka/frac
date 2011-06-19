require 'test/unit'
require File.join(File.dirname(__FILE__), %w{.. lib frac})

class TC_Frac < Test::Unit::TestCase
  def test_frac
    [[ 0.333,    [1, 3],  0x100,    [0, 1, 3],     "1/3" ],
     [ 0.77,  [77, 100],  0x100, [0, 77, 100],  "77/100" ],
     [ 0.2,      [1, 5],  0x100,    [0, 1, 5],     "1/5" ],
     [ 2,        [2, 1],  0x100,    [2, 0, 1],       "2" ],
     [-0.5,     [-1, 2],  0x100,   [0, -1, 2],    "-1/2" ],
     [-1.5,     [-3, 2],  0x100,   [-1, 1, 2],  "-1 1/2" ],
     [-1.7,   [-17, 10],  0x100,  [-1, 7, 10],  "-1 7/10" ],
     [-2.7,   [-27, 10],     10,  [-2, 7, 10],  "-2 7/10" ],
     [ 0,        [0, 1],  0x100,    [0, 0, 1],       "0" ],
     [ 0.85,   [17, 20],  0x100,  [0, 17, 20],   "17/20" ],
     [ 0.5,      [1, 2], '1000',    [0, 1, 2],     "1/2" ],
     [ 0.001,    [0, 1],      2,    [0, 0, 1],       "0" ],
     [ 0.001, [1, 1000],   1000, [0, 1, 1000],  "1/1000" ],
     [ 3.56,   [89, 25],  0x100,  [3, 14, 25], "3 14/25" ],
    ].each{|float, num_den, prec, n, s|
      assert_equal Rational(num_den[0], num_den[1]), Math.frac(float, prec), "#{float.inspect} -> #{num_den[0]} / #{num_den[1]}"
      assert_equal n, Math::Fraction.new(float, prec).to_a, "#{float.inspect} -> #{n}"
      assert_equal s, Math::Fraction.new(float, prec).to_s, "#{float.inspect} -> #{s}"
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
