# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name = "frac"
  s.version = "0.9.3"

  s.authors = [ "Pavel Valodzka" ]
  s.email = "pavel@valodzka.name"
  s.homepage = "https://github.com/valodzka/frac"

  s.files = `git ls-files`.split("\n")
  if RUBY_PLATFORM =~ /java/
    s.platform = "java"
    s.files << "lib/frac_ext.jar"
  else
    s.extensions = [ "ext/extconf.rb" ]
  end

  s.licenses = [ "MIT" ]
  s.require_paths = [ "lib" ]
  s.rubygems_version = "1.6.2"
  s.summary = <<-SUMMARY
Find rational approximation to given real number.

Based on the theory of continued fractions

  if x = a1 + 1/(a2 + 1/(a3 + 1/(a4 + ...)))

then best approximation is found by truncating this series
(with some adjustments in the last term).
Note the fraction can be recovered as the first column of the matrix

  ( a1 1 ) ( a2 1 ) ( a3 1 ) ...
  ( 1  0 ) ( 1  0 ) ( 1  0 )

Instead of keeping the sequence of continued fraction terms,
we just keep the last partial product of these matrices.
  SUMMARY

  s.add_development_dependency("rake", "~> 10.0")
  s.add_development_dependency("rake-compiler")
  s.add_development_dependency("rcov", "~> 0.9")
  s.add_development_dependency("rdoc")
end
