object false

node :header do
  {
    version:    'v1',
    domain:     "#{request.protocol}#{request.host}:#{request.port}",
    timestamp:  Time.now.utc
  }
end

node :pages do
  {
    :previous       => page_no > 1 ? url_for(params.merge({page: page_no-1}))  : nil,
    :next           => @total_pages > page_no ?  url_for(params.merge({page: page_no+1})) : nil,
    :page_no        => page_no,
    :total_results  => @films_count,
    :page_size      => AdminConfig.instance.page_size,
    :total_pages    => @total_pages,
    :order          => order,
    :by             => by,
  }
end

node :films do 
  @films.map do |film|
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
      popularity: film.popularity
    }
  end
end

