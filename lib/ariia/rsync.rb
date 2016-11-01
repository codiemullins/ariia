require 'rsync'

module Ariia
  class Rsync
    class << self
      DEFAULT_ARGS = [
        '-rae', '"ssh -T -l wti"', '--delete',
      ].freeze

      attr_accessor :local_path, :remote_user, :remote_path, :remote_server, :exclude, :args

      def run local_path, remote, exclude, args = nil
        @local_path = local_path
        @remote_user = remote[:user]
        @remote_server = remote[:server]
        @remote_path = remote[:path]
        @exclude = exclude.map { |exclude_item| "--exclude=#{exclude_item}" }
        @args = (args || default_args.dup).concat @exclude

        ::Rsync.run(@local_path, remote_connection, @args) do |result|
          handle_result result
        end
      end

      def handle_result result
        if result.success?
          result.changes.each do |change|
            puts "#{change.filename} (#{change.summary})"
          end
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
