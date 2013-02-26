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
  match 'templates/:action' => "templates#:action", as: 'templates'

  scope 'films' do
    match 'index', to: 'films#index', as: 'films'
    match 'trends/:trend', :constraints => {:trend => /now_playing|latest|upcoming/}, to: 'films#trend', as:'films_trend'
    get 'search', to: "films#search", as: 'films_search'
    get 'quick_search', to: "films#quick_search", as: 'films_quick_search'
    match 'genre/:genre_id', to: "films#genre", as: 'films_genre'
    match ':id', to: 'films#show', as: 'film'
  end

  scope 'persons' do
    match 'index', to: 'persons#index', as: 'persons'
    get 'search', to: "persons#search", as: 'persons_search'
    get 'quick_search', to: "persons#quick_search", as: 'persons_quick_search'
    match ':id', to: 'persons#show', as: 'person'
  end

  scope ':user_id', :constraints => { :user_id => /.*/ } do
    resources :films, 
      :only => [:index, :show], to: 'user_films',
      :constraints => { :id => /watched|loved|unloved|queued|owned/ }, 
      as: 'user_film' do 
        member do 
          put ':film_id', to: 'user_films#update', as: 'update'
          delete ':film_id', to: 'user_films#destroy', as: 'update'
        end
      end
    resources :lists, to: 'user_lists', as: 'user_lists'
    # match 'lists/:id', to: 'user_lists#create', via: :post
    match 'queue/:action', :constraints => {:action => /list|recommend|show/}, to: "queue", as: 'queue', via: :get
  end


  
end
