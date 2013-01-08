class Molamp.Users
  constructor: ->
    $('#scrobble_setting_off').click =>
      @toggleScrobble off
  
    $('#scrobble_setting_on').click =>
      @toggleScrobble on
    
    $('#activity_setting_off').click =>
      @toggleActivity off
    
    $('#activity_setting_on').click =>
      @toggleActivity on
      
  toggleScrobble: (state) ->
    $.ajax '/ajax/scrobble_mode?mode=' + state
  
  toggleActivity: (state) ->
    $.ajax '/ajax/activity_mode?mode=' + state