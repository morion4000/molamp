class Molamp.Utils
  log: (message) ->
    if typeof console isnt 'undefined'
      console.log message
    
  getImage: (array, size) ->
    imagePath = '/assets/noimage.jpg'
        
    if typeof array isnt 'undefined'
      if array.length > 0
        imagePath = array[size]['#text']
    
    imagePath
  
  url_to_lastfm: (url) ->
    # replace all spaces with +
    url.replace /\ /g, '+'
  
  removeActivity: (id) ->
    $('.social_activity table tbody').find('tr td[id='+id+']').remove()
    
    $('.ajax-spinner').spin Molamp.Defaults::SPIN_OPTIONS
    
    $.ajax('/ajax/activity/delete?id='+id).done (data) ->
      $('.ajax-spinner').spin off
      
      $.gritter.add
          title: 'Video deleted'
          text: "The video was deleted from your Facebook Activity Log"

    badge = $('.lead .badge')
    badge.text = parseInt(badge.text()) - 1