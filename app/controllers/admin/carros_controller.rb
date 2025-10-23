# app/controllers/admin/carros_controller.rb

# CORREÇÃO: Herdar do seu controller de admin para segurança
class Admin::CarrosController < Admin::BaseController
  before_action :set_carro, only: %i[ show edit update destroy ]

  def index
    @carros = Carro.all
  end

  def show
    # Esta ação é herdada, mas não é usada pelo seu admin
  end

  def new
    @carro = Carro.new
  end

  def edit
    # Esta ação é herdada
  end

  def create
    @carro = Carro.new(carro_params)

    respond_to do |format|
      if @carro.save
        # CORREÇÃO: Redirecionar para a lista de admin
        format.html { redirect_to admin_carros_path, notice: "Carro criado com sucesso." }
        format.json { render :show, status: :created, location: [:admin, @carro] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @carro.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @carro.update(carro_params)
        # CORREÇÃO: Redirecionar para a lista de admin
        format.html { redirect_to admin_carros_path, notice: "Carro atualizado com sucesso." }
        format.json { render :show, status: :ok, location: [:admin, @carro] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @carro.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @carro.destroy!

    respond_to do |format|
      # CORREÇÃO: Redirecionar para a lista de admin
      format.html { redirect_to admin_carros_path, notice: "Carro removido com sucesso." }
      format.json { head :no_content }
    end
  end

  private
    
    def set_carro
      @carro = Carro.find(params[:id])
    end

    # Esta parte já estava correta, permitindo todos os seus campos.
    def carro_params
      params.require(:carro).permit(
        :nome, 
        :cor, 
        :ano, 
        :marca, 
        :combustivel, 
        :cambio, 
        :placa, 
        :valor_diaria
      )
    end
end