class ChangeUserParamPartToParam1InIvrMenuEntries < ActiveRecord::Migration
  def self.up
    rename_column :ivr_menu_entries, :user_param_part, :param_1
  end

  def self.down
    rename_column :ivr_menu_entries, :param_1, :user_param_part
  end
end
