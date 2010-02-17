class AddPartialNameToIvrMenuEntryPrototypes < ActiveRecord::Migration
  def self.up
    add_column :ivr_menu_entry_prototypes, :partial_name, :string
  end

  def self.down
    remove_column :ivr_menu_entry_prototypes, :partial_name
  end
end
