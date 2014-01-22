object false

extends 'api/v1/shared/header'

node :film_recommendations do
  @results.map do |film_view|
    presenter = present(film_view, FilmPresenter)
    {
      film:{
        id: presenter.id,
        title: presenter.title,
        poster: presenter.poster_uri,
        release_date: presenter.release_date,
        director: presenter.director,
        providers: presenter.film.providers.map do |p|
        {
          id: p.id,
          name: p.name,
          link: p.aff_link,
          rating: p.rating
        }
        end,
      },
    recommendations: 
      current_user.recommended_films.includes(:user).where(film_id: film_view.id).map do |recommendation|
        friend_presenter = present(recommendation.user, UserPresenter)
        {
          id: recommendation.id,
          username: friend_presenter.username,
          friend_url: api_v1_user_path(recommendation.user_id),
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