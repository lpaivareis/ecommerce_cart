# frozen_string_literal: true

class CreateCarts < ActiveRecord::Migration[7.1]
  def change
    create_table :carts do |t|
      t.decimal :total_price, precision: 17, scale: 2, default: 0
      t.boolean :abandoned, default: false
      t.datetime :last_interaction_at

      t.timestamps
    end
  end
end
