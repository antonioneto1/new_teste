class TitulosController < ApplicationController
  before_action :set_titulo, only: %i[ show edit update destroy ]

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
