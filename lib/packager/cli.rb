require 'thor'

require 'packager'

class Packager::CLI < Thor
  # Make sure to exit(1) on failure. This isn't covered in the specs.
  # :nocov:
  def self.exit_on_failure?
    true
  end
  # :nocov:

  # Taken from http://stackoverflow.com/a/27804972/1732954
  map %w[--version] => :__print_version
  desc "--version", "Print the version"
  def __print_version
    puts Packager::VERSION
  end

  desc :execute, "Execute one or more package DSL definition(s)"
  default_task :execute
  def execute(*args)
    if args.empty?
      raise Thor::Error, "No filenames provided for execute"
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

      puts "'#{filename}' executed #{packages.join(', ')}"
    end
  end

  desc :validate, "Validate one or more package DSL definition(s)"
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
end
