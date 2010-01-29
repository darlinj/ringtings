Given /^we create some ivr menu entry prototypes$/ do 
  IvrMenuEntryPrototype.destroy_all
  IvrMenuEntryPrototype.create! :name => "synthetic_voice",
    :description => "Synthetic voice",
    :freeswitch_command_template => "somthing containing an @ symbol",
    :image => "ivr_step_action.png"

  IvrMenuEntryPrototype.create! :name => "play_sound_file",
    :description => "Play audio file",
    :freeswitch_command_template => "somthing containing an @ symbol",
    :image => "ivr_step_action.png"
end

