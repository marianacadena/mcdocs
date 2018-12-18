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
    #
    #
    #  # if !@archivo_pem.nil?
    #       key_pem = File.read(@archivo_pem.tempfile)
    #
    #       key = OpenSSL::PKey::RSA.new key_pem, @clave_pem
    #       if(key)
    #         digest = OpenSSL::Digest::SHA256.new
    #         #archivo = '/Users/cristina/Downloads/tema5.pdf'
    #         #archivo = pem_file
    #         #ruta_archivo = '/Users/cristina/Downloads/'
    #         #n_archivo = 'tema5.pdf'
    #
    #
    #         signature = key.sign digest, self.archivo
    #
    #         nombre_final = "mcdocs_certificado_#{current_academico.numPersonal}.pdf"
    #         #filename = "#{Prawn::DATADIR}/pdfs/multipage_template.pdf"
    #         Prawn::Document.generate("certificado.pdf", :template => archivo) do
    #           font "Times-Roman"
    #           text "FIRMADO POR: + #{current_academico.nombre} + " " #{current_academico.apellidos}", :align => :center
    #           text "LOCALIZACIÓN: México", :align => :center
    #           text "PUBLIC KEY: + #{key.public_key.to_s}", :align => :center
    #           text "CIFRADO DEL DOCUMENTO: + #{digest.to_s}", :align => :center
    #           text "FECHA CERTIFICACIÓN: + #{DateAndTime.now.to_s}", :align => :center
    #         end
    #
    #         pdf = CombinePDF.new
    #         pdf << CombinePDF.load(self.archivo)
    #         pdf << CombinePDF.load("certificado.pdf")
    #         pdf.save nombre_final
    #       else
    #         #flash[:notice] = "La contraseña del pem es inválida"
    #       end
    #     end
    #
    #

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

  def pem_file_key=(archivo, clave)
    @archivo_pem = archivo
    @clave_pem = clave
  end

end
