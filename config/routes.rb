Filmlovers::Application.routes.draw do

  root :to => 'app#index'

  devise_for :users, :controllers => { :omniauth_callbacks => "sessions", :registrations => "registrations"}

  match 'auth/:provider/callback',  to: 'sessions#create'
  match 'auth/failure',             to: redirect('/')
  match 'signout',                  to: 'sessions#destroy', as: 'signout'
  match 'login',                    to: 'sessions#login', as: 'login'
  match 'pusher/auth' => 'pusher#auth', as: 'pusher_auth'
  get   'current_user' => 'sessions#currentuser'

  get   'users', to: 'users#index', as: 'users'
  # resources :users

  namespace :api, format: [:json] do
    namespace :v1 do
      resources :registrations, :only => [:create, :update]
      resources :tokens, :only => [:create, :destroy, :index]
      resources :persons,  only: :show
      resources :films do
        collection do
          resources 'genres',   only: [:index]
          get '(:action(/sort_by/:sort_by))',  
            :constraints => {
              :action => /in_cinemas|coming_soon|popular|genres|netflix|rotten/, 
              :sort_by => /title|release_date|earliest_release_date|loved|watched|owned|popularity/}, 
            as: 'category'
          get 'categories'
          get 'search'
        end
      end      
      resources :users do
        resources :lists,         to: 'user_lists',         as: 'user_lists', :only => [:show, :index]
        resources :films, only: [:index, :show], to: 'user_films', constraints: { :id => /watched|loved|owned/ }, as: 'films' do 
          member do 
            put     ':film_id',   to: 'user_films#update',  as: 'update'
            delete  ':film_id',   to: 'user_films#destroy', as: 'update'
          end
        end        
      end
      resources :recommendations do
        collection do
          resources :films, except: [:edit], to: 'film_recommendations'
        end
      end      
    end
  end

  resources 'films',        only: [:show, :index] do
    collection do
      resources 'genres',   only: [:index]

      get '(:action(/sort_by/:sort_by)(/filter_by(/year/:year)(/decade/:decade)(/genres/*genres)))', 
        :constraints => {
          :action => /in_cinemas|coming_soon|popular|genres|netflix|rotten/, 
          :sort_by => /title|release_date|earliest_release_date|loved|watched|owned|popularity/}, 
        as: 'category'
      get ':user_action',        to: "films#actioned", constraints: {user_action: /search|quick_search|watched|loved|owned/}, as: 'actioned'
      post ':id' => redirect("/films/%{id}")  
    end
    member do
      get 'summary',        to: "films#summary",        as: 'summary'
      get ':user_action',   to: "films#users", as: 'users', :constraints => { :user_action => /watched|loved|owned/ }
      get 'list_view',      to: "films#list_view",  as: 'list_view'
      get 'trailer_popup',  to: "films#trailer_popup" , as: 'trailer_popup'
    end
  end

  resources 'cinemas' do
    collection do
      get 'now_playing'
      resources 'times'
      resources 'films'
    end
  end

  resources 'search', only: [:show, :index] do
    collection do
      get 'smart'
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
      get 'netflix'
    end
  end

  resources :lists, :except => [:show] do
    resources :films, to: 'film_lists', :only => [:update, :destroy, :show, :create, :new]
  end

  scope 'queue' do
    put 'list/:id', to: 'queue#update_list', as: 'queue_to_list'
  end

  scope 'site' do
    get ':action', to: 'site', as: 'site'
  end

  resources 'friendships', :constraints => { :id => /.*/ } do
    member do
      put ':change_action', to: 'friendships#change', as: 'change', constraints: {type: /confirm|ignore/}
    end
  end

  namespace :facebook do
    get  'credits' => "credits#index",               as:'shop'
    post 'credits' => "credits#callback",            as:'shop_callback'
    get  'invite'  => "friends#index",               as:'invite'
    post 'invite'  => "friends#invite",              as:'send_invites'
    scope 'social' do
      match 'films/:id'       => 'social#share',     as: 'share', constraints: {type: /achievement|levelup|new_game/}, via: :get
      match 'activity'        => "social#activity",  as: 'activity', via:[:get, :post]
      get   'liked'            => "social#liked",    as:'liked'
    end
  end

  # Current User posts to recommendations to create, with params of friends ids
  resources 'recommendations' do
    collection do
      resources :films, except: [:edit], as: 'film_recommendations', controller: 'film_recommendations'
    end
  end

  scope ':user_id', :constraints => { :user_id => /.*/ } do
    resources :films, :only => [:index, :show], to: 'users#show', :constraints => { :id => /watched|loved|owned/ }, as: 'user_film' do 
      member do 
        put ':film_id',     to: 'user_films#update',  as: 'update'
        delete ':film_id',  to: 'user_films#destroy', as: 'update'
      end
    end

    resources :recommendations, only: [:index], to: 'user_recommendations' do
      collection do
        get 'sent'
        get 'received'
      end
    end

    resources :lists,         to: 'user_lists',         as: 'user_lists', :only => [:show, :index]
    match 'queue/:action',    to: "queue",              as: 'queue', :constraints => {:action => /list|recommend|show/},  via: :get
    # get '', to: 'show'
  end

  get '/:user_id', to: 'users#show', as: 'user', :constraints => { :user_id => /.*/ }


end
