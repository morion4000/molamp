class Molamp.Player
  history: null
  playing: off
  playingInterval: null
  watchTimeout: null
  
  constructor: ->
    
  play: (track, history = on) ->
    youtube = new Molamp.YoutubeWrapper
        
    youtube.search track.get('artist'), track.get('title'), (results) =>
      if results isnt null
        @playing = on
        
        Youtube.loadVideoById results[0]
        
        # Highlight current track
        # $(track).css 
            # backgroundColor: '#EEE'
            # fontWeight: 'bold'
        
        if history is on
          @history.push track
          alert 'history'
                   
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
    if @history.size() >= 1
      currentTrackResults = @tracks.where
        mbid: @history.last().get('mbid')
      
      currentTrack = _.first(currentTrackResults)
      
      nextTrackResults = @tracks.where
        uid: currentTrack.get('uid') + 1
      
      track = _.first(nextTrackResults)
    else
      track = @tracks.at(0)
        
    @play(track)
    
  previous: ->
    console.log @history
    
    if @history.size() > 1
      track = @history.at(@history.size() - 2)
    else
      track = @tracks.at(0)
      
    @play track, off 
