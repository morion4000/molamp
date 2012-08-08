class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.string :title
      t.string :author
      t.string :body

      t.timestamps
    end
  end
end
