require 'fileutils'
require 'tmpdir'

RSpec.shared_context :workdir do
  before(:all) { @dir = Dir.pwd }

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
end
