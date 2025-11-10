class Admin::LocatariosController < Admin::BaseController
  before_action :set_locatario, only: %i[ show edit update destroy ]

  # GET /admin/locatarios
  def index
    @locatarios = Locatario.order(:nome)

    if params[:query].present?
      termo = "%#{params[:query].strip}%"
      @locatarios = @locatarios.where("email LIKE ? OR cpf LIKE ?", termo, termo)
    end

    @locatarios = @locatarios.page(params[:page]).per(9)
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
    if @locatario.destroy
      redirect_to admin_locatarios_path, notice: "Locatário foi excluído com sucesso. O histórico de empréstimos foi mantido (anonimizado)."
    else  
      error_message = @locatario.errors.full_messages.to_sentence
      
      # Se a mensagem estiver em branco (por outro motivo), usa uma padrão
      error_message = "Não foi possível excluir o locatário." if error_message.blank?
      
      # Redireciona para a página anterior (provavelmente a 'show') com o alerta
      redirect_to request.referrer || [:admin, @locatario], alert: error_message
    end
  end

  private
    
    def set_locatario
      @locatario = Locatario.find(params[:id])
    end

    def locatario_params
      params.require(:locatario).permit(:nome, :email, :admin, :cpf)
    end
end