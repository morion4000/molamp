class AddMoreDetailsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :facebook_username, :string
    add_column :users, :claimed, :boolean, :null => false, :default => true
  end
  
  def self.down
    remove_column :users, :facebook_username
    remove_column :users, :claimed
  end
end
