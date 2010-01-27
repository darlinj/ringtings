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

IvrMenuEntryPrototype.create! :name => "synthetic_voice",
  :description => "Synthetic voice",
  :freeswitch_command_template => "somthing containing an @ symbol",
  :image => "ivr_step_action.png"

IvrMenuEntryPrototype.create! :name => "play_sound_file",
  :description => "Play audio file",
  :freeswitch_command_template => "somthing containing an @ symbol",
  :image => "ivr_step_action.png"
