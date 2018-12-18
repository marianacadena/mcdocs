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


end
