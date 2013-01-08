class Molamp.Player
  history: new Molamp.Collections.History
  playing: off
  playingInterval: null
  watchTimeout: null
  
  constructor: ->
    Molamp.YoutubeWrapper::loadPlayer()
    
    Dispatcher.on 'player:play', (e) =>
       @play(e)
       
    Dispatcher.on 'player:next', =>
      @next()
      
    Dispatcher.on 'player:previous', =>
      @previous()
      
    Dispatcher.on 'player:toggle', =>
      if @playing is on
        @pause()
        
        $('#toggle_play').find('i').attr class: 'icon-play'
      else 
        @resume()
        
        $('#toggle_play').find('i').attr class: 'icon-pause'
                
    Dispatcher.on 'youtube:event', (e) =>
      switch e.data
        # Started
        when 1
          @playing = on
          $('#toggle_play').find('i').attr class: 'icon-pause'
          
          # Post to Facebook timeline after 10 seconds
          if @watchTimeout?
            @watchTimeout = setTimeout =>
              if @activity is on
                #Lastfm.activity Playlist.currentTrack.artist, Playlist.currentTrack.title, Playlist.currentTrack.image
                  
                @watchTimeout = null
            , 10*1000
            
          $('#total_time').text(gmdate 'i:s', Youtube.getDuration())
            
          if not @playingInterval?
            @playingInterval = setInterval =>
              percentage = Youtube.getCurrentTime() / Youtube.getDuration() * 100
                
              $('#current_time').text(gmdate 'i:s', Youtube.getCurrentTime())
              $('#progress_bar').slider value: percentage
            , 500
          
        # Paused
        when 2
          @playing = off
          $('#toggle_play').find('i').attr class: 'icon-play'
            
          clearTimeout @watchTimeout
          @watchTimeout = null
            
          clearInterval @playingInterval
          @playingInterval = null
          
        # Ended
        when 0
          @playing = off
          $('#toggle_play').find('i').attr class: 'icon-play'
            
          clearTimeout @watchTimeout
          @watchTimeout = null
            
          clearInterval @playingInterval
          @playingInterval = null
            
          # Scrobble the current track first
          # if @scrobble is on
            # Lastfm.scrobble Playlist.currentTrack.artist, Playlist.currentTrack.title, Playlist.currentTrack.image
                
          @next()
      
    Dispatcher.on 'youtube:error', (e) =>
      Molamp.Utils::log e
      
      @next()
    
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
          # alert 'history'
                   
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
    #console.log @history
    
    if @history.size() > 1
      track = @history.at(@history.size() - 2)
    else
      track = @tracks.at(0)
      
    @play track, off 
