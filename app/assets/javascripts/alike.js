var Alike = {
	youtubeLoaders: [],
	
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
			var container = template({
				mbid: tracks[i].mbid,
				parent_mbid: track.mbid, 
				name: tracks[i].name,
				artist: tracks[i].artist.name,
				image: tracks[i].image.length > 0 ? tracks[i].image[0]['#text'] : '/assets/noimage.png'
			});
			
			tr.after(
				$('<tr>').css({
					backgroundColor: '#FFF',
					display: 'none'
				}).attr({
					id: track.mbid + '_' + tracks[i].mbid,
					'class': 'similar_row'
				}).append(
					$('<td>').attr({colspan: 2}).append(container)
				)
			);
			
			if (track != null) {
				track.similar.push({
					uid: i,
					mbid: tracks[i].mbid,
					artist: tracks[i].artist.name,
					title: tracks[i].name,
					image: tracks[i].image[0]['#text'],
					similar: track.uid 
				});
			}
		}
		
		$('tr[class=similar_row]').show('slow');
		
		$.gritter.add({
			title: 'Similar tracks...',
			text: 'Retreived tracks similar to <strong>' + track.artist + ' - ' + track.title + '</strong>'
		});
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
				
		for (var i=0, l=tracks.length; i<l; i++) {				
			var container = template({
				mbid: tracks[i].mbid, 
				name: tracks[i].name,
				image: tracks[i].image.length > 0 ? tracks[i].image[0]['#text'] : '/assets/noimage.png' // TODO: this does not work
			});
			
			table.append(
				$('<tr>').css({
					backgroundColor: '#FFF'
				}).attr({
					id: 'track-' + (Playlist.tracks.length + 1),
					rel: tracks[i].mbid
				}).append([
					$('<td>').text(Playlist.tracks.length + 1),
					$('<td>').append(container)
				])
			);
			
			Playlist.tracks.push({
				uid: Playlist.tracks.length,
				mbid: tracks[i].mbid,
				artist: tracks[i].artist.name,
				title: tracks[i].name,
				image: tracks[i].image[0]['#text'],
				similar: [] 
			});
		}
		
		moreRow.remove();
		
		table.append(moreRow);
		
		$.gritter.add({
			title: 'More tracks...',
			text: 'Added ' + Playlist.limit + ' more tracks for <strong>' + tracks[0].artist.name + '</strong>'
		});
	},
	
	moreTracks: function() {
		Playlist.page += 1;
		
		Lastfm.moreTracks();
	}
};