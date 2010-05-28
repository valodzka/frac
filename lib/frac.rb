
require 'rational'
require File.join(File.dirname(__FILE__), %w{.. ext frac_ext})

module Math
  class << self
    # Find rational approximation to given real number.
    def frac(float, maxden)
      begin
        find_fracs_int(float, maxden)
      rescue RangeError
        begin
          find_fracs_long(float, maxden)
        rescue RangeError
          find_fracs_ll(float, maxden)
        end
      end
    end
  end
end
