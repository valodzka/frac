# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{frac}
  s.version = "0.9.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Pavel Valodzka"]
  s.date = %q{2010-05-25}
  s.description = %q{Find rational approximation to given real number}
  s.email = %q{pavel@valodzka.name}
  s.extensions = ['ext/extconf.rb']
  s.files = %w{ext/frac_ext.c ext/extconf.rb lib/frac.rb}
  s.has_rdoc = false
  s.homepage = %q{http://github.com/valodzka/frac}
  s.require_paths = ["lib"]
  
  s.summary = <<-RDOC
Find rational approximation to given real number.

based on the theory of continued fractions
if x = a1 + 1/(a2 + 1/(a3 + 1/(a4 + ...)))
then best approximation is found by truncating this series
(with some adjustments in the last term).
Note the fraction can be recovered as the first column of the matrix
  ( a1 1 ) ( a2 1 ) ( a3 1 ) ...
  ( 1  0 ) ( 1  0 ) ( 1  0 )
  
Instead of keeping the sequence of continued fraction terms,
we just keep the last partial product of these matrices.
  RDOC

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2
  end
end
