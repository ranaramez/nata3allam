Nata3allam::Application.routes.draw do
  
  devise_for :users, :path => "", :path_names => { :sign_in => 'login', :sign_out => 'logout'}
  
  resources :admin_dashboard, only: :index

  resources :n_classes do
    put :course_week
    get :enrolled_students
  end

  resources :students


  resources :class_schedule_entries, only: [:new, :create, :destroy]
  match 'n_class/:n_clas_id/schedule', :to => 'class_schedule_entries#index', as: 'class_schedule_entries'
    
  root :to => 'Home#index'
end
