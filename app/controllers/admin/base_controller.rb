# app/controllers/admin/base_controller.rb
class Admin::BaseController < ApplicationController

  layout 'admin'

  # 1. Garante que o usuário está logado
  before_action :authenticate_locatario!

  # 2. Garante que o usuário logado é um admin
  before_action :authorize_admin!

  private

  # Nosso método de segurança privado
  def authorize_admin!
    # Se o usuário atual NÃO for admin, expulse-o para a página inicial com um alerta.
    unless current_locatario&.admin?
      redirect_to root_path, alert: "Acesso negado. Você não é permitido nessa área."
    end
  end
end