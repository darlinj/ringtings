class AddTypeColumnToIvrMenuEntry < ActiveRecord::Migration
  def self.up
    add_column :ivr_menu_entry_prototypes, :type, :string
  end

  def self.down
    remove_column :ivr_menu_entry_prototypes, :type
  end
end
