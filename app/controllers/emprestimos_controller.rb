class EmprestimosController < ApplicationController
  # === Filtros Before Action ===
  # 1. Garante que o usuário esteja logado para TODAS as ações
  before_action :authenticate_locatario!
  
  # 2. Encontra o Carro (pelo :carro_id) para 'new' e 'create'
  before_action :set_carro, only: [:new, :create]
  
  # 3. Garante que o carro encontrado esteja disponível (só para 'new' e 'create')
  before_action :garantir_carro_disponivel, only: [:new, :create]

  # GET /emprestimos (Meus Empréstimos)
  def index
    # A lógica complexa da consulta foi movida para um método privado
    @emprestimos = buscar_emprestimos.page(params[:page]).per(5)
  end

  # GET /carros/:carro_id/emprestimos/new
  def new
    # O 'set_carro' e 'garantir_carro_disponivel' já rodaram
    # A ação 'new' agora só tem 1 responsabilidade: construir o objeto
    @emprestimo = @carro.emprestimos.build
  end

  # POST /carros/:carro_id/emprestimos
  def create
    # Constrói o empréstimo a partir da associação com o carro
    @emprestimo = @carro.emprestimos.build(emprestimo_params)
    # Adiciona o locatário logado
    @emprestimo.locatario = current_locatario

    if @emprestimo.save
      redirect_to emprestimos_path, notice: "Locação solicitada com sucesso! O carro aguarda aprovação."
    else
      # O '@carro' já foi carregado pelo 'set_carro',
      # então o 'render :new' funciona corretamente.
      render :new, status: :unprocessable_entity
    end
  end

  private

  # --- Métodos de Lógica (Query) ---

  # Retorna a consulta base para a página index
  def buscar_emprestimos
    current_locatario.emprestimos
                     .includes(:carro) # Otimiza (evita N+1 query)
                     .order(data_inicio: :desc) # Mais novos primeiro
  end

  # --- Métodos de Filtro (Setup) ---

  # Encontra o Carro pai
  def set_carro
    @carro = Carro.find(params[:carro_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to carros_path, alert: "Carro não encontrado."
  end

  # Garante que o carro do 'set_carro' esteja disponível
  def garantir_carro_disponivel
    # Se o carro estiver disponível, o método termina e a ação continua
    return if @carro.isDisponivel?
    
    # Se não, redireciona com um alerta
    redirect_to carros_path, alert: "Este carro não está disponível no momento."
  end

  # --- Strong Parameters ---

  # O usuário público só pode enviar as datas
  def emprestimo_params
    params.require(:emprestimo).permit(:data_inicio, :data_fim)
  end
end