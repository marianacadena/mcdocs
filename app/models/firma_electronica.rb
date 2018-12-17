class FirmaElectronica < ApplicationRecord
  require 'openssl'
  require 'prawn'
  require 'tempfile'


  belongs_to :academico
  has_one_attached :public_key_file
  attr_accessor :private_key


  def generar_firma(academico)
    key = OpenSSL::PKey::RSA.new 4096
    cipher = OpenSSL::Cipher.new 'AES-128-CBC'
    pass_phrase = academico.numPersonal.to_s
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

  def generar_certificado
    #
    # digest = OpenSSL::Digest::SHA256.new
    #       archivo = '/Users/cristina/Downloads/tema5.pdf'
    #       ruta_archivo = '/Users/cristina/Downloads/'
    #       n_archivo = 'tema5.pdf'
    #       puts "digest: "
    #       puts digest
    #       signature = key.sign digest, archivo
    #
    #       puts "Signature: "
    #       puts signature
    #
    #
    #       nombre_final = ruta_archivo + "certificado_" + n_archivo
    #       #filename = "#{Prawn::DATADIR}/pdfs/multipage_template.pdf"
    #       Prawn::Document.generate("certificado.pdf", :template => archivo) do
    #         font "Times-Roman"
    #         text "public key: + #{key.public_key.to_s}", :align => :center
    #         text "digest: + #{digest.to_s}", :align => :center
    #       end
    #
    #       pdf = CombinePDF.new
    #       pdf << CombinePDF.load(archivo)
    #       pdf << CombinePDF.load("certificado.pdf")
    #       pdf.save nombre_final
    #
    #
  end
end
