class JamDecorator < Draper::Decorator
	delegate_all

	def track_errors
		object.errors.messages.select { |k,v| k.match(/tracks\./)}.map { |m| "#{m[0].to_s.split('.')[-1].humanize} #{m[-1][0]}" }
	end

	def jam_errors

	end
end