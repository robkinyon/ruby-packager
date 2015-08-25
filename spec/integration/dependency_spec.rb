require './spec/integration/context.rb'
describe "Packager integration" do
  context "dependencies" do
    include_context :integration
    include_context :test_package

    it "can create a package with 1 dependency" do
      append_to_file('definition', "
        package {
          name 'foo'
          version '0.0.1'
          requires 'bar'
        }
      ")

      FileUtils.chdir(workdir) do
        capture(:stdout) {
          Packager::CLI.start(['execute', './definition'])
        }

        verify_test_package('foo.test', {
          'name' => 'foo',
          'version' => '0.0.1',
          'requires' => ['bar'],
        })
      end
    end
  end
end
