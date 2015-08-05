describe "Packager single package" do
  it "can create a package without files" do
    item = Packager::DSL.execute_dsl {
      package {
        name 'foo'
        version '0.0.1'
        type 'deb'
      }
    }

    expect(item).to be_instance_of(Packager::DSL::Package)
    expect(item.name).to eq('foo')
    expect(item.version).to eq('0.0.1')
    expect(item.type).to eq('deb')

    # Stub out execute_command
    allow(Packager::Executor).to receive(:execute_command) {}
    rv = Packager::Executor.execute_on(item)
    expect(rv[0]).to eq([
      'fpm',
      '--name', 'foo',
      '--version', '0.0.1',
      '-s', 'empty',
      '-t', 'deb',
    ])
  end
end
