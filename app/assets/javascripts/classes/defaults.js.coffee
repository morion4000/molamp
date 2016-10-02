class Molamp.Defaults
  SPIN_OPTIONS:
    lines: 12 # The number of lines to draw
    length: 4 # The length of each line
    width: 3 # The line thickness
    radius: 5 # The radius of the inner circle

  LASTFM_OPTIONS:
    apiKey: ''
    apiSecret: ''

  YOUTUBE_OPTIONS:
    domElement: 'ytplayer'
    apiUrl: 'https://www.googleapis.com/youtube/v3/search'
    apiKey: 'AIzaSyCof4lR7pAYUvem4KdZ7xke7XvI_FqI0gY'
    playerOptions:
      #videoId: 'XkemFr6gmZo'
      width: 250
      height: 340
      playerVars:
        rel: 0
        enablejsapi: 1
        theme: 'light'
        color: 'red'
        controls: 0
        iv_load_policy: 3
        modestbranding: 1
      origin: 'http://www.molamp.net'
