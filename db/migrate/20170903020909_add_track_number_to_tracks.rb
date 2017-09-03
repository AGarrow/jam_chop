class AddTrackNumberToTracks < ActiveRecord::Migration[5.1]
  def change
    add_column :tracks, :track_number, :integer
  end
end
