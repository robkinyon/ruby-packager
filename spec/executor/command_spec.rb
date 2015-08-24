describe Packager::Struct::Command do
  it "creates a FPM command correctly" do
    cmd = Packager::Struct::Command.new(
      :name => 'foo',
      :version => '0.0.1',
      :target => 'test',
    )
    cmd.add_directory('foo')
    expect(cmd.to_system).to eq([
      'fpm',
      '--name', 'foo',
      '--version', '0.0.1',
      '-s', 'dir',
      '-t', 'test',
      'foo',
    ])
  end
end
