class CsvController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  end

  def titulos_da_base
    byebug
    return render :json => {message: "Digite o numero do CNPJ do cedente"}, status: 400 unless params.dig(:q, :cnpj_cedente_eq).present?
    @q = Titulo.ransack(params[:q])
    @titulos = @q.result(distinct: true)
    return render json: @titulos, status: 200
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
    response = []
    cnpjs = []
    status = 200
    titulos.each do |titulo|
      t = Titulo.create
      t.numero_titulo = titulo['numero_titulo']
      t.cnpj_cedente = titulo['cnpj_cedente']
      t.cnpj_sacado = titulo['cnpj_sacado']
      t.valor = titulo['valor'].to_f 
      t.data_vencimento = titulo['data_vencimento'].to_date
      t.status = status_do_titulo(titulo['numero_titulo'])
      t.data_importacao = Date.today
      if t.valid?
        t.save
        cnpjs << t.cnpj_cedente
      else
        errors << t.errors.messages
        response << parse_respnse(titulo, t.errors.messages)
        status = 400
      end
    end
    response << titulos_protestado?(cnpjs.uniq) if status == 200
    render :json => {message: response}, status: status
    return
  end

  def parse_respnse(titulo, errors)
    {
      titulo: titulo,
      errors: errors
    }
  end


  def leitura_csv(file)
    errors = []
    response = []
    cnpjs = []
    status = 200
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
          t.status = status_do_titulo(numero_do_titulo)
          if t.valid?
            t.save
            cnpjs << t.cnpj_cedente
          else
            errors << t.errors.messages
            response << parse_respnse(titulo, t.errors.messages)
            status = 400
          end
        end
      rescue
      end
      response[:protestos] = titulos_protestado?(cnpjs.uniq) if status == 200
      render :json => {message: response}, status: status 
    end
  end

  def status_do_titulo(numero_do_titulo)
    registro = Registro.new
    result = registro.consulta(numero_do_titulo)
    result['status']
  end

  def titulo_vencido?(vecimento)
    vecimento.present? && vecimento.to_date < Date.today
  end

  def titulos_protestado?(cnpjs)
    protestos = []
    protesto = Protesto.new
    if cnpjs.any?
      cnpjs.each do |cnpj|
        titulos = protesto.consulta(cnpj)
        protestos << {
          mensagem: "O Cedente de CNPJ #{cnpj}, possui a quantidade #{titulos.count} titolos protestados.",
          titulos: titulos
        }
      end
    end
    protestos
  end
end
