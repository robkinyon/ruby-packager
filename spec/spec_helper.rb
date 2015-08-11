require File.expand_path('on_what', File.dirname(File.dirname(__FILE__)))

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

unless on_1_8?
  begin
    require 'simplecov'

    SimpleCov.configure do
      add_filter '/spec/'
      add_filter '/vendor/'
      minimum_coverage 100
      refuse_coverage_drop
    end

    if on_travis?
      require 'codecov'
      SimpleCov.formatter = SimpleCov::Formatter::Codecov
    end

    SimpleCov.start
  rescue LoadError
    puts "Coverage is disabled - install simplecov to enable."
  end
end

require 'packager'

# This is taken from:
# https://github.com/erikhuda/thor/blob/d634d240bdc0462fe677031e1dc6ed656e54f27e/spec/helper.rb#L49
# Found via http://bokstuff.com/blog/testing-thor-command-lines-with-rspec/
def capture(stream)
  begin
    stream = stream.to_s
    eval "$#{stream} = StringIO.new"
    yield
    result = eval("$#{stream}").string
  ensure
    eval("$#{stream} = #{stream.upcase}")
  end

  result
end
