# Rename films to tmdb_movies and run Tmdb::Movie.batch_size(1000).each &:film
# db.films.renameCollection('tmdb_movies')
# db.tmdb_movies.reIndex()
# db.films.ensureIndex({'provider_id':-1, 'provider':1})
# run film user action migration
# db.film_entries.ensureIndex({user_id: -1, film_id: 1})
# AppConfig.update_counters

# delete film user acit
namespace :admin do

  FilmLists = [:watched, :loved, :owned]

  # task :migrate => :environment do |t, args|
    
  #   User.all.each do |user|
  #     FilmLists.each do |list| 
  #       Film.find(user.films[list].members).each do |film|
  #         FilmUserAction.do film, user, list 
  #         puts "#{film.title} #{list} by #{user}"
  #       end
  #     end
  #   end
  # end

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
    Log.info "Deleting #{Film.adult.count} adult films"
    Film.adult.delete_all
    Log.info "#{Films.adult.count} adult films remaining"
  end

  desc "Delete all invalid films "
  task :delete_invalid => :environment do
    Log.info "Deleting #{Films.invalid.count} films"
    Films.invalid.delete_all
    Log.info "#{Films.invalid.count} invalid films remaining"
  end  

  desc "Update film coutners"
  task :update_counters => :environment do
    Log.info "Updating film counters"
    AppConfig.update_counters
    Log.info "Updating film counters done"
  end  

  desc "Update film collections"
  task :update_film_collections => :environment do
    Log.info "Updating film collections"
    FilmCollection.populate_in_cinemas
    Log.info "Updating films in cinemas done. There are #{FilmCollection.in_cinemas.film_ids.count} films found in cinemas"    
    FilmCollection.populate_coming_soon
    Log.info "Updating films coming soon done. There are #{FilmCollection.coming_soon.film_ids.count} films found coming soon"

  end


  desc "Migrate FilmUser Actions"
  task :migrate_actions => :environment do
    FilmUserAction.order_by([:film_id, :asc]).each do |fua| 
      film = Film.find_by(provider_id: fua.film_id)
      next unless film
      # fua.update_attribute(:film_id, film.id) if film
      fe = FilmEntry.fetch_for(fua.user, film) if fua.user
      fe.do_action(fua.action) if fe
    end
  end

  # desc "Migrate providers"
  # task :migrate_providers => :environment do
  #   Film.ne('details.imdb_id' => nil).each {|f| f.provider_by(:imdb, f.details.imdb_id).save!}
  # end

  # desc "Migrate Genres"
  # task :migrate_genres => :environment do
  #   Film.each {|f| f.update_attribute(:genres, f.details['genres'].map {|g| g['name']}) if f.details and f.details['genres']}
  # end

  # desc "Migrate Popularoty"
  # task :migrate_genres => :environment do
  #   Film.each {|f| f.update_attribute(:popularity, f.details['popularity']) if f.details and f.details['popularity']}
  # end

  desc "download netflix db"
  task :netflix_download => :environment do
    Log.info "Downloading netflix catalogue"
    #{}"curl --header 'Accept-Encoding:gzip' -o "netflix.gzip" 'http://cdn-api.netflix.com/api/v3/current/Catalog2/en_US.xml?token=1374971241_94fd8e68a652c9223e64168b198e5d14'"
  end

  desc 'AW data feed'
  task :lovefilm_download => :environment do
    "http://datafeed.api.productserve.com/datafeed/download/apikey/1f1765b2311360c1f37fc5807d3b484c/mid/2605/columns/merchant_id,merchant_name,aw_product_id,merchant_product_id,product_name,description,category_id,category_name,merchant_category,aw_deep_link,aw_image_url,search_price,currency,delivery_cost,merchant_deep_link,merchant_image_url,aw_thumb_url,brand_id,brand_name,commission_amount,commission_group,condition,delivery_time,display_price,ean,in_stock,is_hotpick,isbn,is_for_sale,language,merchant_thumb_url,model_number,mpn,parent_product_id,pre_order,product_type,promotional_text,rrp_price,specifications,stock_quantity,store_price,upc,valid_from,valid_to,warranty,web_offer/format/xml/compression/gzip/"
    # "mongoimport --collection lovefilm_movies --file tmp/lovefilm/datafeed_171645.csv --type csv --db filmlovers_development --headerline"
  end

  desc 'Blink data feed'
  task :blinkbox_download => :environment do
    "http://datafeed.api.productserve.com/datafeed/download/apikey/1f1765b2311360c1f37fc5807d3b484c/mid/2481/columns/merchant_id,merchant_name,aw_product_id,merchant_product_id,product_name,description,category_id,category_name,merchant_category,aw_deep_link,aw_image_url,search_price,currency,delivery_cost,merchant_deep_link,merchant_image_url,aw_thumb_url,brand_id,brand_name,commission_amount,commission_group,condition,delivery_time,display_price,ean,in_stock,is_hotpick,isbn,is_for_sale,language,merchant_thumb_url,model_number,mpn,parent_product_id,pre_order,product_type,promotional_text,rrp_price,specifications,stock_quantity,store_price,upc,valid_from,valid_to,warranty,web_offer/format/xml/compression/gzip/"  
    # "mongoimport --collection blinkbox_movies --file tmp/blinkbox/datafeed_171645.csv --type csv --db filmlovers_development --headerline"
  end

  desc 'Zavvi data feed'
  task :zavvi_download => :environment do
    "http://datafeed.api.productserve.com/datafeed/download/apikey/1f1765b2311360c1f37fc5807d3b484c/mid/2549/columns/merchant_id,merchant_name,aw_product_id,merchant_product_id,product_name,description,category_id,category_name,merchant_category,aw_deep_link,aw_image_url,search_price,currency,delivery_cost,merchant_deep_link,merchant_image_url,aw_thumb_url,brand_id,brand_name,commission_amount,commission_group,condition,delivery_time,display_price,ean,in_stock,is_hotpick,isbn,is_for_sale,language,merchant_thumb_url,model_number,mpn,parent_product_id,pre_order,product_type,promotional_text,rrp_price,specifications,stock_quantity,store_price,upc,valid_from,valid_to,warranty,web_offer/format/xml/compression/gzip/"
    "mongoimport --collection zavvi_movies --file tmp/zavvi/datafeed_171645.csv --type csv --db filmlovers_development --headerline"
  end
end