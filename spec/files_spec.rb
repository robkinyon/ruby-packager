require 'tmpdir'

describe "Packager empty packages" do
  before(:all) { Packager::DSL.default_type('dir') }
  after(:all) { Packager::DSL.default_type = nil }

  let(:sourcedir) { Dir.mktmpdir }

  it "can create a package with files" do
    FileUtils.chdir(sourcedir) do
      FileUtils.touch('file1')
    end
    $sourcedir = sourcedir

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
    allow(Packager::Executor).to receive(:execute_command) {}
    rv = Packager::Executor.execute_on(item)
    expect(rv[0]).to eq([
      'fpm',
      '--name', 'foo',
      '--version', '0.0.1',
      '-s', 'dir',
      '-t', 'dir',
      'foo'
    ])

    # Need to verify that the file actually makes it there.
    # Either we need to inspect the build area (somehow) or actually
    # run the packager and inspect the result
  end
end
