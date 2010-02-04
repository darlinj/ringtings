class AddParam1DefaultToIvrMenuEntry < ActiveRecord::Migration
  def self.up
    add_column :ivr_menu_entry_prototypes, :param_1_default, :string
  end

  def self.down
    remove_column :ivr_menu_entry_prototypes, :param_1_default
  end
end
