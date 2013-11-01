module Apple
  class Movie
    include Mongoid::Document
    include Mongoid::Timestamps


    field :_id, type: Integer
    field :export_date, type: String
    field :name, type: String
    field :title_version, type: String
    field :search_terms, type: String
    field :parental_advisory_id, type: String
    field :artist_display_name, type: String
    field :collection_display_name, type: String
    field :media_type_id, type: Integer
    field :view_url, type: String
    field :artwork_url, type: String
    field :original_release_date, type: Date
    field :itunes_release_date, type: Date
    field :studio_name, type:String
    field :networkd_name, type: String
    field :content_provider_name, type:String
    field :track_length, type:String
    field :copyright, type:String
    field :p_line, type:String
    field :short_description, type:String
    field :long_description, type:String
    field :episode_production_number, type:String
    field :title_id, type: String, default: ->{ Film.create_uuid(self.name, self.year) if self.year}

    index({ title_id: 1 }, { unique: true, name: "apple_title_id_index", background: true })

    def self.upsert(row)
      i=0
      new(export_date: row[i],
          id: row[i+=1],
          name: row[i+=1],
          title_version: row[i+=1],
          search_terms: row[i+=1],
          parental_advisory_id: row[i+=1],
          artist_display_name: row[i+=1],
          collection_display_name: row[i+=1],
          media_type_id: row[i+=1],
          view_url: row[i+=1],
          artwork_url: row[i+=1],
          original_release_date: itunes_date(row[i+=1]),
          itunes_release_date: itunes_date(row[i+=1]),
          studio_name: row[i+=1],
          networkd_name: row[i+=1],
          content_provider_name: row[i+=1],
          track_length: row[i+=1],
          copyright: row[i+=1],
          p_line: row[i+=1],
          short_description: row[i+=1],
          long_description: row[i+=1],
          episode_production_number: row[i+=1]).upsert
    end

    def self.itunes_date(value)
      Date.strptime(value, '%Y %m %d')
    rescue
      value
    end

    def identifier
      self.class.name.deconstantize
    end    

    def film
      return unless @film = find_film
      @film.add_provider(self)
      @film
    end

    def find_film
      Film.where(_id: title_id).first
    end

    # def title_id
    #   Film.create_uuid(title, year)
    # end

    def title
      name
    end

    def year
     original_release_date.year if original_release_date
    end

    def link
      view_url
    end

    def rating
      0
    end

    def release_date
      
    end

    def poster
      artwork_url
    end

    def genres
      {}
    end
  
    def release_date_country
      nil
    end

    def trailer
      nil
    end

    def popularity
      0
    end

    def classification
      nil
    end

    def set_film_provider!
      film.update_film_provider self
    end

    protected
    def create_film
      Log.debug("Creating film from #{identifier} data: #{title_id}")
      Film.create_from(self)
    end
  end
end