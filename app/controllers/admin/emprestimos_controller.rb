class Admin::EmprestimosController < Admin::BaseController
  before_action :set_emprestimo, only: %i[ show edit update destroy ]

  # GET /admin/emprestimos
  def index
    @emprestimos = Emprestimo.all
  end

  # GET /admin/emprestimos/1
  def show
  end

  # GET /admin/emprestimos/new
  def new
    @emprestimo = Emprestimo.new
  end

  # GET /admin/emprestimos/1/edit
  def edit
  end

  # POST /admin/emprestimos
  def create
    @emprestimo = Emprestimo.new(emprestimo_params)

    respond_to do |format|
      if @emprestimo.save
        # --- CORREÇÃO ---
        # Redireciona para a rota de admin
        format.html { redirect_to [:admin, @emprestimo], notice: "Emprestimo was successfully created." }
        format.json { render :show, status: :created, location: [:admin, @emprestimo] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @emprestimo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/emprestimos/1
  def update
    respond_to do |format|
      if @emprestimo.update(emprestimo_params)
        # --- CORREÇÃO ---
        # Redireciona para a rota de admin
        format.html { redirect_to [:admin, @emprestimo], notice: "Emprestimo was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: [:admin, @emprestimo] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @emprestimo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/emprestimos/1
  def destroy
    @emprestimo.destroy!

    respond_to do |format|
      # --- CORREÇÃO ---
      # Redireciona para a rota index de admin
      format.html { redirect_to admin_emprestimos_path, notice: "Emprestimo was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    
    def set_emprestimo
      # Mudamos params.expect(:id) para a forma padrão params[:id]
      @emprestimo = Emprestimo.find(params[:id])
    end

    # Os seus 'strong parameters' já estão corretos.
    def emprestimo_params
      params.require(:emprestimo).permit(:locatario_id, :carro_id, :data_inicio, :data_fim, :data_devolucao, :valor_total, :status)
    end
end