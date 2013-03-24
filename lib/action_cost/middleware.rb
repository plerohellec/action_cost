module ActionCost

  # ActionCost data store
  class Data
    attr_reader :request_stats, :stats_collector
    
    def initialize
      # Per process storage
      @stats_collector = ActionCost::StatsCollector.new
      # Per HTTP request storage
      @request_stats = nil
    end

    def start_request(env)
      @request_stats = ActionCost::RequestStats.new(env)
    end

    def end_request
      return unless @request_stats
      @request_stats.close
      @stats_collector.push(@request_stats)
      @request_stats = nil
    end
    
    def push_sql_parser(parser)
      return unless @request_stats
      @request_stats.push(parser)
    end

    def accumulated_stats
      return unless @stats_collector
      @stats_collector.data
    end
  end

  # Middleware responsability is to initialize and close RequestStats
  # object at start and end of HTTP query.
  class Middleware

    def initialize(app)
      @app = app
    end

    def self.action_cost_data
      $action_cost_data
    end

    def call(env)
      self.class.action_cost_data.start_request(env)
      @app.call(env)
    ensure
      self.class.action_cost_data.end_request
    end
    
    def self.push_sql_parser(parser)
      action_cost_data.push_sql_parser(parser)
    end

    def self.accumulated_stats
      action_cost_data.accumulated_stats
    end
  end  
end
