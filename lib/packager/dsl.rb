require "packager/version"

require "dsl/maker"

class Packager::DSL < DSL::Maker
  class << self
    attr_accessor :default_type
  end

  Package = Struct.new(
    :name, :version, :type,
  )

  VersionString = nil
  add_type(VersionString) do |attr, *args|
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
    :type => String,
  }) do
    # Must check truthiness of default_type because String coerces.
    type(Packager::DSL.default_type) if !type && Packager::DSL.default_type

    Package.new(name, version, type)
  end
  add_verification(:package) do |item|
    return "Every package must have a name" unless item.name
    return "Every package must have a version" unless item.version
    return "Every package must have a type" unless item.type
    return
  end
end
