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
    $('.ajax-spinner').spin Molamp.Defaults::SPIN_OPTIONS
    
    $.ajax 
      url: '/ajax/scrobble_mode'
      success: ->
        $('.ajax-spinner').spin off    
      data:
        mode: state  
  
  toggleActivity: (state) ->
    $('.ajax-spinner').spin Molamp.Defaults::SPIN_OPTIONS
    
    $.ajax 
      url: '/ajax/activity_mode'
      success: ->
        $('.ajax-spinner').spin off    
      data:
        mode: state  