module Apple
  class Storefront
    include Mongoid::Document


    field :_id, type: String
    field :export_date, type: String
    field :country_code, type: String
    field :name, type: String

    index({ country_code: 1 }, { unique: true, name: "storefront_country_code_index", background: true })

    def self.import(row)
      i=0
      create(export_date: row[i],
        id:               row[i+=1],
        country_code:     row[i+=1],
        name:             row[i+=1]
      )
    end 

    def self.find_by_country_code(country_code)
      match = where(country_code: country_code).first
      match.id.to_i if match
    end

  end
end