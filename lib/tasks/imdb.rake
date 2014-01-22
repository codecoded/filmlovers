namespace :imdb do



  task :update_films, [:count] => :environment do |t, args|
    pos, count = 0, args[:count].to_i
    count = count <= 0 ? 1000 : count
    FilmProvider.where("name = 'imdb' and rating is null").find_each do |imdb_provider|
      Imdb::Movie.find_or_fetch(imdb_provider.reference).add_movie_provider
      pos += 1
      return if pos == count
    end
  end


end