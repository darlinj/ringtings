class CreateInboundNumberManagers < ActiveRecord::Migration
  def self.up
    create_table :inbound_number_managers do |t|
      t.string :inbound_number
    end
  end

  def self.down
    drop_table :inbound_number_managers
  end
end
