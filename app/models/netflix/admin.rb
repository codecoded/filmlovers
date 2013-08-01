require 'parser'
module Netflix
  module Admin
  extend self
    def process_catalog(file)
      last_imported = AdminConfig.instance.netflix_last_import || 100.years.ago
       Xml::Parser.new(Nokogiri::XML::Reader(open(file))) do
       
        for_element 'catalog_title' do
          movie, update = {}, true
          inside_element  do
            for_element('id')           {movie[:id] = inner_xml}
            for_element('title')        {movie[:title] = attribute 'regular'}
            for_element('release_year') {movie[:release_year] = inner_xml}
            for_element('updated')      {update = Time.at(inner_xml.to_i / 1000) > last_imported}
            inside_element 'delivery_formats' do
              for_element 'availability' do
                movie[:available_from] = attribute 'available_from'
                movie[:available_until] = attribute 'available_until'
                puts movie
              end
            end 
          end

          # puts movie
          Movie.find_or_create_by(movie) if update
        end
      end

      AdminConfig.instance.update_attribute :netflix_last_import, Time.now.utc
    end

    def match_to_films
      Movie.exists(:film_id => false).each {|movie| movie.set_film_id}
    end
  end
end