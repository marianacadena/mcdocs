module HomeHelper
  def academicos_to_share (id_doc)
    @academicos_comparir = Academico.where.not( has_colaboracions: HasColaboracion.where( documento: id_doc.id ), id: id_doc.academico.id )
  end
end
