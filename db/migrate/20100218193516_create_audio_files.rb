class CreateAudioFiles < ActiveRecord::Migration
  def self.up
    create_table :audio_files do |t|
      t.integer :user_id
      t.string :audio_file_name
      t.string :audio_content_type
      t.integer :audio_file_size
      t.timestamps
    end
  end

  def self.down
    drop_table :audio_files
  end
end
