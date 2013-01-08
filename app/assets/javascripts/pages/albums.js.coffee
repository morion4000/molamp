#= require ../classes/youtube
#= require ../classes/player
#= require ../classes/player_utils
  
class Molamp.Albums extends Molamp.Player
  artist: null
  tracks: new Molamp.Collections.Tracks
  tracksView: null
  scrobble: no
  activity: no
  
  constructor: (artist) ->
    super()
    
    @artist = artist
    
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
    
    if @tracks.size() > 0
      @tracksView.render()