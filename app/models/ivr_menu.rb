class IvrMenu < ActiveRecord::Base
  has_one :inbound_number_manager
  has_many :ivr_menu_entries, :autosave => true
  accepts_nested_attributes_for :ivr_menu_entries
  belongs_to :action

  def self.create_demo company_name, inbound_phone_number, target_phone_number
    audio_file = AudioFile.create_demo
    ivr_menu_1 = MenuExitMenuEntry.create_demo "*"
    ivr_menu_2 = TransferCallMenuEntry.create_demo "1",target_phone_number
    ivr_menu_3 = VoiceMailMenuEntry.create_demo "2"
    ivr_menu_4 = PlayAudioFileMenuEntry.create_demo "3", audio_file
    ivr_menu_5 = PlayAudioFileMenuEntry.create_demo "4", audio_file
    ivr_menu_6 = PlayAudioFileMenuEntry.create_demo "5", audio_file
    ivr_menus = [ ivr_menu_1 , ivr_menu_2, ivr_menu_3, ivr_menu_4, ivr_menu_5, ivr_menu_6 ]
    long_greeting = "say:Welcome to #{company_name}. please press one to be connected to one of our agents. press two to be connected to leave a message. press three to hear sucking of teeth. four is for an auto quote and 5 is if you want to pay your bill by credit card"
    IvrMenu.create! :name => "ivr_menu_#{inbound_phone_number}", 
      :long_greeting => long_greeting, 
      :ivr_menu_entries => ivr_menus
  end
end
