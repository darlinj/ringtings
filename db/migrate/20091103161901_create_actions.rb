class CreateActions < ActiveRecord::Migration
  def self.up
    create_table :actions do |t|
      t.integer :callplan_id
      t.string :application_name
      t.string :application_data

      t.timestamps
    end
  end

  def self.down
    drop_table :actions
  end
end
