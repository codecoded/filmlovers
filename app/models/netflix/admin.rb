require 'parser'
module Netflix
  module Admin
  extend self
    def process_catalog(file)
      doc = Nokogiri::XML(File.open(file))

       Xml::Parser.new(Nokogiri::XML::Reader(open(file))) do
       
        for_element 'catalog_title' do
          movie = {}
          inside_element  do
            for_element('id') {movie[:id] = inner_xml}
            for_element('title') {movie[:title] = attribute 'regular'}
            for_element('release_year') {movie[:release_year] = inner_xml}

            inside_element 'delivery_formats' do
              for_element 'availability' do
                movie[:available_from] = attribute 'available_from'
                movie[:available_until] = attribute 'available_until'
                puts movie
              end
            end  
           
          end
          # puts movie
          Movie.find_or_create_by movie
        end
      end
    end

    def match_to_films
      Movie.exists(:film_id => false).each {|movie| movie.set_film_id}
    end
  end
end