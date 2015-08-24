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

require 'packager/cli'
require 'tempfile'
def append_to_file(file, content)
  File.open(file, 'a+') do |f|
    f.write(content)
    f.flush # VERY IMPORTANT
  end
end

# This is used to verify the FPM/test package format is created properly.
def verify_test_package(name, metadata={}, files={})
  expect(File).to exist(name)
  expect(File).to exist(File.join(name, 'META.json'))
  expect(JSON.parse(IO.read(File.join(name, 'META.json')))).to eq({
    'requires' => [],
  }.merge(metadata))
  if files.empty?
    expect(Dir[File.join(name, 'contents/*')].empty?).to be(true)
  else
    file_expectations = files.clone
    Dir[File.join(name, 'contents/**/*')].each do |filename|
      if File.file?(filename)
        content = IO.read(filename)
        filename.gsub! /#{File.join(name, 'contents', '')}/, ''

        expect(file_expectations).to have_key(filename)
        expect(file_expectations[filename]).to eq(content)
        file_expectations.delete(filename)
      end
    end
    expect(file_expectations).to be_empty
  end
end
