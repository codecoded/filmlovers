class CreateFacebookEvents < ActiveRecord::Migration
  def change
    create_table :facebook_events do |t|
      t.references :user
      t.string :facebook_id
      t.string :event_type
      t.string :content

      t.timestamps
    end
    add_index :facebook_events, :user_id
  end
end
