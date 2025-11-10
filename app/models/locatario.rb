class Locatario < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :emprestimos

  validates :nome, :cpf, presence: { message: "O CPF não pode ficar em branco." }
  validates :cpf, uniqueness: { message: "Este CPF já está cadastrado no sistema." }
  validates :cpf, format: { 
      with: /\A\d{11}\z/, # Garante que são 11 dígitos (d) e nada mais (\A ... \z)
      message: "deve conter 11 dígitos numéricos, sem pontos ou traços" 
    }

  # Adicionamos um gatilho 'before_destroy' para verificar os empréstimos
  before_destroy :desvincular_ou_impedir_exclusao

  private

  def desvincular_ou_impedir_exclusao
    # 1. Verifica se existe ALGUM empréstimo que NÃO esteja "Devolvido"
    if self.emprestimos.where.not(status: "Devolvido").exists?
      
      # 2. Se sim, impede a exclusão
      # Adiciona um erro ao objeto
      errors.add(:base, "Não é possível excluir: este locatário possui empréstimos 'Locados' ou 'Pendentes' ativos.")
      
      throw :abort 
    
    else
      # "desvincula" o histórico (define locatario_id = NULL)
      self.emprestimos.update_all(locatario_id: nil)
      
    end
  end
  
end