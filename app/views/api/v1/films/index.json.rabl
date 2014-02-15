object false

extends 'api/v1/shared/pages'

node :films do 
  results = @query.results.order('coalesce(popularity,0) desc')
  @entries = current_user.film_entries.where(film_id: results.map(&:id)).to_a if current_user
  results.map do |film|
    begin
      entry = @entries.find {|fe| fe.film_id == film.id} if @entries
      presenter = present(film, FilmPresenter)
      {
        user: 
        {
          actions: {
            loved: entry ? entry.set?(:loved) : false,
            watched: entry ? entry.set?(:watched) : false,
            owned: entry ? entry.set?(:owned) : false
          }
        },
        id: film.id,
        title: film.title,
        poster: presenter.poster_uri,
        #backdrop: presenter.backdrop_uri,
        director: film.director,
        release_date: film.release_date
      }
    rescue => msg
      Rails.logger.error "film: #{film.title} caused a problem in index.json.rabl. #{msg}"
      nil
    end    
  end.compact
end


