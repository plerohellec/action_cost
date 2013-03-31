module ActionCost
  class RequestStats

    attr_reader :controller_name, :action_name
    attr_reader :operation_stats, :table_stats, :join_stats

    def initialize(env)
      begin
        routes_env = { :method => env['REQUEST_METHOD'] }
        request = Rails.application.routes.recognize_path(env['REQUEST_URI'], routes_env)

        @controller_name  = request[:controller]
        @action_name      = request[:action]
      rescue
        @controller_name  = nil
        @action_name      = nil
      end

      @operation_stats  = { :sql => {}, :rc => {} }
      ActionCost::SqlParser::VALID_OPERATIONS.each do |op|
        @operation_stats[:sql][op] = 0
        @operation_stats[:rc][op] = 0
      end

      @table_stats      = { :sql => {}, :rc => {} }
      @join_stats       = { :sql => {}, :rc => {} }

      action_cost_logfile = File.open(Rails.root.join("log", 'action_cost.log'), 'a')
      action_cost_logfile.sync = true
      @logger = Logger.new(action_cost_logfile)
      @logger.level = Logger::DEBUG
    end

    def push(parser)
      return unless parser.parse
      parser.log

      return if parser.invalid

      case parser.class.to_s
      when 'ActionCost::SqlParser'          then query_type = :sql
      when 'ActionCost::RecordCacheParser'  then query_type = :rc
      end

      increment_item(@table_stats,     query_type, parser.table_name)
      increment_item(@operation_stats, query_type, parser.operation)
      parser.join_tables.each do |table|
        increment_item(@join_stats, query_type, join_string(parser.table_name, table))
      end
    end

    def close
      log
    end

    def log
      @logger.debug ""
      @logger.debug "=== ActionCost: #{@controller_name}##{@action_name}"
      log_by_query_type(:rc)
      log_by_query_type(:sql)
    end

   private

    def increment_item(hash, query_type, key)
#       Rails.logger.debug "increment_item: hash=#{hash.inspect}"
#       Rails.logger.debug "increment_item: query_type=#{query_type} key=#{key}"
      if hash[query_type].has_key?(key)
        hash[query_type][key] += 1
      else
        hash[query_type][key] = 1
      end
    end

    def join_string(t1, t2)
      "#{t1}|#{t2}"
    end

    def log_by_query_type(query_type)
      @logger.debug "  #{query_type.to_s.upcase}:"
      @logger.debug "    Operations:"
      ActionCost::SqlParser::VALID_OPERATIONS.each do |op|
        log_count(@operation_stats, query_type, op)
      end
      @logger.debug "    Tables:"
      @table_stats[query_type].each_key do |table|
        log_count(@table_stats, query_type, table)
      end
    end

    def log_count(hash, query_type, item)
      val = hash[query_type][item]
      @logger.debug "      #{item}: #{hash[query_type][item]}" if val>0
    end
  end
end
