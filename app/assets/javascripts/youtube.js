var Youtube = {
	player: null,
	url: 'https://gdata.youtube.com/feeds/api/videos',
	domElement: 'ytplayer',
	options: {
	  //videoId: 'XkemFr6gmZo',
	  width: '250',
	  height: '340',
	  playerVars: {
	  	rel: 0,
	  	enablejsapi: 1,
	  	theme: 'light',
	  	color: 'red',
	  	controls: 0,
	  	iv_load_policy: 3,
	  	modestbranding: 1,
		origin: 'http://www.molamp.net'
	  }
	},
	watchTimeout: null,
	playingInterval: null,
	playing: false,
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
			Youtube.playing = true;
			$('#toggle_play').find('i').attr('class', 'icon-pause');
		
			// Post to Facebook timeline after 10 seconds
			if (Youtube.watchTimeout == null) {
				Youtube.watchTimeout = setTimeout(function() {
					if (Alike.activity === true) {
						Lastfm.activity(Playlist.currentTrack.artist, Playlist.currentTrack.title, Playlist.currentTrack.image);
						
						Youtube.watchTimeout = null;
					}
				}, 10*1000);
			}
			
			$('#total_time').text(gmdate('i:s', Youtube.player.getDuration()));
			
			if (Youtube.playingInterval == null) {
				Youtube.playingInterval = setInterval(function() {
					var percentage = Youtube.player.getCurrentTime() / Youtube.player.getDuration() * 100;
					
					$('#current_time').text(gmdate('i:s', Youtube.player.getCurrentTime()));
					$('#progress_bar').slider('value', percentage);
				}, 500);
			}
		break;
		
		// Paused
		case 2:
			Youtube.playing = false;
			$('#toggle_play').find('i').attr('class', 'icon-play');
			
			clearTimeout(Youtube.watchTimeout);
			Youtube.watchTimeout = null;
			
			clearInterval(Youtube.playingInterval);
			Youtube.playingInterval = null;
		break;
		
		// Ended
		case 0:
			Youtube.playing = false;
			$('#toggle_play').find('i').attr('class', 'icon-play');
			
			clearTimeout(Youtube.watchTimeout);
			Youtube.watchTimeout = null;
			
			clearInterval(Youtube.playingInterval);
			Youtube.playingInterval = null;
			
			// Scrobble the current track first
			if (Alike.scrobble === true) {
				Lastfm.scrobble(Playlist.currentTrack.artist, Playlist.currentTrack.title, Playlist.currentTrack.image);
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