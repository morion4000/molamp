var Playlist = {
	currentTrack: null,
	artist: null,
	tracksPage: 1,
	tracksLimit: 30,
	albumsPage: 1,
	albumsLimit: 10,
	tracks: [],
	searchData: [],
	
	play: function(mbid, similar, _event) {
		var track = null;
		
		// TODO: Implement better logic for this...
		if (_event === null || typeof event == 'undefined') {
		} else {
			e = typeof event != 'undefined' ? event : _event,
			target = e.target || e.srcElement,
			targetClass = $(target).attr('class');

			if (strstr(targetClass, 'icon') || strstr(targetClass, 'btn')) {
				return true;
			}
		}
			
		if (similar != null) {
			var parent = Playlist.searchTrack(Playlist.tracks, 'mbid', mbid);
			
			track = Playlist.searchTrack(parent.similar, 'mbid', similar);
		} else {
			track = Playlist.searchTrack(Playlist.tracks, 'mbid', mbid);
		}
		
		$.ajax({
			url: Youtube.url,
			success: function(data) {				
				if (typeof data.feed.entry !== 'undefined') {
					var song_url = data.feed.entry[0].link[0].href,
						regex = /[a-zA-Z0-9_-]+(?=&)/,
						matched = regex.exec(song_url);
	
					Youtube.player.loadVideoById(matched[0]);
	
					Playlist.highlightTrack(track);
					Playlist.currentTrack = track;
					
					document.title = track.artist + ' - ' + track.title;
					
					$.gritter.add({
						title: 'Now playing...',
						image: track.image,
						text: track.artist + ' - ' + track.title
					});
					
					_gaq.push(['_trackEvent', 'Tracks', 'Play', track.artist + ' - ' + track.title]);
				} else {
					$.gritter.add({
						title: 'Track not found...',
						image: track.image,
						text: track.artist + ' - ' + track.title
					});
				}
			},
			data: {
				q: track.artist + ' ' + track.title,
				orderby: 'relevance',
				alt: 'json',
				format: 5,
				key: Youtube.key
				//restriction: 'RO'
			},
			dataType: 'json'
		});
	},
	
	next: function() {
		var uid = 0,
			mbid = null;
				
		/*
		 * If similar is an array (object) then the track is a normal track
		 * and if similar is an integer then the track is similar
		 */
		
		if (typeof Playlist.currentTrack.similar === 'object') {		
			// Track is normal
			var similarTracksNo = Playlist.currentTrack.similar.length;
			
			if (similarTracksNo > 0) {
				// Play similar track
				uid = Playlist.currentTrack.similar[similarTracksNo-1].uid;
				
				mbid = Playlist.searchTrack(Playlist.currentTrack.similar, 'uid', uid).mbid;
				
				Playlist.play(Playlist.currentTrack.mbid, mbid, null);
			} else {
				// Play normal track
				if (Playlist.tracks.length > parseInt(Playlist.currentTrack.uid) + 1) {
					// Next normal track
					uid = Playlist.currentTrack.uid + 1;
				} else {
					// Reset to the first normal track
					uid = 0;
				}
				
				mbid = Playlist.searchTrack(Playlist.tracks, 'uid', uid).mbid;
				
				Playlist.play(mbid, null, null);
			}
		} else {
			// Track is similar
			var parent = Playlist.tracks[Playlist.currentTrack.similar];
			
			if (parent.similar.length > parseInt(Playlist.currentTrack.uid) + 1) {
				// Play next similar track
				uid = Playlist.currentTrack.uid + 1;
				
				mbid = Playlist.searchTrack(parent.similar, 'uid', uid).mbid;
						
				Playlist.play(parent.mbid, mbid, null);
			} else {
				// Similar tracks ended, play next normal track
				if (Playlist.tracks.length > parseInt(parent.uid) + 1) {
					uid = parent.uid + 1;	
				} else {
					uid = 0;
				}
				
				mbid = Playlist.searchTrack(Playlist.tracks, 'uid', uid).mbid;
						
				Playlist.play(mbid, null, null);
			}
		}
	},
	
	highlightTrack: function(track) {
		var source = $("#current-track-template").html(),
			template = Handlebars.compile(source);
					
		if (Playlist.currentTrack != null) {
			if (typeof Playlist.currentTrack.similar != 'object') {
				// Similar
				var parent = Playlist.tracks[Playlist.currentTrack.similar];
				
				$('tr[id="'+ parent.mbid + '_' + Playlist.currentTrack.mbid+'"]').css({
					backgroundColor: '#FFF',
					fontWeight: 'normal'
				});
			} else {
				// Regular
				$('tr[id="'+Playlist.currentTrack.mbid+'"]').css({
					backgroundColor: '#FFF',
					fontWeight: 'normal'
				});
			}
		}
		
		if (typeof track.similar != 'object') {
			// Similar
			var parent = Playlist.tracks[parseInt(track.similar)];
			
			$('tr[id="' + parent.mbid + '_' + track.mbid + '"]').css({
				backgroundColor: '#EEE',
				fontWeight: 'bold'
			});	
		} else {
			// Regular			
			$('tr[id="'+track.mbid+'"]').css({
				backgroundColor: '#EEE',
				fontWeight: 'bold'
			});
		}
		
		$('#current_playing').html(
			template({
				title: track.title,
				artist: track.artist,
				url: '#'+track.mbid,
				image: track.image
			})
		);
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
