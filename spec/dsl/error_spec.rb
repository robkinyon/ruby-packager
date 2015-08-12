describe "Packager::DSL validations" do
  def parse(&block)
    Packager::DSL.execute_dsl(&block)
  end

  it "reject an empty package" do
    expect {
      parse { package {} }
    }.to raise_error("Every package must have a name")
  end

  it "reject a package without a name" do
    expect {
      parse { package { version '0.0.1' } }
    }.to raise_error("Every package must have a name")
  end

  context "for versions" do
    it "reject a package without a version" do
      expect {
        parse { package { name 'foo' } }
      }.to raise_error("Every package must have a version")
    end

    it "rejects a package with a bad version" do
      expect {
        parse {
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
      parse {
        package {
          name 'foo'
          version '0.0.1'
        }
      }
    }.to raise_error("Every package must have a type")
  end
end
