Rails.application.routes.draw do
  get 'upload/index'
  get 'upload/new'
  get 'upload/create'
  get 'upload/destroy'
  post 'upload/uploadFile'
  root 'application#index'
  devise_for :users
  
  resources :files, only: [:index, :new, :create, :destroy]   
   root "files#index"  
end

