require 'packager/cli'

require 'tempfile'

# Examine:
# https://gabebw.wordpress.com/2011/03/21/temp-files-in-rspec/

def write_to_file(file, content)
  f = File.new(file, 'a+')
  f.write(content)
  f.flush # VERY IMPORTANT
  f.close
end

describe Packager::CLI do
  describe '#validate' do
    it "handles nothing passed" do
      expect {
        subject.validate
      }.to raise_error(Thor::Error, "No filenames provided for validate")
    end

    it "handles a non-existent filename" do
      expect {
        subject.validate('foo')
      }.to raise_error(Thor::Error, "'foo' cannot be found")
    end

    let(:tempfile) { Tempfile.new('foo').path }

    it "handles an empty file" do
      expect {
        subject.validate(tempfile)
      }.to raise_error(Thor::Error, "'#{tempfile}' produces nothing")
    end

    it "handles a bad file" do
      write_to_file(tempfile, 'package {}')

      expect {
        subject.validate(tempfile)
      }.to raise_error(Thor::Error, "'#{tempfile}' has the following errors:\nEvery package must have a name")
    end

    it "handles a file that works" do
      write_to_file(tempfile, "
        package {
          name 'foo'
          version '0.0.1'
          type 'dir'
        }
      ")

      expect(
        capture(:stdout) { subject.validate(tempfile) }
      ).to eq("'#{tempfile}' parses cleanly\n")
    end
  end
end
