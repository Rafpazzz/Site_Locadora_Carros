class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  #chama o metodo de configuração do devise
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def after_sign_in_path_for(resource)
    # Verificamos se o 'resource' (o locatário) é um admin.
    if resource.is_a?(Locatario) && resource.admin?
      # Se for admin, vá para o painel de admin (a lista de carros do admin).
      admin_carros_path
    else
      # Se for um usuário normal, vá para a página inicial (a lista pública).
      root_path
    end
  end

  #metodo diz ao devise quais campos extras deve permitir salvar durante o cadastro
  def configure_permitted_parameters
    #para o formulario de cadastro
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nome, :cpf])

    #para o formulario de editar a conta do usuario
    devise_parameter_sanitizer.permit(:account_update, keys: [:nome])
  end
end
