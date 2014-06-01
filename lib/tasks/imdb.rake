namespace :imdb do



  task :update_films, [:count] => :environment do |t, args|
    pos, count = 0, args[:count].to_i
    count = count <= 0 ? 1000 : count
    FilmProvider.where("name = 'imdb' and rating is null and reference is not null").find_each do |imdb_provider|
      begin
        movie = Imdb::Movie.find_or_fetch(imdb_provider.reference)
        if film = imdb_provider.film and movie
          film.add_provider(movie)
        else
          imdb_provider.delete
        end
      rescue  => msg
        Log.error msg
      ensure   
        pos += 1
        return if pos == count
      end
    end
  end


end