class AddActonIdToIvrMenu < ActiveRecord::Migration
  def self.up
    add_column :ivr_menus, :action_id, :integer
  end

  def self.down
    remove_column :ivr_menus, :action_id
  end
end
