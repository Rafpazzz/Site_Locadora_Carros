# app/models/emprestimo.rb
class Emprestimo < ApplicationRecord
  
  # --- ASSOCIAÇÕES ---
  belongs_to :locatario
  belongs_to :carro

  # --- VALIDAÇÕES ---
  validates :data_inicio, :data_fim, presence: true
  validate :data_inicio_nao_pode_ser_no_passado
  validate :data_fim_deve_ser_depois_data_inicio

  # --- CALLBACK (A LÓGICA DE NEGÓCIO) ---
  # Calcula o valor_total automaticamente ANTES de criar o registro
  before_validation :calcular_valor_total, on: :create

  private

  # Verifica se a data de início não é anterior a hoje
  def data_inicio_nao_pode_ser_no_passado
    if data_inicio.present? && data_inicio < Date.today
      errors.add(:data_inicio, "não pode ser no passado")
    end
  end

  # Verifica se a data final é pelo menos um dia depois da data de início
  def data_fim_deve_ser_depois_data_inicio
    if data_inicio.present? && data_fim.present? && data_fim <= data_inicio
      errors.add(:data_fim, "deve ser posterior à data de início")
    end
  end

  # --- MÉTODO PRINCIPAL DA LÓGICA ---
  def calcular_valor_total
    # Só roda se as datas e o carro estiverem presentes
    if data_fim.present? && data_inicio.present? && carro.present?
      
      # --- ESTA É A CORREÇÃO ---
      # Forçamos as colunas a serem 'Date' (data) e não 'Time' (tempo/segundos)
      # antes de subtrair.
      dias = (data_fim.to_date - data_inicio.to_date).to_i
      
      # Garante que o mínimo seja 1 dia
      dias = 1 if dias <= 0 
      
      # Pega o valor da diária do carro associado
      valor_diaria = carro.valor_diaria
      
      # Define o valor_total deste Empréstimo
      self.valor_total = dias * valor_diaria
    end
  end
end