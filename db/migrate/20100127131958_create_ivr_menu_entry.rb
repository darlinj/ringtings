class CreateIvrMenuEntry < ActiveRecord::Migration
  def self.up
    create_table :ivr_menu_entry_prototypes do |t|
      t.string :name
      t.string :description
      t.string :freeswitch_command_template
      t.string :image
      t.string :prompt
    end
  end

  def self.down
    drop_table :ivr_menu_entry_prototypes
  end
end
