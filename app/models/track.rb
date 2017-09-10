class Track < ApplicationRecord
	default_scope { where(download: true) }
	belongs_to :jam

	def track_path
		File.join(jam.download_dir_path, "#{track_number}_#{PathSanitizer.sanitize(name)}.wav")
	end
end
