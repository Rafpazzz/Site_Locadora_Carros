class CarrosController < ApplicationController
  
# NOVO CÓDIGO para app/controllers/carros_controller.rb

def index
    # Busca todos os carros para CSV/PDF
    @carros = Carro.order(:nome) 
    
    respond_to do |format|
      # Aplica paginação (Kaminari) APENAS para a view HTML
      format.html { @carros = @carros.page(params[:page]).per(9) }
      
      # Exportação CSV
      format.csv { send_data @carros.to_csv, filename: "carros-publicados-#{Date.today}.csv" }
      
      # Exportação PDF (agora deve funcionar automaticamente)
      format.pdf
    end
  end

  
  def show
    @carro = Carro.find(params[:id])
  end


end