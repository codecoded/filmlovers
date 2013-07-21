object @film


node :header do
  {
    version:    'v1',
    domain:     "#{request.protocol}#{request.host}:#{request.port}",
    timestamp:  Time.now.utc
  }
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
    cast:film.credits.cast.map {|p| {url: nil, name: p.name, description: p.character} },
    crew: film.credits.crew.map {|p| {url: nil, name: p.name, description: p.job} },
    languages: if false then film.spoken_languages.map {|l| l['name']} end,
    genres: if film.genres? then film.genres.map {|g| {url: api_v1_genre_path(Genre.find(g['id'])), name:g['name']}} end,
    popularity: film.popularity
  }
end

