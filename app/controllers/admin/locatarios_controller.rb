class Admin::LocatariosController < Admin::BaseController
  before_action :set_locatario, only: %i[ show edit update destroy ]

  # GET /admin/locatarios
  def index
    @locatarios = Locatario.all
  end

  # GET /admin/locatarios/1
  def show
  end

  # GET /admin/locatarios/new
  def new
    @locatario = Locatario.new
  end

  # GET /admin/locatarios/1/edit
  def edit
  end

  # POST /admin/locatarios
  def create
    @locatario = Locatario.new(locatario_params)

    respond_to do |format|
      if @locatario.save
        # --- CORREÇÃO ---
        # Redireciona para a rota de admin
        format.html { redirect_to [:admin, @locatario], notice: "Locatário foi criado com sucesso." }
        format.json { render :show, status: :created, location: [:admin, @locatario] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @locatario.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/locatarios/1
  def update
    respond_to do |format|
      if @locatario.update(locatario_params)
        # --- CORREÇÃO (O seu erro estava aqui) ---
        # Redireciona para a rota de admin
        format.html { redirect_to [:admin, @locatario], notice: "Locatário foi atualizado com sucesso.", status: :see_other }
        format.json { render :show, status: :ok, location: [:admin, @locatario] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @locatario.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/locatarios/1
  def destroy
    @locatario.destroy!

    respond_to do |format|
      # --- CORREÇÃO ---
      # Redireciona para a rota index de admin
      format.html { redirect_to admin_locatarios_path, notice: "Locatário foi excluído com sucesso.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    
    def set_locatario
      # --- CORREÇÃO ---
      # A forma padrão de buscar o parâmetro :id
      @locatario = Locatario.find(params[:id])
    end

    def locatario_params
      params.require(:locatario).permit(:nome, :email, :admin)
    end
end