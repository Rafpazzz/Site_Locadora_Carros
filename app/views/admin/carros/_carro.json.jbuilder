json.extract! carro, :id, :nome, :cor, :ano, :marca, :created_at, :updated_at
json.url carro_url(carro, format: :json)
