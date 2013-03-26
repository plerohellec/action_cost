module ActionCost
  class Engine < Rails::Engine

    engine_base_dir = File.expand_path("../../..",     __FILE__)
    app_base_dir    = File.expand_path("../../../app", __FILE__)
    lib_base_dir    = File.expand_path("../../../lib", __FILE__)

    config.autoload_paths << lib_base_dir

    initializer 'action_cost:record_cache_hook' do
      if defined?(::RecordCache::Index)=='constant' && ::RecordCache::Index.class==Class
        require "#{lib_base_dir}/action_cost/record_cache/index_hook"
        ::RecordCache::Index.send(:include, ActionCost::RecordCache::IndexHook)
      end
    end

    initializer "action_cost:instrument_adapters" do |app|
      db_adapter = ActiveRecord::Base.db_adapter
      require "#{lib_base_dir}/action_cost/extensions/#{db_adapter}_adapter"
    end

    initializer "action_cost.add_middleware" do |app|
      app.middleware.use ActionCost::Middleware
      $action_cost_data = ActionCost::Data.new
    end
  end
end

