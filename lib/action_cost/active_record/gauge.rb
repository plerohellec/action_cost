module ActionCost
  module ActiveRecord
    module Gauge
      def self.included(base)
        puts "Gauge included in #{base.class}"
      end
    end
  end
end
