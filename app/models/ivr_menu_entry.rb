class IvrMenuEntry < ActiveRecord::Base
  belongs_to :ivr_menu
  belongs_to :prototype, :class_name => 'IvrMenuEntryPrototype'
  validates_presence_of :prototype
end

class SyntheticVoiceMenuEntry < IvrMenuEntry

end

class MenuExitMenuEntry < IvrMenuEntry

end

class VoiceMailMenuEntry < IvrMenuEntry

end

class TransferCallMenuEntry < IvrMenuEntry

end

class SyntheticVoiceMenuEntry < IvrMenuEntry

end

class PlayAudioFileMenuEntry < IvrMenuEntry

end
