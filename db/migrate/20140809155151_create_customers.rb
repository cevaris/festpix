require 'securerandom'

class CreateCustomers < ActiveRecord::Migration
  def self.up

    create_table :customers do |t|

      t.string   :name

      t.string   :color_one
      t.string   :color_two
      t.string   :color_three

      t.string   :slug

      t.timestamps
    end

    add_index :customers, :slug
  end

  def self.down
    remove_index :customers, :slug

    drop_table :customers
  end
end
