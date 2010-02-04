InboundNumberManager.destroy_all

InboundNumberManager.create! :phone_number=>"0123456000"
InboundNumberManager.create! :phone_number=>"0123456001"
InboundNumberManager.create! :phone_number=>"0123456002"
InboundNumberManager.create! :phone_number=>"0123456003"
InboundNumberManager.create! :phone_number=>"0123456004"
InboundNumberManager.create! :phone_number=>"0123456005"
InboundNumberManager.create! :phone_number=>"0123456006"
InboundNumberManager.create! :phone_number=>"0123456007"
InboundNumberManager.create! :phone_number=>"0123456008"
InboundNumberManager.create! :phone_number=>"0123456009"

IvrMenuEntryPrototype.destroy_all

IvrMenuEntryPrototype.create! :name => "MenuExitMenuEntry",
  :description => "Exit the current menu",
  :freeswitch_command_template => "somthing containing an @ symbol",
  :image => "ivr_step_action.png",
  :prompt => "Menu exit",
  :action => "menu-exit"

IvrMenuEntryPrototype.create! :name => "VoiceMailMenuEntry",
  :description => "Voicemail system",
  :freeswitch_command_template => "somthing containing an @ symbol",
  :image => "ivr_step_action.png",
  :prompt => "Go to voicemail",
  :action => "menu-exec-app"

IvrMenuEntryPrototype.create! :name => "TransferCallMenuEntry",
  :description => "Transfer call to another number",
  :freeswitch_command_template => "transfer <param1> XML default",
  :image => "ivr_step_action.png",
  :prompt => "Transfer call to:",
  :action => "transferything-exec-app"

IvrMenuEntryPrototype.create! :name => "SyntheticVoiceMenuEntry",
  :description => "Synthetic voice",
  :freeswitch_command_template => "somthing containing an @ symbol",
  :image => "ivr_step_action.png",
  :prompt => "Synthetic voice says:",
  :action => "menu-exec-app"

IvrMenuEntryPrototype.create! :name => "PlayAudioFileMenuEntry",
  :description => "Play audio file",
  :freeswitch_command_template => "somthing containing an @ symbol",
  :image => "ivr_step_action.png",
  :prompt => "Play audio file:",
  :action => "menu-exec-app"
