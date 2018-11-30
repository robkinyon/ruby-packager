require './spec/dsl/context.rb'
describe Packager::DSL do
  include_context :dsl

  # It's unclear how to replicate what was done in spec/executor/dependency_spec
  # here. The parse_dsl{} needs to have the name of the parameter. Use eval?

  context "requires" do
    it "handles a dependency" do
      items = parse_dsl {
        package {
          name 'foo'
          version '0.0.1'
          type 'test'
          requires 'foo'
        }
      }
      expect(items[0].requires).to be_instance_of(Array)
      expect(items[0].requires[0]).to eq('foo')
    end

    it "handles multiple dependencies" do
      items = parse_dsl {
        package {
          name 'foo'
          version '0.0.1'
          type 'test'
          requires 'foo', 'bar'
          requires 'baz'
        }
      }
      expect(items[0].requires).to be_instance_of(Array)
      expect(items[0].requires).to eq([ 'foo', 'bar', 'baz' ])
    end
  end

  context "provides" do
    it "handles a provides" do
      items = parse_dsl {
        package {
          name 'foo'
          version '0.0.1'
          type 'test'
          provides 'foo'
        }
      }
      expect(items[0].provides).to be_instance_of(Array)
      expect(items[0].provides[0]).to eq('foo')
    end

    it "handles multiple dependencies" do
      items = parse_dsl {
        package {
          name 'foo'
          version '0.0.1'
          type 'test'
          provides 'foo', 'bar'
          provides 'baz'
        }
      }
      expect(items[0].provides).to be_instance_of(Array)
      expect(items[0].provides).to eq([ 'foo', 'bar', 'baz' ])
    end
  end

  context "before_install" do
    it "handles a before_install" do
      items = parse_dsl {
        package {
          name 'foo'
          version '0.0.1'
          type 'test'
          before_install 'foo'
        }
      }
      expect(items[0].before_install).to be_instance_of(Array)
      expect(items[0].before_install[0]).to eq('foo')
    end

    it "handles multiple before_installs" do
      items = parse_dsl {
        package {
          name 'foo'
          version '0.0.1'
          type 'test'
          before_install 'foo', 'bar'
          before_install 'baz'
        }
      }
      expect(items[0].before_install).to be_instance_of(Array)
      expect(items[0].before_install).to eq([ 'foo', 'bar', 'baz' ])
    end
  end

  context "after_install" do
    it "handles a after_install" do
      items = parse_dsl {
        package {
          name 'foo'
          version '0.0.1'
          type 'test'
          after_install 'foo'
        }
      }
      expect(items[0].after_install).to be_instance_of(Array)
      expect(items[0].after_install[0]).to eq('foo')
    end

    it "handles multiple after_installs" do
      items = parse_dsl {
        package {
          name 'foo'
          version '0.0.1'
          type 'test'
          after_install 'foo', 'bar'
          after_install 'baz'
        }
      }
      expect(items[0].after_install).to be_instance_of(Array)
      expect(items[0].after_install).to eq([ 'foo', 'bar', 'baz' ])
    end
  end

  context "before_remove" do
    it "handles a before_remove" do
      items = parse_dsl {
        package {
          name 'foo'
          version '0.0.1'
          type 'test'
          before_remove 'foo'
        }
      }
      expect(items[0].before_remove).to be_instance_of(Array)
      expect(items[0].before_remove[0]).to eq('foo')
    end

    it "handles multiple before_removes" do
      items = parse_dsl {
        package {
          name 'foo'
          version '0.0.1'
          type 'test'
          before_remove 'foo', 'bar'
          before_remove 'baz'
        }
      }
      expect(items[0].before_remove).to be_instance_of(Array)
      expect(items[0].before_remove).to eq([ 'foo', 'bar', 'baz' ])
    end
  end

  context "after_remove" do
    it "handles a after_remove" do
      items = parse_dsl {
        package {
          name 'foo'
          version '0.0.1'
          type 'test'
          after_remove 'foo'
        }
      }
      expect(items[0].after_remove).to be_instance_of(Array)
      expect(items[0].after_remove[0]).to eq('foo')
    end

    it "handles multiple after_removes" do
      items = parse_dsl {
        package {
          name 'foo'
          version '0.0.1'
          type 'test'
          after_remove 'foo', 'bar'
          after_remove 'baz'
        }
      }
      expect(items[0].after_remove).to be_instance_of(Array)
      expect(items[0].after_remove).to eq([ 'foo', 'bar', 'baz' ])
    end
  end

  context "before_upgrade" do
    it "handles a before_upgrade" do
      items = parse_dsl {
        package {
          name 'foo'
          version '0.0.1'
          type 'test'
          before_upgrade 'foo'
        }
      }
      expect(items[0].before_upgrade).to be_instance_of(Array)
      expect(items[0].before_upgrade[0]).to eq('foo')
    end

    it "handles multiple before_upgrades" do
      items = parse_dsl {
        package {
          name 'foo'
          version '0.0.1'
          type 'test'
          before_upgrade 'foo', 'bar'
          before_upgrade 'baz'
        }
      }
      expect(items[0].before_upgrade).to be_instance_of(Array)
      expect(items[0].before_upgrade).to eq([ 'foo', 'bar', 'baz' ])
    end
  end

  context "after_upgrade" do
    it "handles a after_upgrade" do
      items = parse_dsl {
        package {
          name 'foo'
          version '0.0.1'
          type 'test'
          after_upgrade 'foo'
        }
      }
      expect(items[0].after_upgrade).to be_instance_of(Array)
      expect(items[0].after_upgrade[0]).to eq('foo')
    end

    it "handles multiple after_upgrades" do
      items = parse_dsl {
        package {
          name 'foo'
          version '0.0.1'
          type 'test'
          after_upgrade 'foo', 'bar'
          after_upgrade 'baz'
        }
      }
      expect(items[0].after_upgrade).to be_instance_of(Array)
      expect(items[0].after_upgrade).to eq([ 'foo', 'bar', 'baz' ])
    end
  end
end
