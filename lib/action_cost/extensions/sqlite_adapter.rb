module ActiveRecord
  module ConnectionAdapters # :nodoc:
    class SQLiteAdapter

      def execute_with_action_cost(sql, name='')
        Rails.logger.debug "execute_with_action_cost: #{sql}"
        parser = ActionCost::SqlParser.new(sql)
        ActionCost::Middleware.push_sql_parser(parser)
        execute_without_action_cost(sql, name)
      end
      alias_method_chain :execute, :action_cost

      if Rails.version =~ /^3.[12]\./
        def exec_query_with_action_cost(sql, name='', binds = [])
          Rails.logger.debug "exec_query_with_action_cost: #{sql}"
          parser = ActionCost::SqlParser.new(sql)
          ActionCost::Middleware.push_sql_parser(parser)
          exec_query_without_action_cost(sql, name, binds)
        end
        alias_method_chain :exec_query, :action_cost
      end
    end
  end
end
