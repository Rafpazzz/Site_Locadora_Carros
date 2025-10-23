json.extract! locatario, :id, :nome, :cpf, :created_at, :updated_at
json.url locatario_url(locatario, format: :json)
