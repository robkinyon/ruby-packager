require './spec/executor/context.rb'
require './spec/shared_context/workdir.rb'
describe Packager::Executor do
  include_context :executor
  include_context :workdir

  before(:each) {
    executor.workdir = workdir
  }

  it "creates a package with one file" do
    FileUtils.chdir(sourcedir) do
      FileUtils.touch('file1')
    end

    item = Packager::Struct::Package.new(
      :name => 'foo',
      :version => '0.0.1',
      :type => 'test',
      :files => [
        Packager::Struct::File.new(File.join(sourcedir, 'file1'), '/bar/file2'),
      ]
    )

    executor.execute_on([item])

    expect(executor.commands[0]).to eq(
      Packager::Struct::Command.new({
        :name => 'foo',
        :version => '0.0.1',
        :source => 'dir',
        :target => 'test',
        :directories => { 'bar' => true },
      })
    )
    expect(File.exists?(File.join('bar', 'file2'))).to be_truthy
  end

  it "creates a package with one link" do
    FileUtils.chdir(sourcedir) do
      FileUtils.touch('file1')
    end

    item = Packager::Struct::Package.new(
      :name => 'foo',
      :version => '0.0.1',
      :type => 'test',
      :files => [
        Packager::Struct::File.new(File.join(sourcedir, 'file1'), '/bar/file2', true),
      ]
    )
    FileUtils.chdir(workdir) do
      executor.execute_on([item])
    end
    expect(executor.commands[0]).to eq(
      Packager::Struct::Command.new({
        :name => 'foo',
        :version => '0.0.1',
        :source => 'dir',
        :target => 'test',
        :directories => { 'bar' => true },
      })
    )

    # Verify that /bar/file2 points to file1 as a symlink
    expect(File.symlink?(File.join(workdir, 'bar', 'file2'))).to be_truthy
  end
end
