class AddYoutubeTitleToJams < ActiveRecord::Migration[5.1]
  def change
    add_column :jams, :youtube_title, :string
  end
end
