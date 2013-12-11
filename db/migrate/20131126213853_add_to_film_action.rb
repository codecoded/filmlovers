class AddToFilmAction < ActiveRecord::Migration
  def change
    add_column      :film_actions, :watched,  :boolean, null: false, default: false
    add_column      :film_actions, :loved,    :boolean, null: false, default: false
    add_column      :film_actions, :owned,    :boolean, null: false, default: false
    remove_column   :film_actions, :action
  end
end
