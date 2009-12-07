class AddUserIdToCallplan < ActiveRecord::Migration
  def self.up
    add_column :callplans, :user_id, :integer
  end

  def self.down
    remove_column :callplans, :user_id
  end
end
