require 'packager/cli'

describe Packager::CLI do
  describe '#validate' do
    let(:output) { capture(:stdout) { subject.validate } }
    it "handles nothing passed" do
      expect {
        output
      }.to raise_error(Thor::Error, "No filenames provided for validate")
    end
  end
end
