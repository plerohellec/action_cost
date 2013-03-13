module ActionCost
  module ActiveRecord
    module Gauge
      def self.included(base)
        puts "Gauge included in #{base}"
      end
    end
  end
end
