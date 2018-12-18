class FirmaElectronica < ApplicationRecord
  require 'openssl'
  require 'prawn'
  require 'tempfile'


  belongs_to :academico
  has_one_attached :public_key_file
  attr_accessor :private_key


  def generar_firma(academico, clave_pem)
    key = OpenSSL::PKey::RSA.new 4096
    cipher = OpenSSL::Cipher.new 'AES-128-CBC'
    pass_phrase = clave_pem.to_s
    key_secure = key.export cipher, pass_phrase
    publicKey = key.public_key.to_s
    privateKey = key.to_s
    firmaElectronica = FirmaElectronica.new(publicSSLKey: publicKey, academico: academico)

    nombre_archivo = academico.email + '_key.pem'
    archivo_clave_publica = academico.email + '_public_key.pem'
    archivo_clave_privada = academico.email + '_private_key.pem'


    open nombre_archivo, 'w+' do |io|
      io.write key_secure
    end

    open archivo_clave_publica, 'w+' do |io|
      io.write key.public_key
    end


    firmaElectronica.publicSSLKey = publicKey
    firmaElectronica.public_key_file.attach(io: File.open(archivo_clave_publica), filename: archivo_clave_publica, content_type: 'application/x-pem-file')
    firmaElectronica.save!

    firmaPrivada = Tempfile.new(['key', '.secure.pem'])
    open firmaPrivada.path, 'w+' do |io| io.write key_secure end


    self.private_key = firmaPrivada.path


    File.delete(nombre_archivo) if File.exist?(nombre_archivo)

  end

  def generar_certificado(archivo, pem_file, pass_pem)

    key_pem = File.read(pem_file.tempfile)
    key = OpenSSL::PKey::RSA.new key_pem, pass_pem

    digest = OpenSSL::Digest::SHA256.new
    #archivo = '/Users/cristina/Downloads/tema5.pdf'
    #archivo = pem_file
    #ruta_archivo = '/Users/cristina/Downloads/'
    #n_archivo = 'tema5.pdf'


    signature = key.sign digest, archivo

    nombre_final = "mcdocs_certificado_#{current_academico.numPersonal}.pdf"
    #filename = "#{Prawn::DATADIR}/pdfs/multipage_template.pdf"
    Prawn::Document.generate("certificado.pdf", :template => archivo) do
      font "Times-Roman"
      text "FIRMADO POR: + #{current_academico.nombre} + " " #{current_academico.apellidos}", :align => :center
      text "LOCALIZACIÓN: México", :align => :center
      text "PUBLIC KEY: + #{key.public_key.to_s}", :align => :center
      text "CIFRADO DEL DOCUMENTO: + #{digest.to_s}", :align => :center
      text "FECHA CERTIFICACIÓN: + #{DateAndTime.now.to_s}", :align => :center
    end

    pdf = CombinePDF.new
    pdf << CombinePDF.load(archivo)
    pdf << CombinePDF.load("certificado.pdf")
    pdf.save nombre_final
  end
end
