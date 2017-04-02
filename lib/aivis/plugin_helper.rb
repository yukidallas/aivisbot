module Aivis
  module PluginHelper
    def plugins
      @plugins ||= []
    end

    def plugin_cache
      @plugin_cache ||= {}
    end

    def install_plugin(*plugin_list)
      plugin_list.flatten.each do |plugin|
        plugins << plugin
      end
    end

    private

    def all_plugin_handlers(type)
      return plugin_cache[type] if plugin_cache.key(type)
      handlers = Hash.new {|h,k| h[k] = {}}
      plugins.each do |plugin|
        handlers = handlers.merge(plugin.handlers[type])
      end
      plugin_cache[type] = handlers
      return handlers
    end

    def all_plugin_jobs
      return plugin_cache[:job] if plugin_cache.key?(:job)
      jobs = []
      plugins.each do |plugin|
        plugin.jobs.each {|job| jobs << job }
      end
      plugin_cache[:job] = jobs
      return jobs
    end
  end
end
