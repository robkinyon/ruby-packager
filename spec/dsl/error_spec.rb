require './spec/dsl/context.rb'
describe Packager::DSL do
  context "error handling" do
    include_context :dsl

    it "reject an empty package" do
      expect {
        parse_dsl { package {} }
      }.to raise_error("Every package must have a name")
    end

    it "reject a package without a name" do
      expect {
        parse_dsl { package { version '0.0.1' } }
      }.to raise_error("Every package must have a name")
    end

    context "for versions" do
      it "reject a package without a version" do
        expect {
          parse_dsl { package { name 'foo' } }
        }.to raise_error("Every package must have a version")
      end

      it "rejects a package with a bad version" do
        expect {
          parse_dsl {
            package {
              name 'foo'
              version 'b'
            }
          }
        }.to raise_error("'b' is not a legal version string")
      end
    end

    it "rejects a package without a type" do
      expect {
        parse_dsl {
          package {
            name 'foo'
            version '0.0.1'
          }
        }
      }.to raise_error("Every package must have a type")
    end
  end
end
