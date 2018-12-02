require 'packager/version'

require 'tmpdir'

class Packager
  class Executor
    attr_accessor :commands, :dryrun, :workdir

    def initialize(opts={})
      self.dryrun = !!opts[:dryrun]
      self.commands = []
    end

    def with_workdir(&block)
      if workdir
        Dir.chdir(workdir, &block)
      else
        Dir.mktmpdir do |dir|
          Dir.chdir(dir, &block)
        end
      end
    end

    def execute_on(items)
      curdir = Dir.pwd
      items.collect do |item|
        with_workdir do
          path = create_package_for(item)
          FileUtils.mv(path, curdir) if path
        end
      end
    end

    def create_package_for(item)
      unless item.files.empty?
        item.files.each do |file|
          dest = (file.dest || '').gsub /^\//, ''
          FileUtils.mkdir_p File.dirname(dest)
          if file.link
            FileUtils.ln_s(file.source, dest)
          else
            FileUtils.cp_r(file.source, dest)
          end
        end
      end

      cmd = Packager::Struct::Command.new(
        :name     => item.name,
        :version  => item.version,
        :target   => item.type,
        :requires => item.requires,
        :provides => item.provides,
        :before_install => item.before_install,
        :after_install  => item.after_install,
        :before_remove  => item.before_remove,
        :after_remove   => item.after_remove,
        :before_upgrade => item.before_upgrade,
        :after_upgrade  => item.after_upgrade,
      )

      Dir.glob('*') do |entry|
        if File.directory?(entry)
          cmd.add_directory(entry)
        end
      end

      commands.push(cmd)

      execute_command(cmd)
    end

    def execute_command(cmd)
      return if dryrun

      x = `#{cmd.to_system.join(' ')}`
      rv = eval(x)
      raise rv[:error] if rv[:error]
      return rv[:path]
    end
  end
end
