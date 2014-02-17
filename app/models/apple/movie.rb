module Apple
  class Movie < MovieProvider
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
    field :title_director, type: String
    field :match_status, type: String

    index({ title_id: 1 }, { unique: true, name: "apple_title_id_index", background: true })

    def self.import(row)
      i=0
      return unless movie?(row[1].to_i)
       
      create(export_date: row[i],
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
          episode_production_number: row[i+=1])
     Log.debug "#{row[2]}"
     nil
    end

    def self.movie?(video_id)
      GenreVideo.video_ids.include?(video_id)
    end

    def self.itunes_date(value)
      Date.strptime(value, '%Y %m %d')
    rescue
      value
    end

    def title
      name
    end

    def release_date
      original_release_date
    end


    def directors_name
      artist_display_name
    end

    def year
     original_release_date.year if original_release_date
    end

    def link
      view_url
    end

    def poster
      artwork_url
    end

    def storefront_ids
      @storefront_ids ||= Apple::Pricing.storefront_ids_for id
    end

    def try_match
      if film = Film.find_provider(self)
        film.add_provider self 
        update_attribute :match_status, 'matched'
      else
        update_attribute :match_status, 'failed'
      end
    end

  end
end