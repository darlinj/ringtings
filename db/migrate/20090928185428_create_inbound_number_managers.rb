class CreateInboundNumberManagers < ActiveRecord::Migration
  def self.up
    create_table :inbound_number_managers do |t|
      t.string :phone_number
      t.integer :callplan_id
    end
  end

  def self.down
    drop_table :inbound_number_managers
  end
end
