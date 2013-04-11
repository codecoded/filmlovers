namespace :admin do

  FilmLists = [:watched, :loved, :owned]

  task :migrate => :environment do |t, args|
    
    User.all.each do |user|
      FilmLists.each do |list| 
        Film.find(user.films[list].members).each do |film|
          FilmUserAction.do film, user, list 
          puts "#{film.title} #{list} by #{user}"
        end
      end
    end
  end

end