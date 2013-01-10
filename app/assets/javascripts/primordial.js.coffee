window._gaq = window._gaq or []
window.Molamp = window.Molamp or {}
window.Dispatcher = window.Dispatcher or {}
window.Youtube = window.Youtube or {}
	
window.onYouTubePlayerAPIReady = (e) ->
	Dispatcher.trigger 'youtube:ready', e

window.onYouTubePlayerEvent = (e) ->
	Dispatcher.trigger 'youtube:event', e

window.onYouTubePlayerError = (e) ->
	Dispatcher.trigger 'youtube:error', e
