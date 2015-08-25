describe Packager::Struct::Command do
  context '#to_system' do
    it "handles empty packages" do
      expect(Packager::Struct::Command.new(
        :name => 'foo',
        :version => '0.0.1',
        :target  => 'test',
      ).to_system).to eq([
        'fpm',
        '--name', 'foo',
        '--version', '0.0.1',
        '-s', 'empty', '-t', 'test',
      ])
    end

    it "handles packages with files" do
      cmd = Packager::Struct::Command.new(
        :name => 'foo',
        :version => '0.0.1',
        :target  => 'test',
      )
      cmd.add_directory('foo')

      expect(cmd.to_system).to eq([
        'fpm',
        '--name', 'foo',
        '--version', '0.0.1',
        '-s', 'dir', '-t', 'test',
        'foo',
      ])
    end

    it "handles dependencies" do
      cmd = Packager::Struct::Command.new(
        :name => 'foo',
        :version => '0.0.1',
        :target  => 'test',
        :requires => ['foo'],
      )

      expect(cmd.to_system).to eq([
        'fpm',
        '--name', 'foo',
        '--version', '0.0.1',
        '--depends', 'foo',
        '-s', 'empty', '-t', 'test',
      ])
    end

    it "handles provides" do
      cmd = Packager::Struct::Command.new(
        :name => 'foo',
        :version => '0.0.1',
        :target  => 'test',
        :provides => ['foo'],
      )

      expect(cmd.to_system).to eq([
        'fpm',
        '--name', 'foo',
        '--version', '0.0.1',
        '--provides', 'foo',
        '-s', 'empty', '-t', 'test',
      ])
    end
  end
end
