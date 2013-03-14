module ActionCost
  module ActiveRecord
    module Gauge
      def self.included(base)
        Rails.logger.debug "action_cost Gauge included in #{base}"
      end
    end
  end
end
