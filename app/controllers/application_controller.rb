class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  #chama o metodo de configuração do devise
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  #metodo diz ao devise quais campos extras deve permitir salvar durante o cadastro
  def configure_permitted_parameters
    #para o formulario de cadastro
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nome, :cpf])

    #para o formulario de editar a conta do usuario
    devise_parameter_sanitizer.permit(:account_update, keys: [:nome])
  end
end
