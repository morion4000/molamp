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
    row = $('.social_activity table tbody').find('tr td[id='+id+']')
    row.css backgroundColor: '#ADD8E6'
    
    $.ajax('/ajax/activity/delete?id='+id).done (data) ->
      row.remove()

    badge = $('.lead .badge')
    badge.text = parseInt(badge.text) - 1