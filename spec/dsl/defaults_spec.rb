describe Packager::DSL do
  context "default type" do
    before(:all) { Packager::DSL.default_type('dir') }
    after(:all) { Packager::DSL.default_type = nil }

    it "will use the default type" do
      items = Packager::DSL.execute_dsl {
        package {
          name 'foo'
          version '0.0.1'
        }
      }
      expect(items[0].type).to eq('dir')
    end
  end
end
