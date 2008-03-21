class AddDateToInstance < ActiveRecord::Migration
  def self.up
    add_column :instances, :date, :datetime
  end

  def self.down
    remove_column :instances, :date
  end
end
