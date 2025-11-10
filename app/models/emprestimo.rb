class Emprestimo < ApplicationRecord
  
  # === Associações ===
  belongs_to :locatario
  belongs_to :carro

  # === Validações ===
  validates :data_inicio, :data_fim, presence: true
  validate :data_inicio_nao_pode_ser_no_passado, on: :create
  validate :data_fim_deve_ser_depois_data_inicio

  # === Callbacks (Lógica de Negócio Automática) ===
  
  before_validation :calcular_valor_total, on: :create
  
  after_create :definir_carro_como_indisponivel
  after_update :atualizar_disponibilidade_do_carro, if: :saved_change_to_status?

  # A correção para o bug de "excluir"
  after_destroy :definir_carro_como_disponivel
  
  private

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

  def calcular_valor_total
    return unless data_fim.present? && data_inicio.present? && carro.present?
      
    dias = (data_fim.to_date - data_inicio.to_date).to_i
    dias = 1 if dias <= 0
    
    self.valor_total = dias * carro.valor_diaria
  end

  # (Gatilho 'after_create' e 'after_update')
  def definir_carro_como_indisponivel
    carro.update(isDisponivel: false) if carro.present?
  end
  
  # (Gatilho 'after_update')
  def atualizar_disponibilidade_do_carro
    # Se o admin mudou o status para "Devolvido"
    if status == "Devolvido"
      definir_carro_como_disponivel
    # Se o admin mudou para "Locado" ou "Pendente"
    elsif status == "Locado" || status == "Pendente"
      definir_carro_como_indisponivel
    end
  end

  # (Gatilho 'after_destroy' e 'after_update')
  def definir_carro_como_disponivel
    carro.update(isDisponivel: true) if carro.present?
  end
  
end