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

  # Novo método para exportar dados para CSV
  def self.to_csv
    # Requer a biblioteca padrão CSV do Ruby
    require 'csv'
    
    # Define os atributos que serão as colunas do CSV
    attributes = %w[id marca nome valor_diaria]

    CSV.generate(headers: true) do |csv|
      csv << attributes # Adiciona a linha de cabeçalho
      
      all.each do |carro|
        # Mapeia os valores dos atributos para uma nova linha
        csv << attributes.map { |attr| carro.send(attr) }
      end
    end
  end
end