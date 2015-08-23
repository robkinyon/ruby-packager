describe Packager::CLI do
  it "displays the version" do
    expect(
      capture(:stdout) { Packager::CLI.start(['--version']) }
    ).to eq("#{Packager::VERSION}\n")
  end
end
