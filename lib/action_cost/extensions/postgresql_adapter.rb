module ActiveRecord
  module ConnectionAdapters # :nodoc:
    class PostgreSQLAdapter
      
      def execute_with_action_cost(sql, name='')
        Rails.logger.debug "action_cost: #{sql}"
        parser = ActionCost::SqlParser.new(sql)
        parser.parse
        parser.log
        execute_without_action_cost(sql, name)
      end
      alias_method_chain :execute, :action_cost
      
    end
  end
end
