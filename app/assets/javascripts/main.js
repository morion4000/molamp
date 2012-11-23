var _gaq = _gaq || [];

var popover_options = {
	placement: 'right',
	html: true,
	content: function() {
		var id = $(this).attr('id'),
			track = Playlist.searchTrack(Playlist.tracks, 'mbid', id),
			source = $("#track-tooltip-template").html();
			template = Handlebars.compile(source);
			
		return template({
			name: track.title,
			artist: track.artist,
			image: track.image,
			playcount: track.playcount
		});
	},
	title: function() {
		var id = $(this).attr('id'),
			track = Playlist.searchTrack(Playlist.tracks, 'mbid', id);
			
		return track.artist;
	},
	delay: { show: 500, hide: 100 },
	trigger: 'hover'
};
	
$(function() {
	Alike.init();
	
	$('#aboutModal').modal({
		show: false
	});
	
	$('#confirmModal').modal({
		show: false
	});
	
	$('a').live('click', function(e) {
		if ($(this).attr('id') == 'leave_url' || Youtube.player.getPlayerState() != 1) {
			return true;	
		} 
		
		var href = $(this).attr('href') || ' ';
		
		if (!strstr(href, 'javascript:') && href[0] != '#') {
			e.preventDefault();
			
			$('#confirmModal').modal('show');
				
			$('#confirmModal #leave_url').attr('href', href);
		} 
	});
	
	$('[rel=tooltip]').tooltip();
	
	//$('#top-tracks table tr').popover(popover_options);
	
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
	
	$('.player_controls').scrollToFixed({
	    bottom: 0,
	    limit: $('.player_controls').offset().top
	});
	
	$(window).resize(function() {
		var similar_width = $('.similar_artists').width();
		
		$('#ytplayer').width(similar_width);
	});
	
	$('body').resize(function() {
		if ($.isScrollToFixed('.player_controls')) {
			$('.player_controls').trigger('remove.ScrollToFixed');
		}
		
		$('.player_controls').scrollToFixed({
		    bottom: 0,
		    limit: $('.player_controls').offset().top
		});
	});

	$('#progress_bar').slider({
		range: 'min',
        value: 0,
        min: 0,
        max: 100,
        slide: function(event, e) {
        	var percentage = e.value * Youtube.player.getDuration() / 100;
        	 
            Youtube.player.seekTo(percentage, false);
            // TODO: Look into the seekTo options...
        }
	});
	
	$('#toggle_play').click(function() {
		if (Youtube.playing === true) {
			Youtube.playing = false;
			
			Youtube.player.pauseVideo();
			
			$(this).find('i').attr('class', 'icon-play');
		} else {
			Youtube.playing = true;
			
			Youtube.player.playVideo();
			
			$(this).find('i').attr('class', 'icon-pause');
		}
	});
	
	$('#next_play').click(function() {
		Playlist.next();
	});

	$('.similar_tracks').live('click', function(e) {
		var mbid = $(this).parent().parent().parent().parent().attr('id'),
			track = Playlist.searchTrack(Playlist.tracks, 'mbid', mbid);
				
		if (track.similar.length > 0) {
			// Active
			Alike.removeSimilarTracks(mbid);
			
			//$(this).addClass('btn-info');
			//$(this).removeClass('btn-danger');
			
			$(this).children('i').addClass('icon-plus-sign');
			$(this).children('i').removeClass('icon-minus-sign');
		} else {
			// Inactive
			Lastfm.similarTracks(mbid);
			
			//$(this).removeClass('btn-info');
			//$(this).addClass('btn-danger');
			
			$(this).children('i').removeClass('icon-plus-sign');
			$(this).children('i').addClass('icon-minus-sign');
		}
	});
	
	$('#more-tracks').live('click', function(e) {
		Alike.moreTracks();
	});
	
	$('#more-albums').live('click', function(e) {
		Alike.moreAlbums();
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
	
	$('.playlist_track').live({
		click: function(e) {
			var track = $(this),
				track_id = track.attr('id');
			
			Playlist.play(track_id, null, e);
		},
		mouseenter: function(e) {
			$(this).find('a.similar_tracks').removeClass('disabled');
		},
		mouseleave: function(e) {
			$(this).find('a.similar_tracks').addClass('disabled');
		}
	});
	
	$('.similar_row').live('click', function(e) {
		var track = $(this),
			track_id = track.attr('id'),
			params = track_id.split('_');
				
		Playlist.play(params[0], params[1], e);
	});
	
	$('#toggle_top_tracks').click(function(e) {
		_gaq.push(['_trackEvent', 'Tabs', 'Click', 'Top Tracks']);
	});
	
	$('#toggle_top_albums').click(function(e) {
		_gaq.push(['_trackEvent', 'Tabs', 'Click', 'Top Albums']);
	});
	
	$('.typeahead').typeahead({
		source: Playlist.searchData,
		updater:function (item) {
			var track = Playlist.searchTrack(Playlist.tracks, 'title', item);

			Playlist.play(track.mbid, null);
			
			_gaq.push(['_trackEvent', 'Tracks', 'Search', item]);
			
        	return '';
		}
	});
	
	var search_source = function(query, process) {
		/*
		$.ajax('/ajax/autocomplete?query='+query).done(function(data) {
			process(data);
		});
		*/
		
		Lastfm.pointer.artist.search({
			artist: query,
			limit: 10
		}, {
			success: function(data) {
				var results = data.results.artistmatches.artist; 
				if (typeof results === 'object') {
					var data = [];
					
					for (var i=0, l=results.length; i<l; i++) {							
						data.push(results[i]['name']);
					}
					
					process(data);
				}
			}
		});
	}

	$('#generic_search').typeahead({
		source: search_source,
		updater: function (item) {
			_gaq.push(['_trackEvent', 'Menu', 'Search', item]);
			
			location.href = '/artists/' + Alike.url_to_lastfm(item);
			
	    	return item;
		}
	});
	
	$('#main_search').typeahead({
		source: search_source,
		updater: function (item) {
			_gaq.push(['_trackEvent', 'Hero', 'Search', item]);
			
			location.href = '/artists/' + Alike.url_to_lastfm(item);
			
	    	return item;
		}
	});
	
	setTimeout(function() {
		/*
		var rgb = getAverageRGB(document.getElementById('artist_image')),
			start_color = 'whiteSmoke',
			end_color = 'rgb('+rgb.r+','+rgb.g+','+rgb.b+')',
			style = 'backgroundColor: '+end_color+'; background: -webkit-gradient(linear, 0% 0%, 0% 100%, from('+start_color+'), to('+end_color+')); background: -webkit-linear-gradient(top, '+start_color+', '+end_color+'); background: -moz-linear-gradient(top, '+start_color+', '+end_color+'); background: -ms-linear-gradient(top, '+start_color+', '+end_color+'); background: -o-linear-gradient(top, '+start_color+', '+end_color+')';
		
    	$('#application_main_content').attr('style', style);
    	*/
  	}, 3000);
});