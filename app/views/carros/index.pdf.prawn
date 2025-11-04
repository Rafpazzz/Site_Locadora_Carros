# app/views/carros/index.pdf.prawn
#
# NÃO use 'require "prawn"' aqui. A gem 'prawn-rails' faz isso.
# Chame todos os métodos de desenho usando o objeto 'pdf.'

# Define o título do documento
pdf.text "LISTAGEM DE CARROS PARA LOCAÇÃO", size: 18, style: :bold, align: :center
pdf.move_down 20

# Define os dados que serão exibidos na tabela
data = [
  ["ID", "Marca", "Nome", "Placa", "Valor Diária"]
]

# Preenche os dados com os carros
# @carros é carregado pelo controller
@carros.each do |carro|
  data << [
    carro.id,
    carro.marca,
    carro.nome,
    carro.placa,
    "R$ #{carro.valor_diaria}"
  ]
end

# Gera a tabela usando o Prawn
pdf.table(data, header: true, cell_style: { size: 10, border_color: 'CCCCCC' }) do
  # Estilo do cabeçalho da tabela
  row(0).font_style = :bold
  row(0).background_color = 'EEEEEE'
  
  # Ajusta a largura das colunas
  columns(0).width = 40 # ID
  columns(1).width = 100 # Marca
  columns(2).width = 150 # Nome
  columns(3).width = 80 # Placa
  columns(4).width = 100 # Valor Diária
end

pdf.move_down 20
pdf.text "Total de Carros Listados: #{@carros.size}", size: 12