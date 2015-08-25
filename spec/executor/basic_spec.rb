require './spec/executor/context.rb'
describe Packager::Executor do
  include_context :executor

  it "creates an empty directory" do
    item = Packager::Struct::Package.new(
      :name => 'foo',
      :version => '0.0.1',
      :type => 'dir',
    )
    executor.execute_on([item])
    expect(executor.commands[0]).to eq(
      Packager::Struct::Command.new({
        :name => 'foo',
        :version => '0.0.1',
        :source => 'empty',
        :target => 'dir',
      })
    )
  end
end
