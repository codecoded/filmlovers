class Films

  FilmLists = [:watched, :loved, :unloved]

  class << self
    def collection
      $mongo['films']
    end

    def find_by_id(id)
      collection.find_one '_id' => id 
    end

    def exists?(film_id)
      !find_by_id(film_id).nil?
    end
    
    def save!(doc)
      doc['_id'] = doc['id']
      collection.save doc
    end

    def [](list)
      @lists ||= {}
      FilmLists.each do |list|
        @lists[list] =  FilmsScoreChart.new("films:#{list}")
      end
      @lists[list]
    end

    def find_by_ids(ids)
      collection.find({'id'=>{'$in'=>ids}}).map {|film| Film.new film}
    end

    def method_missing(method, args={})
      collection.send method, args
    end
  end


end