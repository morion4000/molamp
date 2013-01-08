var _gaq = _gaq || [],
	Molamp = Molamp || {},
	Dispatcher = Dispatcher || {},
	Youtube = Youtube || {};
	
function onYouTubePlayerAPIReady() {
	Dispatcher.trigger('youtube:ready');
}

function onYouTubePlayerEvent(e) {
	Dispatcher.trigger('youtube:event', e);
}

function onYouTubePlayerError(e) {
	Dispatcher.trigger('youtube:error', e);
}
