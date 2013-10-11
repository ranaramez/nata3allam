Nata3allam::Application.routes.draw do
  
  devise_for :users, :path => "", :path_names => { :sign_in => 'login', :sign_out => 'logout'}
  
  resources :admin_dashboard, only: :index

  resources :n_class, only: [:index, :show]

  match '/class_schedule', :to => 'n_class#schedule'
 
    
  root :to => 'Home#index'
end
