Filmlovers::Application.routes.draw do

  root :to => 'app#index'

  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')

  match 'signout', to: 'sessions#destroy', as: 'signout'

  match 'login', to: 'app#login', as: 'login'
  get 'current_user' => 'sessions#currentuser'

  # scope 'user/:user_id' do
  #   resources :films, 
  #     :only => [:index, :show], to: 'user_films',
  #     :constraints => { :id => /watched|loved|unloved|queued|owned/ } do 
  #       member do 
  #         put ':film_id', to: 'user_films#update', as: 'update'
  #         delete ':film_id', to: 'user_films#destroy', as: 'update'
  #       end
  #     end
  # end

  # namespace :search do
  #   get 'films'
  # end

  match 'genre/:id' => "search#genre", as: 'genre'

  scope 'films' do
    match 'trends/:trend', :constraints => {:trend => /now_playing|latest|upcoming/}, to: 'films#trend', as:'films_trend'
    get 'search', to: "films#search", as: 'films_search'
    match 'genre/:genre_id', to: "films#genre", as: 'films_genre'
    match ':id', to: 'film#show', as: 'film' 
  end

  scope ':user_id', :constraints => { :user_id => /.*/ } do
    resources :films, 
      :only => [:index, :show], to: 'user_films',
      :constraints => { :id => /watched|loved|unloved|queued|owned/ }, as: 'user_film' do 
        member do 
          put ':film_id', to: 'user_films#update', as: 'update'
          delete ':film_id', to: 'user_films#destroy', as: 'update'
        end
      end
  end


  
end
