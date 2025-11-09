# app/models/emprestimo.rb
class Emprestimo < ApplicationRecord
  
  # === Associações ===
  belongs_to :locatario
  belongs_to :carro

  # === Validações ===
  validates :data_inicio, :data_fim, presence: true
  validate :data_inicio_nao_pode_ser_no_passado, on: :create
  validate :data_fim_deve_ser_depois_data_inicio

  # === Callbacks (Lógica de Negócio Automática) ===
  
  # Calcula o valor_total antes de criar o registro
  before_validation :calcular_valor_total, on: :create
  
  # (Passo 2) Marca o carro como indisponível após a criação do empréstimo
  after_create :marcar_carro_como_indisponivel

  # (Passo 3) Atualiza a disponibilidade do carro se o status do empréstimo mudar
  after_update :atualizar_disponibilidade_do_carro, if: :saved_change_to_status?

  
  private

  # --- Métodos de Validação ---

  def data_inicio_nao_pode_ser_no_passado
    if data_inicio.present? && data_inicio < Date.today
      errors.add(:data_inicio, "não pode ser no passado")
    end
  end

  def data_fim_deve_ser_depois_data_inicio
    if data_inicio.present? && data_fim.present? && data_fim <= data_inicio
      errors.add(:data_fim, "deve ser posterior à data de início")
    end
  end

  # --- Métodos de Callback ---

  # Calcula o valor total com base no número de dias e na diária do carro
  def calcular_valor_total
    return unless data_fim.present? && data_inicio.present? && carro.present?
      
    dias = (data_fim.to_date - data_inicio.to_date).to_i
    dias = 1 if dias <= 0 # Garante o mínimo de 1 dia
    
    self.valor_total = dias * carro.valor_diaria
  end

  # Marca o carro associado como indisponível (isDisponivel = false)
  def marcar_carro_como_indisponivel
    carro.update(isDisponivel: false)
  end
  
  # Verifica o status do empréstimo e atualiza o carro
  def atualizar_disponibilidade_do_carro
    if status == "Devolvido"
      carro.update(isDisponivel: true)
    elsif status == "Locado" || status == "Pendente"
      carro.update(isDisponivel: false)
    end
  end
end