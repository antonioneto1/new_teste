class Protesto
  include HTTParty
  base_uri 'https://6e3v4cnk5i.execute-api.us-east-1.amazonaws.com/default/validatorProtestoFake?'

  def initialize
    @options = {}
  end

  def consulta(cnpj)
    @options = { query: { cnpj: cnpj} }
    JSON.parse(self.class.get("/", @options))
  end
end