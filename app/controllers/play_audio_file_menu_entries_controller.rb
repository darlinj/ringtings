class PlayAudioFileMenuEntriesController < ApplicationController
  def edit
    @play_audio_file_ivr_menu = PlayAudioFileMenuEntry.find(params[:id])
  end

  def update
    audio_file = AudioFile.create :audio => params['play_audio_file_menu_entry']['audio']
    play_audio_file_menu_entry = PlayAudioFileMenuEntry.find(params['id'])
    play_audio_file_menu_entry.audio_file = audio_file
    play_audio_file_menu_entry.param_1 = audio_file.audio.path
    play_audio_file_menu_entry.save!

    flash[:notice] = "Callplan sucessfully saved"
    redirect_to_callplan play_audio_file_menu_entry
  end
end
