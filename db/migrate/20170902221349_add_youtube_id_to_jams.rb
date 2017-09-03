class AddYoutubeIdToJams < ActiveRecord::Migration[5.1]
  def change
    add_column :jams, :youtube_id, :string
  end
end
