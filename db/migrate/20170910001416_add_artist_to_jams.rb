class AddArtistToJams < ActiveRecord::Migration[5.1]
  def change
    add_column :jams, :artist, :string
  end
end
