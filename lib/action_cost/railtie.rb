module ActionCost
  class Railtie < Rails::Railtie
    initializer 'action_cost' do |app|
      puts "action_cost initializer"
      ActiveSupport.on_load :active_record do
        puts "action_cost AR loaded"
        include ActionCost::ActiveRecord::Gauge
      end
    end
  end
end
