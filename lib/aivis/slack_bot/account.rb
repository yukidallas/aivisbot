module Aivis
  module SlackBot
    class Account
      attr_reader :token

      def initialize(options = {})
        options.each do |key, value|
          instance_variable_set("@#{key}", value)
        end
      end

      def web_client
        @web_client ||= Slack::Web::Client.new(token: token)
      end

      def realtime_client
        @realtime_client ||= Slack::RealTime::Client.new(token: token)
      end
    end
  end
end
