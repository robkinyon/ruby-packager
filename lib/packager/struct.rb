require 'packager/version'

# This exists so that you can pass in a Hash or an Array. While passing an Array
# can be useful, passing in a Hash is far more self-documenting.
class Packager::Struct < Struct
  def initialize(*args)
    if args.length == 1 and args[0].instance_of?(Hash)
      difference = Set.new(args[0].keys) - Set.new(self.class.members)
      unless difference.empty?
        raise 'Passed in unknown params: ' + difference.to_a.sort.join(', ')
      end
      super(*args[0].values_at(*self.class.members))
    else
      super(*args)
    end
  end

  class Package < Packager::Struct.new(
    :name, :version, :type, :files, :requires, :provides,
  )
    def initialize(*args)
      super(*args)
      self.files ||= []
      self.requires ||= []
      self.provides ||= []
    end
  end

  class File < Packager::Struct.new(
    :source, :dest,
  )
  end

  class Command < Packager::Struct.new(
    :executable, :name, :version,
    :source, :target, :directories, :requires, :provides,
  )
    class << self
      attr_accessor :default_executable
    end

    def initialize(*args)
      super(*args)
      self.source ||= 'empty'
      self.executable ||= self.class.default_executable || 'fpm'
      self.directories ||= {}
      self.requires ||= []
      self.provides ||= []
    end

    def add_directory(*items)
      self.source = 'dir'
      items.each do |item|
        directories[item] = true
      end
    end

    def to_system
      cmd = [
        executable,
        '--name', name,
        '--version', version,
      ]

      self.requires.uniq.each do |req|
        cmd.concat(['--depends', req])
      end

      self.provides.uniq.each do |req|
        cmd.concat(['--provides', req])
      end

      cmd.concat(['-s', source, '-t', target])
      cmd.concat(directories.keys)

      return cmd
    end
  end
end

