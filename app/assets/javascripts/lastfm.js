var Lastfm = {
	pointer: null,
	 
	init: function() {
		/* Create a cache object */
		var cache = new LastFMCache();

		/* Create a LastFM object */
		Lastfm.pointer = new LastFM({
			apiKey: '930976e93a9a305ccd319242e2a90e58',
			apiSecret: 'fa79a2ce3ac9477157b158fd08bf06f4',
			cache: cache
		});
	},
	
	similarTracks: function(mbid) {
		Lastfm.pointer.track.getSimilar({
			mbid: mbid,
			limit: 5
		}, {
			success: function(data) {
				if (typeof data.similartracks.track === 'object') {
					Alike.appendSimilarTracks(mbid, data);	
				} else {
					$.gritter.add({
						title: 'Similar tracks...',
						text: 'We couldn\'t find any similar tracks'
					});
				}
			},
			error: function(code, message) {
				/* Show error message. */
				$.gritter.add({
					title: 'Similar tracks...',
					text: 'We couldn\'t find any similar tracks'
				});
			}
		});
	},
	
	moreTracks: function() {
		Lastfm.pointer.artist.getTopTracks({
			artist: Playlist.tracks[0].artist,
			page: Playlist.tracksPage,
			limit: Playlist.tracksLimit
		}, {
			success: function(data) {
				Alike.appendTracks(data);
			},
			error: function(code, message) {
				$.gritter.add({
					title: 'Error...',
					text: message
				});
			}
		});
	},
	
	moreAlbums: function() {
		Lastfm.pointer.artist.getTopAlbums({
			artist: Playlist.tracks[0].artist,
			page: Playlist.albumsPage,
			limit: Playlist.albumsLimit
		}, {
			success: function(data) {
				Alike.appendAlbums(data);
			},
			error: function(code, message) {
				$.gritter.add({
					title: 'Error...',
					text: message
				});
			}
		});
	},
	
	scrobble: function(artist, track) {
		$.ajax({
			url: '/ajax/scrobble',
			success: function(data) {
				$.gritter.add({
					title: 'Track scrobbled...',
					text: '<strong>' + artist + ' - ' + track + '</strong> was scrobbled on Last.fm'
				});
			},
			data: {
				artist: artist,
				track: track
			},
			dataType: 'json'
		});
	},
	
	activity: function(artist, track) {
		$.ajax({
			url: '/ajax/activity',
			success: function(data) {
				$.gritter.add({
					title: 'Video posted on timeline...',
					text: '<strong>' + artist + ' - ' + track + '</strong> was posted on your Facebook timeline'
				});
			},
			data: {
				artist: artist,
				track: track
			},
			dataType: 'json'
		});
	},
};
