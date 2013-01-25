class Genres
  class << self
    def collection
      $mongo['genres']
    end

    def find_by_id(id)
      return unless id
      collection.find_one '_id' =>  BSON::ObjectId.from_string(id)
    end
    
    def method_missing(method, args={})
      collection.send method, args
    end
  end
end