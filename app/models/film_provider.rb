class FilmProvider
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :film, autobuild: true


  field :name,            type: String
  field :providerId,      type: String
  field :link,            type: String
  field :rating,          type: Float

  scope :rotten, where(name: :rotten)
  scope :netflix, where(name: :netflix)

  def self.group_by_film
    map = %Q{
      function() {
        emit(this.film_id, {count: 1})
      }
    }

    reduce = %Q{
      function(key, values) {
        var result = {count: 0};
        values.forEach(function(value) {
          result.count += value.count;
        });
        return result;
      }
    }

    self.map_reduce(map, reduce).out(inline: true)
  end

end