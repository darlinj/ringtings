class Action < ActiveRecord::Base
  belongs_to :callplan
  has_one :ivr_menu, :autosave => true
  accepts_nested_attributes_for :ivr_menu
end
