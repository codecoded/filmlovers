include Mongo
$mongo = MongoClient.new("localhost", 27017).db("filmlovers_#{Rails.env}")