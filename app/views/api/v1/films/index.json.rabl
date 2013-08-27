object false

extends 'api/v1/shared/header'

node :pages do
  {
    :previous       => page_no > 1 ? url_for(params.merge({page: page_no-1}))  : nil,
    :next           => @total_pages > page_no ?  url_for(params.merge({page: page_no+1})) : nil,
    :page_no        => page_no,
    :total_results  => @films_count,
    :page_size      => page_size,
    :total_pages    => @total_pages,
    :order          => @order,
    :by             => by,
  }
end

node :films do 
  @films.map do |film|
    user_actions = current_user.film_user_actions.where(film: film).distinct(:action) if current_user
    presenter = present(film.details, film.details_presenter)
    {
      user: if current_user
      {
        actions: {
          loved: user_actions ? user_actions.include?(:loved) : false,
          watched: user_actions ? user_actions.include?(:watched) : false,
          owned: user_actions ? user_actions.include?(:owned) : false
        }
      }
      end,
      id: film.id,
      title: film.title,
      poster: presenter.poster_uri,
      backdrop: presenter.backdrop_uri,
      director: if !presenter.director.blank? then presenter.director.name end,
      release_date: film.release_date,
      runtime: presenter.duration,
      counters:{
        watched: film.counters.watched,
        loved: film.counters.loved,
        owned: film.counters.owned
      },
    }
  end
end


