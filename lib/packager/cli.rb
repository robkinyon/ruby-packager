require 'thor'

require 'packager'

class Packager::CLI < Thor
  # Make sure to exit(1) on failure. This isn't covered in the specs.
  # :nocov:
  def self.exit_on_failure?
    true
  end
  # :nocov:

  desc :create, "Create a package"
  def create(*args)
    if args.empty?
      raise Thor::Error, "No filenames provided for create"
    end

    args.each do |filename|
      unless File.exists? filename
        raise Thor::Error, "'#{filename}' cannot be found"
      end

      begin
        items = Packager::DSL.parse_dsl(IO.read(filename))
      rescue Exception => e
        raise Thor::Error, "'#{filename}' has the following errors:\n#{e}"
      end

      if items.empty?
        raise Thor::Error, "'#{filename}' produces nothing"
      end

      packages = Packager::Executor.new.execute_on(items)

      puts "'#{filename}' created #{packages.join(', ')}"
    end
  end

  desc :validate, "Validate a package DSL definition"
  def validate(*args)
    if args.empty?
      raise Thor::Error, "No filenames provided for validate"
    end

    args.each do |filename|
      unless File.exists? filename
        raise Thor::Error, "'#{filename}' cannot be found"
      end

      begin
        items = Packager::DSL.parse_dsl(IO.read(filename))
      rescue Exception => e
        raise Thor::Error, "'#{filename}' has the following errors:\n#{e}"
      end

      if items.empty?
        raise Thor::Error, "'#{filename}' produces nothing"
      end

      puts "'#{filename}' parses cleanly"
    end
  end

  default_task :create
end
