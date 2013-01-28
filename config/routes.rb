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

  scope 'films' do
    match 'trends/:trend', :constraints => {:trend => /now_playing|latest|upcoming/}, to: 'films#trend', as:'films_trend'
    get 'search', to: "films#search", as: 'films_search'
    match 'genre/:genre_id', to: "films#genre", as: 'films_genre'
  end

  scope ':username', :constraints => { :username => /.*/ } do
    resources :films, 
      :only => [:index, :show], to: 'user_films',
      :constraints => { :id => /watched|loved|unloved|queued|owned/ } do 
        member do 
          put ':film_id', to: 'user_films#update', as: 'update'
          delete ':film_id', to: 'user_films#destroy', as: 'update'
        end
      end
  end


  
end
