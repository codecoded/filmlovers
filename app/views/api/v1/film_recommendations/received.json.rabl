object false

extends 'api/v1/shared/header'

node :recommendations do
  @received.map do |recommendation|
    film_presenter = present(recommendation.film.details, recommendation.recommendable.details_presenter)
    friend_presenter = present(recommendation.friend, UserPresenter)
    {      
      film:{
        id: film_presenter.film.id,
        title: film_presenter.film.title,
        poster: film_presenter.poster_uri,
        backdrop: film_presenter.backdrop_uri,
      },
      friend:{
        username: friend_presenter.username,
        friend_url: api_v1_user_path(friend_presenter.user.id),
        avator_uri: friend_presenter.avatar_url
      }
    }
  end
end

