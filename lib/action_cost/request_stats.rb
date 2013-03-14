module ActionCost
  class RequestStats

    attr_reader :controller_name, :action_name
    attr_reader :operation_stats, :table_stats, :join_stats
    
    def initialize(env)
      request = ActionController::Routing::Routes.recognize_path(env['REQUEST_URI'])
      @controller_name  = request[:controller]
      @action_name      = request[:action]
      
      @operation_stats  = {}
      @table_stats      = {}
      @join_stats       = {}
    end

    def push(sql_parser)
      sql_parser.parse
      sql_parser.log

      return if sql_parser.invalid

      increment_item(@table_stats,     sql_parser.table_name)
      increment_item(@operation_stats, sql_parser.operation)
      sql_parser.join_tables.each do |table|
        increment_item(@join_stats, join_string(sql_parser.table_name, table))
      end
    end

    def close
      log
    end

    def log
      Rails.logger.debug "=== ActionCost: #{@controller_name}##{@action_name}"
      Rails.logger.debug "  Operations:"
      ActionCost::SqlParser::VALID_OPERATIONS.each do |op|
        Rails.logger.debug "    #{op}: #{@operation_stats[op]}"
      end
      Rails.logger.debug "  Tables:"
      @table_stats.each_key do |table|
        Rails.logger.debug "    #{table}: #{@table_stats[table]}"
      end
    end

   private

    def increment_item(hash, key)
      if hash.has_key?(key)
        hash[key] += 1
      else
        hash[key] = 1
      end
    end

    def join_string(t1, t2)
      "#{t1}|#{t2}"
    end
  end
end
