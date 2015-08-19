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

  Package = Packager::Struct.new(
    :name, :version, :type, :files,
  )

  File = Packager::Struct.new(
    :source, :dest,
  )

end

