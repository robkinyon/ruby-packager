require 'packager/version'

require 'packager/dsl'
#require 'packager/validator'
require 'packager/executor'

#class Packager
#  def self.do_all(contents)
#    # Pass the string to the DSL
#    items = Packager::DSL.parse_dsl(contents)
#
#    # Take the DSL result and run it through a validator
#    #Packager::Validator.validate(items)
#
#    # Take the validated result and run it through the executor
#    Packager::Executor.execute_on(items)
#  end
#end
