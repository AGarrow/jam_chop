class StatusChannel < ApplicationCable::Channel
	def subscribed
		stream_from "status_#{params[:jam_id]}"
	end

	def unsubcribed
		Rails.logger.debug('StatusChannel#unsubscribed')
	end
end