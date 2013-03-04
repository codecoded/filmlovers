module AppSettings

  PREVIEW_LIMIT = 5
  LIST_CAPACITY = 100

end


module Moped
  module BSON
    class ObjectId
      def to_json(*args)
        to_s.to_json
      end
    end
  end
end