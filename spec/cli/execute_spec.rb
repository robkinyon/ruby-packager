require './spec/cli/context.rb'
describe Packager::CLI do
  context '#execute' do
    include_context :cli

    it "handles nothing passed" do
      expect {
        cli.execute
      }.to raise_error(Thor::Error, "No filenames provided for execute")
    end

    it "handles a non-existent filename" do
      expect {
        cli.execute('foo')
      }.to raise_error(Thor::Error, "'foo' cannot be found")
    end

    it "handles an empty file" do
      FileUtils.touch('definition')
      expect {
        cli.execute('definition')
      }.to raise_error(Thor::Error, "'definition' produces nothing")
    end

    it "handles a bad file" do
      append_to_file('definition', 'package {}')

      expect {
        cli.execute('definition')
      }.to raise_error(Thor::Error, "'definition' has the following errors:\nEvery package must have a name")
    end

    context "handles a file that works" do
      before {
        expect(Packager::DSL).to(
          receive(:parse_dsl).
          with('contents').
          and_return(:stuff)
        )

        expect_any_instance_of(Packager::Executor).to(
          receive(:execute_on).
          with(:stuff).
          and_return(['foo'])
        )
      }

      it {
        append_to_file('definition', 'contents')
        expect(
          capture(:stdout) { cli.execute('definition') }
        ).to eq("'definition' executed foo\n")
      }
    end

    context "handles a file that works with two packages" do
      before {
        expect(Packager::DSL).to(
          receive(:parse_dsl).
          with('contents').
          and_return(:stuff)
        )

        expect_any_instance_of(Packager::Executor).to(
          receive(:execute_on).
          with(:stuff).
          and_return(['foo', 'bar'])
        )
      }

      it {
        append_to_file('definition', 'contents')
        expect(
          capture(:stdout) { cli.execute('definition') }
        ).to eq("'definition' executed foo, bar\n")
      }
    end
  end
end
