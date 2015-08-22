require 'fileutils'
require 'tmpdir'

describe 'FPM::Package::Test' do
  let(:tempdir) { Dir.mktmpdir }
  after(:each) {
    FileUtils.remove_entry_secure tempdir
  }

  def execute(cmd)
    return eval `#{cmd.to_system.join(' ')} 2>/dev/null`
  end

  it "builds a directory" do
    dir = `pwd`.chomp
    cmd = Packager::Struct::Command.new(
      :executable => "ruby -I#{File.join(dir,'spec/lib')} -rfpm/package/test `which fpm`",
      :name => 'foo',
      :version => '0.0.1',
      :source => 'empty',
      :target => 'test',
    )

    Dir.chdir(tempdir) do
      execute(cmd)

      expect(File).to exist('foo.test')
      #Dir.
      #expect(
    end
  end
end
