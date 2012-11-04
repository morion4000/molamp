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
	
	/*
	$('#right_content').scrollToFixed({
		marginTop: 60,
		limit: $(document).height() - 700,
		zIndex: 10,
		offsets: true
	});
	*/
	
	$('#footer').scrollToFixed( {
        bottom: 0,
        limit: $('#footer').offset().top,
        preFixed: function() { 
        	$(this).css({
        		border: '1px solid #DDDDDD',
        		borderRadius: 0,
        		opacity: 0.9
        	}); 
        },
        postFixed: function() { 
        	$(this).css({
        		border: 'none',
        		borderRadius: 4,
        		opacity: 1.0
        	}); 
        }
    });

	$('.similar_tracks').live('click', function(e) {
		var mbid = $(this).parent().parent().parent().parent().attr('id'),
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
	
	$('#more-tracks').live('click', function(e) {
		Alike.moreTracks();
	});
	
	$('#scrobble_setting_off').click(function() {
		Alike.toggleScrobble('off');
		Alike.scrobble = false;
	});
	
	$('#scrobble_setting_on').click(function() {
		Alike.toggleScrobble('on');
		Alike.scrobble = true;
	});
	
	$('#activity_setting_off').click(function() {
		Alike.toggleActivity('off');
		Alike.activity = false;
	});
	
	$('#activity_setting_on').click(function() {
		Alike.toggleActivity('on');
		Alike.activity = true;
	});
	
	setTimeout(function() {
		var rgb = getAverageRGB(document.getElementById('artist_image')),
			start_color = 'whiteSmoke',
			end_color = 'rgb('+rgb.r+','+rgb.g+','+rgb.b+')',
			style = 'backgroundColor: '+end_color+'; background: -webkit-gradient(linear, 0% 0%, 0% 100%, from('+start_color+'), to('+end_color+')); background: -webkit-linear-gradient(top, '+start_color+', '+end_color+'); background: -moz-linear-gradient(top, '+start_color+', '+end_color+'); background: -ms-linear-gradient(top, '+start_color+', '+end_color+'); background: -o-linear-gradient(top, '+start_color+', '+end_color+')';
		
    	$('#application_main_content').attr('style', style);
  	}, 3000);
});