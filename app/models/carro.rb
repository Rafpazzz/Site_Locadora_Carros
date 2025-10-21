class Carro < ApplicationRecord
  has_many :emprestimos
  has_many :locatarios, through: :emprestimos

  # Suas outras validações
  validates :marca, :cor, :nome, presence: true
  
  # A linha abaixo foi corrigida (presence: true, uniqueness: true)
  validates :placa, presence: true, uniqueness: true
  
end
