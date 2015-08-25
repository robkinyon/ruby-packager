require './spec/dsl/context.rb'
describe Packager::DSL do
  context "arguments" do
    include_context :dsl

    it "handles a name in the arguments" do
      items = parse_dsl {
        package 'foo' do
          version '0.0.1'
          type 'test'
        end
      }
      expect(items[0].name).to eq('foo')
    end
  end
end
