class AddAudioFormatToJam < ActiveRecord::Migration[5.1]
  def change
    add_column :jams, :audio_format, :integer, default: 0
  end
end
