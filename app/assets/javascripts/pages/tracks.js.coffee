#= require ../classes/youtube
#= require ../classes/player
#= require ../classes/player_utils

class Molamp.Tracks extends Molamp.Player
  tracks: new Molamp.Collections.Tracks

  constructor: ->
    super()

    Molamp.YoutubeWrapper::loadPlayer()

    $('#next_play').addClass 'disabled'
    $('#previous_play').addClass 'disabled'

    Dispatcher.off 'player:next'
    Dispatcher.off 'player:previous'

  searchYoutubeVideo: (artist, track) ->
    $('.ajax-spinner').spin Molamp.Defaults::SPIN_OPTIONS

    $.ajax
      url: Molamp.Defaults::YOUTUBE_OPTIONS.apiUrl
      success: (data) ->
        $('.ajax-spinner').spin off

        if data.items.length > 0
          song = data.items[0]

          Youtube.cueVideoById song.id.videoId

          # TODO: Send a more specific event
          _gaq.push ['_trackEvent', 'Tracks', 'Play', artist + ' - ' + track]
        else
          $.gritter.add
            title: 'Track not found...'
            text: artist + ' - ' + track
      data:
        q: artist + ' ' + track
        order: 'relevance'
        part: 'snippet'
        type: 'video'
        videoDefinition: 'any'
        videoEmbeddable: 'true'
        videoSyndicated: 'true'
        key: Youtube.key
        #restriction: 'RO'
      dataType: 'json'
