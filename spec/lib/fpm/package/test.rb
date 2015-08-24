require 'fpm/package/dir'

require 'fileutils'

class FPM::Package::Test < FPM::Package::Dir
  # Trigger the inherited capture of subclasses.
  FPM::Package.inherited(FPM::Package::Test)

  def output(output_path)
    output_check(output_path)

    # We have to create the ouput_path so that the Dir type will write out to the
    # contents subdirectory.
    FileUtils.mkdir_p output_path
    super(File.join(output_path, 'contents'))

    # Write out the META.json file.
    File.open(File.join(output_path, 'META.json'), 'w') do |f|
      f.write({
        :name => name,
        :version => version,
        :requires => dependencies.sort,
      }.to_json)
    end
  end
end
