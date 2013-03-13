Rails.application.routes.draw do
  scope :module => "action_cost" do
    get "/action_cost" => "dashboards#index"
  end
end
