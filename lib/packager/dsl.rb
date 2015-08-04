require "packager/version"

require "dsl/maker"

class Packager::DSL < DSL::Maker
  Package = Struct.new(:name, :version)

  VersionString = nil
  add_type(VersionString) do |attr, *args|
    unless args.empty?
      begin
        ___set(attr, Gem::Version.new(args[0]))
      rescue ArgumentError
        raise "'#{args[0]}' is not a legal version string" 
      end
    end
    ___get(attr)
  end

  add_entrypoint(:package, {
    :name => String,
    :version => VersionString,
  }) do
    Package.new(name, version)
  end
  add_verification(:package) do |item|
    return "Every package must have a name" unless item.name
    return "Every package must have a version" unless item.version
    return
  end
end
