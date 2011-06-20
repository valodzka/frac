require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
  rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = %q{frac}
  gem.homepage = %q{https://github.com/valodzka/frac}
  gem.license = %q{}
  gem.summary = %q{Find rational approximation to given real number}
  gem.email = %q{pavel@valodzka.name}
  gem.authors = [%q{Pavel Valodzka}]
  gem.extensions = ["ext/extconf.rb"]
  gem.require_paths = ["lib"]
  gem.summary = <<-RDOC
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
  RDOC
end

require 'rake/extensiontask'
Rake::ExtensionTask.new do |ext|
  ext.ext_dir = 'ext'
  ext.lib_dir = 'lib'
  ext.name = 'frac_ext'
end

Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/*.rb'
  test.verbose = true
end

task :default => [ :compile, :test ]

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "frac #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

