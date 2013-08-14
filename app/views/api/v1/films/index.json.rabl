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
    :order          => order,
    :by             => by,
  }
end

node :films do 
  @films.map do |film|
    user_actions = current_user.film_user_actions.where(film: film).distinct(:action) if current_user
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
      id: film._title_id,
      title: film.title,
      poster: film.poster,
      backdrop: film.backdrop,
      director: film.director,
      release_date: film.uk_release_date,
      counters:{
        watched: film.counters.watched,
        loved: film.counters.loved,
        owned: film.counters.owned
      },
    }
  end
end


