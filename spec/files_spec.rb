require 'tmpdir'

describe "Packager empty packages" do
  before(:all) { Packager::DSL.default_type('dir') }
  after(:all) { Packager::DSL.default_type = nil }

  # This won't work, but it's closer to what we want
  #module Globals
    let(:sourcedir) { Dir.mktmpdir }
    let(:workdir)   { Dir.mktmpdir }
  #end

  it "can create a package with files" do
    # This is a wart.
    $sourcedir = sourcedir

    FileUtils.chdir(sourcedir) do
      FileUtils.touch('file1')
    end

    item = Packager::DSL.execute_dsl {
      package {
        name 'foo'
        version '0.0.1'

        file {
          source File.join($sourcedir, 'file1')
          dest "/foo/bar/file2"
        }
      }
    }

    expect(item).to be_instance_of(Packager::DSL::Package)
    expect(item.name).to eq('foo')
    expect(item.version).to eq('0.0.1')
    expect(item.type).to eq('dir')
    expect(item.files).to be_instance_of(Array)
    expect(item.files[0]).to be_instance_of(Packager::DSL::File)
    expect(item.files[0].source).to eq(File.join(sourcedir, 'file1'))
    expect(item.files[0].dest).to eq("/foo/bar/file2")

    # Stub out execute_command
    FileUtils.chdir(workdir) do
      rv = Packager::Executor.execute_on(item)
      expect(rv[0]).to eq([
        'fpm',
        '--name', 'foo',
        '--version', '0.0.1',
        '-s', 'dir',
        '-t', 'dir',
        'foo'
      ])

      expect(File).to exist('foo.dir')
      expect(File).to exist('foo.dir/foo/bar/file2')
    end
  end
end
