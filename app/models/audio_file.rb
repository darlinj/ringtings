class AudioFile < ActiveRecord::Base
  has_attached_file :audio
  belongs_to :user
  validates_attachment_presence :audio
  def self.create_demo
    filename = "suckingteeth.wav"
    file_with_path = "#{RAILS_ROOT}/freeswitch_stuff/#{filename}"
    audio_file = AudioFile.create! :audio_file_name => filename,
      :audio_file_size => File.size(file_with_path),
      :audio_content_type => "audio/x-wav"
    unless File.exists?(audio_file.audio.path)
      FileUtils.mkdir_p File.dirname(audio_file.audio.path)
      FileUtils.cp file_with_path, audio_file.audio.path
    end
    audio_file
  end

end
