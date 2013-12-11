class CreateFilmRecommendations < ActiveRecord::Migration
  def change
    create_table :film_recommendations do |t|
      t.references :user
      t.string :film_id
      t.boolean :auto
      t.boolean :sent
      t.text :comment
      t.references :friend
      t.string :state

      t.timestamps
    end
    add_index :film_recommendations, :user_id
    add_index :film_recommendations, :friend_id
  end
end
