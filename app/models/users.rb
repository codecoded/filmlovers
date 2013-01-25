class Users
  class << self
    def collection
      $mongo['users']
    end

    def find_by_id(id)
      collection.find_one '_id' => id 
    end

    def method_missing(method, args={})
      collection.send method, args
    end
    
  end


end