class CreateCallplan < ActiveRecord::Migration
  def self.up
    create_table(:callplans) do |t|
      t.string   :company_name
    end
  end

  def self.down
    drop_table :callplans
  end
end
