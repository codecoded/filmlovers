module Apple
  class Pricing
    include Mongoid::Document
    include Mongoid::Timestamps


    field :_id, type: String
    field :export_date, type: String
    field :video_id, type: Integer
    field :retail_price, type: Float
    field :storefront_id, type: Integer
    field :currency_code, type: String
    field :sd_price, type: Float
    field :hq_price, type: Float
    field :lc_rental_price, type: Float
    field :sd_rental_price, type: Float
    field :hd_rental_price, type: Float

    index({ video_id: 1, storefront_id: 1 }, { unique: true, name: "apple_video_storefront_index", background: true })

    def self.import(row)
      i=0
      create(export_date: row[i],
          video_id: row[i+=1],
          retail_price: row[i+=1],
          currency_code: row[i+=1],
          storefront_id: row[i+=1], 
          availability_data: itunes_date(row[i+=1]),                   
          sd_price: row[i+=1],
          hq_price: row[i+=1],
          lc_rental_price: row[i+=1],
          sd_rental_price: row[i+=1],
          hd_rental_price: row[i+=1]
          )
    end

    def self.itunes_date(value)
      Date.strptime(value, '%Y %m %d')
    rescue
      value
    end


    def identifier
      self.class.name.deconstantize
    end    

    def self.storefront_ids_for(video_id)
      ids = where(video_id: video_id).map(&:storefront_id)
      ids.empty? ? nil : ids.flatten.compact
    end

    def video
      @video ||= Apple::Movie.find video_id
    end
  end
end