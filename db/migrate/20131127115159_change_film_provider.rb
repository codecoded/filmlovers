class ChangeFilmProvider < ActiveRecord::Migration
  def change
    create_table :film_providers do |t|
      t.string :film_id
      t.string :name
      t.string :reference
      t.string :link
      t.float :rating
      t.datetime :fetched_at

      t.timestamps
    end
    add_index :film_providers, :film_id
  end
end
