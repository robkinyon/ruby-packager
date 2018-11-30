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

    it "handles before_install" do
      cmd = Packager::Struct::Command.new(
        :name => 'foo',
        :version => '0.0.1',
        :target  => 'test',
        :before_install => ['foo'],
      )

      expect(cmd.to_system).to eq([
        'fpm',
        '--name', 'foo',
        '--version', '0.0.1',
        '--before-install', 'foo',
        '-s', 'empty', '-t', 'test',
      ])
    end

    it "handles after_install" do
      cmd = Packager::Struct::Command.new(
        :name => 'foo',
        :version => '0.0.1',
        :target  => 'test',
        :after_install => ['foo'],
      )

      expect(cmd.to_system).to eq([
        'fpm',
        '--name', 'foo',
        '--version', '0.0.1',
        '--after-install', 'foo',
        '-s', 'empty', '-t', 'test',
      ])
    end

    it "handles before_remove" do
      cmd = Packager::Struct::Command.new(
        :name => 'foo',
        :version => '0.0.1',
        :target  => 'test',
        :before_remove => ['foo'],
      )

      expect(cmd.to_system).to eq([
        'fpm',
        '--name', 'foo',
        '--version', '0.0.1',
        '--before-remove', 'foo',
        '-s', 'empty', '-t', 'test',
      ])
    end

    it "handles after_remove" do
      cmd = Packager::Struct::Command.new(
        :name => 'foo',
        :version => '0.0.1',
        :target  => 'test',
        :after_remove => ['foo'],
      )

      expect(cmd.to_system).to eq([
        'fpm',
        '--name', 'foo',
        '--version', '0.0.1',
        '--after-remove', 'foo',
        '-s', 'empty', '-t', 'test',
      ])
    end

    it "handles before_upgrade" do
      cmd = Packager::Struct::Command.new(
        :name => 'foo',
        :version => '0.0.1',
        :target  => 'test',
        :before_upgrade => ['foo'],
      )

      expect(cmd.to_system).to eq([
        'fpm',
        '--name', 'foo',
        '--version', '0.0.1',
        '--before-upgrade', 'foo',
        '-s', 'empty', '-t', 'test',
      ])
    end

    it "handles after_upgrade" do
      cmd = Packager::Struct::Command.new(
        :name => 'foo',
        :version => '0.0.1',
        :target  => 'test',
        :after_upgrade => ['foo'],
      )

      expect(cmd.to_system).to eq([
        'fpm',
        '--name', 'foo',
        '--version', '0.0.1',
        '--after-upgrade', 'foo',
        '-s', 'empty', '-t', 'test',
      ])
    end
  end
end
