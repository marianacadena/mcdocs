Rails.application.routes.draw do
  get 'chat/index'
  #registros será el controlador que creamos
  devise_for :academicos, skip:[:sessions], controllers:{registrations:"registrations"} #Se indica que el controlador para
  as :academico do
    root 'devise/sessions#create'
    get 'signin', to: 'devise/sessions#create', as: :new_academico_session
    post 'signin', to: 'devise/sessions#create', as: :academico_session
    get 'signout', to: 'devise/sessions#destroy', as: :destroy_academico_session
    get 'registrarse', to: 'devise/registrations#new', as: :new_academico_registrations
  end
  # get 'welcome/index'
  # root 'welcome#index'

  get 'home', to: 'home#index_home', as: :home
  get 'show', to: 'home#show_docx', as: :show_docs
  post 'upload_doc', to:'home#upload_doc', as: :upload
  get 'edit', to: 'editor#edit', as: :editor
  get 'compartir', to: 'compartir#show', as: :compartir
  post 'create_doc', to: 'editor#create_doc', as: :create_doc
  post 'share_doc', to: 'home#share_doc', as: :share_doc
  mount Ckeditor::Engine => '/ckeditor'
  #get 'download_pdf', to: "home#download_pdf/:documento"
  post 'detele_doc', to: 'home#delete_doc', as: :delete_doc

  resources :conversations, only: [:create] do
    member do
      post :close
    end
    resources :messages, only: [:create]
  end

  mount ActionCable.server => '/ConversationChannel'


  get 'chat', to: 'chat#index', as: :chat
  post 'generar_hash', to: 'home#auth_pass', as: :auth_pass
  post 'generar_certificado', to: 'home#generate_signature', as: :generate_certificate
end
