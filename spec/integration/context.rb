require 'fileutils'
require 'tmpdir'

require './spec/shared_context/workdir.rb'
RSpec.shared_context :integration do
  include_context :workdir

  before(:all) { Packager::DSL.default_type('test') }
  after(:all) { Packager::DSL.default_type = nil }

  # This is to get access to the 'test' FPM type in the FPM executable.
  before(:all) {
    Packager::Struct::Command.default_executable =
      "ruby -I#{File.join(@dir,'spec/lib')} -rfpm/package/test `which fpm`"
  }
  after(:all) {
    Packager::Struct::Command.default_executable = 'fpm'
  }

  before(:each) { $sourcedir = sourcedir }
  before(:all) {
    Packager::DSL.add_helper(:sourcedir) do |path|
      File.join($sourcedir, path)
    end
  }
  after(:all) {
    Packager::DSL.remove_helper(:sourcedir)
  }
end

RSpec.shared_context :test_package do
  # This is used to verify the FPM/test package format is created properly.
  def verify_test_package(name, metadata={}, files={})
    expect(File).to exist(name)
    expect(File).to exist(File.join(name, 'META.json'))
    expect(JSON.parse(IO.read(File.join(name, 'META.json')))).to eq({
      'requires' => [],
      'provides' => [],
    }.merge(metadata))
    if files.empty?
      expect(Dir[File.join(name, 'contents/*')].empty?).to be(true)
    else
      file_expectations = files.clone
      Dir[File.join(name, 'contents/**/*')].each do |filename|
        if File.file?(filename)
          content = IO.read(filename)
          filename.gsub! /#{File.join(name, 'contents', '')}/, ''

          expect(file_expectations).to have_key(filename)
          expect(file_expectations[filename]).to eq(content)
          file_expectations.delete(filename)
        end
      end
      expect(file_expectations).to be_empty
    end
  end
end
