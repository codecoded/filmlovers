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

  desc "Update film coutners"
  task :update_counters => :environment do
    Log.info "Updating film counters"
    AppConfig.update_counters
    Log.info "Updating film counters done"
  end  

  desc "Update film collections"
  task :update_film_collections => :environment do
    Log.info "Updating film collections"
    FilmCollection.populate_coming_soon
    Log.info "Updating films coming soon done. There are #{FilmCollection.coming_soon.film_ids.count} films found coming soon"
    FilmCollection.populate_in_cinemas
    Log.info "Updating films in cinemas done. There are #{FilmCollection.in_cinemas.film_ids.count} films found in cinemas"
  end

  desc "download netflix db"
  task :netflix_download => :environment do
    Log.info "Downloading netflix catalogue"
    #{}"curl --header 'Accept-Encoding:gzip' -o "netflix.gzip" 'http://cdn-api.netflix.com/api/v3/current/Catalog2/en_US.xml?token=1374971241_94fd8e68a652c9223e64168b198e5d14'"
  end

  desc 'AW data feed'
  task :lovefilm_download => :environment do
    "http://datafeed.api.productserve.com/datafeed/download/apikey/1f1765b2311360c1f37fc5807d3b484c/mid/2605/columns/merchant_id,merchant_name,aw_product_id,merchant_product_id,product_name,description,category_id,category_name,merchant_category,aw_deep_link,aw_image_url,search_price,currency,delivery_cost,merchant_deep_link,merchant_image_url,aw_thumb_url,brand_id,brand_name,commission_amount,commission_group,condition,delivery_time,display_price,ean,in_stock,is_hotpick,isbn,is_for_sale,language,merchant_thumb_url,model_number,mpn,parent_product_id,pre_order,product_type,promotional_text,rrp_price,specifications,stock_quantity,store_price,upc,valid_from,valid_to,warranty,web_offer/format/xml/compression/gzip/"
  end

  desc 'Blink data feed'
  task :blinkbox_download => :environment do
    "http://datafeed.api.productserve.com/datafeed/download/apikey/1f1765b2311360c1f37fc5807d3b484c/mid/2481/columns/merchant_id,merchant_name,aw_product_id,merchant_product_id,product_name,description,category_id,category_name,merchant_category,aw_deep_link,aw_image_url,search_price,currency,delivery_cost,merchant_deep_link,merchant_image_url,aw_thumb_url,brand_id,brand_name,commission_amount,commission_group,condition,delivery_time,display_price,ean,in_stock,is_hotpick,isbn,is_for_sale,language,merchant_thumb_url,model_number,mpn,parent_product_id,pre_order,product_type,promotional_text,rrp_price,specifications,stock_quantity,store_price,upc,valid_from,valid_to,warranty,web_offer/format/xml/compression/gzip/"  
  end

  desc 'Zavvi data feed'
  task :zavvi_download => :environment do
    "http://datafeed.api.productserve.com/datafeed/download/apikey/1f1765b2311360c1f37fc5807d3b484c/mid/2549/columns/merchant_id,merchant_name,aw_product_id,merchant_product_id,product_name,description,category_id,category_name,merchant_category,aw_deep_link,aw_image_url,search_price,currency,delivery_cost,merchant_deep_link,merchant_image_url,aw_thumb_url,brand_id,brand_name,commission_amount,commission_group,condition,delivery_time,display_price,ean,in_stock,is_hotpick,isbn,is_for_sale,language,merchant_thumb_url,model_number,mpn,parent_product_id,pre_order,product_type,promotional_text,rrp_price,specifications,stock_quantity,store_price,upc,valid_from,valid_to,warranty,web_offer/format/xml/compression/gzip/"
  end
end