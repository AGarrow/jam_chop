class AddUniqueIndexToTracks < ActiveRecord::Migration[5.1]
  def change
  	add_index :tracks, [:name, :jam_id], unique: true
  end
end
