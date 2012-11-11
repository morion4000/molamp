class AddManualToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :manual, :boolean, :null => false, :default => true
  end
  
  def self.down
    remove_column :users, :manual
  end
end
