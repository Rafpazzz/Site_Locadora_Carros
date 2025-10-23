class CarrosController < ApplicationController
  
  def index
    @carros = Carro.page(params[:page]).per(9) # Kaminari
  end

  
  def show
    @carro = Carro.find(params[:id])
  end

end