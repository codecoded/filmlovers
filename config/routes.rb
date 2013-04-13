Filmlovers::Application.routes.draw do

  root :to => 'app#index'

  match 'auth/:provider/callback',  to: 'sessions#create'
  match 'auth/failure',             to: redirect('/')
  match 'signout',                  to: 'sessions#destroy', as: 'signout'
  match 'login',                    to: 'app#login', as: 'login'

  get 'current_user' => 'sessions#currentuser'

  match 'templates/:action' => "templates#:action", as: 'templates'

  resources 'films',        only: [:show, :index] do
    collection do
      resources 'genres',   only: [:show, :index]
      resources 'trends',   only: [:show, :index], :constraints => {:id => /now_playing|latest|upcoming|popular/}
      # 
      get 'search'
      get 'quick_search'    
      get ':user_action',        to: "films#actioned", constraints: {user_action: /search|quick_search|watched|loved|owned/}, as: 'actioned'
    end
    member do
      get ':view',          to: 'films#view', :constraints => { :view => /images|overview|cast|trailer|similar/ }, as: 'view'
      get 'summary',        to: "films#summary",        as: 'film_summary'
      get ':user_action',   to: "films#users", as: 'users', :constraints => { :user_action => /watched|loved|owned/ }
    end
  end

  resources 'persons', only: [:show, :index] do
    collection do 
      get 'search'
      get 'quick_search'
    end
  end

  resources 'channels' do
    collection do
      get 'facebook'
    end
  end

  resources :lists, :except => [:show, :index] do
    resources :films, to: 'listed_films', :only => [:update, :destroy]
  end

  scope 'queue' do
    put 'list/:id', to: 'queue#update_list', as: 'queue_to_list'
  end

  scope 'site' do
    get ':action', to: 'site', as: 'site'
  end

  scope ':user_id', :constraints => { :user_id => /.*/ } do
    resources :films, :only => [:index, :show], to: 'user_films', :constraints => { :id => /watched|loved|queued|owned/ }, as: 'user_film' do 
        member do 
          put ':film_id',     to: 'user_films#update',  as: 'update'
          delete ':film_id',  to: 'user_films#destroy', as: 'update'
        end
      end
    resources :lists,         to: 'user_lists',         as: 'user_lists'
    match 'queue/:action',    to: "queue",              as: 'queue',:constraints => {:action => /list|recommend|show/},  via: :get
    # get '', to: 'show'
  end

  get '/:user_id', to: 'users#show', as: 'user', :constraints => { :user_id => /.*/ }


end
