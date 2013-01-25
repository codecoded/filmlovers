class Lists
  class << self
    def collection
      $mongo['lists']
    end

    def find_by_id(id)
      Lists.find_one '_id' => id 
    end
    
    def method_missing(method, args={})
      collection.send method, args
    end
  end
end