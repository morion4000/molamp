class Molamp.Models.Track extends Backbone.Model
  defaults:
    uid: 0
    mbid: null
    artist: null
    title: null
    image: null
    listeners: 0
    playcount: 0
    url: null
    similar: no
    isSelected: no
 
class Molamp.Collections.Tracks extends Backbone.Collection
  model: Molamp.Models.Track
  
  initialize: ->
    ### Hack to prevent removing the selection on a track if the user clicks it twice.
    Player.play already handles removing the selection on all tracks.
    ###
    #@on 'change:isSelected', @onSelectedChanged
  
  onSelectedChanged: ->
    @each (model) ->
      if model.get('isSelected') is on and not model.hasChanged('isSelected')  
          model.set
            isSelected: no