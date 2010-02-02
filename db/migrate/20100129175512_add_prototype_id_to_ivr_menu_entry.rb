class AddPrototypeIdToIvrMenuEntry < ActiveRecord::Migration
  def self.up
    add_column :ivr_menu_entries, :prototype_id, :integer
  end

  def self.down
    remove_column :ivr_menu_entries, :prototpe_id
  end
end
