# Because of the vagaries of producing OS-specific packages on varying platforms,
# we will test command execution using fpm's "dir" output target. This target does
# not have many of the features we want to exercise, but it will give us *some*
# confidence that our invocation of fpm is correct.
#
# Note: We assume that fpm produces good packages, given correct invocations.
#
# Missing features:
# * dependencies
# * before/after scripts
# * actual installation

require 'tmpdir'

describe "Packager Executor" do
  it "creates an empty directory" do
    Dir.mktmpdir do |tmpdir|
      FileUtils.chdir(tmpdir) do
        item = Packager::DSL::Package.new('foo', '0.0.1', 'dir', [])
        Packager::Executor.execute_on([item])
        expect(File).to exist('foo.dir')
      end
    end
  end
end
