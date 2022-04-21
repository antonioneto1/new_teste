class HomeController < ApplicationController
  #before_action :set_titulo

  def index
  end

  def import
    @titulo.import(params[:cnpj])
  end

  def consulta
    @titulo.consulta(params[:cnpj])
  end

  def set_titulo
    @titulo = Titulo.new
  end
end
