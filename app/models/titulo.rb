class Titulo < ApplicationRecord
  require 'csv'

  validates_presence_of :cnpj_cedente, :message => "É necessario o CNPJ do Cedente"
  validates_presence_of :cnpj_sacado, :message => "É necessario o CNPJ do Sacado"
  validates_presence_of :numero_titulo, :message => "É necessario o numero do Titulo", :uniqueness => {:message => "Código já cadastrado"}
  validates_presence_of :cnpj_sacado, :message => "É necessario o CNPJ do Sacado"
  validates_presence_of :data_vencimento, :message => "É necessario a data de vencimento do titulo"
  validates_presence_of :valor, :message => "É necessario ter valor"

  validate :titulo_vencido?
  #validate :titulo_protestado?

  enum status: { nao_registrado: 0, registrado: 1 }

  def titulo_vencido?
    byebug
    self.data_vencimento.to_date < Date.today
  end

  def titulo_protestado?
    titulos = Protesto.consulta(self.cnpj_cedente)
    if titulos.present?
      titulo.each do |t|
      end
    end
  end

  def titulo_registrado?
    result = Registro.consulta(self.numero_titulo)
    self.status = result['status']
  end
end
