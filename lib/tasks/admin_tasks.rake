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

  desc "Exchange Access Tokens"
  task :exchange_tokens => :environment do
    fb_api = Koala::Facebook::OAuth.new

    User.where('passports.provider'=> :facebook).each do |user|
      passport= user.passport_for(:facebook)
      next unless passport.oauth_token
      new_token = fb_api.exchange_access_token passport.oauth_token
      passport.oauth_token = new_token
      passport.oauth_expires_at = 60.days.from_now
      passport.save!
      Log.debug "Player #{player.name} updated"
    end
  end

  desc "Delete all adult film"
  task :delete_adult => :environment do
    Log.info "Deleting #{Films.adult.count} adult films"
    Films.adult.delete_all
    Log.info "#{Films.adult.count} adult films remaining"
  end

  desc "Delete all invalid films "
  task :delete_invalid => :environment do
    Log.info "Deleting #{Films.invalid.count} films"
    Films.invalid.delete_all
    Log.info "#{Films.invalid.count} invalid films remaining"
  end  
end