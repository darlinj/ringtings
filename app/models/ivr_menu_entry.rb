class IvrMenuEntry < ActiveRecord::Base
  belongs_to :ivr_menu
  has_one :prototype, :class_name => 'IvrMenuEntryPrototype'
end
