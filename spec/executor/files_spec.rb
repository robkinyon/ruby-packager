require './spec/executor/context.rb'
require './spec/shared_context/workdir.rb'
describe Packager::Executor do
  include_context :executor
  include_context :workdir

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
  end
end
