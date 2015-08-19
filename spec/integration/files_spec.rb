require 'fileutils'
require 'tmpdir'

describe "Packager packages" do
  before(:all) { Packager::DSL.default_type('dir') }
  after(:all) { Packager::DSL.default_type = nil }

  let(:sourcedir) { Dir.mktmpdir }
  let(:workdir)   { Dir.mktmpdir }
  # Needed to clean up because doing the let() doesn't trigger the automatic
  # removal using the block form would do.
  after(:each) {
    FileUtils.remove_entry_secure(sourcedir)
    FileUtils.remove_entry_secure(workdir)
  }

  it "can create a package with no files" do
    items = Packager::DSL.execute_dsl {
      package {
        name 'foo'
        version '0.0.1'
      }
    }

    FileUtils.chdir(workdir) do
      executor = Packager::Executor.new
      executor.execute_on(items)
      expect(executor.command[0]).to eq([
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

    items = Packager::DSL.execute_dsl {
      package {
        name 'foo'
        version '0.0.1'

        file {
          source File.join($sourcedir, 'file1')
          dest "/foo/bar/file2"
        }
      }
    }

    # Stub out execute_command
    FileUtils.chdir(workdir) do
      executor = Packager::Executor.new
      executor.execute_on(items)
      expect(executor.command[0]).to eq([
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

    items = Packager::DSL.execute_dsl {
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
    }

    FileUtils.chdir(workdir) do
      executor = Packager::Executor.new
      executor.execute_on(items)
      expect(executor.command[0]).to eq([
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
