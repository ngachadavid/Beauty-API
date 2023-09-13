class CreateBeautyProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :beauty_products do |t|
      t.string :name
      t.text :description
      t.float :price
      t.string :image_url
      t.string :category
      t.integer :qty
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
