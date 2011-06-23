require 'test/unit'
require File.join(File.dirname(__FILE__), %w{.. lib frac})

class TC_Frac < Test::Unit::TestCase
  def test_frac
    [[ 0.333,    [1, 3],  0x100,    [0, 1, 3],     "1/3" ],
     [ 1.to_f/3, [1, 3],  0x100,    [0, 1, 3],     "1/3" ],
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
     [ "3.56",   [89, 25],  0x100,  [3, 14, 25], "3 14/25" ],
    ].each{|float, num_den, prec, n, s|
      assert_equal Rational(num_den[0], num_den[1]), Math.frac(float, prec), "#{float.inspect} -> #{num_den[0]} / #{num_den[1]}"
      assert_equal n, Math::Fraction.new(float, prec).to_a, "#{float.inspect} -> #{n}"
      assert_equal s, Math::Fraction.new(float, prec).to_s, "#{float.inspect} -> #{s}"
    }
  end
  
  def test_frac_strings
    [[ "0.333",     [0, 1, 3],     "1/3", 1.to_f / 3 ],
     [ "3.56",    [3, 14, 25], "3 14/25", 3.56 ],
     [ "3 1/8",     [3, 1, 8],   "3 1/8", 3.125 ],
     [ "-3 1/8",   [-3, 1, 8],  "-3 1/8", -3.125 ],
     [ "-1/8",     [0, -1, 8],    "-1/8", -0.125 ],
    ].each{|float, n, s, f|
      r = Math::Fraction.new(float)
      assert_equal n, r.to_a, "#{float.inspect} -> #{n}"
      assert_equal s, r.to_s, "#{float.inspect} -> #{s}"
      assert_equal f, r.to_f, "#{float.inspect} -> #{f}"
    }
  end
	
  def test_access
    assert_raise NoMethodError do
      Math.find_fracs 0.1, 0x100
    end
  end
	
  def test_frac_validation
    [[1.1, ''], [nil, 0x100], [1.1, 0], [1.5, -100]].each{|params|
      assert_raise ArgumentError, TypeError do
        Math.frac(*params)
      end
    }
  end

  def test_fractions_validation
    ['junk', 'junk 2/3', '10 junk/2', '11 3/junk', nil].each{|param|
      assert_raise ArgumentError, TypeError, "For param #{param}" do
        Math::Fraction.new(param)
      end
    }
  end
end
