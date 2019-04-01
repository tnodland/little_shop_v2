class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.string :name
      t.string :description
      t.string :image_url
      t.integer :quantity
      t.money :current_price
      t.boolean :enabled, default: true
      t.references :merchant, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
