class Molamp.Player
  history: null
  playing: off
  playingInterval: null
  watchTimeout: null
  
  constructor: ->
    
  play: (track) ->
    youtube = new Molamp.YoutubeWrapper
        
    youtube.search track.get('artist'), track.get('title'), (results) =>
      if results isnt null
        @playing = on
        
        Youtube.loadVideoById results[0]
        
        # Highlight current track
        # $(track).css 
            # backgroundColor: '#EEE'
            # fontWeight: 'bold'
        
        @history.push track
                        
        $('#toggle_play').find('i').attr class: 'icon-pause'
        
        document.title = track.get('artist') + ' - ' + track.get('title')        
        
        $.gritter.add
          title: 'Now playing...'
          image: track.get('image')
          text: track.get('artist') + ' - ' + track.get('title')
        
        _gaq.push [
          '_trackEvent'
          'Tracks'
          'Play'
          track.get('artist') + ' - ' + track.get('title')
        ]
      else 
        $.gritter.add
          title: 'Track not found...'
          image: track.get('image')
          text: track.get('artist') + ' - ' + track.get('title')

  pause: ->
    @playing = off
    
    Youtube.pauseVideo()
    
  resume: ->
    @playing = on
    
    Youtube.playVideo()
       
  stop: ->
    @playing = off
    
  next: ->
    alert 'next'
    
    #@play(track)
    
  previous: ->
    if @history.size() > 1
      track = @history.at(@history.size() - 2)
      
      @play(track)
