class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.string :name
      t.string :description
      t.string :image_url, default: 'http://www.spore.com/static/image/500/404/515/500404515704_lrg.png'
      t.integer :quantity
      t.money :current_price
      t.boolean :enabled, default: true
      t.references :merchant, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
