class IvrMenuEntry < ActiveRecord::Base
  belongs_to :ivr_menu
  belongs_to :audio_file
  belongs_to :prototype, :class_name => 'IvrMenuEntryPrototype'
  validates_presence_of :prototype
end

class SyntheticVoiceMenuEntry < IvrMenuEntry

end

class MenuExitMenuEntry < IvrMenuEntry
  def self.create_demo menu_digit
    MenuExitMenuEntry.create :digits => menu_digit,
      :prototype => IvrMenuEntryPrototype.find_by_name("MenuExitMenuEntry")
  end
end

class VoiceMailMenuEntry < IvrMenuEntry
  def self.create_demo menu_digit
    VoiceMailMenuEntry.create :digits => menu_digit,
      :prototype => IvrMenuEntryPrototype.find_by_name("VoiceMailMenuEntry")
  end
end

class TransferCallMenuEntry < IvrMenuEntry
  validates_length_of :param_1, :within => 11..12, :message => "The phone number is not the right length"

  def before_create
    if self.param_1.start_with? "0"
      self.param_1.gsub!(/^0/,"44")
    end
  end

  def self.create_demo menu_digit, destination_number
    TransferCallMenuEntry.create :digits => menu_digit,
      :param_1 => destination_number,
      :prototype => IvrMenuEntryPrototype.find_by_name("TransferCallMenuEntry")
  end
end

class SyntheticVoiceMenuEntry < IvrMenuEntry

end

