class PlayAudioFileMenuEntry < IvrMenuEntry
  def self.create_demo menu_digit,audio_file
    PlayAudioFileMenuEntry.create :digits => menu_digit, 
      :param_1 => audio_file.audio.path,
      :prototype => IvrMenuEntryPrototype.find_by_name("PlayAudioFileMenuEntry"),
      :audio_file => audio_file
  end
end
