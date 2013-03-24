module ActionCost
  class SqlParser
    attr_reader :table_name, :operation, :join_tables, :invalid

    VALID_OPERATIONS = %w{ select insert update delete }
    
    def initialize(sql)
      @invalid  = false
      @sql      = sql
      @join_tables = []
    end

    def parse
      if @sql =~ /^\s*(\w+)/
        op = $1.downcase
        unless VALID_OPERATIONS.include?(op)
          Rails.logger.error "action_cost: unknown operation [#{op}]"
          @invalid = true
          return false
        end
        @operation = op
      else
        Rails.logger.error "action_cost: could not parse [#{@sql}]"
        @invalid = true
        return false
      end

      case @operation
      when 'select' then parse_select
      when 'insert' then parse_insert
      when 'update' then parse_update
      when 'delete' then parse_delete
      end

      return !@invalid
    end

    def log
      if @invalid
        Rails.logger.debug "action_cost: non parsable query"
      else
        Rails.logger.debug "action_cost: operation=#{@operation} table_name=#{@table_name} " +
                           "join_tables=#{@join_tables.inspect}"
      end
    end
    
   private

    def parse_select
      if @sql =~ /from "?(\w+)"?\b/i
        @table_name = $1.downcase
      else
        @invalid = true
        return
      end

      @sql.scan(/join "?(\w+)"?\b/i) do |arr|
        arr.each do |t|
          @join_tables << t.downcase
        end
      end
    end

    def parse_insert
      if @sql =~ /insert into "?(\w+)"?\b/i
        @table_name = $1.downcase
      else
        @invalid = true
      end
    end

    def parse_update
      if @sql =~ /^update "?(\w+)"?\b/i
        @table_name = $1.downcase
      else
        @invalid = true
      end
    end

    def parse_delete
      if @sql =~ /^delete from "?(\w+)"?\b/
        @table_name = $1.downcase
      else
        @invalid = true
      end
    end
  end
end