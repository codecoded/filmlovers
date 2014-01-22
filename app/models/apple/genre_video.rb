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
      return unless movie?(row[1].to_i)
      create(export_date: row[i],
          genre_id: row[i+=1],
          video_id: row[i+=1],
          is_primary: row[i+=1]
          )
    end 

    def self.movie_genre_ids
       @movie_genre_ids ||= Apple::Genre.where(parent_id: 33).map &:genre_id
    end

    def self.movie?(genre_id)
      genre_id == 33 or movie_genre_ids.include?(genre_id)
    end

    def self.video_ids
      @video_ids ||= distinct(:video_id).to_a
    end

    def movie
      @movie ||= Apple::Movie.find video_id
    end
  end
end