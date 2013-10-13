object false

extends 'api/v1/shared/pages'

node :films do 
  @films.map do |film_entry|
    begin
    presenter = present(Film.new(film_entry.film), FilmPresenter)
    {
      id: presenter.id,
      title: presenter.title,
      poster: presenter.poster_uri,
    }
    rescue
      Rails.logger.error "film: #{film_entry.title} caused a problem in film_entries/index.json.rabl"
      nil
    end
  end.compact
end
