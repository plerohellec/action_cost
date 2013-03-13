Rails.application.routes.draw do
  namespace :action_cost do
    resources :dashboards
  end
end
