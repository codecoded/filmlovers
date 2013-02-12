object @film_view

attributes :id, :title, :release_date, :director

node :stats do |film|
  {
    :watched => film.stats(:watched),
    :loved => film.stats(:loved),
    :owned => film.stats(:owned)
  }
end

if current_user
  node :user do |film|
    { 
      :watched => film.actioned?(:watched),
      :watched_url => update_user_film_path(current_user, :watched, film.id),
      :loved => film.actioned?(:loved),
      :loved_url => update_user_film_path(current_user, :loved, film.id),
      :owned => film.actioned?(:owned),
      :owned_url => update_user_film_path(current_user, :owned, film.id),
      :queued => film.actioned?(:queued),
      :queued_url => update_user_film_path(current_user, :queued, film.id)
    }
  end
end
