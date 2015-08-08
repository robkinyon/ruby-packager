require 'packager/version'

require 'pathname'

class Packager
  class Executor
    def self.execute_on(items)
      items = [items] unless items.instance_of? Array
      items.collect do |item|
        create_package_for(item)
      end
    end

    def self.create_package_for(item)
      source = 'empty'
      if item.files
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
        Dir.glob('*') do |entry|
          if File.directory?(entry)
            cmd << entry
          end
        end
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
