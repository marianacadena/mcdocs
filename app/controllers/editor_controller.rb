class EditorController < ApplicationController
  before_action :authenticate_academico!
  require 'htmltoword'
  def edit
    @doc = Documento.new
  end
  def export_pdf
  end

  def create_doc
    @doc = Documento.new(params_create_doc)
    @doc.formato = "docx"
    nombre_arch = "#{@doc.nombre}.docx".html_safe
    arch_new = Htmltoword::Document.create_and_save @doc.contenido, nombre_arch
    @doc.archivo.attach(io: File.open(arch_new), filename: @doc.nombre + ".docx", content_type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' )
    @doc.academico = current_academico
    if @doc.valid?
      @doc.save!
      arch_new.close
      # FileUtils.rm_rf('/Users/marianacro/RubymineProjects/mcdocs/' + @doc.nombre+".docx")
      redirect_to home_path
    else
      flash[:notice] = "No se puede subir el archivo"
    end

  end
  private
    def params_create_doc
      params.require(:documento).permit(:nombre, :contenido)
    end
  end
