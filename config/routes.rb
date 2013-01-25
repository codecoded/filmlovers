Filmlovers::Application.routes.draw do

  root :to => 'app#index'

  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'signout', to: 'sessions#destroy', as: 'signout'

  get 'current_user' => 'sessions#currentuser'

  namespace :search do
    get 'films'
  end

  match 'genre/:id' => "search#genre", as: 'genre'

  scope ':username' do
    resources :films, 
      :only => [:index, :show], 
      :constraints => { :id => /watched|loved|unloved|queued|owned/ } do 
        member do 
          put ':film_id', to: 'films#update', as: 'update'
          delete ':film_id', to: 'films#destroy', as: 'update'
        end
      end
  end
  
end
