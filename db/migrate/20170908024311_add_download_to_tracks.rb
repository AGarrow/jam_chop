class AddDownloadToTracks < ActiveRecord::Migration[5.1]
  def change
    add_column :tracks, :download, :boolean, default: true
  end
end
