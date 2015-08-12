require 'packager/cli'

require 'tempfile'

# Examine:
# https://gabebw.wordpress.com/2011/03/21/temp-files-in-rspec/

describe Packager::CLI do
  subject(:cli) { Packager::CLI.new }

  describe '#validate' do
    let(:definition) { Tempfile.new('foo').path }

    it "handles nothing passed" do
      expect {
        cli.validate
      }.to raise_error(Thor::Error, "No filenames provided for validate")
    end

    it "handles a non-existent filename" do
      expect {
        cli.validate('foo')
      }.to raise_error(Thor::Error, "'foo' cannot be found")
    end

    it "handles an empty file" do
      expect {
        cli.validate(definition)
      }.to raise_error(Thor::Error, "'#{definition}' produces nothing")
    end

    it "handles a bad file" do
      append_to_file(definition, 'package {}')

      expect {
        cli.validate(definition)
      }.to raise_error(Thor::Error, "'#{definition}' has the following errors:\nEvery package must have a name")
    end

    it "handles a file that works" do
      append_to_file(definition, "
        package {
          name 'foo'
          version '0.0.1'
          type 'dir'
        }
      ")

      expect(
        capture(:stdout) { cli.validate(definition) }
      ).to eq("'#{definition}' parses cleanly\n")
    end
  end
end
