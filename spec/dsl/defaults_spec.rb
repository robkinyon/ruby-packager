describe Packager::DSL do
  def parse(&block)
    Packager::DSL.execute_dsl(&block)
  end

  context "default type" do
    before(:all) { Packager::DSL.default_type('unknown') }
    after(:all) { Packager::DSL.default_type = nil }

    it "will use the default type" do
      items = parse {
        package {
          name 'foo'
          version '0.0.1'
        }
      }
      expect(items[0].type).to eq('unknown')
    end
  end
end
