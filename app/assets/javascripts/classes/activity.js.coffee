class Molamp.Activity
  no: 0
  activities: new Molamp.Collections.Activities
  activitiesView: null
  badgeSelector: '.lead .badge'
  
  constructor: ->
    @activitiesView = new Molamp.Views.Activities.ActivitiesView model: @activities
    @activitiesView.render()
  
  add: (obj, mode) ->
    switch mode
      when 'activity'
        model = new Molamp.Models.Activity
          id: obj.id
          artist: obj.artist
          track: obj.track
          artist_url: Molamp.Utils::url_to_lastfm obj.artist
          track_url: Molamp.Utils::url_to_lastfm obj.track
          image: obj.image
          action: 'was shared with your friends on Facebook'
          remove_code: "Molamp.Utils.prototype.removeActivity('#{obj.id}')"
          remove_text: 'Remove'
      
      when 'scrobble'
        model = new Molamp.Models.Activity
          id: obj.id
          artist: obj.artist
          track: obj.track
          artist_url: Molamp.Utils::url_to_lastfm(obj.artist)
          track_url: Molamp.Utils::url_to_lastfm(obj.track)
          image: obj.image
          action: 'was posted on your Last.fm account'
          remove_code: "void(0)"
          remove_text: ''

    @activities.add model

    @no++
    $(@badgeSelector).text @no