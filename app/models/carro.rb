class Carro < ApplicationRecord
  has_many :emprestimos
  has_many :locatarios, through: :emprestimos

  # Validações de presença
  validates :nome, :marca, :placa, :valor_diaria, :ano, presence: true
  validates :placa, uniqueness: true

  # Validações de inclusão
  validates :combustivel, inclusion: { 
    in: %w[gasolina alcool flex diesel], 
    message: "inválido. Use: gasolina, alcool, flex ou diesel." 
  }
  
  validates :cambio, inclusion: { 
    in: %w[manual automatico], 
    message: "inválido. Use: manual ou automatico." 
  }

  # --- Atributos Virtuais para o formulário de 'ano' ---

  # Converte o ano do select (ex: "2024") para a data (2024-01-01)
  # antes de salvar no banco de dados.
  def ano_para_select=(year)
    if year.present? && year.to_i > 0
      self.ano = Date.new(year.to_i, 1, 1)
    else
      self.ano = nil
    end
  end

  # Retorna o ano (ex: 2024) para o <select> do formulário
  # ler e pré-selecionar o valor correto na edição.
  def ano_para_select
    self.ano.year if self.ano.present?
  end

  # --- Métodos de Classe ---

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