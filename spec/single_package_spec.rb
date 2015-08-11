describe "Packager empty packages" do
  it "can create a package without files" do
    item = Packager::DSL.execute_dsl {
      package {
        name 'foo'
        version '0.0.1'
        type 'dir'
      }
    }[0]

    expect(item).to be_instance_of(Packager::DSL::Package)
    expect(item.name).to eq('foo')
    expect(item.version).to eq('0.0.1')
    expect(item.type).to eq('dir')

    # Stub out execute_command
    allow(Packager::Executor).to receive(:execute_command) {}
    rv = Packager::Executor.execute_on(item)
    expect(rv[0]).to eq([
      'fpm',
      '--name', 'foo',
      '--version', '0.0.1',
      '-s', 'empty',
      '-t', 'dir',
    ])
  end

  context "default type" do
    before(:all) { Packager::DSL.default_type('dir') }
    after(:all) { Packager::DSL.default_type = nil }

    it "will use the default type" do
      item = Packager::DSL.execute_dsl {
        package {
          name 'foo'
          version '0.0.1'
        }
      }[0]
      expect(item.type).to eq('dir')
    end
  end
end
