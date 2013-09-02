object false

extends 'api/v1/shared/header'

node :film_recommendations do
  @film_entries.map do |film_entry|
    user_actions = film_entry.actions
    presenter = present(film_entry.fetch_film.details, film_entry.fetch_film.details_presenter)
    {
      film:{
        user: 
        {
          actions: {
            loved: user_actions.include?(:loved) ,
            watched: user_actions.include?(:watched),
            owned: user_actions.include?(:owned)
          }
        },
        id: presenter.film.id,
        title: presenter.title,
        poster: presenter.poster_uri,
        backdrop: presenter.backdrop_uri,
        director: if !presenter.director.blank? then presenter.director.name end,
        release_date: presenter.release_date,
        runtime: presenter.duration,
        counters:{
          watched: presenter.film.counters.watched,
          loved: presenter.film.counters.loved,
          owned: presenter.film.counters.owned
        },
      },
    recommendations: 
      film_entry.recommendations.map do |recommendation|
      friend_presenter = present(recommendation.friend, UserPresenter)
      {
        id: recommendation.id,
        sent: recommendation.sent,
        username: friend_presenter.username,
        friend_url: api_v1_user_path(friend_presenter.user.id),
        avator_uri: friend_presenter.avatar_url
      }
      end  
    }
  end
end