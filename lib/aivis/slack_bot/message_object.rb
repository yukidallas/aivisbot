module Aivis
  module Slackbot
    class MessageObject
      attr_accessor :args
      attr_reader :object, :account

      def initialize(object, account)
        @object = object
        @account = account
      end

      def post(text, options = {})
        post_message(text, options)
      end

      def custom_post(**options)
        options[:channel] = object.channel unless options.key?(:channel)
        options[:fallback] = options[:text] unless options.key?(:fallback)
        attachment = generate_attachment(options)

        payload = {
          :channel => options[:channel],
          :attachments => [attachment]
        }
        post_message("", payload)
      end

      def reply(text, options = {})
        text = "<@#{object.user}> #{text}"
        post_message(text, options)
      end

      def method_missing(method)
        object.send(method)
      end

      private

      def generate_attachment(options = {})
        attachment = {
          :fallback => options[:fallback],
          :color    => options[:color],
          :pretext  => options[:pretext],
          :author_name => options[:author_name],
          :author_link => options[:author_link],
          :author_icon => options[:author_icon],
          :title => options[:title],
          :title_link => options[:title_link],
          :text => options[:text],
          :fields => options[:fields],
          :image_url => options[:image_url],
          :thumb_url => options[:thumb_url],
          :footer => options[:footer],
          :footer_icon => options[:footer_icon]
        }.delete_if {|k, v| v.nil?}
      end

      def post_message(text, options)
        account.web_client.chat_postMessage({
          channel: object.channel,
          text: text,
          as_user: true
        }.merge(options))
      end
    end
  end
end
