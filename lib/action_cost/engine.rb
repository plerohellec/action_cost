module ActionCost
  class Engine < Rails::Engine
    puts "action_cost loading engine"

    engine_base_dir = File.expand_path("../../..",     __FILE__)
    app_base_dir    = File.expand_path("../../../app", __FILE__)
    lib_base_dir    = File.expand_path("../../../lib", __FILE__)

    config.autoload_paths << lib_base_dir

    paths['app/controllers'] = "#{app_base_dir}/controllers/action_cost"

    initializer 'action_cost:include_gauge' do |app|
      puts "action_cost include_gauge"
      ActiveSupport.on_load :active_record do
        puts "action_cost AR loaded"
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
    end
  end
end

