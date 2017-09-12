class Track < ApplicationRecord
	default_scope { where(download: true) }
	belongs_to :jam

	def track_path(audio_format: jam.audio_format)
		File.join(jam.download_dir_path, "#{PathSanitizer.sanitize(name)}.#{audio_format}")
	end
end
