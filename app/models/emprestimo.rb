class Emprestimo < ApplicationRecord
    belongs_to :locatario
    belongs_to :carro
    
end
