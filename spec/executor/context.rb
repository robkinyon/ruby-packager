RSpec.shared_context :executor do
  subject(:executor) { Packager::Executor.new(:dryrun => true) }
end
