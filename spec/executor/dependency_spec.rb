require './spec/executor/context.rb'
describe Packager::Executor do
  include_context :executor

  context "dependencies" do
    it "handles a dependency" do
      item = Packager::Struct::Package.new(
        :name => 'foo',
        :version => '0.0.1',
        :type => 'test',
        :requires => [ 'foo' ],
      )
      executor.execute_on([item])
      expect(executor.commands[0]).to eq(
        Packager::Struct::Command.new({
          :name => 'foo',
          :version => '0.0.1',
          :source => 'empty',
          :target => 'test',
          :requires => [ 'foo' ],
        })
      )
    end
  end

  context "provides" do
    it "handles a provides" do
      item = Packager::Struct::Package.new(
        :name => 'foo',
        :version => '0.0.1',
        :type => 'test',
        :provides => [ 'foo' ],
      )
      executor.execute_on([item])
      expect(executor.commands[0]).to eq(
        Packager::Struct::Command.new({
          :name => 'foo',
          :version => '0.0.1',
          :source => 'empty',
          :target => 'test',
          :provides => [ 'foo' ],
        })
      )
    end
  end
end
