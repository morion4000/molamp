$(function() {
	Alike.init();
	
	$('#aboutModal').modal({
		show: false
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