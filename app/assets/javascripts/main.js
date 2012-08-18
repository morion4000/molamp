// Load the IFrame Player API code asynchronously.
var tag = document.createElement('script');
tag.src = "https://www.youtube.com/player_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

var currentSong = null;
var songs = [];

// Replace the 'ytplayer' element with an <iframe> and
// YouTube player after the API code downloads.
var player;

function onYouTubePlayerAPIReady() {	
	player = new YT.Player('ytplayer', {
	  height: '390',
	  width: '640'
	});

	player.addEventListener('onStateChange', 'eventFired');
}

function eventFired(e) {
	console.log(e.data);

	switch(e.data) {
		case 0:
			console.log('ended');
			var playcount = $('ul#songs_list').find('li[class=active]').next('li').attr('id');

			console.log(playcount);

			song = findSong(playcount);
			play($('input[name=search]').val(), song);
		break;
	}
}

function findSong(playcount) {
	for (var i=0, l=songs.length; i<l; i++) {
		if (songs[i].playcount == playcount) {
			return songs[i];
		}
	}
}

function play(artist, song) {
		var url = 'https://gdata.youtube.com/feeds/api/videos'; 
		//?q=black%20sabbath%20Sabbath%20Bloody%20Sabbath&orderby=relevance&v=2&alt=atom&restriction=RO';

		$.ajax({
			url: url,
			success: function(data) {
				var song_url = data.feed.entry[0].link[0].href;
				var regex = /[a-zA-Z0-9_-]+(?=&)/;
				var matched = regex.exec(song_url);

				console.log(song_url);

				player.loadVideoById(matched[0]);

				if (currentSong != null) {
					$('ul#songs_list').find('li#'+currentSong.playcount).attr('class', 'inactive');
				}

				$('ul#songs_list').find('li#'+song.playcount).attr('class', 'active');

				currentSong = song;
			},
			data: {
				q: artist + ' ' + song.name,
				orderby: 'relevance',
				alt: 'json',
				restriction: 'RO'
			}
		});
	}

// $(function() {
	// $('form[name=search]').submit(function(e) {
		// e.preventDefault();
// 
		// var artist = $('input[name=search]').val();
// 
		// /* Create a cache object */
		// var cache = new LastFMCache();
// 
		// /* Create a LastFM object */
		// var lastfm = new LastFM({
			// apiKey    : 'f21088bf9097b49ad4e7f487abab981e',
			// apiSecret : '7ccaec2093e33cded282ec7bc81c6fca',
			// cache     : cache
		// });
// 
		// /* Load some artist info. */
		// lastfm.artist.getTopTracks({artist: artist, autocorrect: 1, limit: 50}, {
			// success: function(data){
				// /* Use data. */
// 
				// //console.log(data);
// 
				// $('ul#songs_list').html('<li class="nav-header">Top rated songs</li>');
// 
				// songs = data.toptracks.track;
// 
				// for (var i=0, l=data.toptracks.track.length; i<l; i++) {
					// var song = data.toptracks.track[i];
// 					
					// console.log(song);
// 
					// $('ul#songs_list').append(
						// $('<li/>').append($('<a/>').text(song.name).attr('href', 'javascript:;').click((function(s) {
							// return function() {
								// play(artist, s);
							// }
						// })(song))).attr('id', song.playcount)
					// );
				// }
			// },
			// error: function(code, message){
				// /* Show error message. */
		// }});
	// });
// });