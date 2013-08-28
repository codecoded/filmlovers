object false

if !locals[:hide_header]
  extends 'api/v1/shared/header'
end

node :recommendations do 
  @recommendations.map do |recommendation|
    {
      id: recommendation.id,
      friend_id: recommendation.friend_id,
      film_id: recommendation.recommendable_id,
      created: !recommendation.new_record?
    }
  end
end

