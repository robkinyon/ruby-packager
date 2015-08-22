require 'packager/version'

# This exists so that you can pass in a Hash or an Array. While passing an Array
# can be useful, passing in a Hash is far more self-documenting.
class Packager::Struct < Struct
  def initialize(*args)
    if args.length == 1 and args[0].instance_of?(Hash)
      super(*args[0].values_at(*self.class.members))
    else
      super(*args)
    end
  end

  class Package < Packager::Struct.new(
    :name, :version, :type, :files,
  )
    def initialize(*args)
      super(*args)
      self.files ||= []
    end
  end

  class File < Packager::Struct.new(
    :source, :dest,
  )
  end

  class Command < Packager::Struct.new(
    :executable, :name, :version,
    :source, :target, :directories,
  )
    class << self
      attr_accessor :default_executable
    end

    def initialize(*args)
      super(*args)
      self.executable ||= self.class.default_executable || 'fpm'
      self.directories ||= {}
    end

    def add_directory(*items)
      items.each do |item|
        directories[item] = true
      end
    end

    def to_system
      [
        executable,
        '--name', name,
        '--version', version,
        '-s', source,
        '-t', target,
        *directories.keys,
      ]
    end
  end
end

