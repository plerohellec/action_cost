module ActionCost
  class RequestStats
    
    def initialize(env)
      request = ActionController::Routing::Routes.recognize_path(env['REQUEST_URI'])
      @controller_name = request[:controller]
      @action_name     = request[:action]
    end

    def push(sql_parser)
      sql_parser.parse
      sql_parser.log
    end

    def close
    end
   
  end
end
