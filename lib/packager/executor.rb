require 'packager/version'

require 'tmpdir'

class Packager
  class Executor
    attr_accessor :command, :dryrun

    def initialize(opts={})
      self.dryrun = !!opts[:dryrun]
      self.command = []
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

      cmd = [
        'fpm',
        '--name', item.name,
        '--version', item.version,
        '-s', source,
        '-t', item.type,
      ].flatten

      if source == 'dir'
        directories = []
        Dir.glob('*') do |entry|
          if File.directory?(entry)
            directories << entry
          end
        end
        # Sort the directories being added to make it easier to test
        cmd.concat(directories.sort)
      end

      self.command.push(cmd)

      execute_command(cmd)
    end

    def execute_command(cmd)
      return if dryrun

      #FileUtils.chdir('/tmp') do
        x = `#{cmd.join(' ')}`
        #system *cmd
        raise x if x.match(/:error/)
      #end
    end
  end
end
