#= require ../classes/youtube
#= require ../classes/player
#= require ../classes/player_utils

class Molamp.Artists extends Molamp.Player
  artist: null
  tracks: new Molamp.Collections.Tracks
  albums: new Molamp.Collections.Albums
  tracksView: null
  albumsView: null
  scrobble: no
  activity: no
  tracksPage: 1
  tracksLimit: 30
  albumsPage: 1
  albumsLimit: 10

  constructor: (artist) ->
    super()
    
    @artist = artist
    
    # Track when users click the playlist tabs
    $('#toggle_top_tracks').click ->
      _gaq.push [
        '_trackEvent'
        'Tabs'
        'Click'
        'Top Tracks'
      ]
       
    $('#toggle_top_albums').click =>
      if @albums.size() > 0
        moreRow = $('#top-albums table tbody').find 'tr#more-row'
        moreRow.remove()
    
        @albumsView.render()
        
        $('#top-albums table tbody').append moreRow
      
      _gaq.push [
        '_trackEvent'
        'Tabs'
        'Click'
        'Top Albums'
      ]
      
    # Bind to the click events for "More" buttons
    $(document).on 'click', '#more-tracks', =>
      @moreTracks()
    
    $(document).on 'click', '#more-albums', =>
      @moreAlbums()
          
    # Build the Tracks collection based on the page Markup    
    $('#top-tracks table tbody tr').each (index, element) =>
      if $(element).attr('id') isnt 'more-row' and $(element).attr('id') isnt 'no-tracks'
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
    
    moreRow = $('#top-tracks table tbody').find 'tr#more-row'
    moreRow.remove()
    
    if @tracks.size() > 0
      @tracksView.render()
    
    $('#top-tracks table tbody').append moreRow
    
    # Build the Albums collection based on the page Markup    
    $('#top-albums table tbody tr').each (index, element) =>
      if $(element).attr('id') isnt 'more-row' and $(element).attr('id') isnt 'no-albums' 
        album = new Molamp.Models.Track
          title: $(element).find('a[class=lead]').text()
          image: $(element).find('meta[itemprop=image]').attr 'content'
          playcount: $(element).find('span[class=badge]').text()
          url: $(element).find('a[class=lead]').attr 'href'
      
        @albums.add album
    
    @albumsView = new Molamp.Views.Albums.AlbumsView model: @albums
    
    @initPlaylistSearch()
              
  initPlaylistSearch: ->    
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
      page: @tracksPage + 1
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
    
    $('.ajax-spinner').spin Molamp.Defaults::SPIN_OPTIONS
    
    lastfm.artist.getTopAlbums
      artist: @artist
      page: @albumsPage + 1
      limit: @albumsLimit
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
    
    # BUG: Reset the playlist search typehead component
    @initPlaylistSearch()
       
    _gaq.push [
      '_trackEvent' 
      'More' 
      'Click' 
      'Tracks'
    ]

  appendAlbums: (data) ->    
    albums = data.topalbums.album
    table = $('#top-albums table tbody')
    moreRow = table.find 'tr#more-row'
    
    # Remove the More button to add it later
    moreRow.remove()
    
    # Loop trough the albums and append them to the table    
    for album in albums
      albumModel = new Molamp.Models.Album
        title: album.name
        url: album.url
        image: Molamp.Utils::getImage album.image, 1
        playcount: album.playcount
      
      @albums.add albumModel
    
    table.append moreRow
    
    _gaq.push [
      '_trackEvent' 
      'More' 
      'Click'
      'Albums'
    ]
