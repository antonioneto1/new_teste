class ConsultasController < ApplicationController
  skip_before_action :verify_authenticity_token


  def titulos_da_base
    return render :json => {message: "Digite o numero do CNPJ do cedente"}, status: 400 unless params.dig(:q, :cnpj_cedente_eq).present?
    @q = Titulo.ransack(params[:q])
    @titulos = @q.result(distinct: true)
    response = map_vencimento(@titulos)
    return render json: response, status: 200
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
    render :json => {message: "O titulo de Numero: #{params[:numero]}, Possui o Seguinte status #{response['status']}"}, status: 200
  end

  def status_do_titulo(numero_do_titulo)
    registro = Registro.new
    result = registro.consulta(numero_do_titulo)
    result['status']
  end

  def titulo_vencido?(vecimento)
    vecimento.present? && vecimento.to_date < Date.today
  end

  def map_vencimento(titulos)
    titulos.each do |titulo|
      titulo.vencido = titulo_vencido?(titulo.data_vencimento)
      titulo.save
    end
  end
end
