class ActionCost::DashboardsController < ApplicationController
  def index
    render :json => ActionCost::Middleware.accumulated_stats.to_json
  end
end
