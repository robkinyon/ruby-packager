require 'fileutils'
require 'tmpdir'

require './spec/shared_context/workdir.rb'
RSpec.shared_context :integration do
  include_context :workdir

  before(:all) { Packager::DSL.default_type('test') }
  after(:all) { Packager::DSL.default_type = nil }

  # This is to get access to the 'test' FPM type in the FPM executable.
  before(:all) {
    Packager::Struct::Command.default_executable =
      "ruby -I#{File.join(@dir,'spec/lib')} -rfpm/package/test `which fpm`"
  }
  after(:all) {
    Packager::Struct::Command.default_executable = 'fpm'
  }

  before(:each) { $sourcedir = sourcedir }
  before(:all) {
    Packager::DSL.add_helper(:sourcedir) do |path|
      File.join($sourcedir, path)
    end
  }
  after(:all) {
    Packager::DSL.remove_helper(:sourcedir)
  }
end
