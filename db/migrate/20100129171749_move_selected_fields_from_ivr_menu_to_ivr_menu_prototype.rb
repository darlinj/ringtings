class MoveSelectedFieldsFromIvrMenuToIvrMenuPrototype < ActiveRecord::Migration
  def self.up
    remove_column :ivr_menu_entries, :prompt
    remove_column :ivr_menu_entries, :action
    add_column :ivr_menu_entry_prototypes, :action, :string
    remove_column :ivr_menu_entries, :system_param_part
  end

  def self.down
    add_column :ivr_menu_entries, :prompt, :string
    add_column :ivr_menu_entries, :action, :string
    remove_column :ivr_menu_entry_prototypes, :action
    add_column :ivr_menu_entries, :system_param_part, :string
  end
end
