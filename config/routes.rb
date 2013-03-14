Rails.application.routes.draw do

  namespace :action_cost do
    get '/' => 'dashboards#index'
    match '/ca/:ca' => 'dashboards#ca', :as => 'ca', :constraints => { :ca => /.*/ }
    #resources :dashboards
  end

end
