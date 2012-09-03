var Alike = {
	youtubeLoaders: [],
	
	init: function() {
		Youtube.init();
	},
	
	youtubeLoaded: function() {
		for (i=0, l=Alike.youtubeLoaders.length; i<l; i++) {
			Alike.youtubeLoaders[i]();
		}
	}
};