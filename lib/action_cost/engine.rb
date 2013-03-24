module ActionCost
  class Engine < Rails::Engine

    engine_base_dir = File.expand_path("../../..",     __FILE__)
    app_base_dir    = File.expand_path("../../../app", __FILE__)
    lib_base_dir    = File.expand_path("../../../lib", __FILE__)

    config.autoload_paths << lib_base_dir

    initializer 'action_cost:include_gauge' do |app|
      ActiveSupport.on_load :active_record do
        include ActionCost::ActiveRecord::Gauge
      end
    end

    initializer 'action_cost:record_cache_hook' do
      if defined?(::RecordCache::Index)=='constant' && ::RecordCache::Index.class==Class
        require "#{lib_base_dir}/action_cost/record_cache/index_hook"
        ::RecordCache::Index.send(:include, ActionCost::RecordCache::IndexHook)
      end
    end

    initializer "action_cost:instrument_postgresql_adapter" do |app|
      require "#{lib_base_dir}/action_cost/extensions/postgresql_adapter"
    end

    initializer "action_cost.add_middleware" do |app|
      app.middleware.use ActionCost::Middleware
      $action_cost_data = ActionCost::Data.new
    end
  end
end

