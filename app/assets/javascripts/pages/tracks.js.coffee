#= require_tree ../generic

window.searchYoutubeVideo = (artist, track) ->
  $.ajax
    url: Youtube.url
    success: (data) ->
      if data.feed.entry?
        song_url = data.feed.entry[0].link[0].href
        regex = /[a-zA-Z0-9_-]+(?=&)/
        matched = regex.exec song_url

        Youtube.player.cueVideoById matched[0]

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