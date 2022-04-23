class Titulo < ApplicationRecord
  require 'csv'

  validates :cnpj_cedente, presence: {:message => "CNPJ do Cedente é obrigatório"}
  validates :cnpj_sacado, presence: {:message => "CNPJ do Sacado é obrigatório"}
  validates :numero_titulo, presence: {:message => "Numero do Titulo é obrigatório"}
  validates :data_vencimento, presence: {:message => "A data de vencimento do Titulo é obrigatório"}
  validates :valor, presence: {:message => "O Valor do Titulo é obrigatório"}
  
  validate :valor_zerado, :on => :create


  enum status: { nao_registrado: 0, registrado: 1 }

  def status_do_titulo
    registro = Registro.new
    result = registro.consulta(self.numero_titulo)
    result['status']
  end

  def valor_zerado
    errors.add(:valor, "O valor do titulo nao pode ser menor 0.0") if self.valor.zero?
  end

  def titulo_vencido?
    data_vencimento.present? && data_vencimento.to_date < Date.today
  end

  def err_titulo_vencido
    "O titulo de numero #{numero_titulo}, encontra-se vencido"
  end

  def err_duplicado
    "Já existe um titulo de numero #{numero_titulo}, para o Cedente #{cnpj_cedente}"
  end

  def titulo_duplicado?
    return true if Titulo.where(cnpj: cnpj, numero_titulo: numero_titulo).count > 0
  end

  def titulo_duplicado?
    return true if Titulo.where(cnpj_cedente: self.cnpj_cedente, numero_titulo: self.numero_titulo).count > 0
  end
end
