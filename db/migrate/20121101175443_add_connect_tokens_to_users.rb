class AddConnectTokensToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :facebook_token, :string
    add_column :users, :lastfm_token, :string
    add_column :users, :lastfm_username, :string
    add_column :users, :activity_mode, :boolean, :null => false, :default => true
    add_column :users, :scrobble_mode, :boolean, :null => false, :default => true
  end
  
  def self.down
    remove_column :users, :facebook_token
    remove_column :users, :lastfm_token
    remove_column :users, :lastfm_username
    remove_column :users, :activity_mode
    remove_column :users, :scrobble_mode 
  end
end
