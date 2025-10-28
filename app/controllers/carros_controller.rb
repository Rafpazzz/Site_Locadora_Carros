class CarrosController < ApplicationController
  
  def index
    @carros = Carro.order(:nome).page(params[:page]).per(9) 
  end

  
  def show
    @carro = Carro.find(params[:id])
  end

end