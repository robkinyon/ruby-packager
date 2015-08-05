require 'packager/version'

class Packager
  class Executor
    def self.execute_on(items)
      items = [items] unless items.instance_of? Array
      items.collect do |item|
        create_package_for(item)
      end
    end

    def self.create_package_for(item)
      cmd = [
        'fpm',
        '--name', item.name,
        '--version', item.version,
        '-s', 'empty',
        '-t', item.type,
      ]
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
