object false

extends 'api/v1/shared/pages'

node :films do 
  @entries = current_user.films.select(@query.results.map &:id).to_a
  @query.results.map do |film|
    begin
      entry = @entries.find {|fe| fe.film_id == film.id}
      presenter = present(film, FilmPresenter)
      {
        user: 
        {
          actions: {
            loved: entry ? entry.actioned?(:loved) : false,
            watched: entry ? entry.actioned?(:watched) : false,
            owned: entry ? entry.actioned?(:owned) : false
          }
        },
        id: film.id,
        title: film.title,
        poster: presenter.poster_uri,
        #backdrop: presenter.backdrop_uri,
        director: '',
        #director: if !presenter.director.blank? then presenter.director.name end,
        release_date: film.release_date,
        runtime: 0
      }
    rescue
      Rails.logger.error "film: #{film.title} caused a problem in index.json.rabl"
      nil
    end    
  end.compact
end


