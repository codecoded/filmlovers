object false

extends 'api/v1/shared/pages'

node :film_recommendations do
  @query.results.map do |film_entry|
    presenter = present(Film.new(film_entry.film), FilmPresenter)
    {
      film:{
        id: film_entry.film_id,
        title: presenter.title,
        poster: presenter.poster_uri,
        release_date: presenter.release_date,
        providers: presenter.film.providers.apple.map do |p|
        {
          id: p.id,
          name: p.name,
          link: p.aff_link,
          rating: p.rating
        }
        end,
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
        comment: recommendation.comment,
        status: recommendation.state,
        approve: change_api_v1_film_recommendation_path(recommendation, 'approve'),
        hide: change_api_v1_film_recommendation_path(recommendation, 'hide')
      }
      end  
    }
  end
end