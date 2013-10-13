object false

extends 'api/v1/shared/pages'

node :films do 
  @films.map do |film|
    begin
      user_actions = current_user.films.find(film).actions if current_user
      presenter = present(film.details, film.details_presenter)
      {
        id: film.id,
        title: film.title,
        poster: presenter.poster_uri,
        backdrop: presenter.backdrop_uri,
        director: if !presenter.director.blank? then presenter.director.name end,
        release_date: film.release_date,
        runtime: presenter.duration
      }
    rescue
      Rails.logger.error "film: #{film.title} caused a problem in index.json.rabl"
      nil
    end    
  end.compact
end


