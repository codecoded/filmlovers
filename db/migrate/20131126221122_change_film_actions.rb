class ChangeFilmActions < ActiveRecord::Migration
  def change
    change_column      :film_actions, :watched,  :boolean, null: false, default: false
    change_column      :film_actions, :loved,    :boolean, null: false, default: false
    change_column      :film_actions, :owned,    :boolean, null: false, default: false
  end
end
