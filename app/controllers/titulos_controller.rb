class TitulosController < ApplicationController
  #before_action :set_titulo, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token
  

  # GET /titulos or /titulos.json
  def index
    @titulos = Titulo.all
  end

  # GET /titulos/1 or /titulos/1.json
  def show
  end

  # GET /titulos/new
  def new
    @titulo = Titulo.new
  end

  # GET /titulos/1/edit
  def edit
  end

  # POST /titulos or /titulos.json
  def create
    @titulo = Titulo.new(titulo_params)
    respond_to do |format|
      if @titulo.save
        format.html { redirect_to titulo_url(@titulo), notice: "Titulo was successfully created." }
        format.json { render :show, status: :created, location: @titulo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @titulo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /titulos/1 or /titulos/1.json
  def update
    respond_to do |format|
      if @titulo.update(titulo_params)
        format.html { redirect_to titulo_url(@titulo), notice: "Titulo was successfully updated." }
        format.json { render :show, status: :ok, location: @titulo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @titulo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /titulos/1 or /titulos/1.json
  def destroy
    @titulo.destroy

    respond_to do |format|
      format.html { redirect_to titulos_url, notice: "Titulo was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def importar
    if params[:file_csv].present?
      file = params[:file_csv].tempfile.path
      leitura_csv(file)
    else
      titulos = params.dig("_json")
      import_titulo(titulos)
    end
  end

  def import_titulo(titulos)
    errors = []
    response = []
    cnpjs = []
    status = 200
    titulos.each do |titulo|
      dados = {
        numero_titulo: titulo['numero_titulo'],
        cnpj_cedente: titulo['cnpj_cedente'],
        cnpj_sacado: titulo['cnpj_sacado'],
        valor: titulo['valor'].to_f,
        data_vencimento: titulo['data_vencimento'].to_date,
        data_importacao: Date.today
      }
      t = Titulo.create(dados)
      t.status = t.status_do_titulo
      if t.valid?
        t.save
        cnpjs << t.cnpj_cedente
        cnpjs << t.cnpj_sacado
      else
        errors = t.errors.messages
        response << parse_respnse(titulo, errors)
        status = 400
      end
    end

    response << titulos_protestado?(cnpjs.uniq) if status == 200
    render :json => response, status: status
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
          dados = {
            numero_titulo: r[0],
            cnpj_cedente: r[1],
            cnpj_sacado: r[2],
            valor: r[3].to_f,
            data_vencimento: r[4],
            data_importacao: Date.today
          }
          t = Titulo.create(dados)
          t.status = t.status_do_titulo
          if t.valid?
            t.vencido = false
            cnpjs << t.cnpj_cedente
            cnpjs << t.cnpj_sacado
            t.save
          else
            errors = t.errors.messages
            response << parse_respnse(t, errors)
            status = 400
          end
        end
      rescue
      end
      response << titulos_protestado?(cnpjs.uniq) if status == 200
      render :json => response, status: status
    end
  end

  def titulos_protestado?(cnpjs)
    protestos = []
    protesto = Protesto.new
    if cnpjs.any?
      cnpjs.each do |cnpj|
        titulos = protesto.consulta(cnpj)
        protestos << {
          mensagem: "O Cedente de CNPJ #{cnpj}, possui a quantidade #{titulos.count} titulos protestados.",
          titulos: titulos
        }
      end
    end
    protestos
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_titulo
      @titulo = Titulo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def titulo_params
      params.fetch(:titulo, {})
    end
end
