class Documento < ApplicationRecord
  #include ActiveModel::Validations
  validates_presence_of :formato, :nombre, :academico
  #validates :archivo, file_size: { less_than_or_equal_to: 5000.kilobytes },
  #         file_content_type: { allow: ['application/pdf', 'application/msword'] }
  belongs_to :academico
  has_one_attached :archivo
  has_many :has_colaboracions
  has_many :academicos, through: :has_colaboracions
  after_save :save_academicos_colaboradores
  before_create :add_state


  def add_state
    self.activo = 1
  end
  def colaboradores=(value)
    @colaboradores = value
  end
  def save_academicos_colaboradores
    if(!@colaboradores.nil? && @colaboradores.size > 0)
      @colaboradores.each do |colaborador_id|
        HasColaboracion.create(academico_id: colaborador_id, documento_id: self.id)
      end
    end
  end

  def get_my_docs (user)
    Documento.where(academico: user, activo: 1)
  end
  def get_shared_docs (user)
    compartidos = Documento.where(has_colaboracions: HasColaboracion.where(academico: user), activo: 1)
  end
  before_validation :strip_validation
  def strip_validation
    self.nombre = self.nombre.strip unless self .nombre.nil?
    self.formato = self.formato.strip unless  self.formato.nil?
    self.contenido = self.contenido.strip unless self.contenido.nil?
  end

end
