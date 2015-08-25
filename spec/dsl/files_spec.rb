require './spec/dsl/context.rb'
describe Packager::DSL do
  context "files" do
    include_context :dsl

    it "handles one file" do
      items = parse_dsl {
        package {
          name 'foo'
          version '0.0.1'
          type 'test'
          file {
            source 'foo'
            dest 'bar'
          }
        }
      }
      expect(items[0].files).to be_instance_of(Array)
      expect(items[0].files[0].source).to eq('foo')
      expect(items[0].files[0].dest).to eq('bar')
    end

    it "handles two files" do
      items = parse_dsl {
        package {
          name 'foo'
          version '0.0.1'
          type 'test'
          file {
            source 'foo'
            dest 'bar'
          }
          files {
            source 'foo2'
            dest 'bar2'
          }
        }
      }
      expect(items[0].files).to be_instance_of(Array)
      expect(items[0].files[0].source).to eq('foo')
      expect(items[0].files[0].dest).to eq('bar')
      expect(items[0].files[1].source).to eq('foo2')
      expect(items[0].files[1].dest).to eq('bar2')
    end
  end
end
