module ActionCost
  module RecordCache
    module IndexHook

      puts "Loading ActionCost::RecordCache::IndexHook"
      
      def self.included(base)
        puts "action_cost including RecordCache::IndexHook"
        base.class_eval do
          alias_method_chain :get_records, :action_cost
        end
      end

      def get_records_with_action_cost(keys)
        Rails.logger.debug "get_records_with_action_cost: keys=#{keys.inspect}"
        parser = ActionCost::RecordCacheParser.new(table_name)
        ActionCost::Middleware.push_sql_parser(parser)
        get_records_without_action_cost(keys)
      end
    end
  end
end
