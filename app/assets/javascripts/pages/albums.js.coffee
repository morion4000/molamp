#= require ../classes/youtube
#= require ../classes/player
#= require ../classes/player_utils
  
class Molamp.Albums extends Molamp.Player
  artist: null
  
  constructor: (artist) ->
    _super()
    
    @artist = artist