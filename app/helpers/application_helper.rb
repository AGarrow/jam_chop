module ApplicationHelper
	def svg(name)
	  file_path = "#{Rails.root}/app/assets/images/#{name}.svg"
		File.exists?(file_path) ? File.read(file_path).html_safe : '(not found)'
	end
end
