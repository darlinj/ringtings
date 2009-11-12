class CreateIvrMenus < ActiveRecord::Migration
  def self.up
    create_table :ivr_menus do |t|
      t.string :name
      t.string :long_greeting

      t.timestamps
    end
  end

  def self.down
    drop_table :ivr_menus
  end
end
