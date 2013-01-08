#= require ../classes/youtube
#= require ../classes/player
#= require ../classes/player_utils

class Molamp.Tracks extends Molamp.Player
  tracks: new Molamp.Collections.Tracks
  
  constructor: ->
    super()
    
    Molamp.YoutubeWrapper::loadPlayer()
  
  searchYoutubeVideo: (artist, track) ->
    $.ajax
      url: Molamp.Defaults::YOUTUBE_OPTIONS.apiUrl
      success: (data) ->
        if data.feed.entry?
          song_url = data.feed.entry[0].link[0].href
          regex = /[a-zA-Z0-9_-]+(?=&)/
          matched = regex.exec song_url
  
          Youtube.cueVideoById matched[0]
          
          # TODO: Send a more specific event
          _gaq.push ['_trackEvent', 'Tracks', 'Play', artist + ' - ' + track]
        else
          $.gritter.add
            title: 'Track not found...'
            text: artist + ' - ' + track
      data:
        q: artist + ' ' + track
        orderby: 'relevance'
        alt: 'json'
        format: 5
        key: Youtube.key
        #restriction: 'RO'
      dataType: 'json'