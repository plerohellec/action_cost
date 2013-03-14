module ActionCost
  class StatsCollector
    def initialize
      @stats = {}
    end

    def push(request)
      ca = controller_action_string(request)
      add_request(ca, request.operation_stats, request.table_stats)
    end

    def log
      pp @stats
    end

   private
    def add_request(ca, operations, tables)
      if @stats[ca]
        @stats[ca][:num] += 1
      else
        @stats[ca] = { :num => 1, :operations => {}, :tables => {} }
      end
      
      ActionCost::SqlParser::VALID_OPERATIONS.each do |op|
        increment_item(@stats[ca][:operations], op, operations[op])
      end

      tables.each_key do |table|
        increment_item(@stats[ca][:tables], table, tables[table])
      end
    end

    def increment_item(hash, item, val)
      if hash[item]
        hash[item] += val
      else
        hash[item] = val
      end
    end

    def controller_action_string(request)
      "#{request.controller_name}/#{request.action_name}"
    end
  end
end
