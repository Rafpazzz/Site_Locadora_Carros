class Carro < ApplicationRecord
  # ... suas associações ...
  has_many :emprestimos
  has_many :locatarios, through: :emprestimos

  # --- LÓGICA DE NEGÓCIO ---
  validates :nome, :marca, :placa, :valor_diaria, presence: true
  validates :placa, uniqueness: true

  # Regras para os campos de string
  validates :combustivel, inclusion: { 
    in: %w[gasolina alcool flex diesel], 
    message: "inválido. Use: gasolina, alcool, flex ou diesel." 
  }
  
  validates :cambio, inclusion: { 
    in: %w[manual automatico], 
    message: "inválido. Use: manual ou automatico." 
  }
end