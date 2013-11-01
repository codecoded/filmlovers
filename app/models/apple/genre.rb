module Apple
  class Genre
    include Mongoid::Document


    field :_id, type: String
    field :export_date, type: String
    field :genre_id, type: Integer
    field :parent_id, type: Integer
    field :name, type: String

    index({ genre_id: 1, parent_id: 1 }, { unique: true, name: "apple_genre_parent_index", background: true })

    def self.import(row)
      i=0
      create(export_date: row[i],
          genre_id: row[i+=1],
          parent_id: row[i+=1],
          name: row[i+=1]
          )
    end 

  end
end