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
        
        if typeof data.feed.entry isnt 'undefined'
          song_url = data.feed.entry[0].link[0].href
          regex = /[a-zA-Z0-9_-]+(?=&)/
          matched = regex.exec song_url

          callback matched
        else
          callback null
      data:
        q: artist + ' ' + track
        orderby: 'relevance'
        alt: 'json'
        format: 5
        key: Molamp.Defaults::YOUTUBE_OPTIONS.apiKey
        #restriction: 'RO'
      dataType: 'json'