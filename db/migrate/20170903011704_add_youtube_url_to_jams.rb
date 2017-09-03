class AddYoutubeUrlToJams < ActiveRecord::Migration[5.1]
  def change
    add_column :jams, :youtube_url, :string
  end
end
