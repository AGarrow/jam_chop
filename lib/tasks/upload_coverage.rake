namespace :coverage do
	task :upload => :environment do
		s3 = Aws::S3::Resource.new(region:'us-east-1')
		obj = s3.bucket('jam-chop-staging').object('status.svg')
		# obj.content_type = "image/svg+xml"
		obj.upload_file('coverage/coverage.svg', content_type:"image/svg+xml", acl: 'public-read')
	end
end