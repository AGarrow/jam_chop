class PathSanitizer
	class << self
		def sanitize(path)
			path.gsub(/^.*(\\|\/)/, '').gsub(/[^0-9A-Za-z.\-]/, '_').strip
		end
	end
end