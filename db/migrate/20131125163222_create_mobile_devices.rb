class CreateMobileDevices < ActiveRecord::Migration
  def change
    create_table :mobile_devices do |t|
      t.references :user
      t.string :provider
      t.string :uid
      t.string :token
      t.datetime :token_expires_at

      t.timestamps
    end
    add_index :mobile_devices, :user_id
  end
end
