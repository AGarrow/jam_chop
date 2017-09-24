class RemoveDownloadFromTracks < ActiveRecord::Migration[5.1]
  def change
    remove_column :tracks, :download, :boolean
  end
end
