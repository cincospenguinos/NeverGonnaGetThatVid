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

function showVideoInfo(videoInfo){
	console.log(videoInfo.items[0].snippet.thumbnails.default.url);
	var container = $('#video-info-space');
	container.html('');
	$('#alert-space').html('');

	var containerRow = $('<div/>', { 'class':'row' });
	var imageSpace = $('<div/>', { 'class':'col-md-4' });
	imageSpace.html('<img src="' + videoInfo.items[0].snippet.thumbnails.default.url + '" />');
	containerRow.append(imageSpace);

	var titleSpace = $('<div/>', { 'class':'col-md-8' });
	titleSpace.append('<h2><a href=' + videoInfo.url + '>' + videoInfo.items[0].snippet.title + '</a></h2>');
	containerRow.append(titleSpace);

	container.append(containerRow);
	container.append("<div class='btn btn-success btn-lg' id='download-button'><strong>Download this video</strong></div>");

	$('#download-button').click(function(e){
		e.preventDefault();
		window.location.href = '/videos/never_gonna_give_you_up.mp4';
	});
}

/* <script>alert('haxxed');</script>https://www.youtube.com/watch?v=Dkm8Hteeh6M */


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
					e = JSON.parse(e);

					if(e.successful){
						// Show info about the video here!
						showVideoInfo(e.video_info);
					} else {
						showMessage(e.successful, e.message);
					}
				}
			});
		}
	});
});