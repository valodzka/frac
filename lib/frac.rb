
require 'frac_ext'

module Math
  # Find rational approximation to given real number.
  def self.frac(float, prec)
    arr = find_fracs(float, prec)
    arr[2].abs > arr[5].abs ? Rational(arr[3], arr[4]) : Rational(arr[0], arr[1])
  end
end
