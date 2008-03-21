class CreateInstances < ActiveRecord::Migration
  def self.up
    create_table :instances do |t|
      t.text :data
      t.integer :player_id

      t.timestamps
    end
  end

  def self.down
    drop_table :instances
  end
end
