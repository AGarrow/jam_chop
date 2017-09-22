class Track < ApplicationRecord
	default_scope { where(download: true) }
	belongs_to :jam
	validates_presence_of :jam
	validates :start_time, :end_time, :name, :track_number, presence: true
	validates :start_time, :end_time, format: { with: /\A(\d{1,2}:\d{1,2}(?::\d{1,2})?)\z/, message: 'must use HH:MM:SS format'}


	def track_path(audio_format: jam.audio_format)
		File.join(jam.download_dir_path, "#{PathSanitizer.sanitize(name)}.#{audio_format}")
	end
end
