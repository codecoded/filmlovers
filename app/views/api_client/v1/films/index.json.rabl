object false

node :header do
  {
    version:    'v1',
    domain:     'http://www.filmlovers.co.uk',
    timestamp:  Time.now.utc
  }
end

node :pages do
  {
    :previous       => page_no > 1 ? page_coming_soon_api_client_v1_films_path(page_no - 1) : nil,
    :next           => @total_pages > page_no ? page_coming_soon_api_client_v1_films_path(page_no + 1) : nil,
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
      poster: film.poster
    }
  end
end

