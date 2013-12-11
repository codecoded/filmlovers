class RenameFilmActionToFilmEntry < ActiveRecord::Migration
 def change
    rename_table :film_actions, :film_entries
  end 
end
