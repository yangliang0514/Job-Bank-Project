class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :serial
      t.string :status, default: "pending"
      t.string :plan
      t.decimal :amount
      t.datetime :paid_at

      t.timestamps
    end
  end
end
