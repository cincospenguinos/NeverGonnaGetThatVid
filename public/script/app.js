/**
 * app.js
 *
 * All the javascript for the app
 *
 * TODO: All of this
 */

/**
 * Show the message provided.
 */
function showMessage(successful, message){
	var alertSpace = $('#alert-space');
	var div;

	if(successful)
		div = $('<div/>', { 'class': 'alert alert-success', role: 'alert', text: message});
	else
		div = $('<div/>', { 'class': 'alert alert-danger', role: 'alert', text: message});

	div.append('<a href="#" class="close" data-dismiss="alert">&times;</a>');
	div.appendTo(alertSpace);
}

/**
 * Validates the URL provided
 */
function validateURL(url){
	return /www.youtube.com\/watch\?v=\S+/.test(url) || /youtu\.be\/\S+/.test(url);
}

$(document).ready(function(){
	$('#submit-button').click(function(){
		
		var url = $('#youtube-url-input').val();
		if(!validateURL(url)){
			showMessage(false, 'The URL provided is not valid');
		} else {
			$.post({
				url: '/',
				data: { video_url: url },
				success: function(e){
					console.log(e);
				}
			});
		}

		var data = {};
	});
});