class CreateEmployees < ActiveRecord::Migration
  def self.up
    create_table :employees do |t|
      t.string :name
      t.string :phone_number
      t.string :email_address
      t.integer :callplan_id
      t.timestamps
    end
  end

  def self.down
    drop_table :employees
  end
end
