# Because of the vagaries of producing OS-specific packages on varying platforms,
# we will test command execution using a new output target for FPM called 'test.
# This target is based on the 'dir' target and exists in spec/lib.
#
# Note: We assume that fpm produces good packages of other types, given a correct
# invocations.

require 'fileutils'
require 'tmpdir'

describe "Packager integration" do
  before(:all) { Packager::DSL.default_type('test') }
  after(:all) { Packager::DSL.default_type = nil }

  # This is to get access to the 'test' FPM type in the FPM executable.
  before(:all) {
    @dir = Dir.pwd
    Packager::Struct::Command.default_executable = "ruby -I#{File.join(@dir,'spec/lib')} -rfpm/package/test `which fpm`"
  }
  after(:all) {
    Packager::Struct::Command.default_executable = 'fpm'
  }

  # Need to clean up because doing the let() doesn't trigger the automatic
  # removal using the block form of Dir.mktmpdir would do.
  let(:sourcedir) { Dir.mktmpdir }
  let(:workdir)   { Dir.mktmpdir }
  before(:each) { FileUtils.chdir(workdir) }
  after(:each)  {
    FileUtils.chdir @dir
    [sourcedir, workdir].each do |dir|
      FileUtils.remove_entry_secure(dir)
    end
  }

  it "can create a package with no files" do
    append_to_file('definition', "
      package {
        name 'foo'
        version '0.0.1'
      }
    ")

    FileUtils.chdir(workdir) do
      capture(:stdout) {
        Packager::CLI.start(['execute', './definition'])
      }

      verify_test_package('foo.test', {
        'name' => 'foo',
        'version' => '0.0.1',
      })
    end
  end

  it "can create a package with one file" do
    FileUtils.chdir(sourcedir) do
      FileUtils.touch('file1')
    end

    # This is a wart.
    $sourcedir = sourcedir

    append_to_file('definition', "
      package {
        name 'foo'
        version '0.0.1'

        file {
          source '#{File.join($sourcedir, 'file1')}'
          dest '/foo/bar/file2'
        }
      }
    ")

    # Stub out execute_command
    FileUtils.chdir(workdir) do
      capture(:stdout) {
        Packager::CLI.start(['execute', './definition'])
      }

      verify_test_package('foo.test', {
        'name' => 'foo',
        'version' => '0.0.1',
      }, {
        'foo/bar/file2' => '',
      })
    end
  end

  it "can create a package with two files" do
    FileUtils.chdir(sourcedir) do
      FileUtils.touch('file1')
      append_to_file('file3', 'stuff')
    end

    # This is a wart.
    $sourcedir = sourcedir

    append_to_file('definition', "
      package {
        name 'foo'
        version '0.0.1'

        file {
          source '#{File.join($sourcedir, 'file1')}'
          dest '/foo/bar/file2'
        }

        file {
          source '#{File.join($sourcedir, 'file3')}'
          dest '/bar/foo/file4'
        }
      }
    ")

    FileUtils.chdir(workdir) do
      capture(:stdout) {
        Packager::CLI.start(['execute', './definition'])
      }

      verify_test_package('foo.test', {
        'name' => 'foo',
        'version' => '0.0.1',
      }, {
        'foo/bar/file2' => '',
        'bar/foo/file4' => 'stuff',
      })
    end
  end
end
