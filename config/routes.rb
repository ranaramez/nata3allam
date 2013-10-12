Nata3allam::Application.routes.draw do
  
  devise_for :users, :path => "", :path_names => { :sign_in => 'login', :sign_out => 'logout'}
  
  resources :admin_dashboard, only: :index

  resources :n_class do
    get :schedule
    put :course_week
  end
 
    
  root :to => 'Home#index'
end
