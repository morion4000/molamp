var Lastfm = {
	call : function() {
		var artist = $('input[name=search]').val();

		/* Create a cache object */
		var cache = new LastFMCache();

		/* Create a LastFM object */
		var lastfm = new LastFM({
			apiKey : 'f21088bf9097b49ad4e7f487abab981e',
			apiSecret : '7ccaec2093e33cded282ec7bc81c6fca',
			cache : cache
		});

		/* Load some artist info. */
		lastfm.artist.getTopTracks({
			artist : artist,
			autocorrect : 1,
			limit : 50
		}, {
			success : function(data) {
				/* Use data. */

				//console.log(data);

				$('ul#songs_list').html('<li class="nav-header">Top rated songs</li>');

				songs = data.toptracks.track;

				for (var i = 0, l = data.toptracks.track.length; i < l; i++) {
					var song = data.toptracks.track[i];

					console.log(song);

					$('ul#songs_list').append($('<li/>').append($('<a/>').text(song.name).attr('href', 'javascript:;').click((function(s) {
						return function() {
							play(artist, s);
						}
					})(song))).attr('id', song.playcount));
				}
			},
			error : function(code, message) {
				/* Show error message. */
			}
		});
	}
};
