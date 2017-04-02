require 'aivis/plugin_helper'

module Aivis
  class Reactor
    include Aivis::PluginHelper

    def initialize(options = {})
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
      yield(self) if block_given?
    end

    private

    def threads
      @threads ||= []
    end

    def reactor_running?
      @reactor_running && Process.pid == @reactor_pid
    end

    def handle_exception(options = {})
      yield if block_given?
    end
  end
end
