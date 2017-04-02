module Aivis
  class Plugin
    class << self
      def handlers
        @handlers ||= Hash.new {|h,k| h[k] = {} }
      end

      def jobs
        @jobs ||= []
      end

      private

      def on(type)
        @block_type = type.to_sym
        yield if block_given?
      end

      def run(&block)
        handlers[block_type][:run] ||= []
        handlers[block_type][:run] << block
      end

      def match(regexp, options = {}, &block)
        handlers[block_type][:match] ||= []
        handlers[block_type][:match] << [regexp, options, block]
      end

      def command(regexp, options = {}, &block)
        options[:reply] = true if options.is_a?(Hash)
        match(regexp, options, &block)
      end

      def every(period, options = {}, &block)
        jobs << Aivis::Job.new(period, options, &block)
      end

      def block_type
        @block_type || :match
      end
    end
  end
end
