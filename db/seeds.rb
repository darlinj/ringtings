InboundNumberManager.destroy_all

InboundNumberManager.create! :phone_number=>"447031917560"
InboundNumberManager.create! :phone_number=>"448444843729"
InboundNumberManager.create! :phone_number=>"448715041970"
InboundNumberManager.create! :phone_number=>"44123456003"
InboundNumberManager.create! :phone_number=>"44123456004"
InboundNumberManager.create! :phone_number=>"44123456005"
InboundNumberManager.create! :phone_number=>"44123456006"
InboundNumberManager.create! :phone_number=>"44123456007"
InboundNumberManager.create! :phone_number=>"44123456008"
InboundNumberManager.create! :phone_number=>"44123456009"

IvrMenuEntryPrototype.destroy_all

IvrMenuEntryPrototype.create! :name => "MenuExitMenuEntry",
  :description => "Exit the current menu",
  :freeswitch_command_template => "",
  :image => "ivr_step_action_menu_exit.png",
  :prompt => "Menu exit",
  :action => "menu-exit"

IvrMenuEntryPrototype.create! :name => "VoiceMailMenuEntry",
  :description => "Voicemail system",
  :freeswitch_command_template => "voicemail default ${domain_name} ${dialed_extension}",
  :image => "ivr_step_action_voicemail.png",
  :prompt => "Go to voicemail",
  :action => "menu-exec-app"

IvrMenuEntryPrototype.create! :name => "TransferCallMenuEntry",
  :description => "Transfer call to another number",
  :freeswitch_command_template => "transfer <param_1> XML default",
  :image => "ivr_step_action_transfer_call.png",
  :prompt => "Transfer call to:",
  :param_1_default => "441234-SOME-NUM",
  :action => "menu-exec-app"

IvrMenuEntryPrototype.create! :name => "SyntheticVoiceMenuEntry",
  :description => "Synthetic voice",
  :freeswitch_command_template => "say:<param_1>",
  :image => "ivr_step_action_synthetic_voice.png",
  :prompt => "Synthetic voice says:",
  :param_1_default => "your announcement here",
  :action => "menu-exec-app"

IvrMenuEntryPrototype.create! :name => "PlayAudioFileMenuEntry",
  :description => "Play audio file",
  :freeswitch_command_template => "play <param_1>",
  :image => "ivr_step_action_play_audio_file.png",
  :prompt => "Play audio file:",
  :param_1_default => "/some/file.wav",
  :action => "menu-exec-app"
