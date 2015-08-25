require 'fileutils'
require 'tmpdir'

RSpec.shared_context :integration do
  before(:all) { Packager::DSL.default_type('test') }
  after(:all) { Packager::DSL.default_type = nil }

  # This is to get access to the 'test' FPM type in the FPM executable.
  before(:all) {
    @dir = Dir.pwd
    Packager::Struct::Command.default_executable = "ruby -I#{File.join(@dir,'spec/lib')} -rfpm/package/test `which fpm`"
  }
  after(:all) {
    Packager::Struct::Command.default_executable = 'fpm'
  }

  # Need to clean up because doing the let() doesn't trigger the automatic
  # removal using the block form of Dir.mktmpdir would do.
  let(:sourcedir) { Dir.mktmpdir }
  let(:workdir)   { Dir.mktmpdir }
  before(:each) { FileUtils.chdir(workdir) }
  after(:each)  {
    FileUtils.chdir @dir
    [sourcedir, workdir].each do |dir|
      FileUtils.remove_entry_secure(dir)
    end
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
