# config/routes.rb
Rails.application.routes.draw do
  
  # --- ROTAS PÚBLICAS / DEVISE ---
  devise_for :locatarios, controllers: { 
    registrations: 'locatarios/registrations' 
  }, 
  path: '', 
  path_names: { 
    sign_in: 'login',           
    sign_out: 'logout',        
    sign_up: 'cadastro',        
    edit: 'minha-conta'         
  }

  resources :carros, only: [:index, :show]
  resources :emprestimos, only: [:new, :create, :index, :show] 
  
  root "carros#index"

  # --- ROTAS ADMINISTRATIVAS ---
  # O namespace :admin corrige seu erro 'admin_carros_path'
  namespace :admin do
    resources :locatarios
    resources :carros
    resources :emprestimos
  end

  # Rota de Health Check
  get "up" => "rails/health#show", as: :rails_health_check
end