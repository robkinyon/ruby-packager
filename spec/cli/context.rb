# Examine:
# https://gabebw.wordpress.com/2011/03/21/temp-files-in-rspec/

require 'fileutils'
require 'tmpdir'

RSpec.shared_context :cli do
  subject(:cli) { Packager::CLI.new }

  let(:workdir) { Dir.mktmpdir }
  before(:all)  { @dir = Dir.pwd }
  before(:each) { FileUtils.chdir(workdir) }
  after(:each)  {
    FileUtils.chdir @dir
    FileUtils.remove_entry_secure(workdir)
  }
end
