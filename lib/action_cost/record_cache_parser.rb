module ActionCost
  class RecordCacheParser
    attr_reader :table_name, :operation, :join_tables, :invalid

    VALID_OPERATIONS = %w{ select insert update delete }

    def initialize(table_name)
      @invalid  = false
      @table_name = table_name
      @join_tables = []
      @operation = 'select'
    end

    def parse
      return true
    end

    def log
      if @invalid
        Rails.logger.debug "action_cost: record cache non parsable query"
      else
        Rails.logger.debug "action_cost: record_cache operation=#{@operation} table_name=#{@table_name} " +
                           "join_tables=#{@join_tables.inspect}"
      end
    end
  end
end
