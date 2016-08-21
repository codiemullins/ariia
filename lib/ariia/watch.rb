require 'rb-fsevent'

module Ariia
  class Watch
    attr_reader :fsevent, :watchers
    def initialize
      @fsevent = FSEvent.new
      @watchers = {}
    end

    def watch local_path, remote_user, remote_server, remote_path
      watchers[local_path] = {
        remote_user: remote_user,
        remote_server: remote_server,
        remote_path: remote_path
      }
    end

    def run
      fsevent.watch local_paths do |directories|
        local_path = local_path(directories)
        if local_path
          opts = watchers[local_path]
          Rsync.run local_path, opts[:remote_user], opts[:remote_server], opts[:remote_path]
        end
      end

      fsevent.run
    end

    def local_paths
      watchers.keys
    end

    def local_path directories
      local_path = local_paths.find do |path|
        directories.any? { |dir| dir.include?(path) }
      end
    end
  end
end
