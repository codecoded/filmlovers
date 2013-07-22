object @film

if !locals[:hide_header]
  node :header do
    {
      version:    'v1',
      domain:     "#{request.protocol}#{request.host}:#{request.port}",
      timestamp:  Time.now.utc
    }
  end 
end

node :film do |film|
  {
    id: film._title_id,
    title: film.title,
    director: film.director,
    release_date: film.uk_release_date,
    backdrop: film.backdrop,
    poster: film.poster,
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
    cast: if film.cast? then film.credits.cast.map {|p| {url: nil, name: p.name, description: p.character} } end,
    crew: if film.crew? then film.credits.crew.map {|p| {url: nil, name: p.name, description: p.job} } end,
    languages: if film.spoken_languages then film.spoken_languages.map {|l| l['name']} end,
    genres: if film.genres? then film.genres.map {|g| {url: api_v1_genre_path(Genre.find_by_id(g['id'])), name:g['name']}} end,
    studios: if film.studios? then film.production_companies.map {|s| {url: '', name: s['name']}} end,
    locations: if film.locations? then film.production_countries.map {|s| {url: '', name: s['name']}} end,
    original_title: if film.original_title != film.title then film.original_title end, 
    status: if film.status != 'Released' then film.status end,
    popularity: film.popularity,
  }
end

