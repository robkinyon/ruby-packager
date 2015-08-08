require "packager/version"

require "dsl/maker"

class Packager::DSL < DSL::Maker
  class << self
    attr_writer :default_type
    def default_type(*args)
      @default_type = args[0] unless args.empty?
      @default_type
    end
  end

  Package = Struct.new(
    :name, :version, :type, :files,
  )

  File = Struct.new(
    :source, :dest,
  )

  add_type(VersionString = {}) do |attr, *args|
    unless args.empty?
      begin
        ___set(attr, Gem::Version.new(args[0]).to_s)
      rescue ArgumentError
        raise "'#{args[0]}' is not a legal version string" 
      end
    end
    ___get(attr)
  end

  add_entrypoint(:package, {
    :name => String,
    :version => VersionString,
    :type => Any,
    :file => generate_dsl({
      :source => String,
      :dest   => String,
    }) do
      File.new(source, dest)
    end
  }) do |*args|
    type(Packager::DSL.default_type) unless type
    default(:name, args, 0)

    Package.new(name, version, type, file ? [file] : nil)
  end
  add_verification(:package) do |item|
    return "Every package must have a name" unless item.name
    return "Every package must have a version" unless item.version
    return "Every package must have a type" unless item.type
    return
  end
end
