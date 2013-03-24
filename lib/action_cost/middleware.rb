module ActionCost
  class Middleware

    attr_reader :request_stats, :stats_collector
    cattr_accessor :singleton

    def initialize(app)
      @app = app
      @stats_collector = ActionCost::StatsCollector.new
      @request_stats = nil

      @@singleton = self
    end

    def call(env)
      start_request(env)
      @app.call(env)
    ensure
      end_request
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

    def self.push_sql_parser(parser)
      return unless singleton.request_stats
      singleton.request_stats.push(parser)
    end

    def self.accumulated_stats
      return unless singleton.stats_collector
      singleton.stats_collector.data
    end
  end  
end
