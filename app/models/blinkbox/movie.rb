module Blinkbox
  class Movie < MovieProvider
    include Mongoid::Document
    include Mongoid::Timestamps

    def self.rentals
      where(merchant_category: 'DVD Rentals')
    end

    def self.dvds
      where(merchant_category: 'DVDs')
    end

    def id
      self['aw_product_id']
    end

    def title
      self['product_name'].gsub('(SD)','').chop if  self['product_name']
    end

    def directors_name
      self['model_number']
    end

    def link
      self['aw_deep_link']
    end

    def poster
      self['aw_image_url']
    end

  end
end