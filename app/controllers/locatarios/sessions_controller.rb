class Locatarios::SessionsController < Devise::SessionsController
  # Executa o método 'set_no_cache_headers' ANTES da página 'new' (login)
  # e da ação 'create' (submeter o login).
  before_action :set_no_cache_headers, only: [:new, :create]

  private

  # Este método diz ao navegador para NUNCA guardar esta página em cache.
  def set_no_cache_headers
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
end