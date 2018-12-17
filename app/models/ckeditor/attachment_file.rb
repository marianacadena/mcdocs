class Ckeditor::AttachmentFile < Ckeditor::Asset
  has_one_attached :data
                    #:url => "/ckeditor_assets/attachments/:id/:filename",
                    #:path => ":rails_root/public/ckeditor_assets/attachments/:id/:filename"



  def url_thumb
    @url_thumb ||= Ckeditor::Utils.filethumb(filename)
  end
end
