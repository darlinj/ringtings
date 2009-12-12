class SplitParametersIntoUserAndSystemParts < ActiveRecord::Migration
  def self.up
    rename_column :ivr_menu_entries, :parameters, :system_param_part
    add_column :ivr_menu_entries, :user_param_part, :string
  end

  def self.down
    rename_column :ivr_menu_entries, :system_param_part, :parameters
    remove_column :ivr_menu_entries, :user_param_part
  end
end
