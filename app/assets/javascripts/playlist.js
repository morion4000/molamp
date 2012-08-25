var Playlist = {
	currentTrack: null,
	artist: null,
	tracks: [],
	
	play: function(id) {
		var url = 'https://gdata.youtube.com/feeds/api/videos'; 
		//?q=black%20sabbath%20Sabbath%20Bloody%20Sabbath&orderby=relevance&v=2&alt=atom&restriction=RO';

		$.ajax({
			url: url,
			success: function(data) {
				var song_url = data.feed.entry[0].link[0].href;
				var regex = /[a-zA-Z0-9_-]+(?=&)/;
				var matched = regex.exec(song_url);

				console.log(song_url);

				Youtube.player.loadVideoById(matched[0]);

				Playlist.currentTrack = id;
			},
			data: {
				q: Playlist.artist + ' ' + Playlist.tracks[id].title,
				orderby: 'relevance',
				alt: 'json',
				restriction: 'RO'
			}
		});
	}
};
