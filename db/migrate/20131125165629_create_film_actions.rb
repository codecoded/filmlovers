class CreateFilmActions < ActiveRecord::Migration
  def change
    create_table :film_actions do |t|
      t.references :user
      t.string :film_id
      t.string :action
      t.integer :facebook_id

      t.timestamps
    end
    add_index :film_actions, :user_id
  end
end
