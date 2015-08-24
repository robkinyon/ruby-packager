describe Packager::Executor do
  class Packager::Struct::TestCommand < Packager::Struct.new(:command)
    def to_system
      command
    end
  end
  context "#execute_command" do
    it "handles errors" do
      cmd = Packager::Struct::TestCommand.new(
        :command => ["echo '{:error=>\"foo\"}'"]
      )
      expect {
        subject.execute_command(cmd)
      }.to raise_error('foo')
    end

    it "handles success" do
      cmd = Packager::Struct::TestCommand.new(
        :command => ["echo '{:path=>\"foo\"}'"]
      )
      expect(subject.execute_command(cmd)).to eq('foo')
    end
  end
end
