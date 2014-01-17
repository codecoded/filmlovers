object false

extends 'api/v1/shared/pages'

node :films do 
  @query.results.map do |film_entry|
    begin
    presenter = present(film_entry)
    {
      id: presenter.film.id,
      title: presenter.title,
      poster: presenter.poster_uri,
      director: presenter.director,
      backdrop: presenter.backdrop_uri,
    }
    rescue => msg
      Rails.logger.error "film: #{film_entry.title} erorred in film_entries/index.json.rabl. #{msg}"
      nil
    end
  end.compact
end
