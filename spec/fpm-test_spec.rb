# Q.V. the initial comment in spec/integration/files_spec.rb
#
# Missing features:
# * dependencies
# * before/after scripts

require 'fileutils'
require 'tmpdir'

describe 'FPM::Package::Test' do
  # This is to get access to the 'test' FPM type in the FPM executable.
  before(:all) {
    dir = `pwd`.chomp
    Packager::Struct::Command.default_executable = "ruby -I#{File.join(dir,'spec/lib')} -rfpm/package/test `which fpm`"
  }
  after(:all) {
    Packager::Struct::Command.default_executable = 'fpm'
  }

  let(:tempdir) { Dir.mktmpdir }
  after(:each) {
    FileUtils.remove_entry_secure tempdir
  }

  # FIXME: 2>/dev/null is to suppress a Bundler complaint about JSON.
  def execute(cmd)
    return eval `#{cmd.to_system.join(' ')} 2>/dev/null`
  end

  it "builds a directory" do
    dir = `pwd`.chomp
    cmd = Packager::Struct::Command.new(
      :name => 'foo',
      :version => '0.0.1',
      :source => 'empty',
      :target => 'test',
    )

    Dir.chdir(tempdir) do
      execute(cmd)

      expect(File).to exist('foo.test')
      expect(File).to exist('foo.test/META.json')
      expect(JSON.parse(IO.read('foo.test/META.json'))).to eq({
        'name' => 'foo',
        'version' => '0.0.1',
      })
      expect(Dir['foo.test/contents/*'].empty?).to be(true)
    end
  end
end
