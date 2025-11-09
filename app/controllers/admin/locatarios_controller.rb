class Admin::LocatariosController < Admin::BaseController
  before_action :set_locatario, only: %i[ show edit update destroy ]

  def index
    @locatarios = Locatario.all
  end

  def show
  end

  def new
    @locatario = Locatario.new
  end

  def edit
  end

  def create
    @locatario = Locatario.new(locatario_params)

    respond_to do |format|
      if @locatario.save
        # Redireciona para a rota 'show' de admin
        format.html { redirect_to [:admin, @locatario], notice: "Locatário foi criado com sucesso." }
        format.json { render :show, status: :created, location: [:admin, @locatario] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @locatario.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @locatario.update(locatario_params)
        # Redireciona para a rota 'show' de admin
        format.html { redirect_to [:admin, @locatario], notice: "Locatário foi atualizado com sucesso.", status: :see_other }
        format.json { render :show, status: :ok, location: [:admin, @locatario] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @locatario.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      # Usamos 'destroy' (sem !) para retornar true/false
      if @locatario.destroy
        # SUCESSO: O locatário foi excluído.
        format.html { redirect_to admin_locatarios_path, notice: "Locatário foi excluído com sucesso.", status: :see_other }
        format.json { head :no_content }
      
      else
        # FALHA: O locatário tem empréstimos (ForeignKey).
        
        # 1. Mensagem de erro personalizada.
        error_message = "Não é possível excluir este locatário pois ele possui empréstimos associados."
        
        # 2. Redireciona para a página anterior (referrer) com o alerta.
        #    (O 'status: :unprocessable_entity' foi removido para corrigir o erro 422)
        format.html { redirect_to request.referrer, alert: error_message }
        format.json { render json: { error: error_message }, status: :unprocessable_entity }
      end
    end
  end

  private
    
    def set_locatario
      @locatario = Locatario.find(params[:id])
    end

    # Define os 'strong parameters'
    def locatario_params
      params.require(:locatario).permit(:nome, :email, :admin)
    end
end