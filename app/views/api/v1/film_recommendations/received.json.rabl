object false

extends 'api/v1/shared/header'

node :film_recommendations do
  @film_entries.map do |film_entry|
    presenter = present(Film.new(film_entry.film), FilmPresenter)
    {
      film:{
        id: film_entry.film_id,
        title: presenter.title,
        poster: presenter.poster_uri,
        release_date: presenter.release_date,
      },
    recommendations: 
      film_entry.recommendations.map do |recommendation|
      friend_presenter = present(recommendation.friend, UserPresenter)
      {
        id: recommendation.id,
        sent: recommendation.sent,
        username: friend_presenter.username,
        friend_url: api_v1_user_path(friend_presenter.user.id),
        avator_uri: friend_presenter.avatar_url,
        comment: recommendation.comment
      }
      end  
    }
  end
end