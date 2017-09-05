class Jam < ApplicationRecord
	has_many :tracks
	accepts_nested_attributes_for :tracks
	validates :youtube_url, format: { with: /(https:)?(\/\/www\.)?youtube\.com\/watch\?v=\w+/, message: 'Please enter a valid youtube url'}
	validates :youtube_url, :youtube_id, :youtube_title, presence: true
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
