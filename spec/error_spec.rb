describe "Packager Error-handling" do
  it "rejects an empty package" do
    expect {
      Packager::DSL.parse_dsl("package {}")
    }.to raise_error("Cannot have an empty package definition")
  end
end
