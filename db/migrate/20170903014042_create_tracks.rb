class CreateTracks < ActiveRecord::Migration[5.1]
  def change
    create_table :tracks do |t|
      t.string :name
      t.string :start_time
      t.string :end_time
      t.integer :jam_id

      t.timestamps
    end
  end
end
