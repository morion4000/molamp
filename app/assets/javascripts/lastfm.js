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
			page: Playlist.page,
			limit: Playlist.limit
		}, {
			success: function(data) {
				Alike.appendTracks(data);
			},
			error: function(code, message) {
				alert(message);
			}
		});
	},
	
	scrobble: function(artist, track) {
		$.ajax({
			url: '/tracks/scrobble',
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
	}
};
