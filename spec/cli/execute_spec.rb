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

    # NOTE: You (currently) cannot reuse a helper name within the test suite.
    # Otherwise, you run afoul of add_helper() being called twice with the same
    # name.
    context 'variables' do
      it "handles --var a:b" do
        package_name = 'foobar'
        cli.options = {'var' => { 'pkg_name' => package_name } }
        expect_any_instance_of(Packager::Executor).to(
          receive(:execute_on).
          and_return([package_name])
        )

        append_to_file('definition', '
          package pkg_name do
            type "test"
            version "0.0.1"
          end
        ')

        expect(
          capture(:stdout) { cli.execute('definition') }
        ).to eq("'definition' executed foobar\n")
      end

      it "handles --var a:b c:d" do
        cli.options = {
          'var' => {
            'pkg_version' => '0.0.3',
          }
        }
        expect_any_instance_of(Packager::Executor).to(
          receive(:execute_on) { |_, items|
            expect(items[0].version).to eq('0.0.3')
          }.
          and_return(['foobar'])
        )

        append_to_file('definition', '
          package "foobar" do
            type "test"
            version pkg_version
          end
        ')

        expect(
          capture(:stdout) { cli.execute('definition') }
        ).to eq("'definition' executed foobar\n")
      end

      # This throws an error
      it "throws an error on --var version:0.0.3" do
        cli.options = {
          'var' => {
            'version' => '0.0.3',
          }
        }

        append_to_file('definition', '
          package "foobar" do
            type "test"
            version version
          end
        ')

        expect {
          capture(:stdout) { cli.execute('definition') }
        }.to raise_error("'version' is a reserved word")
      end
    end
  end
end
