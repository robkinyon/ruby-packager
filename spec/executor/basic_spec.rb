describe Packager::Executor do
  subject(:executor) { Packager::Executor.new(:dryrun => true) }

  it "creates an empty directory" do
    item = Packager::Struct::Package.new(
      :name => 'foo',
      :version => '0.0.1',
      :type => 'dir',
    )
    executor.execute_on([item])
    expect(executor.commands[0]).to eq(
      Packager::Struct::Command.new({
        :name => 'foo',
        :version => '0.0.1',
        :source => 'empty',
        :target => 'dir',
      })
    )
  end

  let(:sourcedir) { Dir.mktmpdir }
  let(:workdir)   { Dir.mktmpdir }
  # Need to clean up because doing the let() doesn't trigger the automatic
  # removal using the block form of Dir.mktmpdir would do.
  after(:each) {
    [sourcedir, workdir].each do |dir|
      FileUtils.remove_entry_secure(dir)
    end
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
