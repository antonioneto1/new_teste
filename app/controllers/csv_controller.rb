class CsvController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  end

  def titulos_da_base
    @titulos = Titulo.all
    render :json => @titulos
  end

  def protestados
    return render :json => {message: "Digite o numero do CNPJ"}, status: 400 unless params[:cnpj].present?

    titulos = Protesto.new
    response = titulos.consulta(params[:cnpj])
    render :json => response
  end

  def titulo_registrado
    return render :json => {message: "Digite o numero do Titulo"}, status: 400 unless params[:numero].present?

    titulos = Registro.new
    response = titulos.consulta(params[:numero])
    render :json => response
  end

  def importar
    if params[:file_csv].present?
      file = params[:file_csv].tempfile.path
      Thread.new do
        leitura_csv(file)
      end
      render :json => {message: 'Os titulos estao sendo imporados, embreve voce poderá conferir'}, status: 200
    else
      titulos = params.dig("csv","_json")
      import_titulo(titulos)
    end
  end

  def import_titulo(titulos)
    errors = []
    titulos.each do |titulo|
      t = Titulo.create
      t.numero_titulo = titulo['numero_titulo']
      t.cnpj_cedente = titulo['cnpj_cedente']
      t.cnpj_sacado = titulo['cnpj_sacado']
      t.valor = titulo['valor'].to_f 
      t.data_vencimento = titulo['data_vencimento'].to_date if t.titulo_vencido?
      t.data_importacao = Date.today
      if t.valid?
        t.save
      else
        errors << "O Titulo de numero #{t.numero_titulo} possui os seguintes erros #{t.errors.messages }"
      end
    end
    render :json => {message: errors}, status: 400
    return
  end


  def leitura_csv(file)
    errors = []
    File.open(file).each do |r|
      begin
        r = r.join(",") if r.is_a?(Array)
        r = r.split(";")
        if r[0].present?
          next if r[0] == "numero_titulo"
          t = Titulo.create
          t.numero_titulo = r[0]
          t.cnpj_cedente = r[1]
          t.cnpj_sacado = r[2]
          t.valor = r[3].to_f
          t.data_vencimento = r[4]
          t.data_importacao = Date.today
          if t.valid?
            t.save
          else
            errors << "O Titulo de numero #{t.numero_titulo} possui os seguintes erros #{t.errors.messages }"
          end
        end
      rescue
      end
      render :json => {message: errors}, status: 400 
    end
  end
end
