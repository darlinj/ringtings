class CreateIvrMenuEntries < ActiveRecord::Migration
  def self.up
    create_table :ivr_menu_entries do |t|
      t.string :action
      t.string :digits
      t.string :params
      t.integer :ivr_menu_id

      t.timestamps
    end
  end

  def self.down
    drop_table :ivr_menu_entries
  end
end
