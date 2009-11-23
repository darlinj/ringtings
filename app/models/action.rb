class Action < ActiveRecord::Base
  belongs_to :callplan
  has_one :ivr_menu
end
