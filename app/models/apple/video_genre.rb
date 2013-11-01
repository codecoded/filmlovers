module Apple
  class GenreVideo
    include Mongoid::Document


    field :_id, type: String
    field :export_date, type: String
    field :genre_id, type: Integer
    field :video_id, type: Integer
    field :is_primary, type: Boolean

    index({ genre_id: 1, video_id: 1 }, { unique: true, name: "apple_genre_video_index", background: true })

    def self.import(row)
      i=0
      create(export_date: row[i],
          genre_id: row[i+=1],
          video_id: row[i+=1],
          is_primary: row[i+=1]
          )
    end 

  end
end