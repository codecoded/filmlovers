require 'parser'
module Netflix
  module Admin
  extend self
    def import(file)
      last_imported = AdminConfig.instance.netflix_last_import || 100.years.ago
       Xml::Parser.new(Nokogiri::XML::Reader(open(file))) do
       
        for_element 'catalog_title' do
          movie, update, is_movie = Movie.new, false, false

          inside_element  do
            for_element('id') do 
              is_movie  = inner_xml =~ /\/movies\//
              movie.id = inner_xml
            end
            for_element('title')          {movie.title = attribute 'regular'}
            for_element('release_year')   {movie.release_year = inner_xml}
            for_element('updated')        {update = Time.at(inner_xml.to_i / 1000) > last_imported}
            for_element('average_rating') {movie.rating = inner_xml}
            for_element('link') do 
              if attribute('title')=='web page' 
                movie.link = attribute('href')
              end
            end

            inside_element('box_art') do 
              for_element('link') do 
                if attribute('rel')=='http://schemas.netflix.com/catalog/titles/box_art/197pix_w' 
                  movie.poster = attribute('href')
                end
              end
            end

            inside_element 'delivery_formats' do
              for_element 'availability' do
                movie.available_from = Time.at(attribute('available_from').to_i)
              end
            end 
          end


          # puts movie
          movie.film if (true and is_movie)
        end
      end

      AdminConfig.instance.update_attribute :netflix_last_import, Time.now.utc
    end

    def match_to_films
      Movie.exists(:film_id => false).each {|movie| movie.set_film_id}
    end
  end
end