#= require gritter
#= require jquery-scrolltofixed.js
#= require jquery.ba-resize.js

$ ->
  Dispatcher.on 'youtube:ready', ->
    window.Youtube = new YT.Player Molamp.Defaults::YOUTUBE_OPTIONS.domElement, Molamp.Defaults::YOUTUBE_OPTIONS.playerOptions
    
    Youtube.addEventListener 'onStateChange', 'onYouTubePlayerEvent'
    Youtube.addEventListener 'onError', 'onYouTubePlayerError'
    
  # Prompt users when leaving the page and the player is still playing
  $('#confirmModal').modal
    show: false

  $(document).on 'click', 'a', (e) ->
    if $(@).attr('id') is 'leave_url' or Youtube.getPlayerState() isnt 1
      return
    
    href = $(@).attr('href') or ' '
    
    if not strstr(href, 'javascript:') and href[0] isnt '#'
      e.preventDefault()
      
      $('#confirmModal').modal 'show'
        
      $('#confirmModal #leave_url').attr href: href
     
  # Overwrite Gritter options
  $.extend $.gritter.options,
    position: 'top-left' # defaults to 'top-right' but can be 'bottom-left', 'bottom-right', 'top-left', 'top-right' (added in 1.7.1)
    # fade_in_speed: 'medium', // how fast notifications fade in (string or int)
    # fade_out_speed: 2000, // how fast the notices fade out
    # time: 6000 // hang on the screen for...
  
  # "Responsive" Youtube player (Change the width of the Youtube player when the width of the window changes) 
  if $('.player_controls').size() > 0
    $('.player_controls').scrollToFixed
      bottom: 0
      limit: $('.player_controls').offset().top
  
  $(window).resize ->
    if $('#ytplayer').css('position') isnt 'fixed'
      $('#ytplayer').width $('.similar_artists').width()
  
  $('body').resize ->
    if $('.player_controls').size() > 0      
      if $.isScrollToFixed '.player_controls'
        $('.player_controls').trigger 'detach.ScrollToFixed'
  
      $('.player_controls').scrollToFixed
          bottom: 0
          limit: $('.player_controls').offset().top
    
  # JQuery UI Slider for the player controls 
  $('#progress_bar').slider
    range: 'min'
    value: 0
    min: 0
    max: 100
    slide: (event, e) ->
      percentage = e.value * Youtube.getDuration() / 100
       
      Youtube.seekTo percentage, false
      # TODO: Look into the seekTo options...
  
  toggle_volume_icon = $('#toggle_volume').find('i')
  
  $('#progress_bar_volume').slider
    orientation: 'vertical'
    range: 'min'
    value: 100
    min: 0
    max: 100
    slide: (event, e) ->
      Youtube.setVolume e.value
      
      if e.value is 0
        toggle_volume_icon.attr class: 'icon-volume-off'
      else if e.value >= 50
        toggle_volume_icon.attr class: 'icon-volume-up'
      else
        toggle_volume_icon.attr class: 'icon-volume-down'

  # Get the artist image average color and change the background of the application with it
  # setTimeout ->
      # rgb = getAverageRGB(document.getElementById 'artist_image')
      # start_color = 'whiteSmoke'
      # end_color = 'rgb('+rgb.r+','+rgb.g+','+rgb.b+')'
      # style = 'backgroundColor: '+end_color+'; background: -webkit-gradient(linear, 0% 0%, 0% 100%, from('+start_color+'), to('+end_color+')); background: -webkit-linear-gradient(top, '+start_color+', '+end_color+'); background: -moz-linear-gradient(top, '+start_color+', '+end_color+'); background: -ms-linear-gradient(top, '+start_color+', '+end_color+'); background: -o-linear-gradient(top, '+start_color+', '+end_color+')'
     
      # $('#application_main_content').attr 'style', style
  # , 3000
  
  $('#toggle_volume').click ->
    $('.progress_bar_volume_container').toggle()  
  
  $('#toggle_fullscreen').click ->
    Dispatcher.trigger 'player:fullscreen'
  
  $('#toggle_play').click ->
    Dispatcher.trigger 'player:toggle'
  
  $('#next_play').click ->
    Dispatcher.trigger 'player:next'
    
  $('#previous_play').click ->
    Dispatcher.trigger 'player:previous'
