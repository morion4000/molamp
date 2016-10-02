class Molamp.YoutubeWrapper
  loadPlayer: ->
    # Load the IFrame Player API code asynchronously.
    tag = document.createElement('script')
    tag.src = 'https://www.youtube.com/player_api'
    firstScriptTag = document.getElementsByTagName('script')[0]
    firstScriptTag.parentNode.insertBefore tag, firstScriptTag

  search: (artist, track, callback) ->
    $('.ajax-spinner').spin Molamp.Defaults::SPIN_OPTIONS

    $.ajax
      url: Molamp.Defaults::YOUTUBE_OPTIONS.apiUrl
      success: (data) ->
        $('.ajax-spinner').spin off

        if data.items.length > 0
          song = data.items[0]

          callback {
            'id': song.id.videoId,
            'url': '',
            'title': song.snippet.title
          }
        else
          callback null
      data:
        q: artist + ' ' + track
        order: 'relevance'
        part: 'snippet'
        type: 'video'
        videoDefinition: 'any'
        videoEmbeddable: 'true'
        videoSyndicated: 'true'
        key: Molamp.Defaults::YOUTUBE_OPTIONS.apiKey
        #restriction: 'RO'
      dataType: 'json'
