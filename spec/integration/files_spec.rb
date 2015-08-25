# Because of the vagaries of producing OS-specific packages on varying platforms,
# we will test command execution using a new output target for FPM called 'test.
# This target is based on the 'dir' target and exists in spec/lib.
#
# Note: We assume that fpm produces good packages of other types, given a correct
# invocations.

require './spec/integration/context.rb'
describe "Packager integration" do
  context 'files' do
    include_context :integration

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

      append_to_file('definition', "
        package {
          name 'foo'
          version '0.0.1'

          file {
            source sourcedir('file1')
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

      append_to_file('definition', "
        package {
          name 'foo'
          version '0.0.1'

          file {
            source sourcedir('file1')
            dest '/foo/bar/file2'
          }

          file {
            source sourcedir('file3')
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
end
