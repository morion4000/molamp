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
    