class HomeController < ApplicationController
  before_action :authenticate_academico!
  def index_home
    @doc_uploaded = Documento.new
    @academicos = Academico.new.find_other_academicos(current_academico.email)
    if params[:compa]
      @mis_docs =  Documento.new.get_shared_docs(current_academico)
      @partial_view = "layouts/compartidos"
    else
      @mis_docs =  Documento.new.get_my_docs(current_academico)
      @partial_view = "layouts/mis_docs"
    end
  end
  def upload_doc
    @doc_uploaded = Documento.new(upload_doc_params)
    @doc_uploaded.academico = current_academico
    if @doc_uploaded.archivo.content_type == "application/pdf"
      @doc_uploaded.formato = "pdf"
    else
      @doc_uploaded.formato = "docx"
    end
    if @doc_uploaded.valid? #&& @doc_uploaded.formato == @doc_uploaded.archivo.content_type
      @doc_uploaded.save!
      redirect_to root_path
    end
  end
  def share_doc
    documento = Documento.find params[:documento_id]
    documento.colaboradores = params[:colaboradores]

    if documento.save!
      redirect_to home_path
    else
      flash[:notice] = "El archivo no se ha podido compartir"
      redirect_to home_path
    end
  end
  def delete_doc
    doc_off = Documento.find(params[:doc_id])
    doc_off.activo = 0
    if doc_off.save!
      flash[:notice] =  "Se ha eliminado"
    else
      flash[:notice] =  "No se ha podido eliminar"
    end
    redirect_to home_path
  end

  def auth_pass
    @firma = FirmaElectronica.new
    @firma.generar_firma(current_academico)
    send_file(@firma.private_key, filename: "privatekey.pem", type: "application/x-pem-file")

  end
  private
    def upload_doc_params
      params.require(:documento).permit(:nombre, :archivo)
    end
    def download_pdf
      send_file asset_path(url_for(params[:documento].archivo)), type: "application/pdf", x_sendfile: true
    end
end
