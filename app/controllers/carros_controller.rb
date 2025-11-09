class CarrosController < ApplicationController
  def index
    @carros = Carro.all

    # 🔍 Busca geral (nome, marca ou placa)
    if params[:query].present?
      termo = "%#{params[:query]}%"
      @carros = @carros.where("nome ILIKE ? OR marca ILIKE ? OR placa ILIKE ?", termo, termo, termo)
    end

    # 🎯 Filtros específicos
    @carros = @carros.where(marca: params[:marca]) if params[:marca].present?
    @carros = @carros.where(cambio: params[:cambio]) if params[:cambio].present?
    @carros = @carros.where(combustivel: params[:combustivel]) if params[:combustivel].present?

    # 💰 Faixa de preço
    if params[:valor_min].present?
      @carros = @carros.where("valor_diaria >= ?", params[:valor_min])
    end
    if params[:valor_max].present?
      @carros = @carros.where("valor_diaria <= ?", params[:valor_max])
    end

    @carros = @carros.order(:marca, :nome)

    respond_to do |format|
      format.html { @carros = @carros.page(params[:page]).per(9) }
      format.csv  { send_data @carros.to_csv, filename: "carros-#{Date.today}.csv" }
      format.pdf
    end
  end

  def show
    @carro = Carro.find(params[:id])
  end
end
