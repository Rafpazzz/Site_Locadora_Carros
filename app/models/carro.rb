class Carro < ApplicationRecord
 
  has_many :emprestimos
  has_many :locatarios, through: :emprestimos

  validates :nome, :marca, :placa, :valor_diaria, :ano, presence: true
  validates :placa, uniqueness: true

  validates :combustivel, inclusion: { 
    in: %w[gasolina alcool flex diesel], 
    message: "inválido. Use: gasolina, alcool, flex ou diesel." 
  }
  
  validates :cambio, inclusion: { 
    in: %w[manual automatico], 
    message: "inválido. Use: manual ou automatico." 
  }

  # Atributo virtual 'setter' para o formulário de ano
  def ano_para_select=(year)
    if year.present? && year.to_i > 0
      self.ano = Date.new(year.to_i, 1, 1)
    else
      self.ano = nil
    end
  end

  # Atributo virtual 'getter' para o formulário de ano
  def ano_para_select
    self.ano.year if self.ano.present?
  end

  # Retorna uma string formatada ("Nome (Placa)") para ser usada
  # no collection_select do formulário de admin.
  def nome_e_placa
    "#{nome} (#{placa})"
  end

  # === Métodos de Classe ===

  def self.to_csv
    require 'csv'
    
    attributes = %w[id marca nome valor_diaria]

    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |carro|
        csv << attributes.map { |attr| carro.send(attr) }
      end
    end
  end
end