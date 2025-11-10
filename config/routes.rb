# config/routes.rb
Rails.application.routes.draw do
  
  # === SUAS ROTAS DEVISE (Mantidas) ===
  # Mantém as suas URLs personalizadas (login, logout, cadastro, etc.)
  devise_for :locatarios, controllers: { 
    registrations: 'locatarios/registrations',
    sessions: 'locatarios/sessions'
  }, 
  path: '', 
  path_names: { 
    sign_in: 'login',           
    sign_out: 'logout',        
    sign_up: 'cadastro',        
    edit: 'minha-conta'         
  }
  
  # (A linha 'sign_out_via: :get' foi removida pois era um erro de sintaxe)
  
  # === ROTAS PÚBLICAS (Corrigidas) ===
  
  root "carros#index"

  resources :carros, only: [:index, :show] do
    # CORREÇÃO: Cria /carros/:carro_id/emprestimos/new
    resources :emprestimos, only: [:new, :create], shallow: true
  end

  # A rota 'Meus Empréstimos' (index) fica separada
  resources :emprestimos, only: [:index]

  # === ROTAS DE ADMIN (Mantidas) ===
  namespace :admin do
    root "dashboard#index"
    resources :locatarios, except: [:new, :create]
    resources :carros
    resources :emprestimos
  end
  
  get "up" => "rails/health#show", as: :rails_health_check
end