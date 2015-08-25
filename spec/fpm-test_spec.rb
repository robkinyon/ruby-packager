# Q.V. the initial comment in spec/integration/files_spec.rb
#
# Missing features:
# * dependencies
# * before/after scripts

require 'tempfile'

require './spec/integration/context.rb'
require './spec/shared_context/workdir.rb'
describe 'FPM::Package::Test' do
  include_context :workdir
  include_context :test_package

  # This is to get access to the 'test' FPM type in the FPM executable.
  before(:all) {
    includedir = File.join(@dir,'spec/lib')
    @fpm = "ruby -I#{includedir} -rfpm/package/test `which fpm`"
  }

  # FIXME: 2>/dev/null is to suppress a Gem::Specification complaint about JSON.
  # After 'bundle install', Ruby 2.2 has JSON 1.8.3 and 1.8.1 (default) installed
  # and something gets confused because both are sufficient for JSON >= 1.7.7
  # You can disable it by setting the envvar VERBOSE=1
  def execute(cmd)
    cmd.unshift @fpm
    cmd.push '2>/dev/null' unless ENV['VERBOSE'] && ENV['VERBOSE'] != '0'
    return eval `#{cmd.join(' ')}`# 
  end

  it "creates an empty package" do
    execute([
      '--name foo',
      '--version 0.0.1',
      '-s empty',
      '-t test',
    ])

    verify_test_package('foo.test', {
      'name' => 'foo',
      'version' => '0.0.1',
    })
  end

  it "creates an empty package with dependencies" do
    execute([
      '--name foo',
      '--version 0.0.2',
      '--depends baz',
      '--depends bar',
      '-s empty',
      '-t test',
    ])

    verify_test_package('foo.test', {
      'name' => 'foo',
      'version' => '0.0.2',
      'requires' => [ 'bar', 'baz' ],
    })
  end

  it "creates a package with files" do
    append_to_file('foo', 'stuff')

    execute([
      '--name foo',
      '--version 0.0.1',
      '-s dir',
      '-t test',
      'foo'
    ])

    verify_test_package('foo.test', {
      'name' => 'foo',
      'version' => '0.0.1',
    }, {
      'foo' => 'stuff',
    })
  end
end
