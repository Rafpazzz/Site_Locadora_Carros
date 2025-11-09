class Admin::EmprestimosController < Admin::BaseController
  before_action :set_emprestimo, only: %i[ show edit update destroy ]

  def index
    @emprestimos = Emprestimo.all
  end

  def show
  end

  # Carrega os dados necessários para o formulário de NOVO empréstimo
  def new
    @emprestimo = Emprestimo.new
    
    # --- CORREÇÃO (Passo 2) ---
    # Carrega locatários (ordenados por email) e carros (ordenados por placa)
    @locatarios = Locatario.order(:email)
    @carros = Carro.where(isDisponivel: true).order(:placa)
  end

  # Carrega os dados necessários para o formulário de EDITAR empréstimo
  def edit
    # --- CORREÇÃO (Passo 2) ---
    # Carrega locatários (ordenados por email) e carros (ordenados por placa)
    @locatarios = Locatario.order(:email)
    @carros = Carro.order(:placa)
  end

  def create
    @emprestimo = Emprestimo.new(emprestimo_params)

    respond_to do |format|
      if @emprestimo.save
        format.html { redirect_to [:admin, @emprestimo], notice: "Emprestimo was successfully created." }
        format.json { render :show, status: :created, location: [:admin, @emprestimo] }
      else
        # Recarrega os dropdowns em caso de falha na validação
        @locatarios = Locatario.order(:email)
        @carros = Carro.where(isDisponivel: true).order(:placa)
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @emprestimo.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @emprestimo.update(emprestimo_params)
        format.html { redirect_to [:admin, @emprestimo], notice: "Emprestimo was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: [:admin, @emprestimo] }
      else
        # Recarrega os dropdowns em caso de falha na validação
        @locatarios = Locatario.order(:email)
        @carros = Carro.order(:placa)
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @emprestimo.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @emprestimo.destroy!

    respond_to do |format|
      format.html { redirect_to admin_emprestimos_path, notice: "Emprestimo was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    
    def set_emprestimo
      @emprestimo = Emprestimo.find(params[:id])
    end

    # Define os 'strong parameters'
    def emprestimo_params
      params.require(:emprestimo).permit(:locatario_id, :carro_id, :data_inicio, :data_fim, :data_devolucao, :valor_total, :status)
    end
end