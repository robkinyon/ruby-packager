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
    @dir = `pwd`.chomp
    @includedir = File.join(@dir,'spec/lib')
  }

  # Do all of our work within a temp directory
  let(:tempdir) { Dir.mktmpdir }
  before(:each) { Dir.chdir tempdir }
  after(:each) {
    Dir.chdir @dir
    FileUtils.remove_entry_secure tempdir
  }

  # FIXME: 2>/dev/null is to suppress a Bundler complaint about JSON.
  def execute(cmd)
    cmd.unshift "ruby -I#{@includedir} -rfpm/package/test `which fpm`"
    return eval `#{cmd.join(' ')} 2>/dev/null`
  end

  it "builds a directory" do
    execute([
      '--name foo',
      '--version 0.0.1',
      '-s empty',
      '-t test',
    ])

    expect(File).to exist('foo.test')
    expect(File).to exist('foo.test/META.json')
    expect(JSON.parse(IO.read('foo.test/META.json'))).to eq({
      'name' => 'foo',
      'version' => '0.0.1',
    })
    expect(Dir['foo.test/contents/*'].empty?).to be(true)
  end
end
