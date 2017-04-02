module Aivis
  module SlackBot
    module Configurable

      ATTRIBUTES = [
        :admin_id, :bot_id, :token,
        :allow_message_loops, :allow_multiple_response
      ]

      attr_accessor(*ATTRIBUTES)

      def events
        @events ||= [:hello, :message, :close, :closed]
      end

      private

      def credentials
        {
          :bot_id => bot_id,
          :token  => token
        }
      end

      def validate_credentials!
        credentials.each do |credential, value|
          if value.nil?
            fail(ArgumentError.new("#{credential} must be required."))
          elsif value == true || value == false || !value.is_a?(String)
            fail(ArgumentError.new("Invalid #{credential} specified: #{value.inspect} must be a String."))
          end
        end
      end
    end
  end
end
