class MoveTypeColumnFromIvrMenuPrototypeToIvrMenu < ActiveRecord::Migration
  def self.up
    remove_column :ivr_menu_entry_prototypes, :type
    add_column :ivr_menu_entries, :type, :string
  end

  def self.down
    add_column :ivr_menu_entry_prototypes, :type, :string
    remove_column :ivr_menu_entries, :type
  end
end
