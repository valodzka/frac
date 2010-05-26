require 'test/unit'
require File.join(File.dirname(__FILE__), %w{.. lib frac})

class TC_Frac < Test::Unit::TestCase
	def test_conversion
		prec = 0x100
		
		[[0.333, 1, 3], [0.77, 77, 100], [0.2, 1, 5]].each{|float, num, den|
			assert_equal Rational(num, den), Math.frac(float, prec), "#{float} -> #{num} / #{den}"
		}
	end
	
	def test_access
		assert_raise NoMethodError do
			Math.find_fracs 0.1, 0x100
		end
	end
	
	def test_params
		assert_raise TypeError do
			Math.frac(1.1, nil)
		end
		
		#assert_raise TypeError do
	#		Math.frac(nil, 0x100)
	#	end		
	end
end
