require 'thor'

require 'packager'

class Packager::CLI < Thor
  # Make sure to fail. This isn't covered in the specs.
  # :nocov:
  def self.exit_on_failure?
    true
  end
  # :nocov:

  #desc :create, "Create a package"
  #def create
  #  puts "Hello"
  #end

  desc :validate, "Validate a package DSL definition"
  def validate(*args)
    if args.empty?
      raise Thor::Error, "No filenames provided for validate"
    end

    #args.each do |filename|
    #  unless File.exists? filename
    #    puts "#{filename} cannot be found"
    #    next
    #  end

    #  begin
    #    items = Packager::DSL.parse_dsl(IO.read(filename))
    #    if !items || items.empty?
    #      puts "#{filename} has nothing in it"
    #    else
    #      puts "#{filename} parses cleanly"
    #    end
    #  rescue Exception => e
    #    puts "#{filename} has the following errors:\n#{e}"
    #  end
    #end
  end

  default_task :create
end
