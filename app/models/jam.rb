class Jam < ApplicationRecord
	has_many :tracks

	def download_dir_path
		"#{Constants::DOWNLOAD_DIR}/#{youtube_id}/#{youtube_title}"
	end

	def tar_path
		"#{download_dir_path.split("/")[0..-2].join("/")}/#{youtube_title}.tar.gz"
	end
	def youtube_dl_path
		"\"#{download_dir_path}/#{youtube_title}.\%\%(ext)\""
	end

	def raw_audio_path
		"#{download_dir_path}/#{youtube_title}.wav"
	end
end
