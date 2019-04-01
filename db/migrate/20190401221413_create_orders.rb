class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.integer :status, limit: 2, default: 0
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
