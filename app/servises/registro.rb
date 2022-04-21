class Registro
  include HTTParty
  base_uri 'https://rgshxukw2a.execute-api.us-east-1.amazonaws.com/default/validadorRegistroTituloFake?'

  def initialize
    @options = {}
  end

  def consulta(numero_titulo)
    @options = { query: { numero_titulo: numero_titulo} }
    JSON.parse(self.class.get("/", @options))
  end
end