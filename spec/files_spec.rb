require 'tmpdir'

describe "Packager packages" do
  before(:all) { Packager::DSL.default_type('dir') }
  after(:all) { Packager::DSL.default_type = nil }

  let(:sourcedir) { Dir.mktmpdir }
  let(:workdir)   { Dir.mktmpdir }

  it "can create a package with no files" do
    item = Packager::DSL.execute_dsl {
      package {
        name 'foo'
        version '0.0.1'
      }
    }[0]

    expect(item).to be_instance_of(Packager::DSL::Package)
    expect(item.name).to eq('foo')
    expect(item.version).to eq('0.0.1')
    expect(item.type).to eq('dir')
    expect(item.files).to eq([])

    FileUtils.chdir(workdir) do
      rv = Packager::Executor.execute_on(item)
      expect(rv[0]).to eq([
        'fpm',
        '--name', 'foo',
        '--version', '0.0.1',
        '-s', 'empty',
        '-t', 'dir',
      ])

      expect(File).to exist('foo.dir')
      expect(Dir['foo.dir/*'].empty?).to be(true)
    end
  end

  it "can create a package with one file" do
    FileUtils.chdir(sourcedir) do
      FileUtils.touch('file1')
    end

    # This is a wart.
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
    }[0]

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

  it "can create a package with two file" do
    FileUtils.chdir(sourcedir) do
      FileUtils.touch('file1')
      FileUtils.touch('file3')
    end

    # This is a wart.
    $sourcedir = sourcedir

    item = Packager::DSL.execute_dsl {
      package {
        name 'foo'
        version '0.0.1'

        file {
          source File.join($sourcedir, 'file1')
          dest "/foo/bar/file2"
        }

        file {
          source File.join($sourcedir, 'file3')
          dest "/bar/foo/file4"
        }
      }
    }[0]

    expect(item).to be_instance_of(Packager::DSL::Package)
    expect(item.name).to eq('foo')
    expect(item.version).to eq('0.0.1')
    expect(item.type).to eq('dir')
    expect(item.files).to be_instance_of(Array)
    expect(item.files[0]).to be_instance_of(Packager::DSL::File)
    expect(item.files[0].source).to eq(File.join(sourcedir, 'file1'))
    expect(item.files[0].dest).to eq("/foo/bar/file2")
    expect(item.files[1]).to be_instance_of(Packager::DSL::File)
    expect(item.files[1].source).to eq(File.join(sourcedir, 'file3'))
    expect(item.files[1].dest).to eq("/bar/foo/file4")

    FileUtils.chdir(workdir) do
      rv = Packager::Executor.execute_on(item)
      expect(rv[0]).to eq([
        'fpm',
        '--name', 'foo',
        '--version', '0.0.1',
        '-s', 'dir',
        '-t', 'dir',
        'bar', 'foo'
      ])

      expect(File).to exist('foo.dir')
      expect(File).to exist('foo.dir/foo/bar/file2')
      expect(File).to exist('foo.dir/bar/foo/file4')
    end
  end
end
