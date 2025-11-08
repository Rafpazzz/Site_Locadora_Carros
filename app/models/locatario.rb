class Locatario < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :alugueis
  has_many :emprestimos
  has_many :carros, through: :alugueis

  validates :nome, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :cpf, presence: true, uniqueness: true

  validates :cpf, format: { with: /\A\d{11}\z/, message: "deve conter 11 dígitos numéricos (sem pontos ou traços)" }, if: -> { cpf.present? }

  before_validation :limpar_cpf

  before_save :formatar_nome

  private

  def limpar_cpf
    if self.cpf.present?
      #gsub = remove tudo que nao for um digito
      self.cpf = self.cpf.gsub(/\D/,'')
    end
  end

  def formatar_nome
    if self.nome.present?
      #capitaliza o nome de uma forma inteligente
      self.nome = self.nome.titleize
    end
  end
  
end
