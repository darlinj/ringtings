class User < ActiveRecord::Base
  include Clearance::User
  has_one :callplan
  has_many :audio_files
end
