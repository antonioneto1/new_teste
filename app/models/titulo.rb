class Titulo < ApplicationRecord
  require 'csv'

  validates :cnpj_cedente, presence: {:message => "CNPJ do Cedente é obrigatório"}
  validates :cnpj_sacado, presence: {:message => "CNPJ do Sacado é obrigatório"}
  validates :numero_titulo, presence: {:message => "Numero do Titulo é obrigatório"}
  validates :data_vencimento, presence: {:message => "A data de vencimento do Titulo é obrigatório"}
  validates :valor, presence: {:message => "O Valor do Titulo é obrigatório"}

  validate :titulo_vencido?
  #validate :titulo_protestado?

  enum status: { nao_registrado: 0, registrado: 1 }

  def titulo_vencido?
    self.data_vencimento.present? && self.data_vencimento.to_date < Date.today
  end

  def titulo_protestado?
    titulos = Protesto.consulta(self.cnpj_cedente)
    if titulos.present?
      titulo.each do |t|
      end
    end
  end

  def titulo_duplicado?
    return true if Titulo.where(cnpj: self.cnpj, numero_titulo: self.numero_titulo).count > 0
  end
end
