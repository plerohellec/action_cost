module ActionCost
  class Middleware

    class << self
      def start_request(env)
        @@request_stats = ActionCost::RequestStats.new(env)
      end

      def end_request
        @@request_stats.close
        @@stats_collector.push(@@request_stats)
        @@request_stats = nil
      end

      def push_sql_parser(sql_parser)
        return unless @@request_stats
        @@request_stats.push(sql_parser)
      end
    end

    def initialize(app)
      puts "action_cost initializing middleware"
      @app = app
      @@stats_collector = ActionCost::StatsCollector.new
      @@request_stats = nil
    end

    def call(env)
      self.class.start_request(env)
      @app.call(env)
    ensure
      self.class.end_request
    end
  end  
end
