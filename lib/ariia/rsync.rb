require 'rsync'

module Ariia
  class Rsync
    class << self
      DEFAULT_ARGS = [
        '-rae', '"ssh -T -l wti"', '--delete', '--exclude="/.git"',
        '--exclude="/tmp"', '--exclude="/log"', '--exclude="/vendor/bundle"',
        '--exclude="/public/static"', '--exclude="/public/lists"',
      ]

      attr_accessor :local_path, :remote_user, :remote_path, :remote_server, :args

      def run local_path, remote_user, remote_server, remote_path, args = nil
        @local_path = local_path
        @remote_user = remote_user
        @remote_server = remote_server
        @remote_path = remote_path
        @args = args || default_args

        ::Rsync.run(@local_path, remote_connection, @args) do |result|
          handle_result result
        end
      end

      def handle_result result
        if result.success?
          result.changes.each { |change| puts "#{change.filename} (#{change.summary})" }
        else
          puts result.error
        end
      end

      def remote_connection
        "#{remote_user}@#{remote_server}:#{remote_path}"
      end

      def default_args
        DEFAULT_ARGS
      end
    end
  end
end
