CloudNoteServer::Application.routes.draw do
  resources :notes

  resources :users, except: [:destroy]

  resources :user_sessions, only: [:new, :create, :destroy] do
    collection do
      post :create_api
    end
  end
end
