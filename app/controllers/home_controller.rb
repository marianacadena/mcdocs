class HomeController < ApplicationController
  before_action :remove_authentication_flash_message_if_root_url_requested
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
      @certificado = FirmaElectronica.new
      #@certificado.generar_certificado(pem_file, pass_pem, archivo)
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
    flash[:notice] = doc_off.save! ? "Se ha eliminado" : "No se ha podido eliminar"
    redirect_to home_path
  end

  def auth_pass
    clave_actual = params[:pass_actual]
    puts "CLAVE ACTUAL" + clave_actual
    clave_pem = params[:pass_pem]
    puts "PEM" + clave_pem
    clave_confirm_pem = params[:conf_pass_pem]
    puts "CONF_PEM" + clave_confirm_pem
    if params[:pass_actual]
      puts "HOLAA"
      if current_academico.valid_password?(clave_actual)
        puts "HIIII"
        if clave_pem == clave_confirm_pem
          puts "AAAAA"
          @firma = FirmaElectronica.new
          @firma.generar_firma(current_academico, clave_pem)
          send_file(@firma.private_key, filename: "privatekey.pem", type: "application/x-pem-file")
          #redirect_to home_path
          #FileUtils.rm_rf('/Users/marianacro/RubymineProjects/mcdocs/' + @doc.nombre+".docx")
        else
          flash[:notice] = "Las claves del archivo pem no coinciden"
        end
      else
        flash[:notice] = "Contraseña incorrecta"
      end
    else

    end
  end

  def generate_signature

  end

  private
  def upload_doc_params
    params.require(:documento).permit(:nombre, :archivo)
  end
  def download_pdf
    send_file asset_path(url_for(params[:documento].archivo)), type: "application/pdf", x_sendfile: true
  end
  def remove_authentication_flash_message_if_root_url_requested
    if session[:academico_return_to] == root_path and flash[:alert] == I18n.t('devise.failure.unauthenticated')
      flash[:alert] = nil
    end
  end
end
