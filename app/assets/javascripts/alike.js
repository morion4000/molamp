var Alike = {
	youtubeLoaders: [],
	scrobble: false,
	
	init: function() {
		Youtube.init();
		Lastfm.init();
		
		Alike.checkScrobble();
	},
	
	youtubeLoaded: function() {
		for (i=0, l=Alike.youtubeLoaders.length; i<l; i++) {
			Alike.youtubeLoaders[i]();
		}
	},
	
	log: function(message) {
		console.log(message);
	},
	
	appendSimilarTracks: function(mbid, data) {
		var tr = $('table tbody').find('tr[id="'+mbid+'"]'),
			tracks = data.similartracks.track,
			track = Playlist.searchTrack(Playlist.tracks, 'mbid', mbid),
			source = $("#similar-template").html();
			template = Handlebars.compile(source);
				
		for (i=tracks.length-1; i>=0; i--) {
			if (tracks[i].mbid == '') {
				tracks[i].mbid = '_' + md5(tracks[i].name + tracks[i].artist.name);
			}
					
			var container = template({
				mbid: tracks[i].mbid,
				parent_mbid: track.mbid, 
				name: tracks[i].name,
				artist: tracks[i].artist.name,
				image: Alike.getImage(tracks[i].image, 0),
				duration: tracks[i].duration != 0 ? gmdate('i:s', tracks[i].duration/1000) : null
			});
			
			tr.after(container);
			
			if (track != null) {
				track.similar.push({
					uid: i,
					mbid: tracks[i].mbid,
					artist: tracks[i].artist.name,
					title: tracks[i].name,
					image: Alike.getImage(tracks[i].image, 0),
					similar: track.uid 
				});
				
				//Playlist.searchData.push(tracks[i].name);
			}
		}
		
		$('tr[class=similar_row]').show('slow');
		
		$.gritter.add({
			title: 'Similar tracks...',
			text: 'Retreived tracks similar to <strong>' + track.artist + ' - ' + track.title + '</strong>'
		});
		
		_gaq.push(['_trackEvent', 'Tracks', 'Similar', track.artist + ' - ' + track.title]);
	},
	
	removeSimilarTracks: function(mbid) {
		var tr = $('table tbody').find('tr[id="'+mbid+'"]'),
			track = Playlist.searchTrack(Playlist.tracks, 'mbid', mbid);
		
		for (i=0, l=track.similar.length; i<l; i++) {
			$('tr[class=similar_row][id="' + track.mbid + '_' + track.similar[i].mbid+'"]').remove();	
		}
		
		track.similar = [];
	},
	
	appendTracks: function(data) {
		var source = $("#track-template").html();
			template = Handlebars.compile(source),
			tracks = data.toptracks.track,
			table = $('#top-tracks table tbody'),
			moreRow = $('#top-tracks table tbody').find('tr#more-row');
		
		moreRow.remove();
				
		for (var i=0, l=tracks.length; i<l; i++) {
			if (tracks[i].mbid == '') {
				tracks[i].mbid = '_' + md5(tracks[i].name + tracks[i].artist.name);
			}
						
			var container = template({
				no: Playlist.tracks.length + 1,
				mbid: tracks[i].mbid, 
				name: tracks[i].name,
				image: Alike.getImage(tracks[i].image, 0),
				duration: tracks[i].duration != 0 ? gmdate('i:s', tracks[i].duration) : null
			});
			
			table.append(container);
			
			Playlist.tracks.push({
				uid: Playlist.tracks.length,
				mbid: tracks[i].mbid,
				artist: tracks[i].artist.name,
				title: tracks[i].name,
				image: Alike.getImage(tracks[i].image, 0),
				similar: [] 
			});
			
			Playlist.searchData.push(tracks[i].name);
		}
		
		table.append(moreRow);
		
		$.gritter.add({
			title: 'More tracks...',
			text: 'Added ' + Playlist.limit + ' more tracks for <strong>' + tracks[0].artist.name + '</strong>'
		});
		
		_gaq.push(['_trackEvent', 'More', 'Click', tracks[0].artist.name]);
	},
	
	moreTracks: function() {
		Playlist.page += 1;
		
		Lastfm.moreTracks();
	},
	
	getImage: function(array, size) {
		var imagePath = '/assets/noimage.jpg';
				
		if (typeof array !== 'undefined') {
			if (array.length > 0) {
				imagePath = array[size]['#text'];
			}
		}
		
		return imagePath;
	},
	
	checkScrobble: function() {
		var state = $.cookie('scrobble_setting') != null ? $.cookie('scrobble_setting') : 'off';
				
		if (strstr($('#scrobble_setting_on').attr('class'), 'disabled') ||
			strstr($('#scrobble_setting_on').attr('class'), 'disabled')) {
			Alike.scrobble = false;
		} else {
			if (state === 'on') {
				Alike.scrobble = true;
				
				$('#scrobble_setting_on').addClass('active');
			} else {
				Alike.scrobble = false;
				
				$('#scrobble_setting_off').addClass('active');
			}
		}
	},
	
	toggleScrobble: function(state) {
		$.cookie('scrobble_setting', state);
	}
};