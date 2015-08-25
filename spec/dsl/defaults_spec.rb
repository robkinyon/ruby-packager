require './spec/dsl/context.rb'
describe Packager::DSL do
  context "default type" do
    include_context :dsl

    before(:all) { Packager::DSL.default_type('unknown') }
    after(:all) { Packager::DSL.default_type = nil }

    it "will use the default type" do
      items = parse_dsl {
        package {
          name 'foo'
          version '0.0.1'
        }
      }
      expect(items[0].type).to eq('unknown')
    end
  end
end
