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
      directories = {}
      if item.files
        source = 'dir'
        item.files.each do |file|
          root = nil
          Pathname.new(file.dest).each_filename {|x| root ||= x }
          directories[root] = true
        end
      end

      cmd = [
        'fpm',
        '--name', item.name,
        '--version', item.version,
        '-s', source,
        '-t', item.type,
        directories.keys
      ].flatten
      execute_command(cmd)
      return cmd
    end

    def self.execute_command(cmd)
      #FileUtils.chdir('/tmp') do
        `#{cmd.join(' ')}`
      #end
    end
  end
end
