class Molamp.Activity
  nr: 0
  TIMELINE: 0
  SCROBBLE: 1
  domElement: '.social_activity'
  badgeElement: '.lead .badge'
  
  constructor: ->
  
  add: (obj, mode) ->
    table = $(@domElement).find 'table tbody'
    template = Handlebars.compile($("#social-activity-template").html())

    switch mode
      when @TIMELINE
        container = template
          id: obj.id
          artist: obj.artist
          track: obj.track
          artist_url: Molamp.url_to_lastfm obj.artist
          track_url: Molamp.url_to_lastfm obj.track
          image: obj.image
          action: 'was shared with your friends on Facebook'
          remove_link: "javascript:Activity.remove(#{obj.id}, #{@TIMELINE})"
          remove_text: 'Remove from Timeline'
      
      when @SCROBBLE
        container = template
          id: obj.id
          artist: obj.artist
          track: obj.track
          artist_url: Molamp.url_to_lastfm(obj.artist)
          track_url: Molamp.url_to_lastfm(obj.track)
          image: obj.image
          action: 'was posted on your Last.fm account'
          remove_link: "javascript:Activity.remove(#{obj.id}, #{@SCROBBLE})"
          remove_text: 'Remove'

    table.prepend container
    
    Activity.no++
    $(Activity.badge).text @nr
    
  remove: (id, mode) ->
    row = $(@domElement).find('table tbody').find('tr[id='+id+']');
    
    row.css backgroundColor: '#ADD8E6'
    
    switch mode
      when @TIMELINE
        $.ajax('/ajax/activity/delete?id='+id).done (data) ->
          row.remove()
     
      else
        row.remove()
   
    Activity.no--
    $(Activity.badge).text @nr
