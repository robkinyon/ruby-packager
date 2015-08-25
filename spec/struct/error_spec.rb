class Packager::Struct::Testing < Packager::Struct.new(:foo, :bar)
end

describe Packager::Struct do
  context "throws an error if" do
    it "is passed an unknown parameter" do
      expect {
        Packager::Struct::Testing.new(:baz => 1)
      }.to raise_error('Passed in unknown params: baz')
    end
  end
end
