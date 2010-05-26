
require 'rational'
require 'frac_ext'

module Math
  class << self
    private :find_fracs

    # Find rational approximation to given real number.
    def frac(float, maxden)
      arr = find_fracs(Float(float), Integer(maxden))
      arr[2].abs > arr[5].abs ? Rational(arr[3], arr[4]) : Rational(arr[0], arr[1])
    end
  end
end
