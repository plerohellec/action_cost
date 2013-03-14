class ActionCost::DashboardsController < ApplicationController

  layout 'action_cost'
  
  def index
    respond_to do |format|
      format.json do
        render :json => ActionCost::Middleware.accumulated_stats.to_json
      end
      format.html do
        @data = ActionCost::Middleware.accumulated_stats
        ca_sums = {}
        @data.each_pair do |key, val|
          #val[:operations]['select'] = 0 unless val[:operations]['select']
          ca_sums[key] = val[:operations][:rc]['select'] + val[:operations][:sql]['select']
        end
        @sorted_cas = ca_sums.sort_by { |k,v| v/@data[k][:num] }.reverse.map { |v| v[0] }
        render
      end
    end
  end


  def ca
    ca = params[:ca]
    @data = ActionCost::Middleware.accumulated_stats
    @num = @data[ca][:num]
    @tables = @data[ca][:tables]
    @rc_sorted_table_names  = @tables[:rc].sort_by { |k,v| v/@data[ca][:num] }.reverse.map { |v| v[0] }
    @sql_sorted_table_names = @tables[:sql].sort_by { |k,v| v/@data[ca][:num] }.reverse.map { |v| v[0] }
  end
end
