class CarrosController < ApplicationController
  def index
    @carros = Carro.where(isDisponivel: true) # Mostra apenas disponíveis

    if params[:query].present?
      termo = "%#{params[:query]}%"
      # Trocamos ILIKE por LIKE
      @carros = @carros.where("nome LIKE ? OR marca LIKE ? OR placa LIKE ?", termo, termo, termo)
    end
   
    # --- Filtros Adicionais ---
    @carros = @carros.where(marca: params[:marca]) if params[:marca].present?
    @carros = @carros.where(cambio: params[:cambio]) if params[:cambio].present?
    @carros = @carros.where(combustivel: params[:combustivel]) if params[:combustivel].present?

    @carros = @carros.order(:marca, :nome)

    @carros = @carros.page(params[:page]).per(9)

    # (Lógica para PDF e CSV)
    respond_to do |format|
      format.html
      format.csv { send_data Carro.to_csv(@carros), filename: "carros-#{Date.today}.csv" }
      format.pdf do
        pdf = CarroPdf.new(@carros)
        send_data pdf.render,
                  filename: "carros-#{Date.today}.pdf",
                  type: "application/pdf",
                  disposition: "inline" # ou "attachment" para baixar
      end
    end
  end

  def show
    @carro = Carro.find(params[:id])
  end
end