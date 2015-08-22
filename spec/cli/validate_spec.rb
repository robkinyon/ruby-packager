# Examine:
# https://gabebw.wordpress.com/2011/03/21/temp-files-in-rspec/

describe Packager::CLI do
  subject(:cli) { Packager::CLI.new }

  describe '#create' do
    let(:definition) { Tempfile.new('foo').path }

    it "handles nothing passed" do
      expect {
        cli.create
      }.to raise_error(Thor::Error, "No filenames provided for create")
    end

    it "handles a non-existent filename" do
      expect {
        cli.create('foo')
      }.to raise_error(Thor::Error, "'foo' cannot be found")
    end

    it "handles an empty file" do
      expect {
        cli.create(definition)
      }.to raise_error(Thor::Error, "'#{definition}' produces nothing")
    end

    it "handles a bad file" do
      append_to_file(definition, 'package {}')

      expect {
        cli.create(definition)
      }.to raise_error(Thor::Error, "'#{definition}' has the following errors:\nEvery package must have a name")
    end

    it "handles a file that works" do
      contents = "
        package {
          name 'foo'
          version '0.0.1'
          type 'dir'
        }
      "
      append_to_file(definition, contents)

      expect(Packager::DSL).to(
        receive(:parse_dsl).
        with(contents).
        and_return(:stuff)
      )

      expect_any_instance_of(Packager::Executor).to(
        receive(:execute_on).
        with(:stuff).
        and_return(['foo'])
      )

      expect(
        capture(:stdout) { cli.create(definition) }
      ).to eq("'#{definition}' created foo\n")
    end

    it "handles a file that works with two packages" do
      append_to_file(definition, 'contents')

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

      expect(
        capture(:stdout) { cli.create(definition) }
      ).to eq("'#{definition}' created foo, bar\n")
    end
  end

  describe '#validate' do
    let(:definition) { Tempfile.new('foo').path }

    it "handles nothing passed" do
      expect {
        cli.validate
      }.to raise_error(Thor::Error, "No filenames provided for validate")
    end

    it "handles a non-existent filename" do
      expect {
        cli.validate('foo')
      }.to raise_error(Thor::Error, "'foo' cannot be found")
    end

    it "handles an empty file" do
      expect {
        cli.validate(definition)
      }.to raise_error(Thor::Error, "'#{definition}' produces nothing")
    end

    it "handles a bad file" do
      append_to_file(definition, 'package {}')

      expect {
        cli.validate(definition)
      }.to raise_error(Thor::Error, "'#{definition}' has the following errors:\nEvery package must have a name")
    end

    it "handles a file that works" do
      append_to_file(definition, "
        package {
          name 'foo'
          version '0.0.1'
          type 'dir'
        }
      ")

      expect(
        capture(:stdout) { cli.validate(definition) }
      ).to eq("'#{definition}' parses cleanly\n")
    end
  end
end
