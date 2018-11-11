require './spec/dsl/context.rb'
describe Packager::DSL do
  context 'adding a helper' do
    include_context :dsl

    before(:each) do
      if not subject.class.has_helper? :test_helper
        subject.class.add_helper(:test_helper) { 'testing' }
      end
    end

    it 'finds the test_helper' do
      items = parse_dsl {
        package do
          name test_helper
          version '0.0.1'
          type 'test'
        end
      }
      expect(items[0].name).to eq('testing')
    end
  end
end
