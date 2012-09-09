var Playlist = {
	currentTrack: null,
	artist: null,
	page: 3,
	limit: 10,
	tracks: [],
	
	play: function(mbid, similar) {
		var url = 'https://gdata.youtube.com/feeds/api/videos',
			track = null; 
		//?q=black%20sabbath%20Sabbath%20Bloody%20Sabbath&orderby=relevance&v=2&alt=atom&restriction=RO';

		if (similar != null) {
			var parent = Playlist.searchTrack(Playlist.tracks, 'mbid', mbid);
			
			track = Playlist.searchTrack(parent.similar, 'mbid', similar);
		} else {
			track = Playlist.searchTrack(Playlist.tracks, 'mbid', mbid);
		}
		
		$.ajax({
			url: url,
			success: function(data) {
				var song_url = data.feed.entry[0].link[0].href,
					regex = /[a-zA-Z0-9_-]+(?=&)/,
					matched = regex.exec(song_url);

				Youtube.player.loadVideoById(matched[0]);

				Playlist.highlightTrack(track);
				Playlist.currentTrack = track;
				
				$.gritter.add({
					title: 'Now playing...',
					image: track.image,
					text: track.artist + ' - ' + track.title
				});
			},
			data: {
				q: track.artist + ' ' + track.title,
				orderby: 'relevance',
				alt: 'json',
				restriction: 'RO'
			},
			dataType: 'json'
		});
	},
	
	next: function() {
		var uid = 0,
			mbid = null;
		
		// Scrobble the current track first
		Lastfm.scrobble(Playlist.currentTrack.artist, Playlist.currentTrack.title);
		
		/*
		 * If similar is an array (object) then the track is a normal track
		 * and if similar is an integer then the track is similar
		 */
		
		if (typeof Playlist.currentTrack.similar === 'object') {		
			// Play next normal track
			if (Playlist.tracks.length > parseInt(Playlist.currentTrack.uid) + 1) {
				// Next normal track
				uid = Playlist.currentTrack.uid + 1;
			} else {
				// Reset to the first normal track
				uid = 0;
			}
			
			mbid = Playlist.searchTrack(Playlist.tracks, 'uid', uid).mbid;
			
			Playlist.play(mbid, null);
		} else {
			// Play next similar track
			var parent = Playlist.tracks[Playlist.currentTrack.similar];
			
			if (parent.similar.length > parseInt(Playlist.currentTrack.uid) + 1) {
				// Play next similar track
				uid = Playlist.currentTrack.uid + 1;
				
				mbid = Playlist.searchTrack(parent.similar, 'uid', uid).mbid;
						
				Playlist.play(parent.mbid, mbid);
			} else {
				// Similar tracks ended, play next normal track
				if (Playlist.tracks.length > parseInt(parent.uid) + 1) {
					uid = parent.uid + 1;	
				} else {
					uid = 0;
				}
				
				mbid = Playlist.searchTrack(Playlist.tracks, 'uid', uid).mbid;
						
				Playlist.play(mbid, null);
			}
		}
	},
	
	highlightTrack: function(track) {
		if (Playlist.currentTrack != null) {
			if (typeof Playlist.currentTrack.similar != 'object') {
				// Similar
				var parent = Playlist.tracks[Playlist.currentTrack.similar];
				
				$('tr[rel="'+ parent.mbid + '_' + Playlist.currentTrack.mbid+'"]').css('backgroundColor', '#FFF');
			} else {
				// Regular
				$('tr[rel="'+Playlist.currentTrack.mbid+'"]').css('backgroundColor', '#FFF');
			}
		}
		
		if (typeof track.similar != 'object') {
			// Similar
			var parent = Playlist.tracks[parseInt(track.similar)];
			
			$('tr[rel="' + parent.mbid + '_' + track.mbid + '"]').css('backgroundColor', '#EEE');	
		} else {
			// Regular			
			$('tr[rel="'+track.mbid+'"]').css('backgroundColor', '#EEE');
		}
	},
	
	searchTrack: function(tracks, attribute, value) {
		var i, l;
		
		for (i=0, l=tracks.length; i<l; i++) {
			if (tracks[i][attribute] == value) {
				return tracks[i];
			}
		}
		
		return null;
	}
};
