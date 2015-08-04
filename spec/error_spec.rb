describe "Packager validations" do
  it "reject an empty package" do
    expect {
      Packager::DSL.execute_dsl { package {} }
    }.to raise_error("Every package must have a name")
  end

  it "reject a package without a name" do
    expect {
      Packager::DSL.execute_dsl { package { version '0.0.1' } }
    }.to raise_error("Every package must have a name")
  end

  it "reject a package without a version" do
    expect {
      Packager::DSL.execute_dsl { package { name 'foo' } }
    }.to raise_error("Every package must have a version")
  end

  it "rejects a package with a bad version" do
    expect {
      Packager::DSL.execute_dsl {
        package {
          name 'foo'
          version 'b'
        }
      }
    }.to raise_error("'b' is not a legal version string")
  end
end
