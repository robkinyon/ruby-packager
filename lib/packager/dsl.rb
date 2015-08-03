require "packager/dsl"

require "dsl/maker"

class Packager::DSL < DSL::Maker
  add_entrypoint(:package) {}
  add_verification(:package) do |*args|
    return "Cannot have an empty package definition"
  end
end
