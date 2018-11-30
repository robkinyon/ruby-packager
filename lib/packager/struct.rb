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
    :before_install, :after_install,
    :before_remove, :after_remove,
    :before_upgrade, :after_upgrade,
  )
    def initialize(*args)
      super(*args)
      self.files ||= []
      self.requires ||= []
      self.provides ||= []
      self.before_install ||= []
      self.after_install  ||= []
      self.before_remove  ||= []
      self.after_remove   ||= []
      self.before_upgrade ||= []
      self.after_upgrade  ||= []
    end
  end

  class File < Packager::Struct.new(
    :source, :dest,
  )
  end

  class Command < Packager::Struct.new(
    :executable, :name, :version,
    :source, :target, :directories, :requires, :provides,
    :before_install, :after_install,
    :before_remove, :after_remove,
    :before_upgrade, :after_upgrade,
  )
    class << self
      attr_accessor :default_executable
    end

    def initialize(*args)
      super(*args)
      self.source ||= 'empty'
      self.executable ||= self.class.default_executable || 'fpm'
      self.directories ||= {}

      @unique_mappers = {
        :requires => '--depends',
        :provides => '--provides',
        :before_install => '--before-install',
        :after_install  => '--after-install',
        :before_remove  => '--before-remove',
        :after_remove   => '--after-remove',
        :before_upgrade => '--before-upgrade',
        :after_upgrade  => '--after-upgrade',
      }

      @unique_mappers.keys.each {|i| self[i] ||= [] }
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

      @unique_mappers.each do |element, flag|
        self[element].uniq.each do |item|
          cmd.concat([flag, item])
        end
      end

      cmd.concat(['-s', source, '-t', target])
      cmd.concat(directories.keys)

      return cmd
    end
  end
end

