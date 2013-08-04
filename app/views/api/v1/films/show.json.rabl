object @film

if !locals[:hide_header]
  extends 'api/v1/shared/header'
end


node :film do |film|
  user_actions = current_user.film_user_actions.where(film: film).distinct(:action) if current_user
  {
    user: if current_user
    {
      actions: {
        loved: user_actions ? user_actions.include?(:loved) : false,
        watched: user_actions ? user_actions.include?(:watched) : false,
        owned: user_actions ? user_actions.include?(:owned) : false
      }
    } 
    end,
    id: film._title_id,
    title: film.title,
    director: film.director,
    release_date: film.uk_release_date,
    backdrop: film.backdrop,
    poster: film.poster,
    tagline: film.tagline,
    overview: film.overview,
    starring: film.starring,
    budget: film.budget,
    runtime: film.runtime,
    trailer: film.trailer,
    counters:{
      watched: film.counters.watched,
      loved: film.counters.loved,
      owned: film.counters.owned
    },
    images:{
      backdrops: film.backdrops_urls_for('w300')
    },
    cast: if film.cast? then film.credits.cast.map {|p| {url: nil, name: p.name, description: p.character, image: p.profile('w92')} } end,
    crew: if film.crew? then film.credits.crew.map {|p| {url: nil, name: p.name, description: p.job, image: p.profile('w92')} } end,
    languages: if film.spoken_languages then film.spoken_languages.map {|l| l['name']} end,
    genres: if film.genres? then film.genres.map {|g| {url: api_v1_genre_path(Genre.find_by_id(g['id'])), name:g['name']}} end,
    studios: if film.studios? then film.production_companies.map {|s| {url: '', name: s['name']}} end,
    locations: if film.locations? then film.production_countries.map {|s| {url: '', name: s['name']}} end,
    original_title: if film.original_title != film.title then film.original_title end, 
    status: if film.status != 'Released' then film.status end,
    popularity: film.popularity,
  }
end

