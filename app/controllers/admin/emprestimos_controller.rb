class Admin::EmprestimosController < Admin::BaseController
  before_action :set_emprestimo, only: %i[ show edit update destroy ]

  def index
    @emprestimos = Emprestimo.includes(:carro, :locatario)

    # 2. Lógica da Busca (por Placa ou CPF)
    if params[:query].present?
      termo = "%#{params[:query].strip}%"
      # Adiciona 'references' para permitir o 'where' nas tabelas associadas
      @emprestimos = @emprestimos.references(:carro, :locatario).where(
        "carros.placa LIKE ? OR locatarios.cpf LIKE ? OR locatarios.email LIKE ?", 
        termo, termo, termo
      )
    end

    @emprestimos = @emprestimos.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
  end

  def new
    @emprestimo = Emprestimo.new
    @locatarios = Locatario.order(:email)
    @carros = Carro.where(isDisponivel: true).order(:placa)
  end

  def edit
    @locatarios = Locatario.order(:email)
    @carros = Carro.order(:placa)
  end

  def create
    @emprestimo = Emprestimo.new(emprestimo_params)

    respond_to do |format|
      if @emprestimo.save
        format.html { redirect_to [:admin, @emprestimo], notice: "Emprestimo foi criado com sucesso." }
        format.json { render :show, status: :created, location: [:admin, @emprestimo] }
      else
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
        format.html { redirect_to [:admin, @emprestimo], notice: "Emprestimo foi atualizado com sucesso.", status: :see_other }
        format.json { render :show, status: :ok, location: [:admin, @emprestimo] }
      else
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
      format.html { redirect_to admin_emprestimos_path, notice: "Emprestimo foi excluído com sucesso.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    
    def set_emprestimo
      @emprestimo = Emprestimo.find(params[:id])
    end

    def emprestimo_params
      params.require(:emprestimo).permit(:locatario_id, :carro_id, :data_inicio, :data_fim, :data_devolucao, :valor_total, :status)
    end
end