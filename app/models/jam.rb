class Jam < ApplicationRecord
	has_attached_file :cover_image, styles: { default: "600x600", thumb: "100x100" }, default_url: "/images/:style/missing.png"
	attr_reader :cover_image_remote_url
	validates_attachment_content_type :cover_image, content_type: /\Aimage\/.*\z/

	has_many :tracks
	accepts_nested_attributes_for :tracks

	validates :youtube_url, format: { with: /(https:)?(\/\/www\.)?youtube\.com\/watch\?v=\w+/, message: 'Please enter a valid youtube url'}
	validates :youtube_url, :youtube_id, :youtube_title, presence: true

	def cover_image_remote_url=(url_value)
		self.cover_image = URI.parse(url_value)
		@cover_image_remote_url = url_value
	end

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
