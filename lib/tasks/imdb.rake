namespace :imdb do



  task :update_films, [:count] => :environment do |t, args|
    pos, count = 0, args[:count].to_i
    count = count <= 0 ? 1000 : count
    FilmProvider.where("name = 'imdb' and rating is null").find_each do |imdb_provider|
      movie = Imdb::Movie.find_or_fetch(imdb_provider.reference)
      film = movie.film_by_reference
      film.add_provider(movie) if film
      pos += 1
      return if pos == count
    end
  end


end