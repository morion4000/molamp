#= require handlebars-1.0.0.beta.6.js
#= require ../classes/youtube
#= require ../classes/player
#= require ../classes/player_utils

class Molamp.Artists extends Molamp.Player
  artist: null
  tracks: new Molamp.Collections.Tracks
  tracksView: null
  scrobble: no
  activity: no
  tracksPage: 1
  tracksLimit: 30
  albumsPage: 1
  albumsLimit: 10

  constructor: (artist) ->
    _super()
    
    @artist = artist
    
    # Track when users click the playlist tabs
    $('#toggle_top_tracks').click ->
      _gaq.push [
        '_trackEvent'
        'Tabs'
        'Click'
        'Top Tracks'
      ]
       
    $('#toggle_top_albums').click ->
      _gaq.push [
        '_trackEvent'
        'Tabs'
        'Click'
        'Top Albums'
      ]
      
    # Bing to the click events for "More" buttons
    $('#more-tracks').live 'click', =>      
      @moreTracks()
    
    $('#more-albums').live 'click', =>
      @moreAlbums()
      
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
    
    Dispatcher.on 'youtube:ready', ->
      window.Youtube = new YT.Player Molamp.Defaults::YOUTUBE_OPTIONS.domElement, Molamp.Defaults::YOUTUBE_OPTIONS.playerOptions
      
      Youtube.addEventListener 'onStateChange', 'onYouTubePlayerEvent'
      Youtube.addEventListener 'onError', 'onYouTubePlayerError'
            
    Dispatcher.on 'youtube:event', (e) ->
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
          @playing = false
          $('#toggle_play').find('i').attr class: 'icon-play'
            
          clearTimeout @watchTimeout
          @watchTimeout = null
            
          clearInterval @playingInterval
          @playingInterval = null
          
        # Ended
        when 0
          @playing = false
          $('#toggle_play').find('i').attr class: 'icon-play'
            
          clearTimeout @watchTimeout
          @watchTimeout = null
            
          clearInterval @playingInterval
          @playingInterval = null
            
          # Scrobble the current track first
          # if @scrobble is on
            # Lastfm.scrobble Playlist.currentTrack.artist, Playlist.currentTrack.title, Playlist.currentTrack.image
                
          @next()
      
    Dispatcher.on 'youtube:error', (e) ->
      Molamp.Utils::log e
      
      @next()
    
    # Build the Tracks collection based on the page Markup    
    $('#top-tracks table tbody tr').each (index, element) =>
      if $(element).attr('id') isnt 'more-row'
        track = new Molamp.Models.Track
          uid: index + 1
          mbid: $(element).attr('data-service-id')
          artist: @artist
          title: $(element).find('div[itemprop=name]').text()
          image: $(element).find('meta[itemprop=image]').attr 'content'
          url: $(element).find('meta[itemprop=url]').attr 'content'
          similar: no
      
        @tracks.add track
    
    @tracksView = new Molamp.Views.Tracks.TracksView model: @tracks
    
    @history = new Molamp.Collections.History
    
    moreRow = $('#top-tracks table tbody').find 'tr#more-row'
    moreRow.remove()
    
    @tracksView.render()
    
    $('#top-tracks table tbody').append moreRow
            
    # Search the playlist
    $('.typeahead').typeahead
      source: @tracks.pluck 'title'
      updater: (item) =>
        search = @tracks.where
          title: item
        
        Dispatcher.trigger 'player:play', _.first(search)
        
        _gaq.push [
          '_trackEvent'
          'Tracks'
          'Search'
          item
        ]
        
        ''
              
  moreTracks: ->
    lastfm = new Molamp.LastfmWrapper
        
    $('.ajax-spinner').spin Molamp.Defaults::SPIN_OPTIONS
    
    lastfm.artist.getTopTracks
      artist: @artist
      page: @tracksPage
      limit: @tracksLimit
    ,
      success: (data) =>
        $('.ajax-spinner').spin off
        
        @tracksPage += 1
         
        @.appendTracks data
        
      error: (code, message) ->
        $('.ajax-spinner').spin off
        
        $.gritter.add
          title: 'Error...'
          text: message

  moreAlbums: ->
    lastfm = new Molamp.LastfmWrapper
    
    $('.ajax-spinner').spin @spinOptions
    
    lastfm.artist.getTopAlbums
      artist: Playlist.tracks[0].artist
      page: Playlist.albumsPage
      limit: Playlist.albumsLimit
    , 
      success: (data) =>
        $('.ajax-spinner').spin off
        
        @albumsPage += 1
        
        @.appendAlbums data
        
      error: (code, message) ->
        $('.ajax-spinner').spin off
        
        $.gritter.add
          title: 'Error...'
          text: message
    
  appendTracks: (data) ->
    tracks = data.toptracks.track
    table = $('#top-tracks table tbody')
    moreRow = table.find 'tr#more-row'
    
    # Remove the More button to add it later
    moreRow.remove()
    
    # Loop trough the tracks and append them to the table
    for track in tracks
      if track.mbid is ''
        track.mbid = '~' + md5 track.name + track.artist.name
      
      trackModel = new Molamp.Models.Track
        uid: (@.tracksPage - 1) * @.tracksLimit + _i + 1
        mbid: track.mbid
        artist: track.artist.name
        title: track.name
        image: Molamp.Utils::getImage track.image, 0
        listeners: track.listeners
        playcount: track.playcount
      
      @tracks.add trackModel
            
    table.append moreRow 
    
    # The Bootstrap tooltip needs to be destroyed and re-intialized for it to work for the new tracks
    $('[rel=tooltip]').tooltip 'destroy'
    $('[rel=tooltip]').tooltip()
    
    $.gritter.add
      title: 'More tracks...'
      text: "Added #{@.tracksLimit} more tracks for <strong>#{@.artist}</strong>"
       
    _gaq.push [
      '_trackEvent' 
      'More' 
      'Click' 
      'Tracks'
    ]
    
  appendSimilarTracks: (mbid, data) ->
    tr = $('table tbody').find('tr[id="'+mbid+'"]')
    tracks = data.similartracks.track
    track = Playlist.searchTrack Playlist.tracks, 'mbid', mbid
    source = $("#similar-template").html()
    template = Handlebars.compile source
      
    for [(tracks.length-1)..0]
      if tracks[i].mbid == ''
        tracks[i].mbid = '~' + md5 tracks[i].name + tracks[i].artist.name
      
      if tracks[i].artist.name != Playlist.tracks[0].artist
        artist = tracks[i].artist.name
          
      container = template
        no_parent: track.uid+1
        no: (i+1)
        mbid: tracks[i].mbid
        parent_mbid: track.mbid 
        name: tracks[i].name
        artist: artist
        image: Molamp.Utils::getImage(tracks[i].image, 0)
        duration: gmdate('i:s', tracks[i].duration/1000) if tracks[i].duration isnt 0
      
      tr.after container
      
      if track?
        track.similar.push
          uid: i
          mbid: tracks[i].mbid
          artist: tracks[i].artist.name
          title: tracks[i].name
          image: Molamp.Utils::getImage(tracks[i].image, 0)
          similar: track.uid
    
    $('table tbody').find('tr[class=similar_row]').show 'slow'
    
    $.gritter.add
      title: 'Similar tracks...'
      text: "Retreived tracks similar to <strong>#{track.artist} - #{track.title}</strong>"
    
    _gaq.push [
      '_trackEvent'
      'Tracks'
      'Similar'
      track.artist + ' - ' + track.title
    ]
  
  removeSimilarTracks: (mbid) ->
    tr = $('table tbody').find "tr[id={#mbid}]"
    track = Playlist.searchTrack Playlist.tracks, 'mbid', mbid
    
    for similar in [0..track.similar.length]
      $("tr[class=similar_row][id='#{track.mbid}_#{similar.mbid}]").remove()
    
    track.similar = []
  
  appendAlbums: (data) ->
    source = $("#album-template").html()
    template = Handlebars.compile source
    albums = data.topalbums.album
    table = $('#top-albums table tbody')
    moreRow = $('#top-albums table tbody').find 'tr#more-row'
    
    moreRow.remove()
        
    for album in albums                  
      table.append template
        no: (@.albumsPage - 1) * @.albumsLimit + _i + 1
        name: album.name
        image: Molamp.Utils::getImage album.image, 1
        playcount: album.playcount
        url: '/artists/' + Molamp.url_to_lastfm(@.artist) + '/' + @.url_to_lastfm(album.name)
        lastfm_url: album.url
    
    table.append moreRow
    
    $.gritter.add
      title: 'More albums...'
      text: "Added #{@.albumsLimit} more albums for <strong>#{@.artist}</strong>"
    
    _gaq.push [
      '_trackEvent' 
      'More' 
      'Click'
      'Albums'
    ]