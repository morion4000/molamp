var Youtube = {
	player: null,
	url: 'https://gdata.youtube.com/feeds/api/videos',
	domElement: 'ytplayer',
	options: {
	  height: '340',
	  width: '250'
	},
	key: 'AI39si5R6V7abxfitoVlki1bxJmGmMzYBtupUi4Dy7R9Ae7eu_ASK4uZhNgozUYFSNa7u_6mleqoJtQZOuUBuUtOEFj_3DEGvg',
	
	init: function() {
		// Load the IFrame Player API code asynchronously.
		var tag = document.createElement('script');
		tag.src = "https://www.youtube.com/player_api";
		var firstScriptTag = document.getElementsByTagName('script')[0];
		firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
	}
};

function onYoutubeEventFired(e) {	
	switch(e.data) {
		// Started
		case 1:
			// Post to Facebook timeline after 10 seconds
			setTimeout(function() {
				if (Alike.activity === true) {
					Lastfm.activity(Playlist.currentTrack.artist, Playlist.currentTrack.title);
				}
			}, 10*1000);
		break;
		
		// Ended
		case 0:
			// Scrobble the current track first
			if (Alike.scrobble === true) {
				Lastfm.scrobble(Playlist.currentTrack.artist, Playlist.currentTrack.title);
			}
					
			Playlist.next();
		break;
	}
}

function onYoutubeErrorFired(e) {	
	switch(e.data) {
		default:
			Playlist.next();
		break;
	}
}

function onYouTubePlayerAPIReady() {	
	Youtube.player = new YT.Player(Youtube.domElement, Youtube.options);

	Youtube.player.addEventListener('onStateChange', 'onYoutubeEventFired');
	Youtube.player.addEventListener('onError', 'onYoutubeErrorFired');
	
	Alike.youtubeLoaded();
}