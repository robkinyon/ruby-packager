# Because of the vagaries of producing OS-specific packages on varying platforms,
# we will test command execution using a new output target for FPM called 'test.
# This target is based on the 'dir' target and exists in spec/lib.
#
# Note: We assume that fpm produces good packages of other types, given a correct
# invocations.

require 'fileutils'
require 'tmpdir'

describe "Packager packages" do
  before(:all) { Packager::DSL.default_type('test') }
  after(:all) { Packager::DSL.default_type = nil }

  # This is to get access to the 'test' FPM type in the FPM executable.
  before(:all) {
    dir = `pwd`.chomp
    Packager::Struct::Command.default_executable = "ruby -I#{File.join(dir,'spec/lib')} -rfpm/package/test `which fpm`"
  }
  after(:all) {
    Packager::Struct::Command.default_executable = 'fpm'
  }

  let(:sourcedir) { Dir.mktmpdir }
  let(:workdir)   { Dir.mktmpdir }
  # Need to clean up because doing the let() doesn't trigger the automatic
  # removal using the block form of Dir.mktmpdir would do.
  after(:each) {
    [sourcedir, workdir].each do |dir|
      FileUtils.remove_entry_secure(dir)
    end
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
      capture(:stdout) { executor.execute_on(items) }
      expect(executor.commands[0]).to eq(
        Packager::Struct::Command.new({
          :name => 'foo',
          :version => '0.0.1',
          :target => 'test',
        })
      )

      expect(File).to exist('foo.test')
      expect(File).to exist('foo.test/META.json')
      expect(JSON.parse(IO.read('foo.test/META.json'))).to eq({
        'name' => 'foo',
        'version' => '0.0.1',
        'requires' => [],
      })
      expect(Dir['foo.test/contents/*'].empty?).to be(true)
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
      capture(:stdout) { executor.execute_on(items) }
      expect(executor.commands[0]).to eq(
        Packager::Struct::Command.new({
          :name => 'foo',
          :version => '0.0.1',
          :source => 'dir',
          :target => 'test',
          :directories => { 'foo' => true },
        })
      )

      expect(File).to exist('foo.test')
      expect(File).to exist('foo.test/META.json')
      expect(JSON.parse(IO.read('foo.test/META.json'))).to eq({
        'name' => 'foo',
        'version' => '0.0.1',
        'requires' => [],
      })
      expect(File).to exist('foo.test/contents/foo/bar/file2')
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
      capture(:stdout) { executor.execute_on(items) }
      expect(executor.commands[0]).to eq(
        Packager::Struct::Command.new({
          :name => 'foo',
          :version => '0.0.1',
          :source => 'dir',
          :target => 'test',
          :directories => { 'foo' => true, 'bar' => true },
        })
      )

      expect(File).to exist('foo.test')
      expect(File).to exist('foo.test/META.json')
      expect(JSON.parse(IO.read('foo.test/META.json'))).to eq({
        'name' => 'foo',
        'version' => '0.0.1',
        'requires' => [],
      })
      expect(File).to exist('foo.test/contents/foo/bar/file2')
      expect(File).to exist('foo.test/contents/bar/foo/file4')
    end
  end
end
