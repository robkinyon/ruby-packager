require File.expand_path('on_what', File.dirname(__FILE__))
$:.push File.expand_path('../lib', __FILE__)
require 'packager/version'

Gem::Specification.new do |s|
  s.name    = 'packager-dsl'
  s.version = Packager::VERSION
  s.author  = 'Rob Kinyon'
  s.email   = 'rob.kinyon@gmail.com'
  s.summary = 'DSL for creating packages'
  s.description = 'DSL for creating a package that is easy to work with.'
  s.license = 'MIT'
  s.homepage = 'https://github.com/robkinyon/ruby-packager'

  # Don't tramp along our dot-files, except for .rspec
  s.files         = `git ls-files`.split("\n").select { |filename|
    !filename.match(/^\./) || filename == '.rspec'
  }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- {bin}/*`.split("\n")
  s.require_paths = %w(lib)

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency 'dsl_maker', '~> 1.0', '>= 1.0.0'
  s.add_dependency 'fpm', '~> 1.4', '>= 1.1.0'
  s.add_dependency 'thor', '~> 0.0', '>= 0.19.0'

  s.add_development_dependency 'rake', '~> 10'
  s.add_development_dependency 'rspec', '~> 3.0.0', '>= 3.0.0'
  s.add_development_dependency 'simplecov', '~> 0'
  s.add_development_dependency 'rubygems-tasks', '~> 0'
  s.add_development_dependency 'json', '~> 1', '>=1.7.7'

  # To limit needed compatibility with versions of dependencies, only configure
  #   yard doc generation when *not* on Travis, JRuby, or 1.8
  if !on_travis? && !on_jruby? && !on_1_8?
    # Github flavored markdown in YARD documentation
    # http://blog.nikosd.com/2011/11/github-flavored-markdown-in-yard.html
    s.add_development_dependency 'yard', '>= 0.9.11'
    s.add_development_dependency 'redcarpet', '~> 3'
    s.add_development_dependency 'github-markup', '~> 1.3'
  end
end
