class Titulo < ApplicationRecord
  require 'csv'

  validates :cnpj_cedente, presence: {:message => "CNPJ do Cedente é obrigatório"}
  validates :cnpj_sacado, presence: {:message => "CNPJ do Sacado é obrigatório"}
  validates :numero_titulo, presence: {:message => "Numero do Titulo é obrigatório"}
  validates :data_vencimento, presence: {:message => "A data de vencimento do Titulo é obrigatório"}
  validates :valor, presence: {:message => "O Valor do Titulo é obrigatório"}
  
  validate :valor_zerado
  validate :valida_vencimento
  validate :titulo_duplicado


  enum status: { nao_registrado: 0, registrado: 1 }

  def status_do_titulo
    registro = Registro.new
    result = registro.consulta(self.numero_titulo)
    result['status']
  end

  def valor_zerado
    errors.add(:valor, "O valor do titulo nao pode ser menor 0.0") if self.valor.zero?
  end

  def valida_vencimento
    errors.add(:data_vencimento,"O titulo de numero #{numero_titulo}, encontra-se vencido") unless data_vencimento.to_date > Date.today
  end

  def titulo_duplicado
    if Titulo.where(cnpj_cedente: cnpj_cedente, numero_titulo: numero_titulo).where.not(status: nil, vencido: nil).count > 0
      errors.add(:numero_titulo, "Já existe um titulo de numero #{numero_titulo}, para o Cedente #{cnpj_cedente}")
    end
  end
end
