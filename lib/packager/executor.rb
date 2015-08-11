require 'packager/version'

require 'tmpdir'

class Packager
  class Executor
    def self.execute_on(items)
      items = [items] unless items.instance_of? Array
      #curdir = Dir.pwd
      items.collect do |item|
        #Dir.mktmpdir do |tempdir|
        #  Dir.chdir(tempdir) do
            create_package_for(item)
        #  end
        #end
      end
    end

    def self.create_package_for(item)
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

      execute_command(cmd)
      return cmd
    end

    def self.execute_command(cmd)
      #FileUtils.chdir('/tmp') do
        x = `#{cmd.join(' ')}`
        #system *cmd
        raise x if x.match(/:error/)
      #end
    end
  end
end
