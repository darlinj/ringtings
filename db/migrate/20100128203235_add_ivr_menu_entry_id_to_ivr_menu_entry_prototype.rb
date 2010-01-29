class AddIvrMenuEntryIdToIvrMenuEntryPrototype < ActiveRecord::Migration
  def self.up
    add_column :ivr_menu_entry_prototypes, :ivr_menu_entry_id, :integer
  end

  def self.down
    remove_column :ivr_menu_entry_prototypes, :ivr_menu_entry_id
  end
end
