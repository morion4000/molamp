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
		var tr = $('div#top-tracks table tbody').find('tr[rel="'+mbid+'"]'),
			tracks = data.similartracks.track,
			track = Playlist.searchTrack(Playlist.tracks, 'mbid', mbid)
				
		for (i=tracks.length-1; i>=0; i--) {
			var container =
				'<div class="row-fluid">' +
					'<div class="span1">' +
					'</div>' +
					'<div class="span1">' +
				  		'<img alt="Sugar Magnolia" class="img-rounded" src="' + tracks[i].image[0]['#text'] + '">' +
				  	'</div>' +
				  	'<div class="span10">' +
				  		'<h4><a href=\'javascript:Playlist.play("' + track.mbid + '", "' + tracks[i].mbid + '")\'>'+ tracks[i].artist.name + ' - ' + tracks[i].name + '</a></h4>' +
				  		'</div>' +
				'</div>';
			
			tr.after(
				$('<tr>').css({
					backgroundColor: '#FFF',
					display: 'none'
				}).attr({
					id: 'track-_' + i,
					rel: track.mbid + '_' + tracks[i].mbid,
					'class': 'similar_row'
				}).append(
					$('<td>').attr({colspan: 2}).append(container)
				)
			);
			
			if (track != null) {
				Playlist.tracks[track.uid].similar.push({
					uid: i,
					mbid: tracks[i].mbid,
					artist: tracks[i].artist.name,
					title: tracks[i].name,
					similar: track.uid 
				});
			}
		}
		
		$('tr[class=similar_row]').show('slow');
	},
	
	removeSimilarTracks: function(mbid) {
		var tr = $('div#top-tracks table tbody').find('tr[rel="'+mbid+'"]'),
			track = Playlist.searchTrack(Playlist.tracks, 'mbid', mbid);
		
		for (i=0, l=track.similar.length; i<l; i++) {
			$('tr[class=similar_row][rel="' + track.mbid + '_' + track.similar[i].mbid+'"]').remove();	
		}
		
		track.similar = [];
	}
};