require 'packager/version'

require 'tmpdir'

class Packager
  class Executor
    attr_accessor :commands, :dryrun

    def initialize(opts={})
      self.dryrun = !!opts[:dryrun]
      self.commands = []
    end

    def execute_on(items)
      #curdir = Dir.pwd
      items.collect do |item|
        #Dir.mktmpdir do |tempdir|
        #  Dir.chdir(tempdir) do
            create_package_for(item)
        #  end
        #end
      end
    end

    def create_package_for(item)
      source = 'empty'
      unless item.files.empty?
        source = 'dir'
        item.files.each do |file|
          dest = (file.dest || '').gsub /^\//, ''
          FileUtils.mkdir_p File.dirname(dest)
          FileUtils.cp_r(file.source, dest)
        end
      end

      cmd = Packager::Struct::Command.new(
        :name    => item.name,
        :version => item.version,
        :source  => source,
        :target  => item.type,
      )

      if source == 'dir'
        directories = []
        Dir.glob('*') do |entry|
          if File.directory?(entry)
            cmd.add_directory(entry)
          end
        end
      end

      commands.push(cmd)

      execute_command(cmd)
    end

    def execute_command(cmd)
      return if dryrun

      #FileUtils.chdir('/tmp') do
        x = `#{cmd.to_system.join(' ')}`
        #system *cmd
        rv = eval(x)
        raise x if rv[:error]
        return rv[:path]
      #end
    end
  end
end
