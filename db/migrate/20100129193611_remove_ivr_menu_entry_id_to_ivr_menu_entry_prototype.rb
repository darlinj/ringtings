class RemoveIvrMenuEntryIdToIvrMenuEntryPrototype < ActiveRecord::Migration
  def self.up
    remove_column :ivr_menu_entry_prototypes, :ivr_menu_entry_id
  end

  def self.down
    add_column :ivr_menu_entry_prototypes, :ivr_menu_entry_id, :integer
  end
end
