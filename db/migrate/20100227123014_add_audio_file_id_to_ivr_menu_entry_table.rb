class AddAudioFileIdToIvrMenuEntryTable < ActiveRecord::Migration
  def self.up
    add_column :ivr_menu_entries, :audio_file_id, :integer
  end

  def self.down
    remove_column :ivr_menu_entries, :audio_file_id
  end
end
