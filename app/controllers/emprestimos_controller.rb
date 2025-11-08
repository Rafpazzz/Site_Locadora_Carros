# app/controllers/emprestimos_controller.rb
class EmprestimosController < ApplicationController
  # Todos que não são admin precisam estar logados para ver estas páginas
  before_action :authenticate_locatario!

  # GET /emprestimos (A página "Meus Empréstimos")
  def index
    # Mostra apenas os empréstimos do utilizador que está logado
    @emprestimos = current_locatario.emprestimos.order(data_inicio: :desc)
    
    # Você PRECISA criar a view para isto:
    # Crie o arquivo: app/views/emprestimos/index.html.erb
  end

  # GET /emprestimos/new (O formulário para alugar)
  def new
    @emprestimo = Emprestimo.new
    # Precisamos de saber qual carro está a ser alugado (vem da URL)
    @carro = Carro.find(params[:carro_id])
  end

  # POST /emprestimos (A ação de salvar)
  def create
    @carro = Carro.find(params[:emprestimo][:carro_id])
    @emprestimo = Emprestimo.new(emprestimo_params)
    
    # --- LÓGICA IMPORTANTE ---
    # Associa o empréstimo ao utilizador logado
    @emprestimo.locatario = current_locatario
    # Associa o empréstimo ao carro
    @emprestimo.carro = @carro
    # --- FIM DA LÓGICA ---

    if @emprestimo.save
      # --- ESTA É A CORREÇÃO DO SEU ERRO ---
      # Em vez de: redirect_to @emprestimo (que vai para o 'show')
      # Mude para:
      redirect_to emprestimos_path, notice: "Aluguel confirmado com sucesso! O valor total é R$ #{@emprestimo.valor_total}."
    else
      # Se falhar (ex: data errada), mostre o formulário 'new' novamente
      render :new, status: :unprocessable_entity
    end
  end

  # Esta ação (show) causou o seu erro. 
  # Não a estamos a usar por agora, mas vamos deixá-la aqui.
  def show
    # O seu erro antigo (...17-05-58.png) foi corrigido
    @emprestimo = current_locatario.emprestimos.find(params[:id])
  end

  private

  # Define quais parâmetros do formulário são permitidos
  def emprestimo_params
    params.require(:emprestimo).permit(:data_inicio, :data_fim, :carro_id)
  end
end