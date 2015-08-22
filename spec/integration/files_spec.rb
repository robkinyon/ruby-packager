require 'fileutils'
require 'tmpdir'

describe "Packager packages" do
  before(:all) { Packager::DSL.default_type('test') }
  after(:all) { Packager::DSL.default_type = nil }

  before(:all) {
    dir = `pwd`.chomp
    Packager::Struct::Command.default_executable = "ruby -I#{File.join(dir,'spec/lib')} -rfpm/package/test `which fpm`"
  }
  after(:all) {
    Packager::Struct::Command.default_executable = 'fpm'
  }

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
      capture(:stdout) { executor.execute_on(items) }
      expect(executor.commands[0]).to eq(
        Packager::Struct::Command.new({
          :name => 'foo',
          :version => '0.0.1',
          :source => 'empty',
          :target => 'test',
        })
      )

      expect(File).to exist('foo.test')
      expect(File).to exist('foo.test/META.json')
      expect(JSON.parse(IO.read('foo.test/META.json'))).to eq({
        'name' => 'foo',
        'version' => '0.0.1',
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
      })
      expect(File).to exist('foo.test/contents/foo/bar/file2')
      expect(File).to exist('foo.test/contents/bar/foo/file4')
    end
  end
end
