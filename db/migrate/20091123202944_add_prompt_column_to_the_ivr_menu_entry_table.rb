class AddPromptColumnToTheIvrMenuEntryTable < ActiveRecord::Migration
  def self.up
    add_column :ivr_menu_entries, :prompt, :string
  end

  def self.down
    remove_column :ivr_menu_entries, :prompt
  end
end
