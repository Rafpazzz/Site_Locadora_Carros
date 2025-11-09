# config/routes.rb
Rails.application.routes.draw do
  
  devise_for :locatarios, controllers: { 
    registrations: 'locatarios/registrations',
    # Informa ao Devise para usar o seu controller de 'sessions' personalizado
    sessions: 'locatarios/sessions'
  }, 
  path: '', 
  path_names: { 
    sign_in: 'login',           
    sign_out: 'logout',        
    sign_up: 'cadastro',        
    edit: 'minha-conta'         
  },
  

  sign_out_via: :get
  

  resources :carros, only: [:index, :show]
  resources :emprestimos, only: [:new, :create, :index, :show] 
  root "carros#index"
  namespace :admin do
    resources :locatarios
    resources :carros
    resources :emprestimos
  end
  get "up" => "rails/health#show", as: :rails_health_check
end