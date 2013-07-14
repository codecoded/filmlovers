module TMS
  class Program
    include Mongoid::Document
    include Mongoid::Timestamps

    after_create :set_film_id

    field :_id, type: String, default: ->{ self.TMSId }
    field :film_id, type: Integer

    scope :unmatched, -> { exists(film_id: false) }    
    scope :matched, -> { exists(film_id: true) }

    def self.find_or_create(tms_data)
      find(tms_data['TMSId']) || with(safe:false).create(tms_data)
    end

    def self.import(file)
      json = Utilities.file_to_json(file)
      json['on']['programs']['program'].map {|program| find_or_create(program)}
    end

    def film
      @film ||= Film.find_by(_title_id: common_title)
    end

    def processable?
      movieInfo && movieInfo['releases'] && titles
    end

    def movieInfo
      self['movieInfo']
    end

    def title
      @title ||= titles['title']
      @title.kind_of?(Array) ? @title.first : @title
    end

    def releases
      return unless movieInfo and movieInfo['releases']
      @releases ||= movieInfo['releases']['release']
    end

    def release_date
      return unless releases
      @release_date ||= (releases.kind_of?(Array) ? (releases.find {|r| r['type']=='Original'} || {}): (releases['Original'] || {}))['date']
    end

    def year
      @year ||= (releases.kind_of?(Array) ? releases.find {|r| r['type']=='Year'} : (releases['Year'] || {}))['date']
    end

    def ratings
      self['ratings']
    end

    def rating
      @rating ||= ratings ? ratings['rating'] : nil
    end

    def bbfc_rating
      return unless rating
      @bbfc_rating ||= (rating.kind_of?(Array) ? (rating.find {|r| r['ratingsBody'] =~ /British Board of Film Classification/} || {} ): rating)['code']  
    end

    def common_title
      "#{title.parameterize}-#{year}"
    end

    def set_film_id
      if processable? and film
        update_attribute :film_id, film.id
        film.update_attributes(tms_id: id, uk_rating: bbfc_rating)
      end
    end


  end
end