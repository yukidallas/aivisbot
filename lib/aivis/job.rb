require 'aivis/core_ext/numeric'

module Aivis
  class Job
    def initialize(period, options = {}, &block)
      @period = period
      @at = options[:at] ? parse_at(*options[:at]) : []
      @last = nil
      @block = block
    end

    def run(t, account)
      @last = t
      @block.call(t, account)
    end

    def time?(t)
      elapsed_ready = (@last.nil? || (t - @last).to_i >= @period)
      time_ready = @at.empty? || @at.any? { |at| (at[0].empty? || t.hour == at[0].to_i) && (at[1].empty? || t.min == at[1].to_i) }
      elapsed_ready && time_ready
    end

    private

    def parse_at(*args)
      args.map do |at|
        raise "#{at} must be a string" unless at.is_a?(String)
        raise "#{at} has not a colon separator" unless at =~ /:/
        hour, min = at.split(":")
        min = '' if min.nil?
        raise "Failed to parse #{at}" if hour.to_i >= 24 || min.to_i >= 60
        [hour, min]
      end
    end
  end
end
