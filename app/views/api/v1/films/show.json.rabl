object @film

if !locals[:hide_header]
  extends 'api/v1/shared/header'
end

presenter = present(@film.details, @film.details_presenter)

node :film do 
  film_entry = current_user.films.find(@film) if current_user
  {
    user: if current_user
    {
      actions: {
        loved: film_entry ? film_entry.actioned?(:loved) : false,
        loved_url: api_v1_film_action_path(current_user.id, :loved, @film.id ),
        watched: film_entry ? film_entry.actioned?(:watched) : false,
        watched_url: api_v1_film_action_path(current_user.id, :watched, @film.id,),
        owned: film_entry ? film_entry.actioned?(:owned) : false,
        owned_url: api_v1_film_action_path(current_user.id, :owned, @film.id),
      }
    } 
    end,
    id: presenter.film.id,
    title: presenter.film.title,
    director: if presenter.director? then presenter.director.name end,
    release_date: presenter.film.release_date,
    backdrop: presenter.backdrop_uri,
    poster: presenter.poster_uri,
    tagline: presenter.tagline,
    overview: presenter.overview,
    starring: presenter.starring,
    budget: presenter.budget,
    runtime: presenter.duration,
    trailer: presenter.trailer,
    counters:{
      watched: presenter.film.counters.watched,
      loved: presenter.film.counters.loved,
      owned: presenter.film.counters.owned
    },
    images:{
      backdrops: presenter.backdrops_urls_for(:medium),
      posters: presenter.posters_urls_for(:medium)
    },
    similar: presenter.similar_films, 
    cast: if presenter.cast? then presenter.credits.cast.map {|p| {id: p.id, name: p.name, description: p.character, image: p.profile('w92')} } end,
    crew: if presenter.crew? then presenter.credits.crew.map {|p| {id: p.id, name: p.name, description: p.job, image: p.profile('w92')} } end,
    languages: if presenter.languages? then presenter.languages.map {|l| l['name']} end,
    genres: if presenter.genres? then presenter.genres.map {|g| {url: category_api_v1_films_url(action: params[:action], genres: g), name:g['name']}} end,
    studios: if presenter.studios? then presenter.studios.map {|s| {url: '', name: s['name']}} end,
    locations: if presenter.locations? then presenter.locations.map {|s| {url: '', name: s['name']}} end,
    original_title: if presenter.original_title != presenter.title then presenter.original_title end, 
    status: if presenter.status != 'Released' then presenter.status end,
    popularity: presenter.popularity,
    providers: presenter.film.providers.map do |p|
    {
      id: p.id,
      name: p.name,
      link: p.aff_link,
      rating: p.rating
    }
    end
  }
end

