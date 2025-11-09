class Admin::CarrosController < Admin::BaseController
  before_action :set_carro, only: %i[ show edit update destroy ]

  def index
    @carros = Carro.all

    # 🔍 Busca geral
    if params[:query].present?
      termo = "%#{params[:query]}%"
      @carros = @carros.where("nome ILIKE ? OR marca ILIKE ? OR placa ILIKE ?", termo, termo, termo)
    end

    # 🎯 Filtros específicos
    @carros = @carros.where(marca: params[:marca]) if params[:marca].present?
    @carros = @carros.where(cambio: params[:cambio]) if params[:cambio].present?
    @carros = @carros.where(combustivel: params[:combustivel]) if params[:combustivel].present?

    # 💰 Filtro opcional por faixa de preço
    if params[:valor_min].present?
      @carros = @carros.where("valor_diaria >= ?", params[:valor_min])
    end
    if params[:valor_max].present?
      @carros = @carros.where("valor_diaria <= ?", params[:valor_max])
    end

    @carros = @carros.order(:marca, :nome)
  end

  def show; end
  def new; @carro = Carro.new; end
  def edit; end

  def create
    @carro = Carro.new(carro_params)
    if @carro.save
      redirect_to admin_carros_path, notice: "Carro criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @carro.update(carro_params)
      redirect_to admin_carros_path, notice: "Carro atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @carro.destroy!
    redirect_to admin_carros_path, notice: "Carro removido com sucesso."
  end

  private

  def set_carro
    @carro = Carro.find(params[:id])
  end

  def carro_params
    params.require(:carro).permit(
      :nome, 
      :cor, 
      :ano_para_select, 
      :marca, 
      :combustivel, 
      :cambio, 
      :placa, 
      :valor_diaria
    )
  end
end
