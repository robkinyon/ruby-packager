RSpec.shared_context :dsl do
  def parse_dsl(&block)
    Packager::DSL.execute_dsl(&block)
  end
end
