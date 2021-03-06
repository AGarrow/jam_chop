$(document).ready(function(){
	$("#add-track").click(function(e){
		e.preventDefault();
		var $lastTrack = $("#tracks-table > tbody > :last");
		var $newRow = $lastTrack.clone().html($lastTrack.html().replace(/\[[0-9]{1,2}\]/g, "["+String($("tr").length)+"]"));
		$("#tracks-table").append($newRow);
		$lastTrack = $("#tracks-table > tbody > :last");
		$lastTrack.find(".time-field > input").each(function(){
			$(this).val('');
			$(this).attr('placeholder', '00:00')
		});
		$lastTrack.find(".name-field > input ").val('');
		$lastTrack.find(".name-field > input ").attr('placeholder', 'Track Title')
		updateTrackNumbers();
		updateRemoveButton();
	});

	$("button.remove-track").click(function(e){
		console.log("delete");
		e.preventDefault();
		$(this).closest("tr").remove();
		updateTrackNumbers();
		updateRemoveButton();
	});

	$("input[type='checkbox']").click(function(){updateTrackNumbers();});
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
					$("#status-container").html("<a class=\"btn form-button\" href=\"" + data.download_url + "\"> Download </>")
				case 'error':
					$("#status-display > p").text(I18n.t('statuses.'+data.status));
					$("#loading-svg").hide();
				default:
					$("#status-display > p").text(I18n.t('statuses.'+data.status));
					console.log(data);
			}
		}
	})
}

function updateTrackNumbers(){
	$("tr").each(function( index ){
		$(this).find(".track-no > input").val(String(index + 1))
	});
}

function updateRemoveButton(){
	if($("tr").length > 1) {
		$(".remove-track").show();
	}
	else{
		$(".remove-track").hide();
	}
}


