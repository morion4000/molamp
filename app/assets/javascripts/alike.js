var Alike = {
	youtubeLoaders: [],
	scrobble: false,
	activity: false,
	
	init: function() {
		Youtube.init();
		Lastfm.init();
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
		
		$('table tbody').find('tr[class=similar_row]').show('slow');
		
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
				no: (Playlist.tracksPage - 1) * Playlist.tracksLimit + i + 1,
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
				listeners: tracks[i].listeners,
				playcount: tracks[i].playcount,
				url: tracks[i].playcount,
				similar: [] 
			});
			
			Playlist.searchData.push(tracks[i].name);
		}
		
		table.append(moreRow);
		
		$.gritter.add({
			title: 'More tracks...',
			text: 'Added ' + Playlist.tracksLimit + ' more tracks for <strong>' + Playlist.tracks[0].artist + '</strong>'
		});
		
		$('[rel=tooltip]').tooltip('destroy');
		$('[rel=tooltip]').tooltip();
		
		$('#top-tracks table tr').popover('destroy');
		$('#top-tracks table tr').popover(popover_options);
		
		_gaq.push(['_trackEvent', 'More', 'Tracks', Playlist.tracks[0].artist]);
	},
	
	appendAlbums: function(data) {
		var source = $("#album-template").html();
			template = Handlebars.compile(source),
			albums = data.topalbums.album,
			table = $('#top-albums table tbody'),
			moreRow = $('#top-albums table tbody').find('tr#more-row');
		
		moreRow.remove();
				
		for (var i=0, l=albums.length; i<l; i++) {
			console.log(albums[i]);
									
			var container = template({
				no: (Playlist.albumsPage - 1) * Playlist.albumsLimit + i + 1,
				name: albums[i].name,
				image: Alike.getImage(albums[i].image, 1),
				playcount: albums[i].playcount,
				url: '/artists/' + Alike.url_to_lastfm(Playlist.tracks[0].artist) + '/' + Alike.url_to_lastfm(albums[i].name),
				lastfm_url: albums[i].url
			});
			
			table.append(container);
		}
		
		table.append(moreRow);
		
		$.gritter.add({
			title: 'More albums...',
			text: 'Added ' + Playlist.albumsLimit + ' more albums for <strong>' + Playlist.tracks[0].artist + '</strong>'
		});
		
		_gaq.push(['_trackEvent', 'More', 'Albums', Playlist.tracks[0].artist]);
	},
	
	moreTracks: function() {
		Playlist.tracksPage += 1;
		
		Lastfm.moreTracks();
	},
	
	moreAlbums: function() {
		Playlist.albumsPage += 1;
		
		Lastfm.moreAlbums();
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
	
	toggleScrobble: function(state) {
		$.ajax('/ajax/scrobble_mode?mode='+state);
	},
	
	toggleActivity: function(state) {
		$.ajax('/ajax/activity_mode?mode='+state);
	},
	
	url_to_lastfm: function(url) {
		// replace all spaces with +
		return url.replace(/ /gi, '+');
	}
};