class AddTimestampsToCallplan < ActiveRecord::Migration
  def self.up
    change_table  :callplans do |t|
      t.timestamps
    end
  end

  def self.down
    remove_column :callplans, :updated_at
    remove_column :callplans, :created_at
  end
end
