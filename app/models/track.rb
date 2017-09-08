class Track < ApplicationRecord
	default_scope { where(download: true) }
end
