class Jam < ApplicationRecord
	has_attached_file :cover_image, styles: { default: "600x600", thumb: "100x100" }, default_url: "/images/:style/missing.png"
	attr_reader :cover_image_remote_url
	

	enum  status: [ :downloading, :chopping, :compressing, :uploading, :cleaning_up, :done, :deleted, :error, :applying_metadata ]
	enum	audio_format: [ :mp3, :wav ]
	has_many :tracks
	accepts_nested_attributes_for :tracks

	mount_uploader :jam_zip_upload, JamUploader

	scope :to_delete, -> { where("uploaded_at < ?", Time.zone.now - 1).where(upload_deleted_at: nil) }

	validates :youtube_url, format: { with: Constants::YOUTUBE_URL_REGEX }
	validates :youtube_url, :youtube_id, :youtube_title, presence: true
	validates_attachment_content_type :cover_image, content_type: /\Aimage\/.*\z/
	validates_presence_of :tracks

	def cover_image_remote_url=(url_value)
		self.cover_image = URI.parse(url_value)
		@cover_image_remote_url = url_value
	end

	def download_root_path
		File.join(Constants::DOWNLOAD_DIR, id.to_s)
	end

	def download_dir_path
		File.join(download_root_path, id.to_s)
	end

	def tar_path
		File.join(download_root_path, "#{PathSanitizer.sanitize(youtube_title)}.tar.gz")
	end

	def youtube_dl_path
		"\"#{download_dir_path}/#{id}.\%\%(ext)\""
	end

	def raw_audio_path
		File.join(download_dir_path, "#{id}.wav")
	end
end
