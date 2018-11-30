require './spec/executor/context.rb'
describe Packager::Executor do
  include_context :executor

  def self.testit(name, addl_input, addl_output)
    it "handles a #{name}" do
      item = Packager::Struct::Package.new({
        :name => 'foo',
        :version => '0.0.1',
        :type => 'test',
      }.merge(addl_input))
      executor.execute_on([item])
      expect(executor.commands[0]).to eq(
        Packager::Struct::Command.new({
          :name => 'foo',
          :version => '0.0.1',
          :source => 'empty',
          :target => 'test',
        }.merge(addl_output))
      )
    end
  end

  testit :dependency, {
    :requires => ['foo'],
  }, {
    :requires => ['foo'],
  }

  testit :provides, {
    :provides => ['foo'],
  }, {
    :provides => ['foo'],
  }

  testit :before_install, {
    :before_install => ['foo'],
  }, {
    :before_install => ['foo'],
  }

  testit :after_install, {
    :after_install => ['foo'],
  }, {
    :after_install => ['foo'],
  }

  testit :before_remove, {
    :before_remove => ['foo'],
  }, {
    :before_remove => ['foo'],
  }

  testit :after_remove, {
    :after_remove => ['foo'],
  }, {
    :after_remove => ['foo'],
  }

  testit :before_upgrade, {
    :before_upgrade => ['foo'],
  }, {
    :before_upgrade => ['foo'],
  }

  testit :after_upgrade, {
    :after_upgrade => ['foo'],
  }, {
    :after_upgrade => ['foo'],
  }
end
