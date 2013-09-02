object false


extends 'api/v1/shared/header'

node :recommendations do 
  @recommendations.map do |recommendation|
    {
      id: recommendation.id,
      friend_id: recommendation.friend_id,
      film_id: @film.id,
      created: !recommendation.new_record?
    }
  end if !@recommendations.nil?
end
