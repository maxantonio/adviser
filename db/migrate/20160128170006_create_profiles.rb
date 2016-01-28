class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :uid
      t.string :provider
      t.string :first_name
      t.string :last_name
      t.string :url_profile
      t.string :url_image
      t.string :country
      t.string :description
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
