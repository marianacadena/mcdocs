class Academico < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_one_attached :img_perfil
  has_many_attached :doc_subidos
  has_many :messages, dependent: :destroy
  has_many :conversations, foreign_key: :sender_id
  has_many :has_colaboracions
  has_many :documentos, through: :has_colaboracions
  validates :img_perfil, presence: true
  before_create :generate_image
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :confirmable, :lockable #las ultimas dos permiten llevar un seguimiento de la cuenta y

  def generate_image
    self.img_perfil.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'imagenUsuario.png')), filename: 'img_default.png', content_type: 'image/png')
  end
  def find_other_academicos (email_remitente )
    Academico.where.not(email: email_remitente)
  end
end
