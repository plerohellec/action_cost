module ActionCost
  class Engine < Rails::Engine
    puts "action_cost loading engine"
    config.autoload_paths << File.expand_path("../../", __FILE__)

    app_base_dir = File.expand_path("../../../app", __FILE__)
    paths.app.controllers     = "#{app_base_dir}/controllers/action_cost"
  end
end

