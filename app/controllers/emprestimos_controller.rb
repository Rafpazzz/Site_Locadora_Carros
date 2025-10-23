# app/controllers/emprestimos_controller.rb
class EmprestimosController < ApplicationController
  # Exige que o locatário esteja logado para QUALQUER ação
  # neste controller (new, create, index, show).
  before_action :authenticate_locatario!

  # GET /emprestimos (Mostra MEUS empréstimos)
  def index
    # Graças ao Devise, podemos usar 'current_locatario'
    @emprestimos = current_locatario.emprestimos.order(data_inicio: :desc)
  end

  # GET /emprestimos/1 (Mostra o detalhe de UM dos meus empréstimos)
  def show
    @emprestimo = current_locatario.emprestimos.find(params[:id])
  end

  # GET /emprestimos/new (O formulário para alugar)
  def new
    # Precisamos saber qual carro o usuário escolheu (veio do link)
    @carro = Carro.find(params[:carro_id])
    
    # Criamos um empréstimo "em branco" para o formulário
    @emprestimo = Emprestimo.new(carro: @carro)
  end

  # POST /emprestimos (Salva o novo aluguel)
  def create
    @emprestimo = Emprestimo.new(emprestimo_params)
    
    # Associamos o empréstimo ao USUÁRIO LOGADO
    @emprestimo.locatario = current_locatario
    
    # Definimos um status inicial
    @emprestimo.status = 'pendente' 

    if @emprestimo.save
      redirect_to @emprestimo, notice: 'Carro alugado com sucesso!'
    else
      # Se falhar, precisamos do @carro de novo para mostrar o formulário
      @carro = @emprestimo.carro 
      render :new, status: :unprocessable_entity
    end
  end

  private


  # Strong Parameters para o formulário
  def emprestimo_params
    params.require(:emprestimo).permit(:carro_id, :data_inicio, :data_fim)
  end

end
