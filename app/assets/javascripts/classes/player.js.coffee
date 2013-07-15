class Molamp.Player
  history: new Molamp.Collections.History
  playing: off
  playingInterval: null
  fullscreen: off
  watchTimeout: null
  activityTimeout: null
  scrobbleTimeout: null
  activityHelper: new Molamp.Activity

  constructor: ->
    Molamp.YoutubeWrapper::loadPlayer()

    Dispatcher.on 'player:fullscreen', (e) =>
      @fullscreen = not @fullscreen
      
      if @fullscreen is on
        $('#toggle_fullscreen').find('i').attr class: 'icon-resize-small'
        
        $('#ytplayer').css
          position: 'fixed'
          left: 0
          top: 41
          width: $(window).width()
          height: $(window).height() - $('.player_controls').height() - $('.navbar-inner').height() - 14
          
        $('body').css overflow: 'hidden'
      else
        $('#toggle_fullscreen').find('i').attr class: 'icon-resize-full'
      
        $('#ytplayer').css
          position: 'static'
          width: $('.similar_artists').width()
          height: 300
      
        $('body').css overflow: 'visible'
    
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
        when YT.PlayerState.PLAYING
          @playing = on
          
          @faviconPlay()
          
          $('#toggle_play').find('i').attr class: 'icon-pause'
          
          # Post to Facebook timeline after 10 seconds
          if @watchTimeout isnt null
            @watchTimeout = setTimeout =>
              if @activity is on
                #Lastfm.activity Playlist.currentTrack.artist, Playlist.currentTrack.title, Playlist.currentTrack.image
                @watchTimeout = null
            , 10*1000
            
          $('#total_time').text(gmdate 'i:s', Youtube.getDuration())
          
          if @playingInterval is null
            @playingInterval = setInterval =>
              percentage = Youtube.getCurrentTime() / Youtube.getDuration() * 100
              
              $('#current_time').text(gmdate 'i:s', Youtube.getCurrentTime())
              $('#progress_bar').slider value: percentage
            , 500
          
        when YT.PlayerState.PAUSED
          @playing = off

          @faviconPause()

          $('#toggle_play').find('i').attr class: 'icon-play'
          
          clearTimeout @watchTimeout
          @watchTimeout = null
          
          clearInterval @playingInterval
          @playingInterval = null
          
        when YT.PlayerState.ENDED
          @playing = off

          @faviconPause()

          $('#toggle_play').find('i').attr class: 'icon-play'
            
          clearTimeout @watchTimeout
          @watchTimeout = null
            
          clearInterval @playingInterval
          @playingInterval = null
          
          Dispatcher.trigger 'player:next'
      
    Dispatcher.on 'youtube:error', (e) =>
      Molamp.Utils::log e
      
      Dispatcher.trigger 'player:next'
    
  play: (track, history = on) ->
    youtube = new Molamp.YoutubeWrapper
    
    youtube.search track.get('artist'), track.get('title'), (results) =>
      if results isnt null
        @playing = on
        
        @faviconPlay()

        Youtube.loadVideoById results.id
        
        ###
        Hack to fix the tracks not being having their highlight removed
        on the production instance. It isn't necessarily on development. 
        ###
        $('#top-tracks table tbody tr').removeClass 'active_track'
        
        track.set
          isSelected: on
        
        if @scrobbleTimeout isnt null
          clearTimeout @scrobbleTimeout
          @scrobbleTimeout = null
        
        if @activityTimeout isnt null
          clearTimeout @activityTimeout
          @activityTimeout = null

        # Scrobble the track after listening for 30 seconds
        if @scrobble is on
            @scrobbleTimeout = setTimeout =>
              @doScrobble track.get('artist'), track.get('title'), track.get('image')
            , 10*1000

        # Post the track on Facebook after 30 seconds
        if @activity is on
            @activityTimeout = setTimeout =>
              @doActivity track.get('artist'), track.get('title'), track.get('image')
            , 10*1000

        if history is on
          @history.push track
        
        $('#toggle_play').find('i').attr class: 'icon-pause'
        
        document.title = track.get('artist') + ' - ' + track.get('title')
        
        $.gritter.add
          title: track.get('title')
          image: track.get('image')
          text: track.get('artist')
        
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
    if @history.size() > 0
      currentTrackResults = @tracks.where
        mbid: @history.last().get('mbid')
      
      currentTrack = _.first(currentTrackResults)
      
      nextTrackResults = @tracks.where
        uid: currentTrack.get('uid') + 1
      
      track = _.first(nextTrackResults)
    else
      track = @tracks.at(0)
        
    @play(track)
    
    _gaq.push [
      '_trackEvent'
      'Tracks'
      'Next'
      track.get('artist') + ' - ' + track.get('title')
    ]

  previous: ->
    #console.log @history
    
    if @history.size() > 1
      track = @history.at(@history.size() - 2)
    else
      track = @tracks.at(0)
      
    @play track, off
    
    _gaq.push [
      '_trackEvent'
      'Tracks'
      'Previous'
      track.get('artist') + ' - ' + track.get('title')
    ]

  faviconPlay: ->
    $('#favicon').attr 'href', '/assets/play_favicon.ico'

  faviconPause: ->
    $('#favicon').attr 'href', '/assets/pause_favicon.ico'

  doScrobble: (artist, track, image) ->
    $('.ajax-spinner').spin Molamp.Defaults::SPIN_OPTIONS
    
    $.ajax
      url: '/ajax/scrobble'
      success: (data) =>
        $('.ajax-spinner').spin off
             
        $.gritter.add
          title: 'Track scrobbled...'
          text: "<strong>#{artist} - #{track}</strong> was scrobbled on Last.fm"
          
        @activityHelper.add
          id: md5(artist+track)
          artist: artist
          track: track
          image: image
        , 'scrobble'

      data:
        artist: artist
        track: track
      dataType: 'json'

  doActivity: (artist, track, image) ->
    $('.ajax-spinner').spin Molamp.Defaults::SPIN_OPTIONS
    
    $.ajax
      url: '/ajax/activity'
      timeout: 20*1000
      success: (data) =>
        $('.ajax-spinner').spin off
    
        $.gritter.add
          title: 'Video posted on timeline...'
          text: "<strong>#{artist} - #{track}</strong> was posted on your Facebook timeline"

        @activityHelper.add
          id: data.id
          artist: artist
          track: track
          image: image
        , 'activity'

      data:
        artist: artist
        track: track
      dataType: 'json'
