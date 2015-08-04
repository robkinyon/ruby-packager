describe "Packager single package" do
  it "can create a package without files" do
    item = Packager::DSL.execute_dsl {
      package {
        name 'foo'
        version '0.0.1'
      }
    }

    expect(item).to be_instance_of(Packager::DSL::Package)
    expect(item.name).to eq('foo')
    expect(item.version).to eq(Gem::Version.new('0.0.1'))
  end
end
