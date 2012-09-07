var Youtube = {
	player: null,
	domElement: 'ytplayer',
	options: {
	  height: '270',
	  width: '200'
	},
	
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
		// Ended
		case 0:
			Playlist.next();
		break;
	}
}

function onYouTubePlayerAPIReady() {	
	Youtube.player = new YT.Player(Youtube.domElement, Youtube.options);

	Youtube.player.addEventListener('onStateChange', 'onYoutubeEventFired');
	
	Alike.youtubeLoaded();
}