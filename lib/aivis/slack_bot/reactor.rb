require 'aivis/reactor'
require 'aivis/slack_bot/configurable'

module Aivis
  module SlackBot
    class Reactor < Aivis::Reactor
      include Aivis::SlackBot::Configurable

      def run
        validate_credentials!

        if reactor_running?
          raise "error: already started."; exit
        else
          @reactor_pid = Process.pid
          @reactor_running = true
        end

        self.events.each do |event|
          account.realtime_client.on(event) do |object|
            handle_exception(scope: 'PLUGIN_ERROR') do
              extract(object)
            end
          end
        end

        handle_exception(scope: 'JOB_ERROR') do
          start_job!
        end

        handle_exception(scope: 'SLACK_ERROR') do
          account.realtime_client.start!
        end
      end

      def account
        @account ||= Aivis::SlackBot::Account.new(token: token)
      end

      private

      def start_job!
        threads << Thread.new do
          while @reactor_running do
            handle_exception(scope: 'PLUGIN_JOB_ERROR') do
              jobs = all_plugin_jobs.select do |job|
                job.time?(Time.now)
              end
              jobs.each do |job|
                job.run(Time.now, account)
              end
              sleep(0.1)
            end
          end
        end
      end

      def extract(object)
        return unless object.respond_to?(:type)
        object_type = object.type.to_sym
        handlers = all_plugin_handlers(object_type)
        if object_type == :message
          return if object.user == bot_id && allow_message_loops == false
          message = Aivis::Slackbot::MessageObject.new(object, account)

          handlers[:run].each {|block| block.call(message, account)}
          handlers[:match].each do |regexp, options, block|
            if options.is_a?(Hash) && options[:reply]
              next unless message.text =~ /^<@#{bot_id}>:?\s*#{regexp}$/
            elsif options.is_a?(Hash) && options[:admin]
              next unless message.user == admin_id
              next unless message.text =~ /^<@#{bot_id}>:?\s*#{regexp}$/
            else
              next unless message.text =~ /^#{regexp}$/
            end
            message.args = [$1, $2, $3, $4, $5]
            block.call(message, account)
            break unless allow_multiple_response
          end
        else
          handlers[:run].each {|block| block.call(object, account)}
        end
      end
    end
  end
end
