$(document).ready(function(){
	if ($("#status-display").length > 0) {
		displayStatus()
	}
});

function displayStatus(){
	var jam_id = $("#status-display").data('jam-id')
	var status = App.cable.subscriptions.create({
		channel: "StatusChannel",
		jam_id: jam_id
	}, {
		connected: function(){
			console.log('connected');
		},
		disconnected: function(){
			console.log('disconnected');
		},
		received: function(data){
			switch(data.status) {
				case 'done':
					$("#status-display").hide();
					$("#status-container").html("<a href=\"" + data.download_url + "\"> Download </>")
				default:
					$("#status-display > p").text(I18n.t('statuses.'+data.status));
					console.log(data);
			}
		}
	})
}