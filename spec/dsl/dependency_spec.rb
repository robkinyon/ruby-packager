require './spec/dsl/context.rb'
describe Packager::DSL do
  include_context :dsl

  context "requires" do
    it "handles a dependency" do
      items = parse_dsl {
        package {
          name 'foo'
          version '0.0.1'
          type 'test'
          requires 'foo'
        }
      }
      expect(items[0].requires).to be_instance_of(Array)
      expect(items[0].requires[0]).to eq('foo')
    end

    it "handles multiple dependencies" do
      items = parse_dsl {
        package {
          name 'foo'
          version '0.0.1'
          type 'test'
          requires 'foo', 'bar'
          requires 'baz'
        }
      }
      expect(items[0].requires).to be_instance_of(Array)
      expect(items[0].requires).to eq([ 'foo', 'bar', 'baz' ])
    end
  end

  context "provides" do
    it "handles a provides" do
      items = parse_dsl {
        package {
          name 'foo'
          version '0.0.1'
          type 'test'
          provides 'foo'
        }
      }
      expect(items[0].provides).to be_instance_of(Array)
      expect(items[0].provides[0]).to eq('foo')
    end

    it "handles multiple dependencies" do
      items = parse_dsl {
        package {
          name 'foo'
          version '0.0.1'
          type 'test'
          provides 'foo', 'bar'
          provides 'baz'
        }
      }
      expect(items[0].provides).to be_instance_of(Array)
      expect(items[0].provides).to eq([ 'foo', 'bar', 'baz' ])
    end
  end
end
