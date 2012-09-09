$(function() {
	Alike.init();
	
	$('#aboutModal').modal({
		show: false
	});
	
	$.extend($.gritter.options, { 
		position: 'top-left' // defaults to 'top-right' but can be 'bottom-left', 'bottom-right', 'top-left', 'top-right' (added in 1.7.1)
		// fade_in_speed: 'medium', // how fast notifications fade in (string or int)
		// fade_out_speed: 2000, // how fast the notices fade out
		// time: 6000 // hang on the screen for...
	});
	
	$('#right_content').scrollToFixed();
	
	$('.similar_tracks').click(function(e) {
		var mbid = $(this).parent().parent().parent().parent().attr('rel'),
			track = Playlist.searchTrack(Playlist.tracks, 'mbid', mbid);
				
		if (track.similar.length > 0) {
			// Active
			Alike.removeSimilarTracks(mbid);
			
			$(this).addClass('btn-info');
			$(this).removeClass('btn-danger');
			
			$(this).children('i').addClass('icon-plus-sign');
			$(this).children('i').removeClass('icon-minus-sign');
		} else {
			// Inactive
			Lastfm.similarTracks(mbid);
			
			$(this).removeClass('btn-info');
			$(this).addClass('btn-danger');
			
			$(this).children('i').removeClass('icon-plus-sign');
			$(this).children('i').addClass('icon-minus-sign');
		}
	});
});